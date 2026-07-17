inherit bob-user-vars extrausers

EXTRA_USERS_PARAMS = " \
	groupadd -g 1011 users;\
	useradd \
	--uid 1010 \
	--create-home --home-dir ${BOB_USER_PATH} \
	--groups users \
	--user-group \
    --password ${BOB_USER_PASSWORD} \
    --shell /bin/sh \
    ${BOB_USER_NAME}; \
"

HAILO_PKGS = ""
HAILO_PKGS:hailo = "\
    packagegroup-hailo-hailort \
    hailo-firmware \
    hailo-pci \
"

CORE_IMAGE_EXTRA_INSTALL += " \
    linux-firmware-bcm43430 \
    bridge-utils \
    hostapd \
    iptables \
    avahi-daemon \
    kernel-modules \
    openssh openssh-keygen openssh-sftp-server \
    ntp \
    packagegroup-core-boot \
    procps \
    tzdata \
    iw \
    xdg-user-dirs \
    nano \
    ssh-keys \
    podman-homeassistant \
    util-linux-lsblk \
    bluez5 \
    raspi-gpio \
    rpio \
    rpi-gpio \
    ${HAILO_PKGS} \
"

# ROOTFS Size configs
IMAGE_ROOTFS_SIZE = "36700160"
IMAGE_ROOTFS_EXTRA_SPACE := ""
