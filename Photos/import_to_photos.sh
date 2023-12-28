#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /path/to/photo"
    exit 1
fi

photo_path=$(realpath "$1")

osascript <<EOD
  set photoPath to "${photo_path}"
  set photosApp to (path to application "Photos")

  tell application "Photos"
    set photoFile to POSIX file photoPath as alias
    import {photoFile}
  end tell
EOD
