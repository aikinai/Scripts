#!/usr/bin/env bash

#
# exif-description.sh
# Alan Rogers
# 2016/07/04
#
# Generate EXIF description for JPEGs with the format:
#   Directories up to 'Pictures', Keywords, with, commas, #stars, Camera model
#

for FILE in "$@"
do
  # Get all directories up to a "Pictures" directory and replace / with spaces
  DIRECTORY="$(dirname "$(readlink -f "${FILE}")" | sed -e 's/^.*\/Pictures\///' -e 's/\// /g'), "
  # String to hold keywords, rating, make, and model
  # Avoids calling exiftool multiple times
  TMP="$(exiftool -keywords -rating -make -model "${FILE}")"
  # Copy all metadata into individual variables
  KEYWORDS="$(echo "$TMP" | awk -F ": " '/^Keywords/ { print $2 }')"
  RATING="$(echo "$TMP" | awk -F ": " '/^Rating/ { print $2 }')"
  MODEL="$(echo "$TMP" | awk -F ": " '/^Camera Model Name/ { print $2 }')"

  # Combine them all for the description
  DESCRIPTION=""
  if [ -n "$DIRECTORY" ]; then
    DESCRIPTION="${DESCRIPTION}${DIRECTORY}"
  fi
  if [ -n "$KEYWORDS" ]; then
    DESCRIPTION="${DESCRIPTION}${KEYWORDS}, "
  fi
  # Set rating to 'unrated' if no rating or 0
  if [ -z "$RATING" -o "$RATING" = "0" ]; then
    DESCRIPTION="${DESCRIPTION}unrated, "
  else
    DESCRIPTION="${DESCRIPTION}${RATING}star, "
  fi
  if [ -n "$MODEL" ]; then
    DESCRIPTION="${DESCRIPTION}${MODEL}"
  fi

  # Set description to the generated string
  echo -e "\x1B[01;35m${FILE}\x1B[00m description set to \x1B[00;33m${DESCRIPTION}\x1B[00m"
  exiftool -overwrite_original -description="${DESCRIPTION}" "${FILE}" &> /dev/null
  if [ $? -ne 0 ]; then
    echo -e "\x1B[00;31mError: Failed to set description for ${FILE}.\x1B[00m" >&2
    exit 1
  fi
done

exit 0
