#!/usr/bin/env bash
#
# finalize-photos.sh
# Alan Rogers
# 2018/09/07
#
# Master script that just runs the other scripts
# I use to finalize my exported JPGs or HEICs
#
# Usage: finalize-jpg.sh INPUT_DIRECTORY
#

# First argument is the exported photo directory to finalize

if [ -z "$1" ]; then
    echo -e ""
    echo -e "USAGE: finalize-photos.sh INPUT"
    echo -e ""
    exit 1
else
  DIR=$1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

"${SCRIPT_DIR}"/encode-heic.swift "${DIR}"/*.tif
if [ $? -ne 0 ]; then
  exit 1
fi
rm -rf "${DIR}"/*.tif
"${SCRIPT_DIR}"/exif-to-modified.sh "${DIR}"
"${SCRIPT_DIR}"/tag-keywords.sh "${DIR}"
"${SCRIPT_DIR}"/copy-tags.sh "${DIR}"

# Import HEIC files to Apple Photos
echo -e "\x1B[01;35mImport to Apple Photos\x1B[00m"

heic_files=()
for file in "${DIR}"/*.heic; do
    heic_files+=("$(realpath "$file")")
done

if [ ${#heic_files[@]} -gt 0 ]; then
  import_result=$(osascript <<EOD
    set heicFilesStr to "$(printf '%s\n' "${heic_files[@]}")"
    set heicFiles to the paragraphs of heicFilesStr
    set photosApp to (path to application "Photos")

    tell application "Photos"
      set importedFiles to {}
      set photoFiles to {}
      repeat with heicFile in heicFiles
        set posixPath to heicFile as string
        set photoFile to POSIX file posixPath as alias
        set end of photoFiles to photoFile
      end repeat
      set importedFiles to import photoFiles

      set favoriteKeyword to "♡"
      set frameKeyword to "Frame"
      set frameAlbum to album "Frame"
      set frameLandscapeAlbum to album "Frame Landscape"

      repeat with mediaItem in importedFiles
        set mediaKeywords to keywords of mediaItem
        if favoriteKeyword is in mediaKeywords then
          set favorite of mediaItem to true
        end if
        if frameKeyword is in mediaKeywords then
          add mediaItem to frameAlbum
          if width of mediaItem > height of mediaItem then
            add mediaItem to frameLandscapeAlbum
          end if
        end if
      end repeat
    end tell

    if (count of importedFiles) = (count of heicFiles) then
      return "All photos successfully imported"
    else
      return "Some photos may not have been imported"
    end if
EOD
)
  echo -e "$import_result"
else
  echo "No HEIC images found; nothing imported to Apple Photos"
fi

exit 0
