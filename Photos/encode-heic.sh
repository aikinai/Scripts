#!/usr/bin/env bash
#
# encode-heic.sh
# Encodes images to HEIC using ffmpeg (with x265, mp4box, and exiftool).
# Also copies created and modified dates to the new file
#
# x265 encoder uses CRF=26 with slower preset unless overridden.
# Crops images to even dimensions since that's required by the encoder.
#
# Options and metadata
#   CRF
#     x265 CRF parameter
#   PRESET
#     x265 preset parameter
#

# Roughly check dependencies
if ! command -v ffmpeg > /dev/null; then
  echo -e ""
  echo -e "\x1B[00;31mERROR\x1B[00m: Please install ffmpeg."
  echo -e ""
  exit 1
fi
if ! command -v mp4box > /dev/null; then
  echo -e ""
  echo -e "\x1B[00;31mERROR\x1B[00m: Please install mp4box."
  echo -e ""
  exit 1
fi
if ! command -v exiftool > /dev/null; then
  echo -e ""
  echo -e "\x1B[00;31mERROR\x1B[00m: Please install exiftool."
  echo -e ""
  exit 1
fi

# Set x265 CRF if defined; use 26 if not
if [ -n "$CRF" ]; then
  CRF_ARG=(
  "-crf"
  "${CRF}"
  )
else
  CRF_ARG=(
  "-crf"
  "26"
  )
fi

# Set x265 preset if defined
if [ -n "$PRESET" ]; then
  PRESET_ARG=(
    -preset
    "${PRESET}"
  )
else
  PRESET_ARG=(
    "-preset"
    "slower"
  )
fi

for INPUT in "$@"
do
  DIRECTORY="$(dirname "${INPUT}")"
  FULLPATH="$(realpath "${DIRECTORY}")"
  BASENAME="$(basename "${INPUT%.*}")"
  EXTENSION="${INPUT##*.}"
  HVCFILE="${FULLPATH}/${BASENAME}.hvc"
  # Use same FILENAME.heic for output, unless defined in OUTPUT
  if [ -z "$OUTPUT" ]; then
    OUTPUT="${FULLPATH}/${BASENAME}.heic"
  fi

  # Set up ffmpeg arguments as an array since this is more robust and doesn't 
  # break on the quotes in the subtitles option
  FFMPEG_ARGS=(
  -y
  -i "${INPUT}"
  -c:v libx265
  -pix_fmt yuv420p 
  -vf "crop=trunc(iw/2)*2:trunc(ih/2)*2"
  -f hevc
  "${PRESET_ARG[@]}"
  "${CRF_ARG[@]}"
  "${HVCFILE}"
  )

  ffmpeg "${FFMPEG_ARGS[@]}"

  MP4Box \
    -add-image "${HVCFILE}" \
    -ab heic \
    -set-primary 1 \
    -new "${OUTPUT}"
  rm "${HVCFILE}"

  # Use exiftool to copy all metadata
  echo -e "\x1B[00;33mCopy all metadata from \x1B[01;35m${INPUT}\x1B[00m"
  # Try to copy everything first, but this will still miss some important tags
  exiftool -overwrite_original -extractEmbedded -TagsFromFile "$INPUT" "-all:all>all:all" "$OUTPUT"

  # Copy MacOS Finder tags from original file
  echo -e "\x1B[00;33mCopy MacOS Finder tags from \x1B[01;35m${INPUT}\x1B[00m"
  tag --add "$(tag --no-name --list "$INPUT")" "$OUTPUT"

  # Copy created and modified dates from original file
  echo -e "\x1B[00;33mCopy file created and modified date from \x1B[01;35m${INPUT}\x1B[00m"
  SetFile \
    -d "$(GetFileInfo -d "$INPUT")" \
    -m "$(GetFileInfo -m "$INPUT")" \
    "$OUTPUT"
  unset OUTPUT
done
