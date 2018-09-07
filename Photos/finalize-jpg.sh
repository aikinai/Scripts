#!/usr/bin/env bash
#
# finalize-jpg.sh
# Alan Rogers
# 2018/09/07
#
# Master script that just runs the other scripts I use to finalize my JPGs
#
# Usage: finalize-jpg.sh INPUT_DIRECTORY
#

# First argument is the JPG directory to finalize
if [ -z "$1" ]; then
    echo -e ""
    echo -e "USAGE: finalize-jpg.sh INPUT"
    echo -e ""
    exit 1
else
  DIR=$1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

${SCRIPT_DIR}/exif-to-modified.sh "${DIR}"
${SCRIPT_DIR}/tag-keywords.sh "${DIR}"
${SCRIPT_DIR}/copy-tags.sh "${DIR}"

echo -e ""
echo -e "\x1B[01;35mCopy Share tagged photos to ~/Pictures/Upload/\x1B[00m"
rsync -vaX $(tag -f "Share" "${DIR}") ~/Pictures/Upload/

exit 0
