#!/bin/sh
set -eu

PHASE="$1"
TARGET="$2"

case "$PHASE" in 
    preinst)
        CURRENT=$(rpi-abctl status | sed -n 's/^Running slot: //p')
        ["$CURRENT" != "$TARGET"] || exit 1

        rpi-abctl prepare
        ;;
    postinst)
        rpi-abctl trial
        sync
        ;;
    postfailure)
        logger -t swupdate "Update failed for slot $TARGET"
        ;;
esac
