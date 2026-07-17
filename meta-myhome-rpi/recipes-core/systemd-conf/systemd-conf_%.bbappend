FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://eth.network \
    file://en.network \
    file://wlan.network \
"

FILES:${PN} += " \
    ${sysconfdir}/systemd/network/eth.network \
    ${sysconfdir}/systemd/network/en.network \
    ${sysconfdir}/systemd/network/wlan.network \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${UNPACKDIR}/eth.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${UNPACKDIR}/en.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${UNPACKDIR}/wlan.network ${D}${sysconfdir}/systemd/network
}
