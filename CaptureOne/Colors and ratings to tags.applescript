(*

 Colors and ratings to tags
 Alan Rogers
 2018/12/27

Tag all colored photos with ♡ and all rated photos with Share.
Also removes the colors and ratings.

To tag photos as favorites or for sharing, I first mark the photos
with a color or ratings since those are first-class citizens in the
Capture One UI. I then use this script to convert the colors and
ratings into tags which will be exported in the photo EXIF data.

*)

tell application "Capture One 12"
	repeat with theVariant in variants of current document
		if (color tag of theVariant ≠ 0) then
			tell theVariant to make keyword with properties {name:"♡"}
			set color tag of theVariant to 0
		end if
		if (rating of theVariant ≠ 0) then
			tell theVariant to make keyword with properties {name:"Share"}
			set rating of theVariant to 0
		end if
	end repeat
end tell