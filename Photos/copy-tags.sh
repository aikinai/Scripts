#!/usr/bin/env bash
#
# copy-tags.sh
# Alan Rogers
# 2018/09/07
#
# Copy MacOS Finder tags from JPG to EIP
# Very specific to my standard file structure.
# Only works on tags "Share" and "♡".
#
# Usage: copy-tags.sh INPUT
#

# First argument is the directory with JPGs to copy tags from
if [ -z "$1" ]; then
    echo -e ""
    echo -e "USAGE: copy-tags.sh INPUT"
    echo -e ""
    exit 1
else
  DIR=$1
fi

if ! command -v tag > /dev/null; then
    echo -e ""
    echo -e "\x1B[00;31mERROR\x1B[00m: Please install tag."
    echo -e ""
    exit 1
fi

echo -e ""
echo -e "\x1B[01;35mCopy MacOS Finder tags from JPGs to EIPs\x1B[00m"

for FILE in $(tag --find "Share" "${DIR}")
do
  FILENAME="$(basename "${FILE}")"
  FILENAME="${FILENAME%.*}"
  OUTPUT="$(find ~/Pictures/Import -name "${FILENAME}.eip")"
  tag --add "Share" "${OUTPUT}"
  echo -e "${OUTPUT} ← \x1B[00;32mShare\x1B[00m"
done

for FILE in $(tag --find "♡" "${DIR}")
do
  FILENAME="$(basename "${FILE}")"
  FILENAME="${FILENAME%.*}"
  OUTPUT="$(find ~/Pictures/Import -name "${FILENAME}.eip")"
  tag --add "♡" "${OUTPUT}"
  echo -e "${OUTPUT} ← \x1B[00;32m♡\x1B[00m"
done

exit 0
