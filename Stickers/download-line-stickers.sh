#!/usr/bin/env bash
# 
# download-line-stickers.sh
# Alan Rogers 2016/12/31
#
# Downloads sticker packs from LINE.
#
# Requires:
#   curl
#
# Usage: download-line-stickers.sh directory pack_name pack_id
#   directory: Location to save the downloaded stickers
#   pack_name: Name for the sticker pack
#   pack_id: Line's ID for the sticker pack to download
#

DIRECTORY=$1
NAME=$2
ID=$3

# Get directory the script is in so I can come back later
cd "$(dirname "$0")"
SCRIPT_DIR="$(pwd)"

# This is where Line keeps their retina iPhone stickers and seems to be the 
# highest quality versions you can download
LINE_URL="http://dl.stickershop.line.naver.jp/products/0/0/1/${ID}/iphone/stickers@2x.zip"

TMP_DIR=$(mktemp -d)
ZIP_PACK="${ID}.zip"

# Download, unzip, and clean up extraneous files
cd ${TMP_DIR}
curl -o ${ZIP_PACK} ${LINE_URL}
unzip ${ZIP_PACK}
rm -rf *_key* tab_* productInfo.meta

mkdir -pv "${DIRECTORY}/${NAME}"
mv -iv *.png "${DIRECTORY}/${NAME}/"

cd "${DIRECTORY}/${NAME}/"
COUNTER=01
for FILE in *.png
do
  NEWNAME="${NAME} $(printf "%02d" ${COUNTER})"
  mv "${FILE}" "${NEWNAME}.png"
  COUNTER=$((COUNTER+1))
done
