#!/bin/bash
#
# romanize.sh
#
# Converts Japanese text to romaji.
# Primarily written to convert Japanese text in my music library so it can be 
# displayed in the car.
# 

cd "$(dirname "$0")"

read INPUT

echo "$INPUT" | ./romaji.sh | ./titlecase.pl | ./customdict.sh
