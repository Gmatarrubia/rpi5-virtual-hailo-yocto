FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
    file://10-bob-sudo \
"

do_install:append() {
    install -d ${D}/data
    install -d ${D}/data2

    install -d ${D}/etc/sudoers.d
    install -m 0644 ${UNPACKDIR}/10-bob-sudo ${D}/etc/sudoers.d/10-bob-sudo
}

FILES:${PN} += " \
    /data \
    /data2 \
    /etc/sudoers.d/10-bob-sudo \
"
