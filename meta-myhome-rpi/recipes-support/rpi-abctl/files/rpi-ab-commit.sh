#!/bin/sh
set -eu

systemctl --quiet is-active homeassistant.service
rpi-abctl commit
