#!/bin/sh

if [ -e $(dirname $0)/.env ]; then
	source $(dirname $0)/.env
fi

set -xe

echo "modules=loop,squashfs,sd-mod,usb-storage root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes %CONSOLETTY% rootwait quiet" > /boot/cmdline.txt

cat <<EOF > /boot/config.txt
[pi0]
kernel=vmlinuz-rpi
initramfs initramfs-rpi
[pi0w]
kernel=vmlinuz-rpi
initramfs initramfs-rpi
[pi3]
kernel=vmlinuz-rpi
initramfs initramfs-rpi
arm_64bit=1
[pi3+]
kernel=vmlinuz-rpi
initramfs initramfs-rpi
arm_64bit=1
[pi4]
enable_gic=1
kernel=vmlinuz-rpi4
initramfs initramfs-rpi4
arm_64bit=1
[all]
include usercfg.txt
EOF

cat <<EOF > /boot/usercfg.txt
%BOOTUSERCFG%
EOF

if [ -n "$BOOTUSERCFG" ]; then
	for cmd in $BOOTUSERCFG; do
		echo $cmd >> /boot/usercfg.txt
	done
fi

# fstab
cat <<EOF > /etc/fstab
/dev/mmcblk0p1  /boot           vfat    defaults          0       2
/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1
EOF

cd /boot/overlays && find -type f \( -name "*.dtb" -o -name "*.dtbo" \) | cpio -pudm /boot
