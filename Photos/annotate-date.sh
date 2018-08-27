#
# Super rough version of a script that adds a date annotation to photos for printing
# Needs to be cleaned up for better speed, robustness, and portability and more 
# importantly, to position the text consistently inside area that will be 
# cropped when printing
#

# First argument is the directory in which to rename images
if [ -z "$1" ]; then
  echo -e ""
  echo -e "USAGE: exif-to-modified.sh INPUT"
  echo -e ""
  exit 1
else
  DIR=$1
fi

if ! command -v exiftool > /dev/null; then
  echo -e ""
  echo -e "\x1B[00;31mERROR\x1B[00m: Please install exiftool."
  echo -e ""
  exit 1
fi

if ls *.jpg 1> /dev/null 2>&1; then
  for FILE in "${DIR}"/*.jpg
  do

    ORIGINAL_DATE="$(exiftool -d "%m/%d/%Y %H:%M:%S" -DateTimeOriginal "$FILE" | sed 's/^.* : //')"
    DAY="$(date +%e --date="$ORIGINAL_DATE")"

    DENSITY="$(echo "scale=2; sqrt($(exiftool -megapixels "$FILE" | sed 's/^.* : //')) / sqrt(24) * 72" | bc)"

    case $DAY in
      1?) DAY=${DAY}th ;;
      *1) DAY=${DAY}st ;;
      *2) DAY=${DAY}nd ;;
      *3) DAY=${DAY}rd ;;
      *)  DAY=${DAY}th ;;
    esac

    DATE="$(date +"%B $DAY, %Y" --date="$ORIGINAL_DATE")"

    convert "$FILE" -gravity southeast \
      -font ~/Library/Fonts/SF-Pro-Text-Regular.otf \
      -density $DENSITY -pointsize 96 -stroke '#333333C0' -strokewidth 8 -annotate +350+100 "$DATE" \
      -density $DENSITY -pointsize 96 -stroke  none -fill white -annotate +350+100 "$DATE" \
      "$FILE"
  done
fi

exit 0
