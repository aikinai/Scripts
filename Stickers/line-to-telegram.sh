#!/usr/bin/env bash
# 
# line-to-telegram.sh
# Alan Rogers 2016/1/20
#
# Downloads sticker packs from Line and converts them into Telegram sticker 
# packs.
#
# Requires:
#   curl         (to download the stickerpacks from Line)
#   imagemagick  (to resize the images for Telegram)
#   telegram-cli (to upload images to the Telegram Stickers bot)
#
# Usage: line-to-telegram.sh pack_name pack_address pack_id
#   pack_name: Readable name for the Telegram sticker pack
#   pack_address: unique name and address for the Telegram pack
#   pack_id: Line's ID for the sticker pack to download
#

NAME=$1
ADDRESS=$2
ID=$3

# Get directory the script is in so I can come back later
cd "$(dirname "$0")"
SCRIPT_DIR="$(pwd)"

# This is where Line keeps their retina iPhone stickers and seems to be the 
# highest quality versions you can download
LINE_URL="http://dl.stickershop.line.naver.jp/products/0/0/1/${ID}/iphone/stickers@2x.zip"

TMP_DIR=$(mktemp -d)
ZIP_PACK="${ADDRESS}.zip"

# Download, unzip, and clean up extraneous files
cd ${TMP_DIR}
curl -o ${ZIP_PACK} ${LINE_URL}
unzip ${ZIP_PACK}
rm -rf *_key* tab_* productInfo.meta

# Sometimes the files are optimized for iPhone and can't be scaled by 
# ImageMagick, so this uses Xcode's version of pngcrush to revert the iPhone 
# optimizations
for IMAGE in *.png
do
  pngcrush -revert-iphone-optimizations $IMAGE tmp.png
  mv tmp.png $IMAGE
done

# Scale images to 512 pixels on the longest side
# This is required for Telegram stickers
for IMAGE in *.png
do
  convert $IMAGE -filter LanczosSharp -resize 512x512 $IMAGE
done

cd "${SCRIPT_DIR}"

# Call the expect script to upload to Telegram
./telegram-stickers.exp "${NAME}" "${ADDRES}" "${TMP_DIR}/"
