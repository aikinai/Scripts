#!/usr/bin/env bash
#
# rename-images.sh
# Alan Rogers
# 2016/06/25
#
# Renames all JPEGs in a directory with ISO8601-formatted time taken from EXIF
# DateTimeOriginal tag. If there are multiple images with the same time, the
# count is added the end of the filename.
#
# Usage: rename-images.sh DIRECTORY [TIMEZONE]
#
# Assumes local timezone if not specified
#

# First argument is the directory in which to rename images
if [ -z "$1" ]; then
    echo -e ""
    echo -e "USAGE: rename-images.sh DIRECTORY [TIMEZONE]"
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

# Use exiftool's build in rename function to rename all images with ISO8601 time
exiftool '-FileName<DateTimeOriginal' -d "%Y-%m-%dT%H%M%S${TIMEZONE}%%-c.%%le" "$DIR"

# When exiftool adds counts to images with the same time, it leave the first
# image with no count, leaving the files out of order in most alphabetical
# sorts. This looks for any files with a count and adds -0 to the first file in
# the series.
find -E . -iregex ".*-1\.(jpg|arw|xmp)" -print0 | while read -d $'\0' FILE
do
  EXTENSION="${FILE##*.}"
  BASENAME="${FILE%-1.*}"
  if [ -n "${BASENAME}" ]; then
    mv "${BASENAME}.${EXTENSION}" "${BASENAME}-0.${EXTENSION}"
  else
    echo -e ""
    echo -e "\x1B[00;31mERROR\x1B[00m: Failed renaming first image in a series."
    echo -e ""
    exit 1
  fi
done

exit 0
