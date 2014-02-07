#!/bin/bash
#
# Check if a reboot is required in Ubuntu
#
if [ -f /var/run/reboot-required ]; then
	echo -e ""
	echo -e "\x1B[00;31mReboot required\x1B[00m"
    exit 1
else
	echo -e ""
	echo -e "\x1B[00;32mReboot not required\x1B[00m"
    exit 0
fi
