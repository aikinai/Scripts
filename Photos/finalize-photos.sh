#!/usr/bin/env bash
#
# finalize-photos.sh
# Alan Rogers
# 2018/09/07
#
# Master script that just runs the other scripts
# I use to finalize my exported JPGs or HEICs
#
# Usage: finalize-jpg.sh INPUT_DIRECTORY
#

# First argument is the exported photo directory to finalize

if [ -z "$1" ]; then
    echo -e ""
    echo -e "USAGE: finalize-photos.sh INPUT"
    echo -e ""
    exit 1
else
  DIR=$1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

"${SCRIPT_DIR}"/encode-heic.swift "${DIR}"/*.tif
if [ $? -ne 0 ]; then
  exit 1
fi
rm -rf "${DIR}"/*.tif
"${SCRIPT_DIR}"/exif-to-modified.sh "${DIR}"
"${SCRIPT_DIR}"/tag-keywords.sh "${DIR}"
"${SCRIPT_DIR}"/copy-tags.sh "${DIR}"

# echo -e ""
# echo -e "\x1B[01;35mCopy Share tagged photos to ~/Pictures/Share/\x1B[00m"
# rsync -vaX $(tag -f "Share" "${DIR}") ~/Pictures/Share/

echo -e ""
echo -e "\x1B[01;35mCopy Frame tagged photos to ~/Pictures/Frame/\x1B[00m"
# This doesn't work with files with spaces. Need to fix it.
rsync -vaX $(tag -f "Frame" "${DIR}") ~/Pictures/Frame/

exit 0
