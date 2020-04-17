#!/usr/bin/env bash
#
# import-photos.sh
# Alan Rogers
# 2019/10/15
#
# Usage: import-photos.sh
#
# Imports ARWs, JPEGS, MP4s, and MTSs from drives mounted as
# Untitled or NO NAME into dated folders in ~/Pictures/Import/
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

for VOLUME in "NO NAME" "Untitled"
do
  DRIVE="/Volumes/${VOLUME}"

  if [ ! -d "${DRIVE}" ]; then
    continue
  fi
  find "${DRIVE}" -not -path "*.Trashes*" \
                  \( -iname "*.jpeg" -o \
                     -iname "*.jpg" -o \
                     -iname "*.arw" -o \
                     -iname "*.mp4" -o \
                     -iname "*.mts" \) \
                     -print0 | sort -z | while read -d $'\0' FILE
    do
      BASENAME="$(basename "${FILE}")"
      SOURCE_DIR="$(dirname "${FILE}")"
      case ${FILE} in
        *mts|*MTS)
          DATE_DIRECTORY="$(exiftool -api largefilesupport=1 -s -s -s -d "%Y/%m/%Y-%m-%d" -datetimeoriginal "${FILE}")"
          DESTINATION="${HOME}/Pictures/Import/${DATE_DIRECTORY}/Videos/"
          RENAME=true
          ;;
        *mp4|*MP4)
          DATE_DIRECTORY="$(exiftool -api largefilesupport=1 -s -s -s -d "%Y/%m/%Y-%m-%d" -createdate "${FILE}")"
          DESTINATION="${HOME}/Pictures/Import/${DATE_DIRECTORY}/Videos/"
          XML_FILE="$(find "${SOURCE_DIR}" -iname "$(basename "${FILE%.*}")*.xml")"
          RENAME=true
          ;;
        *THMBNL*)
          break # Skips video thumbnail JPEGs
          ;;
        *)
          DATE_DIRECTORY="$(exiftool -s -s -s -d "%Y/%m/%Y-%m-%d" -createdate "${FILE}")"
          DESTINATION="${HOME}/Pictures/Import/${DATE_DIRECTORY}/Photos/"
          ;;
      esac
      if [ ! -d "${DESTINATION}" ]; then
        echo -e ""
        echo -e "\x1B[01;36mCreate \x1B[01;35m${DESTINATION}\x1B[00m"
        mkdir -p "${DESTINATION}"
      fi
      echo -e "\x1B[00;33m${BASENAME}\x1B[00m → \x1B[00;34m${DESTINATION}\x1B[00m"
      rsync -aX "${FILE}" "${DESTINATION}"
      if [ -n "${XML_FILE}" ]; then
        rsync -aX "${XML_FILE}" "${DESTINATION}"
      fi
      if [ "${RENAME}" = true ]; then
        "${SCRIPT_DIR}"/../Encoding/rename-to-time.sh "${DESTINATION}""${BASENAME}"
      fi
      unset DATE_DIRECTORY DESTINATION XML_FILE RENAME
    done
  done
exit 0
