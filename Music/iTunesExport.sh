#!/bin/bash
#
# iTunesExport.sh
#

# Copy only updated files (with a looser modification window)
# `tee` copies the output to the terminal while still saving to the variable
RSYNC_OUTPUT=$(rsync -vrtu --delete --progress --modify-window=2 /Users/Alan/Music/iTunes/iTunes\ Music/Music/ /Volumes/BMW/ | tee /dev/tty)
# Get only changed files so I can limit romaji transcription and genre updating
UPDATED_FILES=$(echo "${RSYNC_OUTPUT}" | grep -i "\.\(mp3\|m4a\)")

echo ""
echo "Updated"
echo "---"

# Have to do this IFS dance to do a for loop on files with spaces
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for NAME in ${UPDATED_FILES}
do
  FILE="$(echo "/Volumes/BMW/${NAME}")"
  INITIAL="$(mediainfo "$FILE" | grep Performer | awk -F ": " '{print $2}' | head -c 1)"
  echo "${FILE}"
  /Applications/kid3.app/Contents/MacOS/kid3-cli -c "set genre '${INITIAL}'" "$FILE"
done

# Restore $IFS
IFS=$SAVEIFS

# Copy over pre-exported and cleaned Playlists
rsync -vau /Users/Alan/Music/Playlists/*.m3u /Volumes/BMW/ > /dev/null
