SUMMARY = "Root filesystem for swupdate as rescue system"
DESCRIPTION = "Root FS to start swupdate in rescue mode	\
		"
LICENSE = "MIT"

require recipes-core/images/core-image-minimal.bb
require image-common.inc

CORE_IMAGE_EXTRA_INSTALL += " \
    swupdate \
    swupdate-www \
    u-boot-fw-utils \
"
IMAGE_FSTYPES = "wic.bz2 wic.bmap ext4.gz"
WKS_FILE = "usbimage-raspberrypi.wks"

IMAGE_CMD:wic:append() {
    BOOT_IMG="${IMGDEPLOYDIR}/swupdate-podman-hass-boot.vfat"
    for boot_part in ${build_wic}/*.p2; do
        bbnote "Copied boot part ${boot_part} to ${BOOT_IMG}"
        cp "${boot_part}" "${BOOT_IMG}"
    done
}
