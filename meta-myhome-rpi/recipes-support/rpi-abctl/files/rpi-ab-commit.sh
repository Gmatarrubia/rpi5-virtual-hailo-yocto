#!/bin/sh
set -eu

if [ -f /etc/ab-commited ]; then
    echo "AB commit already done. Skipping."
    exit 0
fi

systemctl --quiet is-active homeassistant.service

rpi-abctl commit
touch /etc/ab-commited
