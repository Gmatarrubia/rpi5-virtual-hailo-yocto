
inherit bob-user-vars
inherit useradd

USERADD_PACKAGES += "${PN}"
USERADD_PARAM:${PN} = " \
	--uid 1010 \
	--create-home --home-dir ${BOB_USER_PATH} \
	--user-group \
	${BOB_USER_NAME} \
"
