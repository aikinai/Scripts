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

# Sort HEIC files by filename
if [ ${#heic_files[@]} -gt 0 ]; then
  readarray -t sorted_heic_files < <(printf '%s\n' "${heic_files[@]}" | sort)

  import_result=$(osascript <<EOD
set heicFilesStr to "$(printf '%s\n' "${sorted_heic_files[@]}")"
set heicFiles to the paragraphs of heicFilesStr
set photosApp to (path to application "Photos")

tell application "Photos"
	set photoFiles to {}
	repeat with heicFile in heicFiles
		set posixPath to heicFile as string
		set photoFile to POSIX file posixPath as alias
		set end of photoFiles to photoFile
	end repeat
	set importedFiles to import photoFiles

	set favoriteKeyword to "♡"
	set frameKeyword to "Frame"
	set frameAlbum to first album whose name is "Frame"
	set frameLandscapeAlbum to first album whose name is "Frame Landscape"
	
	set frameMediaList to {}
	set frameLandscapeMediaList to {}
	
	repeat with mediaItem in importedFiles
		set mediaKeywords to keywords of mediaItem
		if favoriteKeyword is in mediaKeywords then
			set favorite of mediaItem to true
		end if
		if frameKeyword is in mediaKeywords then
			set end of frameMediaList to mediaItem
			if width of mediaItem > height of mediaItem then
				set end of frameLandscapeMediaList to mediaItem
			end if
		end if
	end repeat
	
  if (count of frameMediaList) > 0 then
      add frameMediaList to frameAlbum
  end if
  if (count of frameLandscapeMediaList) > 0 then
      add frameLandscapeMediaList to frameLandscapeAlbum
  end if
	
end tell

if (count of importedFiles) = (count of heicFiles) then
	return "All photos successfully imported"
else
	return "An error occurred while importing photos to Apple Photos."
end if
EOD
)
echo -e "$import_result"
else
  echo "No HEIC images found; nothing imported to Apple Photos"
fi

exit 0
