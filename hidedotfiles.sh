#!/bin/bash

cd ~/

for FILE in .*
do
    echo -e "attrib +H /L \x22${FILE}\x22" | cmd -
done
