# Depends on aardvark-dns so that podman-compose can resolve container names to IP addresses when using the default network mode.
RDEPENDS:${PN}:append = " python3-shell aardvark-dns"

