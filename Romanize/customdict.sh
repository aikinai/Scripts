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

  echo "$INPUT" |                                                             \
  gsed                                                                        \
  -e 's/ No / no /g'                                                          \
  -e 's/ De / de /g'                                                          \
  -e 's/ Wo / o /g'                                                           \
  -e 's/　 / /g'                                                              \
  -e 's/Vājon/Version/g'                                                      \
  -e 's/Porunogurafitei/Porno Graffiti/'                                      \
  -e 's/Takkīando Tsubasa/Takkī \& Tsubasa/'                                  \
  -e 's/Jannudaruku/Jeanne d\x27Arc/'                                         \
  -e 's/Supittsu/Spitz/'                                                      \
  -e 's/Teiku/Take/'                                                          \
  -e 's/Hamazaki/Hamasaki/'                                                   \
  -e 's/Hisaishi Yuzuru/Joe Hisaishi/'                                        \
  -e 's/Hare Ta Hi Ni …/Hareta Hi Ni…/'                                       \
  -e 's/Pan Ya no Tetsudai/Panya no Tetsudai/'                                \
  -e 's/Jiefu/Jeff/'                                                          \
  -e 's/Pāteī Ni Maniawa Nai/Pātī ni Maniawanai/'                             \
  -e 's/Osonosan no Tanomi Goto …/Osono-san no Tanomigoto…/'                  \
  -e 's/Tobe Nai !/Tobenai!/'                                                 \
  -e 's/Urusurano Koya E/Urusura no Koya E/'                                  \
  -e 's/Shinpi Naru E/Shinpi Naru E/'                                         \
  -e 's/Bōhikō no Jiyū no Bōken Gō/Bōhikō no Jiyū no Bōkengō/'                \
  -e 's/Yasashi Sa Ni Tsutsuma Re Ta Nara/Yasashisa ni Tsutsumareta Nara/'    \
  -e 's/Kimi Toyuu Hana/Kimi to iu Hana/'                                     \
  -e 's/Natsu no Hi 、 Zanzō/Natsu no Hi, Zanzō/'                             \
  -e 's/Shindō Satoshi/Shindōkaku/'                                           \
  -e 's/Ji Heitansaku/Jihei Tansaku/'                                         \
  -e 's/Kanashimi o Yasashi Sa Ni/Kanashimi o Yasashisa Ni/'                  \
  -e 's/Mō Kimi Igai Aise Nai/Mō Kimi Igai Aisenai/'                          \
  -e 's/Yugudorashiru/Yggdrasil/'                                             \
  -e 's/  Myūjikku Korekushon/ Music Collection/'                             \
  -e 's/Utsūutsūumauma(゜ ∀゜ )/Uuu Uuu Uma Uma/'                             \
  -e 's/BeautyandtheBeast〜 Bijotoyajū/Beauty and the Beast - Bijo to Yajū/'  \
  -e 's/Can’ tTakeMyEyesOffOfYOU〜 /Can\x27t Take My Eyes Off of YOU - /'     \
  -e 's/Kun no Hitomi Ni Koishi Teru/Kimi no Hitomi ni Koishiteru/'           \
  -e 's/(CandyFlossMix)/(Candy Floss Mix)/'                                   \
  -e 's/Ha・ Ya・ Te/Ha-Ya-Te/'                                               \
  -e 's/SaluteD\x27amōr〜 Ai no Aisatsu/Salute D\x27amour - Ai no Aisatsu/'   \
  -e 's/(UndertheMoonlightMix)/(Under the Moonlight Mix)/'                    \
  -e 's/SomedayMyPrinceWillCome〜/Someday My Prince Will Come -/'             \
  -e 's/Itsuka Ōji Sama Ga/Itsuka Ōji-sama Ga/'                               \
  -e 's/(ALoveSuite-EDM-Mix)/(A Love Suite -EDM- Mix)/'                       \
  -e 's/Acōsticver/Acoustic Ver/'
