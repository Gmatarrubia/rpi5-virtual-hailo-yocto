SUMMARY = "Deploy a systemd service that reports the raspberry pi temperature and cooling mode"
LICENSE = "CLOSED"

inherit systemd

SRC_URI += "\
    file://rpi-temp-sensor.service \
    file://rpi-temp-sensor.py \
"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

# Container engine dependencies
RDEPENDS:${PN} = " \
    python3 \
    python3-paho-mqtt \
"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "rpi-temp-sensor.service"

do_install() {
    install -d "${D}${bindir}"
    install -d "${D}${systemd_unitdir}/system"
    install -d "${D}${sysconfdir}/systemd/system/multi-user.target.wants/"
    install -m 0644 "${UNPACKDIR}/rpi-temp-sensor.service" "${D}${systemd_unitdir}/system/"
    ln -s "${systemd_unitdir}/system/rpi-temp-sensor.service" "${D}${sysconfdir}/systemd/system/multi-user.target.wants/rpi-temp-sensor.service"
    install -m 0755 "${UNPACKDIR}/rpi-temp-sensor.py" "${D}${bindir}/rpi-temp-sensor.py"
}

FILES:${PN} += "\
    ${systemd_unitdir}/system/* \
    ${sysconfdir}/systemd/system/multi-user.target.wants/* \
    ${bindir}/rpi-temp-sensor.py \
"
