SUMMARY = "Deploy a systemd service that installs the compose.yml and hass data to the final path"
HOMEPAGE = "https://home-assistant.io/"
LICENSE = "CLOSED"

inherit systemd
require homeassistant.inc

SRC_URI += "\
    file://hass-install.service \
    file://hass-install.sh \
"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

# Container engine dependencies
RDEPENDS:${PN} = " \
    bash \
    rsync \
"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "hass-install.service"

do_install() {
    install -d "${D}${bindir}"
    install -d "${D}${systemd_unitdir}/system"
    install -d "${D}${sysconfdir}/systemd/system/multi-user.target.wants/"
    install -m 0644 "${UNPACKDIR}/hass-install.service" "${D}${systemd_unitdir}/system/"
    ln -s "${systemd_unitdir}/system/hass-install.service" "${D}${sysconfdir}/systemd/system/multi-user.target.wants/hass-install.service"
    sed -i -e 's,@HOMEASSISTANT_DIR@,${HOMEASSISTANT_DIR},g' "${D}${systemd_unitdir}/system/hass-install.service"
    sed -i -e 's,@HOMEASSISTANT_DIR_INSTALL@,${HOMEASSISTANT_DIR_INSTALL},g' "${D}${systemd_unitdir}/system/hass-install.service"
    sed -i -e 's,@HOMEASSISTANT_USER@,${HOMEASSISTANT_USER},g' "${D}${systemd_unitdir}/system/hass-install.service"

    install -m 0755 "${UNPACKDIR}/hass-install.sh" "${D}${bindir}/hass-install.sh"
    sed -i -e 's,@HOMEASSISTANT_DIR@,${HOMEASSISTANT_DIR},g' "${D}${bindir}/hass-install.sh"
    sed -i -e 's,@HOMEASSISTANT_DIR_INSTALL@,${HOMEASSISTANT_DIR_INSTALL},g' "${D}${bindir}/hass-install.sh"
    sed -i -e 's,@HOMEASSISTANT_USER@,${HOMEASSISTANT_USER},g' "${D}${bindir}/hass-install.sh"
}

FILES:${PN} += "\
    ${systemd_unitdir}/system/* \
    ${sysconfdir}/systemd/system/multi-user.target.wants/* \
"
