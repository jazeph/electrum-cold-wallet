#!/bin/bash

kill $(ps -ef | grep flash_led_start.sh | grep -v "grep" | awk '{print $2}') 2> /dev/null
