SUMMARY = "A/B update manager scripts"
LICENSE = "CLOSED"

inherit bob-user-vars systemd

SRC_URI += "\
    file://rpi-abctl.sh \
    file://rpi-ab-commit.sh \
    file://rpi-ab-commit.service \
"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

# Container engine dependencies
RDEPENDS:${PN} = " \
    bash \
"

SYSTEMD_SERVICE:${PN} = "rpi-ab-commit.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    # Scripts install
    install -d "${D}${bindir}"
    install -m 0655 "${UNPACKDIR}/rpi-abctl.sh" "${D}${bindir}/rpi-abctl"
    install -m 0644 "${UNPACKDIR}/rpi-ab-commit.sh" "${D}${bindir}/rpi-ab-commit.sh"
    # Service install
    install -d "${D}${systemd_unitdir}/system"
    install -m 0644 "${UNPACKDIR}/rpi-ab-commit.service" "${D}${systemd_unitdir}/system/rpi-ab-commit.service"

}

FILES:${PN} += "\
    ${bindir}/* \
    ${systemd_unitdir}/system/* \
"
