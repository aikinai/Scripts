#!/usr/bin/env bash
#
# import-photos.sh
# Alan Rogers
# Updated: 2024/11/28
#
# Usage: import-photos.sh
#
# Imports ARWs, JPEGs, MP4s, and MTSs from specified drives into
# dated folders in ~/Pictures/Import/
#

set -euo pipefail

# Check for required commands
if ! command -v exiftool > /dev/null; then
    echo -e "\n\x1B[00;31mERROR\x1B[00m: Please install exiftool.\n"
    exit 1
fi

if ! command -v python3 > /dev/null; then
    echo -e "\n\x1B[00;31mERROR\x1B[00m: Python 3 is required for time conversion.\n"
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

VOLUMES=("NO NAME" "Untitled" "MEMORY CARD" "Lexar" "SanDisk64" "SanDisk")

for VOLUME in "${VOLUMES[@]}"
do
    DRIVE="/Volumes/${VOLUME}"

    if [ ! -d "${DRIVE}" ]; then
        continue
    fi

    # Use an associative array to track processed files and avoid duplicates
    declare -A PROCESSED_FILES

    find "${DRIVE}" \( -name ".Trashes" -o -iname "thmbnl" \) -prune -o \
         \( -iname "*.jpeg" -o \
            -iname "*.jpg" -o \
            -iname "*.arw" -o \
            -iname "*.mp4" -o \
            -iname "*.mts" \) \
            -print0 | sort -z | while IFS= read -r -d $'\0' FILE
    do
        # Skip if the file has already been processed
        if [[ -n "${PROCESSED_FILES["$FILE"]+_}" ]]; then
            continue
        fi
        PROCESSED_FILES["$FILE"]=1

        BASENAME="$(basename "${FILE}")"
        SOURCE_DIR="$(dirname "${FILE}")"
        EXTENSION="${BASENAME##*.}"
        EXTENSION="${EXTENSION,,}"  # Convert extension to lowercase
        NEW_FILENAME=""
        XML_FILE=""
        XML_NEW_FILENAME=""
        DATE_DIRECTORY=""
        DESTINATION=""
        DATE_UTC=""

        case "${EXTENSION}" in
            mts|mp4)
                # Extract the CreateDate in UTC
                DATE_UTC=$(exiftool -s -s -s -createdate "${FILE}" 2>/dev/null || echo "")
                if [ -z "${DATE_UTC}" ]; then
                    DATE_DIRECTORY="Unknown_Date"
                    NEW_FILENAME="${BASENAME%.*}.${EXTENSION}"
                else
                    # Convert UTC time to local time using Python
                    DATE_LOCAL=$(python3 -c "
import sys
from datetime import datetime, timezone
dt = datetime.strptime(sys.argv[1], '%Y:%m:%d %H:%M:%S')
dt = dt.replace(tzinfo=timezone.utc).astimezone()
print(dt.strftime('%Y/%m/%Y-%m-%d|%Y-%m-%dT%H%M%S%z'))
" "${DATE_UTC}" 2>/dev/null || echo "")
                    if [ -z "${DATE_LOCAL}" ]; then
                        DATE_DIRECTORY="Unknown_Date"
                        NEW_FILENAME="${BASENAME%.*}.${EXTENSION}"
                    else
                        DATE_DIRECTORY="${DATE_LOCAL%%|*}"
                        DATE_TIME="${DATE_LOCAL##*|}"
                        NEW_FILENAME="${DATE_TIME}.${EXTENSION}"
                    fi
                fi
                DESTINATION="${HOME}/Pictures/Import/${DATE_DIRECTORY}/Videos/"

                # Find associated XML file
                XML_FILE_CANDIDATES=("${SOURCE_DIR}/$(basename "${FILE%.*}")"*.xml)
                if [ -f "${XML_FILE_CANDIDATES[0]}" ]; then
                    XML_FILE="${XML_FILE_CANDIDATES[0]}"
                    if [ -n "${DATE_LOCAL}" ]; then
                        XML_NEW_FILENAME="${NEW_FILENAME%.*}.xml"
                    else
                        XML_NEW_FILENAME="$(basename "${XML_FILE}")"
                    fi
                fi
                ;;
            *thmbnl*)
                continue # Skips video thumbnail JPEGs
                ;;
            *)
                # For photos, extract the CreateDate
                DATE_UTC=$(exiftool -s -s -s -createdate "${FILE}" 2>/dev/null || echo "")
                if [ -z "${DATE_UTC}" ]; then
                    DATE_DIRECTORY="Unknown_Date"
                    NEW_FILENAME="${BASENAME%.*}.${EXTENSION}"
                else
                    # Convert time to local time using Python
                    DATE_LOCAL=$(python3 -c "
import sys
from datetime import datetime
dt = datetime.strptime(sys.argv[1], '%Y:%m:%d %H:%M:%S')
print(dt.strftime('%Y/%m/%Y-%m-%d|%Y-%m-%dT%H%M%S%z'))
" "${DATE_UTC}" 2>/dev/null || echo "")
                    if [ -z "${DATE_LOCAL}" ]; then
                        DATE_DIRECTORY="Unknown_Date"
                        NEW_FILENAME="${BASENAME%.*}.${EXTENSION}"
                    else
                        DATE_DIRECTORY="${DATE_LOCAL%%|*}"
                        DATE_TIME="${DATE_LOCAL##*|}"
                        NEW_FILENAME="${DATE_TIME}.${EXTENSION}"
                    fi
                fi
                DESTINATION="${HOME}/Pictures/Import/${DATE_DIRECTORY}/Photos/"
                ;;
        esac

        if [ ! -d "${DESTINATION}" ]; then
            echo -e "\n\x1B[01;36mCreate \x1B[01;35m${DESTINATION}\x1B[00m"
            mkdir -p "${DESTINATION}"
        fi

        echo -e "\x1B[00;33m${BASENAME}\x1B[00m → \x1B[00;34m${DESTINATION}${NEW_FILENAME}\x1B[00m"
        if ! rsync -aX "${FILE}" "${DESTINATION}${NEW_FILENAME}"; then
            echo -e "\x1B[00;31mFailed to copy ${FILE} to ${DESTINATION}${NEW_FILENAME}\x1B[00m"
            continue
        fi

        if [ -n "${XML_FILE}" ]; then
            echo -e "\x1B[00;33m$(basename "${XML_FILE}")\x1B[00m → \x1B[00;34m${DESTINATION}${XML_NEW_FILENAME}\x1B[00m"
            if ! rsync -aX "${XML_FILE}" "${DESTINATION}${XML_NEW_FILENAME}"; then
                echo -e "\x1B[00;31mFailed to copy ${XML_FILE} to ${DESTINATION}${XML_NEW_FILENAME}\x1B[00m"
            fi
        fi

    done
    unset PROCESSED_FILES
done

exit 0
