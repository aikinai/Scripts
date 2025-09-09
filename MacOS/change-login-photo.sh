#!/usr/bin/env bash
set -euo pipefail

USER="${1:?usage: ./change-login-photo.sh <user> <image>}"
IMAGE="${2:?usage: ./change-login-photo.sh <user> <image>}"

# Portable temp dir
TMPDIR_AVATAR="$(mktemp -d "${TMPDIR:-/tmp}/avatar.XXXXXX")"
trap 'rm -rf "$TMPDIR_AVATAR"' EXIT

# Ensure JPEG and stage it
TMPJPG="$TMPDIR_AVATAR/avatar.jpg"
/usr/bin/sips -s format jpeg "$IMAGE" --out "$TMPJPG" >/dev/null

# World-readable copy for the Picture path
DEST="/Library/User Pictures/${USER}.jpg"
sudo /bin/mkdir -p "/Library/User Pictures"
sudo /bin/cp -f "$TMPJPG" "$DEST"
sudo /usr/sbin/chown root:wheel "$DEST"
sudo /bin/chmod 0644 "$DEST"

# Clean and set both attributes
sudo /usr/bin/dscl . delete "/Users/$USER" JPEGPhoto || true
sudo /usr/bin/dscl . delete "/Users/$USER" Picture || true
sudo /usr/bin/dscl . create "/Users/$USER" Picture "$DEST"

# dsimport header + payload file (portable mktemp usage)
DSFILE="$(mktemp "${TMPDIR:-/tmp}/dsimport.XXXXXX")"
printf "0x0A 0x5C 0x3A 0x2C dsRecTypeStandard:Users 2 dsAttrTypeStandard:RecordName externalbinary:dsAttrTypeStandard:JPEGPhoto\n%s:%s" "$USER" "$TMPJPG" > "$DSFILE"
sudo /usr/bin/dsimport "$DSFILE" /Local/Default M
rm -f "$DSFILE"

# Nudge directory services
sudo /usr/bin/killall -HUP opendirectoryd || true

echo "Set local avatar for $USER."
