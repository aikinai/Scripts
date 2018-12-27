(*

Pack and export
 Alan Rogers
 2018/12/27
 
 Packs all photos in the current view as EIPs and then exports them.
 Exports all photos as TIF using "TIF for HEIC" recipe and only photos
 tagged "Share" as JPEG using "JPEG for Google Photos" recipe.
 
 I export the Share photos separately as JPEG since Google Photos
 has a bug and renders HEIC files with incorrect color.

*)

tell application "Capture One 12"
	-- Pack all photos as EIP
	repeat with theImage in images of current document
		if theImage is not packed then
			pack theImage
		end if
	end repeat
	
	-- Enable only "TIF for HEIC" recipe
	repeat with theRecipe in recipes of current document
		if (name of theRecipe is "TIF for HEIC") then
			set enabled of theRecipe to true
		else
			set enabled of theRecipe to false
		end if
	end repeat
	-- Export all photos as TIF to be encoded as HEIC
	repeat with theVariant in variants of current document
		process theVariant
	end repeat
	
	-- Enable only "JPEG for Google Photos" recipe
	repeat with theRecipe in recipes of current document
		if (name of theRecipe is "JPEG for Google Photos") then
			set enabled of theRecipe to true
		else
			set enabled of theRecipe to false
		end if
	end repeat
	-- Export all Share tagged photos as JPEGs for Google Photos
	repeat with theVariant in variants of current document
		if ((name of keyword of theVariant) contains "Share") then
			process theVariant
		end if
	end repeat
	
	-- Select Process tab to see output progress
	set selected of tool tabs of current document whose id is "OutputToolTab" to true
end tell
