#!/bin/sh
# (c) Robert Shingledecker 2013
. /etc/init.d/tc-functions
checkroot

if [ ! -f /usr/local/sbin/fdisk ]; then
	echo "Loading GNU fdisk util-linux.tcz"
	su tc -c "tce-load -i util-linux.tcz"
	[ "$?" == 0 ] || exit 1
fi

if [ ! -f /usr/local/sbin/mkfs.vfat ]; then
	echo "Loading dosfstools.tcz"
	su tc -c "tce-load -i dosfstools.tcz"
	[ "$?" == 0 ] || exit 1
fi

DEVICE="$1"
if [ -z "$DEVICE" ]; then
	echo "Usage: sdcard.sh device"
	echo "Example: sdcard.sh sdd"
	exit 1
fi

if [ ! -b /dev/"$DEVICE" ]; then
	echo "Invalid device: /dev/$DEVICE"
	exit 1
fi

find boards -type d -name "??*" -mindepth 1 | sort | select "Select Target Board" "-"
read ANS < /tmp/select.ans
[ "$ANS" == "q" ] && exit 1
BOARD="$ANS"

ls boards/*.bin | select "Select script.bin" "-"
read ANS < /tmp/select.ans
[ "$ANS" == "q" ] && exit 1
SCRIPT="$ANS"

cp "$BOARD"/* .
cp "$SCRIPT" script.bin
sync

echo "Writing zero's to beginning of /dev/$DEVICE"
dd if=/dev/zero of=/dev/$DEVICE bs=1M count=1
sync

echo
echo "Partitioning /dev/$DEVICE"
/usr/local/sbin/fdisk -u=sectors /dev/$DEVICE << EOF >/dev/null 2>&1
n
p
1
2048
+8M
w
EOF

sync; sleep 5

echo
echo "Copying u-boot & spl-bin"
dd if=sunxi-spl.bin of=/dev/$DEVICE bs=1024 seek=8
dd if=u-boot.bin of=/dev/$DEVICE bs=1024 seek=32
sync; sleep 5

echo
echo "Formatting /dev/$DEVICE"p1
mkfs.vfat  /dev/"$DEVICE"p1
sync; sleep 5
hdparm -z /dev/$DEVICE
sync; sleep 5
rebuildfstab
#
busybox.suid mount /dev/"$DEVICE"p1 /mnt/"$DEVICE"p1
if [ "$?" != 0 ]; then
	echo "Mount failed! - Abort"
	exit 1
fi

echo
echo "Copying release files"
cp uImage uCore uEnv.txt script.bin boot.scr /mnt/"$DEVICE"p1/.
sync; sleep 5
ls -l /mnt/"$DEVICE"p1/.

umount /mnt/"$DEVICE"p1
echo "SD card setup complete\n"
