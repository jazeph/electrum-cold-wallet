#!/bin/bash

# test seed: tube feed fringe old toward usual again tell switch bone fortune train

PASSWORD="TEMP_PASS_123_!"
PROGRESS=0

rm -rf /home/pi/.electrum/

if (whiptail --title "Electrum wallet" --yesno "Do you already have an Electrum wallet?" 8 78); then
        SEED=$(whiptail --title "Electrum seed" --inputbox "Enter your Electrum seed" 20 78 3>&1 1>&2 2>&3)
	echo "Restoring Electrum wallet..."
	electrum --offline restore --password "$PASSWORD" "$SEED" | whiptail --title "Setting up Electrum" --gauge "Restoring wallet..." 20 40 $PROGRESS
	echo return=$?
	SEED=""
else
	echo "Creating Electrum wallet..."
        electrum --offline create --password "$PASSWORD" | whiptail --title "Setting up Electrum" --gauge "Creating wallet..." 20 40 $PROGRESS
	echo return=$?
fi

PROGRESS=20
electrum daemon -d | whiptail --title "Setting up Electrum" --gauge "Starting daemon..." 20 40 $PROGRESS

PROGRESS=40
electrum load_wallet --password "$PASSWORD" | whiptail --title "Setting up Electrum" --gauge "Loading wallet..." 20 40 $PROGRESS

PROGRESS=60
electrum getmpk | whiptail --title "Setting up Electrum" --gauge "Retrieving master public key..." 20 40 $PROGRESS
