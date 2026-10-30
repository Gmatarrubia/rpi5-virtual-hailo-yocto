#!/bin/bash

set -e

cd /data/homeassistant

if /usr/bin/podman image exists ghcr.io/home-assistant/home-assistant:stable
then
    echo "Home Assistant image already exists. Skipping pull."
else
    # Since pulling will take a while, we can notify systemd that we are still starting up
    systemd-notify --ready --status="Pulling Home Assistant image..."
    echo "Pulling Home Assistant image..."
    /usr/bin/podman-compose pull
fi

systemd-notify --ready --status="Starting Home Assistant..."

echo "Starting Home Assistant..."
/usr/bin/podman-compose up -d

systemd-notify --status="Already started Home Assistant."
