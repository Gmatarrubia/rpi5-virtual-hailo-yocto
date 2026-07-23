inherit bob-user extrausers

EXTRA_USERS_PARAMS = " \
	groupadd -g 1011 users;\
	useradd \
	-u 1010 \
	--home ${BOB_USER_PATH} \
	--groups users \
	--user-group ${BOB_USER_NAME};\
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
    podman-homeassistant \
    ${HAILO_PKGS} \
"
