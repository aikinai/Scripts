#!/bin/bash
#
# romanize.sh
#
# Converts Japanese text to romaji.
# Primarily written to convert Japanese text in my music library so it can be 
# displayed in the car.
# 

echo "$@" | ./romaji.sh | ./customdict.sh | ./titlecase.pl
