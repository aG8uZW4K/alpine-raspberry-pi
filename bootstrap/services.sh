#!/bin/sh

if [ -e $(dirname $0)/.env ]; then
	source $(dirname $0)/.env
fi

set -xe

for service in devfs dmesg mdev; do
	rc-update add $service sysinit
done

for service in modules sysctl hostname bootmisc swclock syslog swap; do
	rc-update add $service boot
done

for service in dbus haveged sshd chronyd local networking avahi-daemon bluetooth wpa_supplicant wpa_cli; do
	if [ "$service" == "bluetooth" ]; then
		if [ "$SOFTWARE_SYSTEM" =~ "bluez" ] || [ "$SOFTWARE_ADDITIONAL" =~ "bluez" ]; then
			rc-update add $service default
		fi
	fi
	rc-update add $service default
done

for service in mount-ro killprocs savecache; do
	rc-update add $service shutdown
done
