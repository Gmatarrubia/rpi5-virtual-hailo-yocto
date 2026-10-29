FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

PACKAGECONFIG_CONFARGS = ""

SRC_URI += " \
    file://09-swupdate-args \
    file://swupdate.cfg \
    file://autoboot.txt \
    file://tryboot.sh \
"

RDEPENDS:${PN} += "\
    rpi-abctl \
    bash \
"

do_install:append() {
    install -m 0644 "${UNPACKDIR}"/09-swupdate-args "${D}${libdir}/swupdate/conf.d/"
    sed -i "s#@MACHINE@#${MACHINE}#g" "${D}${libdir}/swupdate/conf.d/09-swupdate-args"

    install -d "${D}${sysconfdir}"
    install -m 644 "${UNPACKDIR}"/swupdate.cfg "${D}${sysconfdir}/"

    install -d "${D}/bootselector"
    install -m 0644 "${UNPACKDIR}"/autoboot.txt "${D}/bootselector/autoboot.txt"

    install -d "${D}/${bindir}"
    install -m 0755 "${UNPACKDIR}/tryboot.sh" "${D}/${bindir}/tryboot.sh"
}

FILES:${PN} += "bootselector/autoboot.txt"
