#!/usr/bin/env bash
#
# exif-to-modified.sh
# Alan Rogers
# 2018/01/30
#
# Sets file modified and created times to the EXIF date in photos.
#
# Usage: exif-to-modified.sh INPUT
#

# First argument is the directory in which to rename images
if [ -z "$1" ]; then
    echo -e ""
    echo -e "USAGE: exif-to-modified.sh INPUT"
    echo -e ""
    exit 1
else
  DIR=$1
fi
# Second argument is timezone if given;
# if not, assume local time zone
if [ -z "$2" ]; then
  TIMEZONE="$(date +%z)"
else
  TIMEZONE="$2"
fi

if ! command -v exiftool > /dev/null; then
    echo -e ""
    echo -e "\x1B[00;31mERROR\x1B[00m: Please install exiftool."
    echo -e ""
    exit 1
fi

# Update file creation and modification dates to match EXIF data since
# Apple Photos ignores photo metadata
if ls *.jpg 1> /dev/null 2>&1; then
  for FILE in "${DIR}"/*.jpg
  do
    CREATEDATE="$(exiftool -d "%m/%d/%Y %H:%M:%S" -DateTimeOriginal ${FILE} | sed 's/^.* : //')"
    SetFile \
      -d "${CREATEDATE}" \
      -m "${CREATEDATE}" \
      "${FILE}"
  done
fi

exit 0
