# Tiny Core Linux on SD card

Install and run Tiny Core 5.4 (dCore Arm V7hf) on SD card of Allwinner A10 boards.

## Please read carefully

Compared to the original : http://tinycorelinux.net/dCore/armv7/Allwinner-A10
- Instructions I put in here are minimal.
- *mkSDcard.sh* is modified.
- uCore and uImage is already included.
- Personally tested on MK802ii.

## Supported boards

- Cubieboard
- Cubieboard-512MB
- Hackberry
- hyundai-a7hd
- marsboard
- mele-a1000
- mk802
- mk802-1GB
- mk802ii

## Installation

### On your PC

Step 1. Get a copy of tinycorelinux-sdcard 

>wget https://github.com/battcor/tinycorelinux-sdcard/archive/master.zip

or

>git clone https://github.com/battcor/tinycorelinux-sdcard.git

Step 2. Insert the SD card then run the script

>./mkSDcard.sh mmcblk0

The script will prompt you for your board and script bin options.

**Caution**: SD card will be wiped clean and reformatted.

### On your Allwinner A10 board

Step 3. Insert the SD card, connect keyboard and LAN cable, then apply power.

Core boots very quickly to the $ prompt.

Step 4. You need to setup your tce directory to store downloaded and imported extensions. 

>tce-setdrive

You should then select by number the partition that you setup to hold extensions from Step 2.

If you do not see the expected partition then use updbootcodes to add waitusb option and reboot to try again. 

To reboot type:

>sudo reboot

Step 5. Check that your network is up and that you have an IP number, type ifconfig to verify.

If you only have wireless access then read : http://tinycorelinux.net/dCore/armv7/Allwinner-A10/README-wifi.txt

Step 6. Backup

>backup

Step 7. Shutdown

>sudo poweroff