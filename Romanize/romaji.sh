#!/bin/bash
#
# romaji.sh
#
# Uses `mecab` and `kakasi` to convert Japanese text to romaji.
# Since `kakasi` uses ^ to indicate long vowels, also replaces those with 
# Unicode equivalents. Also fixes misplaced commas.
#
# Requires `mecab` and `kakasi`, both available from Homebrew.
#

read INPUT

echo "$INPUT" |                                          \
  mecab -u Dict/UserDict.dic -F "%f[8] " -E "" -U "%m" | \
  kakasi -iutf8 -outf8 -Ka -Ha -Ja |                     \
  sed                                                    \
  -e 's/a^/a/g'                                          \
  -e 's/e^/e/g'                                          \
  -e 's/i^/i/g'                                          \
  -e 's/o^/o/g'                                          \
  -e 's/u^/u/g'                                          \
  -e 's/\([^,]\) ,\([^,]\)/\1, \2/g'

# I wish I could use this version, but the BMW won't even show the long vowels
#
#   sed                                                    \
#   -e 's/a^/ā/g'                                          \
#   -e 's/e^/ē/g'                                          \
#   -e 's/i^/ī/g'                                          \
#   -e 's/o^/ō/g'                                          \
#   -e 's/u^/ū/g'                                          \
#   -e 's/ou/ō/g'                                          \
#   -e 's/\([^,]\) ,\([^,]\)/\1, \2/g'
