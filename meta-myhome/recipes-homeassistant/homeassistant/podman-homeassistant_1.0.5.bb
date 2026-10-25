SUMMARY = "Open-source home automation platform running on Docker Compose container"
HOMEPAGE = "https://home-assistant.io/"
LICENSE = "CLOSED"

inherit systemd
require homeassistant.inc

SRC_URI += "\
    file://homeassistant.service \
    file://ha_backup.tar.gz \
    file://compose.yml \
"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

DEPENDS = "rsync-native"

# Container engine dependencies
RDEPENDS:${PN} = " \
    bash \
    podman \
    podman-compose \
    homeassistant-install \
"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "homeassistant.service"

do_install:append () {
    # Install docker compose stuff
    install -d "${D}${HOMEASSISTANT_DIR}"
    rsync -a "${UNPACKDIR}/" "${D}${HOMEASSISTANT_DIR}/"
    chown -R "${HOMEASSISTANT_USER}:${HOMEASSISTANT_USER}" "${D}${HOMEASSISTANT_DIR}"
    chmod -R 755 "${D}${HOMEASSISTANT_DIR}"

    # Replace compose.yml with the correct version
    install -m 0644 "${UNPACKDIR}/compose.yml" "${D}${HOMEASSISTANT_DIR}/compose.yml"

    # Install systemd unit files and set correct config directory
    install -d "${D}${systemd_unitdir}/system"
    install -d "${D}${sysconfdir}/systemd/system/multi-user.target.wants/"
    install -m 0644 "${UNPACKDIR}/homeassistant.service" "${D}${systemd_unitdir}/system/"
    ln -s "${systemd_unitdir}/system/homeassistant.service" "${D}${sysconfdir}/systemd/system/multi-user.target.wants/homeassistant.service"
    sed -i -e 's,@HOMEASSISTANT_DIR_INSTALL@,${HOMEASSISTANT_DIR_INSTALL},g' "${D}${systemd_unitdir}/system/homeassistant.service"
    sed -i -e 's,@HOMEASSISTANT_USER@,${HOMEASSISTANT_USER},g' "${D}${systemd_unitdir}/system/homeassistant.service"
}

FILES:${PN} += "\
    ${HOMEASSISTANT_DIR}/* \
    ${systemd_unitdir}/system/* \
    ${sysconfdir}/systemd/system/multi-user.target.wants/* \
"
