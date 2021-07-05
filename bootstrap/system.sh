#!/bin/sh

if [ -e $(dirname $0)/.env ]; then
	source $(dirname $0)/.env
fi

set -xe


# base stuff
update-ca-certificates

ROOT_PWD=$(openssl rand -base64 30)
echo "root:${ROOT_PWD}" | chpasswd

if [ -z "${SYSTEM_HOST_NAME}" ]; then
	SYSTEM_HOST_NAME="unkown"
fi
setup-hostname $SYSTEM_HOST_NAME
echo "127.0.0.1    $SYSTEM_HOST_NAME $SYSTEM_HOST_NAME.localdomain" > /etc/hosts

if [ -z "${SYSTEM_KEYMAP}" ]; then

	setup-keymap us us-euro
else
	setup-keymap ${SYSTEM_KEYMAP}
fi

# time
apk add chrony tzdata
if [ -z "${SYSTEM_TIME_ZONE}" ]; then
	setup-timezone -z UTC
else
	setup-timezone -z ${SYSTEM_TIME_ZONE}
fi

# other stuff
if [ "$SOFTWARE_SYSTEM" =~ "bash" ] || [ "$SOFTWARE_ADDITIONAL" =~ "bash" ]; then
	sed -i 's/\/bin\/ash/\/bin\/bash/g' /etc/passwd
fi
