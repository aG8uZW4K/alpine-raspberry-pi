#!/bin/sh

if [ -e $(dirname $0)/.env ]; then
	source $(dirname $0)/.env
fi

set -xe

if [ -z "${USER_FIRST_USER_USERNAME}" ]; then
	USER_FIRST_USER_USERNAME="pi"
fi

apk add sudo

for GRP in spi i2c gpio; do
	addgroup --system $GRP
done

adduser -s /bin/bash -D $USER_FIRST_USER_USERNAME

for GRP in adm dialout cdrom audio users video games input gpio spi i2c netdev; do
  adduser $USER_FIRST_USER_USERNAME $GRP
done

USER_FIRST_USER_PWD="raspberry"

if [ -n "${USER_FIRST_USER_SSHPUBKEY}" ] || [ -n "${USER_FIRST_USER_SSHPUBKEY_BASE64}" ]; then
	
	USER_FIRST_USER_PWD=$(openssl rand -base64 20)
	mkdir -p /home/${USER_FIRST_USER_USERNAME}/.ssh
	if [ -n "${USER_FIRST_USER_SSHPUBKEY}" ]; then
		echo "${USER_FIRST_USER_SSHPUBKEY}" > /home/${USER_FIRST_USER_USERNAME}/.ssh/authorized_keys
	fi
	if [ -n "${USER_FIRST_USER_SSHPUBKEY_BASE64}" ]; then
		echo $USER_FIRST_USER_SSHPUBKEY_BASE64 | base64 -d >> /home/${USER_FIRST_USER_USERNAME}/.ssh/authorized_keys
	fi
	echo "${USER_FIRST_USER_PWD}" > /home/${USER_FIRST_USER_USERNAME}/password
	chmod -R 750 /home/${USER_FIRST_USER_USERNAME}
	chmod 644 /home/${USER_FIRST_USER_USERNAME}/.ssh/authorized_keys
	chmod 600 /home/${USER_FIRST_USER_USERNAME}/password
	chown -R ${USER_FIRST_USER_USERNAME}: /home/${USER_FIRST_USER_USERNAME}
fi
echo "${USER_FIRST_USER_USERNAME}:${USER_FIRST_USER_PWD}" | /usr/sbin/chpasswd
echo "${USER_FIRST_USER_USERNAME} ALL=(ALL) ALL" >> /etc/sudoers.d/${USER_FIRST_USER_USERNAME}
