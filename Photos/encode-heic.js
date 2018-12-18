#!/usr/bin/env osascript -l JavaScript
//
//  encode-heic.js
//
//  Originally authored by Sinoru, 2018/4/28
//  https://gist.github.com/sinoru/36b26cdbfcbc0899ff309f6cad6c1831
//
//  Ported to JavaScript by magic-akari
//  https://gist.github.com/magic-akari/d59efdaf9298ad20f0b5d05eb7d7cef9
//
//  Minor formatting and text cleanup by aikinai, 2018/12/18
//  

ObjC.import("Foundation");
ObjC.import("ImageIO");
ObjC.import("AVFoundation");

// HEIC quality setting of 0.75 seems to be about 50% of JPEG file size at 80% 
// with the same perceptual quality
const quality = 0.75;

console.log(`\n\x1b[01;35mEncode all input files as HEIC at \x1b[0;33m${quality}\x1b[01;35m quality\x1b[0;0m`);

function run(input) {
  for (const file of input) {
    const path = file.toString();
    console.log(`Encode \x1b[0;33m${path}\x1b[0;0m`);

    const sourceFileURL = $.NSURL.fileURLWithPath(path);

    const imageSource = $.CGImageSourceCreateWithURL(sourceFileURL, $());

    if (imageSource.isNil()) {
      console.log(`\x1b[0;31mError\x1b[0;0m: Could not load \x1b[0;33m${sourceFileURL.path.js}\x1b[0;0m`)
      continue;
    }

    const imageProperties = $.CGImageSourceCopyProperties(imageSource, $());

    const imageCount = $.CGImageSourceGetCount(imageSource);

    const destinationFileURL = sourceFileURL.URLByDeletingPathExtension.URLByAppendingPathExtension(
      "heic"
    );

    const imageDestination = $.CGImageDestinationCreateWithURL(
      destinationFileURL,
      $.AVFileTypeHEIC,
      imageCount,
      $()
    );

    if (imageDestination.isNil()) {
      console.log(`\x1b[0;31mError\x1b[0;0m: Could not write \x1b[0;33m${destinationFileURL.path.js}\x1b[0;0m`)
      continue;
    }

    $.CGImageDestinationSetProperties(imageDestination, imageProperties);

    for (let index = 0; index < imageCount; index++) {
      $.CGImageDestinationAddImageFromSource(
        imageDestination,
        imageSource,
        index,
        { kCGImageDestinationLossyCompressionQuality: quality }
      );
    }

    const result = $.CGImageDestinationFinalize(imageDestination);
    if (!result) {
      console.log(`\x1b[0;31mError\x1b[0;0m: Could not finalize \x1b[0;33m${destinationFileURL.path.js}\x1b[0;0m`)
      continue;
    }
  }
}
