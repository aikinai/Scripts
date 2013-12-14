#!/bin/bash

cd ~/

for LINK in $(find .homesick/repos/castle/home/ -maxdepth 1 -exec basename {} \;)
do
    if [[ ${LINK} != "home" ]]; then # "home" shows up for some reason, so skip it
        rm -rf $LINK

        if [ -d .homesick/repos/castle/home/$LINK ]; then
            echo -e "mklink /J \x22${LINK}\x22 \x22.homesick/repos/castle/home/${LINK}\x22" | cmd -
        elif [ -f .homesick/repos/castle/home/$LINK ]; then
            echo -e "mklink /H \x22${LINK}\x22 \x22.homesick/repos/castle/home/${LINK}\x22" | cmd -
        else
            echo -e ".homesick/repos/castle/home/${LINK} is neither a directory nor a file."
        fi

        echo -e "attrib +H /L \x22${LINK}\x22" | cmd -
    fi
done
