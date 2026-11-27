SUMMARY = "Deploy a systemd service that installs the compose.yml and immich data to the final path"
HOMEPAGE = "https://immich.app/"
LICENSE = "CLOSED"

inherit systemd
require immich.inc

SRC_URI += "\
    file://immich-install.service \
    file://immich-install.sh \
"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

# Container engine dependencies
RDEPENDS:${PN} = " \
    bash \
    rsync \
"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "immich-install.service"

do_install() {
    install -d "${D}${bindir}"
    install -d "${D}${systemd_unitdir}/system"
    install -d "${D}${sysconfdir}/systemd/system/multi-user.target.wants/"
    install -m 0644 "${UNPACKDIR}/immich-install.service" "${D}${systemd_unitdir}/system/"
    ln -s "${systemd_unitdir}/system/immich-install.service" "${D}${sysconfdir}/systemd/system/multi-user.target.wants/immich-install.service"
    sed -i -e 's,@IMMICH_DIR@,${IMMICH_DIR},g' "${D}${systemd_unitdir}/system/immich-install.service"
    sed -i -e 's,@IMMICH_DIR_INSTALL@,${IMMICH_DIR_INSTALL},g' "${D}${systemd_unitdir}/system/immich-install.service"
    sed -i -e 's,@IMMICH_USER@,${IMMICH_USER},g' "${D}${systemd_unitdir}/system/immich-install.service"

    install -m 0755 "${UNPACKDIR}/immich-install.sh" "${D}${bindir}/immich-install.sh"
    sed -i -e 's,@IMMICH_DIR@,${IMMICH_DIR},g' "${D}${bindir}/immich-install.sh"
    sed -i -e 's,@IMMICH_DIR_INSTALL@,${IMMICH_DIR_INSTALL},g' "${D}${bindir}/immich-install.sh"
    sed -i -e 's,@IMMICH_USER@,${IMMICH_USER},g' "${D}${bindir}/immich-install.sh"
}

FILES:${PN} += "\
    ${systemd_unitdir}/system/* \
    ${sysconfdir}/systemd/system/multi-user.target.wants/* \
"
