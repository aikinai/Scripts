#!/bin/bash
#
# This script updates the local system time using Google's server response
# instead of ntp since ntp is blocked over the proxy.
#

# If run as sudo or root, set up my normal environment
if [ "$(id -u)" == "0" ]; then
    export HOME="/Users/Alan"
    source ~/.bashrc
fi

sudo date -s "$(curl -I "http://www.google.com/" 2>&1 | grep -E '^[[:space:]]*[dD]ate:' | sed 's/^[[:space:]]*[dD]ate:[[:space:]]*//' | head -1l | awk '{print $1, $3, $2,  $5 ,"GMT", $4 }' | sed 's/,//')"
