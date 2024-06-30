#!/usr/bin/env swift
//
//  encode-heic.swift
//
//  Originally authored by Sinoru, 2018/4/28
//  https://gist.github.com/sinoru/36b26cdbfcbc0899ff309f6cad6c1831
//
//  Minor formatting and text cleanup by aikinai, 2018/12/18
//  

import Foundation
import ImageIO
import AVFoundation

// HEIC quality setting of 0.75 seems to be about 50% of JPEG file size at 80% 
// with the same perceptual quality
let HEICQuality = 0.50
print("\n\u{001B}[01;35mEncode all input files as HEIC at \u{001B}[0;33m\(HEICQuality) \u{001B}[01;35mquality\u{001B}[0;0m")

for argument in CommandLine.arguments.dropFirst() {
    print("Encode \u{001B}[0;33m\(argument)\u{001B}[0;0m")

    let sourceFileURL = URL(fileURLWithPath: argument)

    guard let imageSource = CGImageSourceCreateWithURL(sourceFileURL as CFURL, nil) else {
        print("\u{001B}[0;31mError\u{001B}[0;0m: Could not load \(sourceFileURL)")
        continue
    }

    let imageProperties = CGImageSourceCopyProperties(imageSource, nil)
    let imageCount = CGImageSourceGetCount(imageSource)

    let destinationFileURL = sourceFileURL.deletingPathExtension().appendingPathExtension("heic")

    guard let imageDestination = CGImageDestinationCreateWithURL(destinationFileURL as CFURL, AVFileType.heic as CFString, imageCount, nil) else {
        print("\u{001B}[0;31mError\u{001B}[0;0m: Could not write \(destinationFileURL)")
        continue
    }

    CGImageDestinationSetProperties(imageDestination, imageProperties)
    for index in 0..<imageCount {
        CGImageDestinationAddImageFromSource(imageDestination, imageSource, index, [kCGImageDestinationLossyCompressionQuality: HEICQuality] as CFDictionary)
    }

    guard CGImageDestinationFinalize(imageDestination) else {
        print("\u{001B}[0;31mError\u{001B}[0;0m: Could not finalize \(destinationFileURL)")
        continue
    }
}
