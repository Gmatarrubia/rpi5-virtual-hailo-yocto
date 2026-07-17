SUMMARY = "SSH keys for bob user"
LICENSE = "CLOSED"

inherit bob-user-vars

SSH_KEYS_DIR = "${BOB_USER_PATH}/.ssh"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install:append() {
    install -d "${D}/${SSH_KEYS_DIR}"

    # If host user has public key, then copy it to the target image.
    if [ -f "/home/ubuntu/.ssh/id_rsa.pub" ]; then
        install -m 0600 "/home/ubuntu/.ssh/id_rsa.pub" \
            "${D}/${SSH_KEYS_DIR}/authorized_keys"
    else
        bbwarn "No public key found for host user. No authorized_keys file will be created."
    fi
}

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

FILES:${PN} += "${SSH_KEYS_DIR}/authorized_keys"
