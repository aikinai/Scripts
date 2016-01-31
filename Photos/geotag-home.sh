#!/usr/bin/env bash

exiftool \
  -GPSLatitude=47.6137388888889 \
  -GPSLatitudeRef=N \
  -GPSLongitude=122.333977777778 \
  -GPSLongitudeRef=W \
  -GPSAltitude=130 \
  -GPSAltitudeRef="Above Sea Level" \
  -GPSMapDatum="WGS-84" \
  -overwrite_original \
  $@
