
inherit bob-user

HOMEASSISTANT_USER ?= "${BOB_USER_NAME}"
HOMEASSISTANT_USER[doc] = "homeassistent service runs as docker compose container."
HOMEASSISTANT_DIR ?= "/home/${HOMEASSISTANT_USER}/homeassistant"
HOMEASSISTANT_DIR_INSTALL ?= "/data/homeassistant"
HOMEASSISTANT_DIR[doc] = "Installation directory used by home-assistant."
HOMEASSISTANT_CONFIG_DIR ?= "${HOMEASSISTANT_DIR}/config"
HOMEASSISTANT_CONFIG_DIR[doc] = "Configuration directory used by home-assistant."
