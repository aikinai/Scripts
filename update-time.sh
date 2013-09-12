#!/bin/bash
#
# This script updates the local system time using Google's server response
# instead of ntp since ntp is blocked over the proxy.
#

sudo date -s "$(curl -I "http://www.google.com/" 2>&1 | grep -E '^[[:space:]]*[dD]ate:' | sed 's/^[[:space:]]*[dD]ate:[[:space:]]*//' | head -1l | awk '{print $1, $3, $2,  $5 ,"GMT", $4 }' | sed 's/,//')"
