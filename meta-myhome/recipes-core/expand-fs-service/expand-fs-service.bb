SUMMARY = "Deploy a systemd service that expands the filesystem to the maximum size of the partition on first boot"
LICENSE = "CLOSED"

inherit systemd

SRC_URI += "\
    file://expand-fs.service \
    file://expand-fs.sh \
"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

# Container engine dependencies
RDEPENDS:${PN} = " \
    bash \
    e2fsprogs-resize2fs \
"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "expand-fs.service"

do_install() {
    install -d "${D}${bindir}"
    install -d "${D}${systemd_unitdir}/system"
    install -d "${D}${sysconfdir}/systemd/system/multi-user.target.wants/"
    install -m 0644 "${UNPACKDIR}/expand-fs.service" "${D}${systemd_unitdir}/system/"
    ln -s "${systemd_unitdir}/system/expand-fs.service" "${D}${sysconfdir}/systemd/system/multi-user.target.wants/expand-fs.service"

    install -m 0755 "${UNPACKDIR}/expand-fs.sh" "${D}${bindir}/expand-fs.sh"
}

FILES:${PN} += "\
    ${bindir}/expand-fs.sh \
    ${systemd_unitdir}/system/* \
    ${sysconfdir}/systemd/system/multi-user.target.wants/* \
"
