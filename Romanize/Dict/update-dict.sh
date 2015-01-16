#!/bin/bash
#
# update-dict.sh
#
# Generates `UserDict.dic` in this directory from `UserDict.csv` also in this 
# directory. `UserDict.csv` is a UTF-8 CSV file with each line in the following format:
# 秀々,*,*,*,*,*,*,*,*,*,*,*,ヒデヒデ
#
# Requires `mecab`, available through Homebrew
#

/usr/local/Cellar/mecab/0.996/libexec/mecab/mecab-dict-index \
  -d /usr/local/Cellar/mecab/0.996/lib/mecab/dic/ipadic \
  -u UserDict.dic \
  -f utf8 \
  -t utf8 \
  UserDict.csv
