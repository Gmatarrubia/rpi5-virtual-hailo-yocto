
inherit bob-user-vars
inherit useradd

USERADD_PACKAGES += "${PN}"
USERADD_PARAM:${PN} = " \
	--uid 1010 \
	--create-home --home-dir ${BOB_USER_PATH} \
	--user-group \
	--password '${BOB_USER_PASSWORD}' \
	--system \
	--shell /bin/bash \
	${BOB_USER_NAME} \
"
