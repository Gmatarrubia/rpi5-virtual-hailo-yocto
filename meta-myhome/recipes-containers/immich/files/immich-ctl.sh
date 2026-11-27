#!/bin/bash

set -e

cd /data/immich

start() {
    if /usr/bin/podman image exists ghcr.io/immich-app/immich-server
    then
        echo "Immich image already exists. Skipping pull."
    else
        # Since pulling will take a while, we can notify systemd that we are still starting up
        systemd-notify --ready --status="Pulling Immich image..."
        echo "Pulling Immich image..."
        /usr/bin/podman-compose pull
    fi

    systemd-notify --ready --status="Starting Immich..."

    echo "Starting Immich..."
    /usr/bin/podman-compose up -d

    systemd-notify --status="Already started Immich."
}

stop() {
    echo "Stopping Immich..."
    /usr/bin/podman-compose stop
}

case "${1:-}" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    *)
        echo "Usage: $0 {start|stop}" >&2
        exit 2
        ;;
esac
