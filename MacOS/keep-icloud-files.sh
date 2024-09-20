#!/usr/bin/env bash
# keep-icloud-files.sh
# 2024/09/17
# Adapted from https://superuser.com/a/1844472
# Add to cron
# crontab -e
# 0 * * * * /path/to/keep-icloud-files.sh
#

set -euo pipefail

# Path to the iCloud folder you want to keep downloaded
FOLDER_PATH="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/Share"
# Log file for debugging
LOG_FILE="${HOME}/.icloud_download.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE"
}

# Clear previous log
log "Log started"

# Check if the folder exists
if [[ ! -d "$FOLDER_PATH" ]]; then
    log "Folder $FOLDER_PATH does not exist"
    exit 1
fi

# Find all files in the folder recursively
files=()
while IFS= read -r -d '' file; do
    files+=("$file")
done < <(find "$FOLDER_PATH" -type f -print0)

# Check if files were found
if [[ ${#files[@]} -eq 0 ]]; then
    log "No files found in $FOLDER_PATH"
    exit 1
fi

# Check if files were found
if [[ ${#files[@]} -eq 0 ]]; then
    log "No files found in $FOLDER_PATH"
    exit 1
fi

# Force download each file
for file in "${files[@]}"; do
    log "Downloading $file"
    if ! brctl download "$file" >> "$LOG_FILE" 2>&1; then
        log "Failed to download $file"
    fi
done

log "Requested all files for download"
exit 0
