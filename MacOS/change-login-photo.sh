#!/usr/bin/env bash

USER="$1"
IMAGE="$2"
dscl . delete /Users/$USER JPEGPhoto
dscl . delete /Users/$USER Picture
tmp="$(mktemp)"
printf "0x0A 0x5C 0x3A 0x2C dsRecTypeStandard:Users 2 dsAttrTypeStandard:RecordName externalbinary:dsAttrTypeStandard:JPEGPhoto\n%s:%s" "$USER" "$IMAGE" > "$tmp"
dsimport "$tmp" /Local/Default M
rm "$tmp"
