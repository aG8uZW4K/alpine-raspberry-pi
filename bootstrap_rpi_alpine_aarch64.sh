#! /bin/sh

set -xe

DIR=$(dirname $0)
ENV=$DIR/bootstrap/.env

#
#  environment vars for 
#

export ARCH=aarch64
export QEMU_EMULATOR=qemu-user-static

#
# bootstrap
#
export CONSOLETTY=ttyS0
export CONSOLETTYENABLED=1


SOFTWARE_SYSTEM="wpa_supplicant wireless-tools wireless-regdb iw dbus avahi \
bluez bluez-deprecated dosfstools e2fsprogs-extra parted sudo ca-certificates \
openssl chrony tzdata nano htop curl wget bash bash-completion findutils \
linux-rpi linux-rpi4 raspberrypi-bootloader openssh haveged"
SOFTWARE_ADDITIONAL="python3 py3-pip"
USER_FIRST_USER_USERNAME="piremote"
USER_FIRST_USER_SSHPUBKEY_SRCFILE=/tmp/id_rsa.pub
USER_FIRST_USER_SSHPUBKEY=""
SYSTEM_HOST_NAME=""
SYSTEM_KEYMAP=""
SYSTEM_TIME_ZONE="UTC"

echo -n "" > $ENV

if [ -n "$USER_FIRST_USER_SSHPUBKEY_SRCFILE" ] && [ -e "$USER_FIRST_USER_SSHPUBKEY_SRCFILE" ]; then
	
	USER_FIRST_USER_SSHPUBKEY_BASE64=$(base64 -w 0 $USER_FIRST_USER_SSHPUBKEY_SRCFILE)
fi

KEYS="SOFTWARE_SYSTEM SOFTWARE_ADDITIONAL USER_FIRST_USER_USERNAME USER_FIRST_USER_SSHPUBKEY USER_FIRST_USER_SSHPUBKEY_BASE64 SYSTEM_HOST_NAME SYSTEM_KEYMAP SYSTEM_TIME_ZONE"

for KEY in $(echo $KEYS); do
	if [  -n "${KEY}" ]; then
		 echo "export ${KEY}=\"$(eval "echo \"\$$KEY\"")\"" >> $ENV
	fi
done

#
# prepare debian
#
apt-get	update
apt-get install -y qemu-user-static

#
# start install
#
cd $DIR
./make-image $1 
