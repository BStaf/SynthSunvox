#/bin/bash

sunvoxZipFile="sunvox-1.9.5d.zip"
sunvoxDownloadSite="https://warmplace.ru/soft/sunvox/"

echo config soundcard to AIY

set -o errexit

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 1>&2
   exit 1
fi

set -e

sed -i \
  -e "s/^dtparam=audio=on/#\0/" \
  -e "s/^#\(dtparam=i2s=on\)/\1/" \
  /boot/config.txt
grep -q "dtoverlay=i2s-mmap" /boot/config.txt || \
  echo "dtoverlay=i2s-mmap" >> /boot/config.txt
grep -q "dtoverlay=googlevoicehat-soundcard" /boot/config.txt || \
  echo "dtoverlay=googlevoicehat-soundcard" >> /boot/config.txt
grep -q "dtparam=i2s=on" /boot/config.txt || \
  echo "dtparam=i2s=on" >> /boot/config.txt

if hash pulseaudio>/dev/null; then
	echo "pulseaudio already installed"
else
	echo "pulseaudio not already installed"
	sudo apt-get --assume-yes install pulseaudio pavucontrol paprefs
fi

sunvoxFullDownloadPath="$sunvoxDownloadSite$sunvoxZipFile"
sunvoxDir="sunvox"

if [ -d "$sunvoxDir" ]; then
	echo SunVox already installed
else
	sudo apt-get --assume-yes install libsdl2-2.0
	wget "$sunvoxFullDownloadPath" 
	unzip "$sunvoxZipFile"
	rm "$sunvoxZipFile"
	chmod a+x sunvox/sunvox/linux_arm_armhf_raspberry_pi/sunvox
fi
