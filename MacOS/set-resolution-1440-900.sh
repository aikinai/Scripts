#!/usr/bin/env bash
#
# set-resolution-1440-900.sh
# Alan Rogers
# 2020/05/24
#
# Forces resolution to 1440×900
#
# Usage: set-resolution-1440-900.sh
#
# Requires display_manager.py
# https://github.com/univ-of-utah-marriott-library-apple/display_manager/
#

# Check for display_manager.py
# https://github.com/univ-of-utah-marriott-library-apple/display_manager/
#if ! command -v /usr/local/bin/display_manager.py > /dev/null; then
if ! command -v /usr/local/bin/display_manager.py > /Users/Alan/Desktop/output; then
    echo -e ""
    echo -e "\x1B[00;31mERROR\x1B[00m: Please install display_manager.py."
    echo -e ""
    exit 1
fi

# Set resolution to 1440×900
/usr/local/bin/display_manager.py res 1440 900 > /Users/Alan/Desktop/output2

exit 0
