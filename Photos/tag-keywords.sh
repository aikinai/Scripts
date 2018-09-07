#!/usr/bin/env bash
#
# tag-keywords.sh
# Alan Rogers
# 2018/03/15
#
# Adds MacOS Finder tags to files based on EXIF/IPTC keywords.
#
# Usage: tag-keywords.sh INPUT_DIRECTORY
#

# First argument is the directory in which to rename images
if [ -z "$1" ]; then
  echo -e ""
  echo -e "USAGE: tag-keywords.sh INPUT_DIRECTORY"
  echo -e ""
  exit 1
else
  DIR=$1
fi

if ! command -v exiftool > /dev/null; then
  echo -e ""
  echo -e "\x1B[00;31mERROR\x1B[00m: Please install exiftool."
  echo -e ""
  exit 1
fi

if ! command -v tag > /dev/null; then
  echo -e ""
  echo -e "\x1B[00;31mERROR\x1B[00m: Please install tag."
  echo -e ""
  exit 1
fi

echo -e ""
echo -e "\x1B[01;35mSet MacOS Finder tags from EXIF\x1B[00m"

# Extract all keywords with exiftool and tag with tag
if ls "${DIR}"/*.jpg 1> /dev/null 2>&1; then
  for FILE in "${DIR}"/*.jpg
  do
    KEYWORDS="$(exiftool -s3 -subject ${FILE})"
    echo -e "\x1B[00;33m${FILE}\x1B[00m ← ${KEYWORDS}"
    IFS=","
    for KEYWORD in $KEYWORDS
    do
      tag --add "${KEYWORD}" "${FILE}"
    done
    unset IFS
  done
fi

exit 0
