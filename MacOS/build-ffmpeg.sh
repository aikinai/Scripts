#!/usr/bin/env zsh
#
# Build ffmpeg from source on a RAM disk
#
# The open source build script breaks with GNU sed (and maybe other GNU utilities),
# so this removes those from PATH before building.
#
# Usage: KEEP_RAMDISK=1 ./build-ffmpeg-bsd.zsh   # (optional) keep mounted RAM disk
#

set -e
set -u
set -o pipefail

# Remove GNU utilities from PATH (zsh only; does not affect parent shell)
drop_from_path() {
  local -A rm=()
  local t
  for t in "$@"; do
    [[ -n "${t}" ]] && rm["$t"]=1
  done
  local -a new=()
  local p
  for p in $path; do
    [[ -n "${rm[$p]-}" ]] || new+=("$p")
  done
  path=($new)
}

# Candidates to remove (cover common Homebrew locations, whether $HOMEBREW is set or not)
typeset -a _cands=()
[[ -n "${HOMEBREW:-}" ]] && _cands+=(
  "$HOMEBREW/opt/gnu-sed/libexec/gnubin"
  "$HOMEBREW/opt/coreutils/libexec/gnubin"
)
for _prefix in /opt/homebrew /usr/local "$HOME/.homebrew"; do
  _cands+=(
    "$_prefix/opt/gnu-sed/libexec/gnubin"
    "$_prefix/opt/coreutils/libexec/gnubin"
  )
done
drop_from_path "${_cands[@]}"
rehash

# Sanity check: ensure we're using system BSD tools now
for _cmd in sed ls find xargs; do
  _which=$(command -v "$_cmd" || true)
  if [[ "$_which" != /usr/bin/* && "$_which" != /bin/* && "$_which" != /usr/sbin/* && "$_which" != /sbin/* ]]; then
    print -u2 "Error: $_cmd resolves to $_which (not a system BSD binary). Fix PATH and re-run."
    exit 1
  fi
done

# --- Requirements ---
for _req in diskutil hdiutil git rsync sudo; do
  command -v "$_req" >/dev/null || { print -u2 "Missing required command: $_req"; exit 1; }
done
# Prompt for sudo up-front
sudo -v

# --- RAM disk setup ---
RAM_SECTORS=${RAM_SECTORS:-16777216}   # 16,777,216 * 512 bytes = 8 GiB
VOL_NAME=${VOL_NAME:-RAMdisk}
MNT="/Volumes/$VOL_NAME"

_dev=""
cleanup() {
  set +e
  if mount | grep -q " $MNT "; then
    diskutil unmount "$MNT" >/dev/null || true
  fi
  if [[ -n "$_dev" ]]; then
    hdiutil detach "$_dev" >/dev/null || true
  fi
}
trap '[[ "${KEEP_RAMDISK:-0}" = "1" ]] || cleanup' EXIT

# If an old volume is lingering, try to unmount it
if mount | grep -q " $MNT "; then
  diskutil unmount "$MNT" >/dev/null || true
fi

# Create and format RAM disk
_dev=$(hdiutil attach -nobrowse -nomount "ram://${RAM_SECTORS}")
diskutil erasevolume APFS "$VOL_NAME" "$_dev" >/dev/null

cd "$MNT"

# --- Build ---
git clone https://github.com/Vargol/ffmpeg-apple-arm64-build.git
cd ffmpeg-apple-arm64-build

# Ensure the build uses BSD tools via our PATH (already sanitized)
./build.sh

# Install
sudo rsync -vaX "$MNT/ffmpeg-apple-arm64-build/out/"* /usr/local/

print "Done."
if [[ "${KEEP_RAMDISK:-0}" = "1" ]]; then
  print "Kept RAM disk mounted at: $MNT"
fi
