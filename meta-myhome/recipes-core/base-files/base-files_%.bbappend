FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
    install -d ${D}/data
    install -d ${D}/data2
}

FILES:${PN} += " \
    /data \
    /data2 \
"
