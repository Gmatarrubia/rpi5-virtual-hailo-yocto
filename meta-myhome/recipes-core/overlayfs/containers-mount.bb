SUMMARY = "Mount the containers data partition"

DESCRIPTION = "Mount the ext4 data partition at /var/lib/containers"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SECTION = "base"

PV = "0.1"

SRC_URI = " \
    file://var-lib-containers.mount \
    file://containers-dirs.service \
"

inherit systemd

do_install () {
    install -d ${D}${systemd_system_unitdir}

    install -m 0644 ${UNPACKDIR}/var-lib-containers.mount ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/containers-dirs.service ${D}${systemd_system_unitdir}
}

SYSTEMD_SERVICE:${PN} = "var-lib-containers.mount containers-dirs.service"
