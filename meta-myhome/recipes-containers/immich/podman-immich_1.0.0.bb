SUMMARY = "Open-source home automation platform running on Docker Compose container"
HOMEPAGE = "https://immich.app/"
LICENSE = "CLOSED"

inherit systemd
require immich.inc

SRC_URI += "\
    file://immich.service \
    file://compose.yml \
    file://immich-ctl.sh \
    file://env \
"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

#DEPENDS = "rsync-native"

# Container engine dependencies
RDEPENDS:${PN} = " \
    bash \
    podman \
    podman-compose \
    immich-install \
"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "immich.service"

do_install:append () {
    # Install docker compose stuff
    install -d "${D}${IMMICH_DIR}"
#    rsync -a "${UNPACKDIR}/" "${D}${IMMICH_DIR}/"
#    chown -R "${IMMICH_USER}:${IMMICH_USER}" "${D}${IMMICH_DIR}"
#    chmod -R 755 "${D}${IMMICH_DIR}"

    # Replace compose.yml with the correct version
    install -m 0644 "${UNPACKDIR}/compose.yml" "${D}${IMMICH_DIR}/compose.yml"

    # Install start control script
    install -d "${D}${bindir}"
    install -m 0755 "${UNPACKDIR}/immich-ctl.sh" "${D}${bindir}/immich-ctl.sh"

    # Install systemd unit files and set correct config directory
    install -d "${D}${systemd_unitdir}/system"
    install -d "${D}${sysconfdir}/systemd/system/multi-user.target.wants/"
    install -m 0644 "${UNPACKDIR}/immich.service" "${D}${systemd_unitdir}/system/"
    ln -s "${systemd_unitdir}/system/immich.service" "${D}${sysconfdir}/systemd/system/multi-user.target.wants/immich.service"
    sed -i -e 's,@IMMICH_DIR_INSTALL@,${IMMICH_DIR_INSTALL},g' "${D}${systemd_unitdir}/system/immich.service"
    sed -i -e 's,@IMMICH_USER@,${IMMICH_USER},g' "${D}${systemd_unitdir}/system/immich.service"

    install -m 0644 "${UNPACKDIR}/env" "${D}${IMMICH_DIR}/env"
    sed -i -e 's,@DB_PASS@,${IMMICH_DB_PASSWORD},g' "${D}${IMMICH_DIR}/env"
}

FILES:${PN} += "\
    ${IMMICH_DIR}/* \
    ${systemd_unitdir}/system/* \
    ${bindir}/immich-ctl.sh \
    ${sysconfdir}/systemd/system/multi-user.target.wants/* \
"
