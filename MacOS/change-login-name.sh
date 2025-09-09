#!/usr/bin/env bash
#
# change-login-name.sh
#
# Set the macOS RealName (Full Name) for a local user
#

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  set-realname.sh -n "Full Name" [-u username] [-d]

Options:
  -n  New full name to set (RealName)  [required]
  -u  Target account short name        [default: current user]
  -d  Dry run (show what would change, do nothing)
  -h  Help
USAGE
  exit "${1:-2}"
}

USER_NAME="$(id -un)"
FULL_NAME=""
DRYRUN=0

while getopts ":u:n:dh" opt; do
  case "$opt" in
    u) USER_NAME="$OPTARG" ;;
    n) FULL_NAME="$OPTARG" ;;
    d) DRYRUN=1 ;;
    h) usage 0 ;;
    *) usage 2 ;;
  esac
done

# Basic validation
if [[ -z "${FULL_NAME// }" ]]; then
  echo "Error: -n \"Full Name\" is required." >&2
  usage 2
fi

# Ensure the user record exists
if ! dscl . -read "/Users/${USER_NAME}" >/dev/null 2>&1; then
  echo "Error: user '${USER_NAME}' was not found in the local directory node." >&2
  exit 1
fi

# Show current value(s)
CURRENT="$(dscl . -read "/Users/${USER_NAME}" RealName 2>/dev/null \
          | sed '1d;s/^[[:space:]]*//')"
echo "Current RealName for '${USER_NAME}':"
echo "${CURRENT:-<none>}"
echo

if [[ $DRYRUN -eq 1 ]]; then
  echo "[DRY-RUN] Would set RealName for '${USER_NAME}' to: ${FULL_NAME}"
  exit 0
fi

# Re-exec with sudo if not root
if [[ $EUID -ne 0 ]]; then
  echo "Elevating privileges with sudo..."
  exec sudo "$0" "$@"
fi

# If already exactly the same, do nothing
if [[ "${CURRENT}" == "${FULL_NAME}" ]]; then
  echo "No change needed: RealName already set to '${FULL_NAME}'."
  exit 0
fi

# Delete all existing RealName values (attribute is multi-valued), ignore if missing
if dscl . -read "/Users/${USER_NAME}" RealName >/dev/null 2>&1; then
  dscl . -delete "/Users/${USER_NAME}" RealName || true
fi

# Set a single new value
dscl . -create "/Users/${USER_NAME}" RealName "${FULL_NAME}"

# Verify
NEW="$(dscl . -read "/Users/${USER_NAME}" RealName 2>/dev/null \
      | sed '1d;s/^[[:space:]]*//')"
echo "Updated RealName for '${USER_NAME}':"
echo "${NEW:-<none>}"
