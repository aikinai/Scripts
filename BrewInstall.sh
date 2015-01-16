#!/bin/bash

if ! command -v brew &>/dev/null; then
  echo -e "\x1B[0;34mInstalling Homebrew.\x1B[0m"
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

brew tap homebrew/dupes

brew install \
bash \
bash-completion \
coreutils \
ffmpeg \
gcal \
git \
gnu-sed \
grep \
imagemagick \
lftp \
markdown \
media-info \
openssl \
p7zip \
python \
qtfaststart \
readline \
reattach-to-user-namespace \
rsync \
ruby \
screen \
subversion \
the_silver_searcher \
tmux \
tree \
vim
