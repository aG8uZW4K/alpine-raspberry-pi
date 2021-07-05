#!/bin/sh

if [ -e $(dirname $0)/.env ]; then
	source $(dirname $0)/.env
fi

set -xe

if [ -e "/etc/conf.d/wpa_supplicant" ]; then
	sed -i 's/wpa_supplicant_args=\"/wpa_supplicant_args=\" -u -Dwext,nl80211/' /etc/conf.d/wpa_supplicant

	echo -e 'brcmfmac' >> /etc/modules

cat <<EOF > /boot/wpa_supplicant.conf
	network={
 ssid="SSID"
 psk="PASSWORD"
}
EOF

	ln -s /boot/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
fi

cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto wlan0
iface wlan0 inet dhcp
  up iwconfig wlan0 power off
  
EOF

if [ "$SOFTWARE_SYSTEM" =~ "bluez" ] || [ "$SOFTWARE_ADDITIONAL" =~ "bluez" ]; then
	sed -i '/bcm43xx/s/^#//' /etc/mdev.conf
fi
