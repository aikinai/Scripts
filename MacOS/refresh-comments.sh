#!/usr/bin/env bash
#
# refresh-comments.sh
#
# Refreshes existing comments on MacOS files so the comments actually show in
# Finder. Comments set on extended attributes by non-Finder commands (rsync,
# xattr, etc) do not show up in the UI, so this reads existing comments and
# resets them through Finder.
#

for FILE in "$@"
do
  COMMENT="$(mdls -name kMDItemFinderComment "${FILE}" | awk -F\\\"  '{print $2}')"
  # Skip if the comment is empty
  if [ -z "${COMMENT}" ]; then
    echo Skipped ${FILE}
    continue
  fi
  echo -e "Refresh Finder comment on \x1B[01;35m${FILE}\x1B[00m as \x1B[00;33m${COMMENT}\x1B[00m"
  osascript \
    -e "set filepath to (POSIX file \"$FILE\" as alias)" \
    -e "tell application \"Finder\" to set the comment of filepath to \"$COMMENT\"" \
    &> /dev/null
  if [ $? -ne 0 ]; then
    echo -e "\x1B[00;31mError: Failed to set Finder comment for \x1B[01;35m${FILE}\x1B[00;31m.\x1B[00m" >&2
    exit 1
  fi
done

exit 0
