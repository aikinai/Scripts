#!/usr/bin/env swift
//
//  encode-heic.swift
//
//  Purpose
//  -------
//  • Converts any Lightroom HDR export (JPEG or TIFF) into a single
//    ISO-21496-1 gain-map HEIC.
//  • Copies the gain-map plane when present; falls back to plain SDR HEIC
//    when it isn’t.
//  • Preserves the source ICC profile to avoid unnecessary gamut remapping.
//
//  Requirements
//  ------------
//  • macOS 15 “Sequoia” or later
//  • Xcode / Command-Line Tools 16+ (Swift 6.1)
//  • Source files exported from Lightroom with
//        – HDR Output   = ✓
//        – Maximise Compatibility = ✓
//        – Colour Space = HDR P3   (preferred)  *or*  HDR sRGB
//
//  Usage
//  -----
//      chmod +x encode-heic.swift
//      ./encode-heic.swift  *.jpg  *.tif
//
//  -----------------------------------------------------------------------

import Foundation
import CoreImage
import ImageIO
import AVFoundation

// -----------------------------------------------------------------------
//  Tunables
// -----------------------------------------------------------------------
let heicQuality: Double = 0.50        // ≈ half the size of an 80-% JPEG
let ciContext = CIContext(options: [.priorityRequestLow: true])

// -----------------------------------------------------------------------
//  Main
// -----------------------------------------------------------------------
for path in CommandLine.arguments.dropFirst() {
    let srcURL = URL(fileURLWithPath: path)
    let dstURL = srcURL.deletingPathExtension().appendingPathExtension("heic")

    // -------------------------------------------------------------------
    //  Load the SDR base frame (CI applies orientation automatically).
    // -------------------------------------------------------------------
    guard let sdr = CIImage(contentsOf: srcURL,
                            options: [.applyOrientationProperty: true]) else {
        fputs("❌  Cannot read \(srcURL.lastPathComponent)\n", stderr)
        continue
    }

    // -------------------------------------------------------------------
    //  Attempt to load the HDR gain-map plane.
    //  Returns nil for SDR photos, which is exactly what we want.
    // -------------------------------------------------------------------
    let gainMap = CIImage(contentsOf: srcURL,
                          options: [.auxiliaryHDRGainMap: true])

    // -------------------------------------------------------------------
    //  Destination colour space:
    //    – If the source carries an ICC profile → keep it.
    //    – Otherwise fall back to Display-P3 (safe superset of sRGB).
    // -------------------------------------------------------------------
    let dstColorSpace = sdr.colorSpace
                     ?? CGColorSpace(name: CGColorSpace.displayP3)!

    // -------------------------------------------------------------------
    //  Build the options dictionary for Core Image’s HEIC writer.
    //    * Lossy compression quality      → HEVC QP target
    //    * hdrGainMapImage (optional)     → copies ISO gain-map plane
    // -------------------------------------------------------------------
    let qualityKey = CIImageRepresentationOption(
        rawValue: kCGImageDestinationLossyCompressionQuality as String)

    var opts: [CIImageRepresentationOption: Any] = [qualityKey: heicQuality]
    if let gm = gainMap {
        opts[.hdrGainMapImage] = gm
    }

    // -------------------------------------------------------------------
    //  Write the HEIC.
    //    • format: .RGBA8  -> SDR base frame for gain-map HDR
    //    • Core Image handles tiling and nclx metadata internally.
    // -------------------------------------------------------------------
    do {
        try ciContext.writeHEIFRepresentation(
            of: sdr,
            to: dstURL,
            format: .RGBA8,
            colorSpace: dstColorSpace,
            options: opts
        )

        let kind = gainMap == nil ? "SDR" : "HDR"
        print("✅  \(dstURL.lastPathComponent)  (\(kind))")
    } catch {
        fputs("❌  \(error.localizedDescription) for \(srcURL.lastPathComponent)\n",
              stderr)
    }
}
