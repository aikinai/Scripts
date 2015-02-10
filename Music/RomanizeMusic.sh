#!/bin/bash

# Change IFS so I can iterate over the files with spaces
OIFS="$IFS"
IFS=$'\n'

# for FILE in $(find $1 -name '*.mp3' -o -name '*.m4a')
# do

FILE="$1"

INFO=$(mediainfo "$FILE")

# Chop off the top (with the filename) and check for non-ASCII
echo "$INFO" | tail -n +3 | ag '[\xe4-\xe9][\x80-\xbf][\x80-\xbf]|\xe3[\x81-\x83][\x80-\xbf]' > /dev/null
if [ $? -eq 0 ]; then

  # Extract original metadata
        JA_ARTIST=$(grep "^Performer"       <<< "$INFO" | awk -F ": " '{print $2}')
  JA_ALBUM_ARTIST=$(grep "Album\/Performer" <<< "$INFO" | awk -F ": " '{print $2}')
         JA_ALBUM=$(grep "^Album "          <<< "$INFO" | awk -F ": " '{print $2}')
         JA_TITLE=$(grep "^Track name "     <<< "$INFO" | awk -F ": " '{print $2}')

  COMMAND=""

  # Check each field for Japanese and 
  for FIELD in "ARTIST" "ALBUM_ARTIST" "ALBUM" "TITLE"
  do
    eval FIELDCONTENT=\$JA_$FIELD
    echo $FIELDCONTENT | ag '[\xe4-\xe9][\x80-\xbf][\x80-\xbf]|\xe3[\x81-\x83][\x80-\xbf]' > /dev/null
    if [ $? -eq 0 ]; then
      case $FIELD in
        'ARTIST' )
          ARTIST=$(echo ${JA_ARTIST} | ~/Programs/Scripts/Romanize/romanize.sh)
          COMMAND="${COMMAND} -c \"set artist '${ARTIST}'\""
          echo "Converting ${JA_ARTIST} to ${ARTIST}"
          ;;
        'ALBUM_ARTIST' )
          ALBUM_ARTIST=$(echo ${JA_ALBUM_ARTIST} | ~/Programs/Scripts/Romanize/romanize.sh)
          COMMAND="${COMMAND} -c \"set albumartist '${ALBUM_ARTIST}'\""
          echo "Converting ${JA_ALBUM_ARTIST} to ${ALBUM_ARTIST}"
          ;;
        'ALBUM' )
          ALBUM=$(echo ${JA_ALBUM} | ~/Programs/Scripts/Romanize/romanize.sh)
          COMMAND="${COMMAND} -c \"set album '${ALBUM}'\""
          echo "Converting ${JA_ALBUM} to ${ALBUM}"
          ;;
        'TITLE' )
          TITLE=$(echo ${JA_TITLE} | ~/Programs/Scripts/Romanize/romanize.sh)
          COMMAND="${COMMAND} -c \"set title '${TITLE}'\""
          echo "Converting ${JA_TITLE} to ${TITLE}"
          ;;
      esac
    fi
  done

  if [ -n "$COMMAND" ]; then
    COMMAND="/Applications/kid3.app/Contents/MacOS/kid3-cli $COMMAND \"$FILE\""
    eval $COMMAND
  fi

fi

# done

IFS="$OIFS" # Revert IFS

exit 0
