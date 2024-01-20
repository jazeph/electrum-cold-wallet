#!/bin/bash

source config.sh

# no autologin
sudo systemctl --quiet set-default multi-user.target
sudo rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf

echo "\n"
echo "=================="
echo "Update and upgrade"
echo "=================="
echo "\n"
sudo apt update
sudo apt -y upgrade
#sudo apt -y dist-upgrade

echo "\n"
echo "========================================"
echo "Setup USB automounting + trigger scripts"
echo "========================================"
echo "\n"

sudo apt -y install autofs
sudo bash -c "echo \"/media/ /etc/auto.ext-usb --timeout=10,defaults,user,exec,uid=1000\" >> /etc/auto.master"
sudo bash -c "echo \"usb -fstype=auto :$USB_PARTITION\" >> /etc/auto.ext-usb"
sudo systemctl restart autofs

sudo cp scripts/device_added.sh /bin/
sudo chmod +x /bin/device_added.sh
sudo cp scripts/80-process-usb.rules /etc/udev/rules.d/

echo "\n"
echo "=================="
echo "Setup dependencies"
echo "=================="
echo "\n"
sudo apt -y install \
	jq \
	python3-pyqt5 libsecp256k1-0 python3-cryptography python3-setuptools python3-pip

echo "\n"
echo "============================="
echo "Download and install Electrum"
echo "============================="
echo "\n"
wget https://download.electrum.org/$ELECTRUM_VERSION/Electrum-$ELECTRUM_VERSION.tar.gz

#wget https://download.electrum.org/$ELECTRUM_VERSION/Electrum-$ELECTRUM_VERSION.tar.gz.asc
#wget https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc
#gpg --import ThomasV.asc
#gpg --verify Electrum-$ELECTRUM_VERSION.tar.gz.asc

python3 -m pip install --user Electrum-$ELECTRUM_VERSION.tar.gz

sudo bash -c "echo \"alias electrum=/home/pi/.local/bin/electrum\" > /etc/rc.local"
sudo bash -c "echo \"electrum daemon -d\" >> /etc/rc.local"

sudo bash -c "echo none > /sys/class/leds/led0/trigger"

alias electrum=/home/pi/.local/bin/electrum

# generate Electrum password based on device serial number and inserted USB stick UUID
PASSWORD=$(./generate_password.sh)


echo PASSWORD=$PASSWORD





if (whiptail --title "Electrum wallet" --yesno "Do you already have an Electrum wallet?" 8 78); then
	whiptail --title "Electrum seed" --inputbox "Enter your Electrum seed" | electrum restore --password "$PASSWORD" -
else
	electrum create --password "$PASSWORD"
fi


# control LED: https://forums.raspberrypi.com/viewtopic.php?t=12530#p136266

# /dev/sda1: UUID="A43E-1F49" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="ca445441-01"
# /dev/sda1: UUID="34B9-4192" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="ca445441-01"
