#!/bin/bash

SERIAL_NUMBER="$(sudo cat -v /sys/firmware/devicetree/base/serial-number)"
USB_UUID="$(sudo blkid -sUUID $USB_PARTITION | cut -d '"' -f 2)"
echo "$SERIAL_NUMBER $USB_UUID" | base64
