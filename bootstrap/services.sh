#!/bin/sh

if [ -e $(dirname $0)/.env ]; then
	source $(dirname $0)/.env
fi

set -xe

for service in devfs dmesg mdev; do
	if [ -e /etc/init.d/$service ]; then
		rc-update add $service sysinit
	fi
done

for service in modules sysctl hostname bootmisc swclock syslog swap; do
    if [ -e /etc/init.d/$service ]; then
		rc-update add $service boot
	fi
done

for service in dbus haveged sshd chronyd local networking avahi-daemon bluetooth wpa_supplicant wpa_cli udev-trigger udev; do
	if [ "$service" == "bluetooth" ]; then
		if [ "$SOFTWARE_SYSTEM" =~ "bluez" ] || [ "$SOFTWARE_ADDITIONAL" =~ "bluez" ]; then
			if [ -e /etc/init.d/$service ]; then
				rc-update add $service default
			fi
		fi
	fi
	if [ -e /etc/init.d/$service ]; then
		rc-update add $service default
	fi
done

for service in mount-ro killprocs savecache; do
    if [ -e /etc/init.d/$service ]; then
		rc-update add $service shutdown
	fi
done
