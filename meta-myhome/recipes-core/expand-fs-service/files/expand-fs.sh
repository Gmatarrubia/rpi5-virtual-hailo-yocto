#!/bin/sh

set -e
current_partition="$(cat /proc/cmdline | sed -n 's/.*root=\([^ ]*\).*/\1/p')"
/usr/sbin/resize2fs "${current_partition}" -f
