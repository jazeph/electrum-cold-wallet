#!/bin/bash

LED_ON="false"

while true
do
        for var in "$@"
        do
                if "$LED_ON" == "true"; then
                        LED_ON="false"
			echo 0 > /sys/class/leds/led0/brightness
                else
                        LED_ON="true"
			echo 1 > /sys/class/leds/led0/brightness
                fi
                sleep $var
        done
done
