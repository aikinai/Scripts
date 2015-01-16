#!/bin/bash
#
# customdict.sh
#
# Custom dictionary of sed replacements for converting my music library from 
# Japanese to romaji
#
# Intended to be called from `romanize.sh`
#

read INPUT

  echo "$INPUT" |                                                              \
  sed                                                                          \
  -e 's/porunogurafitei/Porno Graffiti/g'                                      \
  -e 's/takkīando tsubasa/Takkī \& Tsubasa/g'                                  \
  -e 's/jannudaruku/Jeanne d\x27Arc/g'                                         \
  -e 's/supittsu/Spitz/g'                                                      \
  -e 's/hamazaki/hamasaki/g'
