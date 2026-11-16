#!/bin/sh
set -eu

PHASE="$1"
TARGET="$2"

update_cmdline() {
    mkdir -p /tmp/newfat
    NEXT_VFAT_PART=""
    NEXT_ROOT=""
    if [ "$TARGET" = "A" ]
    then
        NEXT_VFAT_PART="/dev/sda2"
        NEXT_ROOT="/dev/sda4"
    else
        NEXT_VFAT_PART="/dev/sda3"
        NEXT_ROOT="/dev/sda5"
    fi
    mount "${NEXT_VFAT_PART}" /tmp/newfat
    sed -i "s|root=[^ ]*|root=${NEXT_ROOT}|" /tmp/newfat/cmdline.txt
    sync
    umount /tmp/newfat
}

# rsync_hass() {
#     # Sync the homeassistant directory to the new rootfs partition
#     NEXT_ROOT=""
#     if [ "$TARGET" = "A" ]
#     then
#         NEXT_ROOT="/dev/sda4"
#     else
#         NEXT_ROOT="/dev/sda5"
#     fi
#     mkdir -p /tmp/newroot
#     mount "${NEXT_ROOT}" /tmp/newroot
#     rsync -a  /home/bob/homeassistant/ /tmp/newroot/home/bob/homeassistant/
#     sync
#     umount /tmp/newroot
# }

case "$PHASE" in 
    preinst)
        CURRENT=$(rpi-abctl status | sed -n 's/^Running slot: //p')
        [ "$CURRENT" != "$TARGET" ] || exit 1

        rpi-abctl prepare
        ;;
    postinst)
        rpi-abctl trial
        update_cmdline
        #rsync_hass
        sync
        ;;
    postfailure)
        logger -t swupdate "Update failed for slot $TARGET"
        ;;
esac
