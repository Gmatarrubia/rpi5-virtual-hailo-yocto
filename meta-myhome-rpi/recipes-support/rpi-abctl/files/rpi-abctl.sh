#!/bin/sh
# /usr/sbin/rpi-abctl
set -eu

SELECTOR_DEV="${SELECTOR_DEV:-/dev/disk/by-label/autoboot}"
MNT="/run/rpi-ab-selector"
DT="/proc/device-tree/chosen/bootloader"

die() {
    echo "rpi-abctl: $*" >&2
    exit 1
}

dt_uint() {
    [ -r "$DT/$1" ] || die "Missing firmware property: $1"
    hex=$(od -An -tx1 -v "$DT/$1" | tr -d ' \n')
    printf '%d\n' "0x$hex"
}

slot_from_partition() {
    case "$1" in
        2) echo A ;;
        3) echo B ;;
        *) die "Unexpected boot partition: $1" ;;
    esac
}

partition_from_slot() {
    case "$1" in
        A) echo 2 ;;
        B) echo 3 ;;
        *) die "Invalid slot: $1" ;;
    esac
}

other_slot() {
    case "$1" in
        A) echo B ;;
        B) echo A ;;
        *) die "Invalid slot" ;;
    esac
}

mount_selector() {
    mkdir -p "$MNT"
    mount -t vfat "$SELECTOR_DEV" "$MNT" ||
        die "Cannot mount selector partition"
}

unmount_selector() {
    sync
    umount "$MNT"
}

# Extract the selected partition from an autoboot section.
read_partition() {
    awk -v section="$1" '
        /^\[/ {
            active = ($0 == "[" section "]")
            next
        }
        active && /^[[:space:]]*boot_partition=/ {
            split($0, a, "=")
            gsub(/[[:space:]]/, "", a[2])
            result = a[2]
        }
        END { print result }
    ' "$MNT/autoboot.txt"
}

read_config() {
    [ -f "$MNT/autoboot.txt" ] ||
        die "autoboot.txt missing"

    grep -Eq '^tryboot_a_b=1$' "$MNT/autoboot.txt" ||
        die "tryboot_a_b is not enabled"

    NORMAL_PART=$(read_partition all)
    TRIAL_PART=$(read_partition tryboot)

    case "$NORMAL_PART:$TRIAL_PART" in
        2:3|3:2) ;;
        *) die "Invalid A/B configuration" ;;
    esac
}

write_config() {
    normal="$1"
    trial="$2"

    # Write a replacement file in the same filesystem.
    cat > "$MNT/autoboot.new" <<EOF
[all]
tryboot_a_b=1
boot_partition=$normal

[tryboot]
boot_partition=$trial
EOF

    sync
    mv -f "$MNT/autoboot.new" "$MNT/autoboot.txt"
    sync
}

RUNNING_PART=$(dt_uint partition)
RUNNING_SLOT=$(slot_from_partition "$RUNNING_PART")
TRYBOOT=$(dt_uint tryboot)

case "${1:-}" in
    status)
        mount_selector
        read_config
        echo "Running slot: $RUNNING_SLOT"
        echo "Confirmed slot: $(slot_from_partition "$NORMAL_PART")"
        echo "Trial target: $(slot_from_partition "$TRIAL_PART")"
        echo "Tryboot active: $TRYBOOT"
        unmount_selector
        ;;

    prepare)
        [ "$TRYBOOT" -eq 0 ] ||
            die "Cannot update during trial boot"

        mount_selector
        read_config

        [ "$RUNNING_PART" -eq "$NORMAL_PART" ] ||
            die "Running slot is not confirmed"

        echo "Inactive slot: $(other_slot "$RUNNING_SLOT")"
        unmount_selector
        ;;

    trial)
        [ "$TRYBOOT" -eq 0 ] ||
            die "Already in trial mode"

        mount_selector
        read_config

        [ "$RUNNING_PART" -eq "$NORMAL_PART" ] ||
            die "Current slot is not confirmed"

        [ "$TRIAL_PART" -ne "$RUNNING_PART" ] ||
            die "Trial slot equals running slot"

        unmount_selector
        echo "Trial target verified."
        echo "Execute: reboot '0 tryboot'"
        ;;

    commit)
        [ "$TRYBOOT" -eq 1 ] ||
            die "Not running in tryboot mode"

        mount_selector
        read_config

        [ "$RUNNING_PART" -eq "$TRIAL_PART" ] ||
            die "Running partition is not trial target"

        write_config "$RUNNING_PART" "$NORMAL_PART"
        unmount_selector

        echo "Slot $RUNNING_SLOT committed successfully."
        ;;

    *)
        echo "Usage: $0 {status|prepare|trial|commit}"
        exit 2
        ;;
esac
