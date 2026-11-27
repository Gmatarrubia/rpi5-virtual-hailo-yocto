
inherit bob-user

IMMICH_USER ?= "${BOB_USER_NAME}"
IMMICH_USER[doc] = "immich service runs as docker compose container."
IMMICH_DIR ?= "/home/${IMMICH_USER}/immich"
IMMICH_DIR_INSTALL ?= "/data/immich"
IMMICH_DIR[doc] = "Installation directory used by immich."
IMMICH_CONFIG_DIR ?= "${IMMICH_DIR}/config"
IMMICH_CONFIG_DIR[doc] = "Configuration directory used by immich."
IMMICH_DB_PASSWORD ?= "postgresimmich"
