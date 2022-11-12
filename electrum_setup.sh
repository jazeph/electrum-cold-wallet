#!/bin/bash

# test seed: tube feed fringe old toward usual again tell switch bone fortune train

PASSWORD="TEMP_PASS_123_!"

rm -rf /home/pi/.electrum/

electrum daemon -d

if (whiptail --title "Electrum wallet" --yesno "Do you already have an Electrum wallet?" 8 78); then
        SEED=$(whiptail --title "Electrum seed" --inputbox "Enter your Electrum seed" 20 78 3>&1 1>&2 2>&3)
	echo "Restoring Electrum wallet... $SEED"
	electrum restore --password "$PASSWORD" "$SEED"
	SEED=""
else
	echo "Creating Electrum wallet..."
        electrum create --password "$PASSWORD"
fi

electrum load_wallet --password "$PASSWORD"
electrum getmpk
