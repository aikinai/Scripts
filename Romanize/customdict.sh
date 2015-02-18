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
  -e 's/Bājon/Version/g'                                                      \
  -e 's/Porunogurafitei/Porno Graffiti/'                                      \
  -e 's/Takkīando Tsubasa/Takkī \& Tsubasa/'                                  \
  -e 's/Jannudaruku/Jeanne d\x27Arc/'                                         \
  -e 's/Supittsu/Spitz/'                                                      \
  -e 's/teiku5/Take 5/'                                                       \
  -e 's/Hamazaki Ayumi/Ayumi Hamasaki/'                                       \
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
  -e 's/Acōsticver/Acoustic Ver/'                                             \
  -e 's/Niji Shoku Basu/Nijiiro Basu/'                                        \
  -e 's/Yasashi Sa no Shizuku/Yasashisa no Shizuku/'                          \
  -e 's/Onaji Doa o Kugure Tara/Onaji Doa o Kuguretara/'                      \
  -e 's/Nippon (Neojapanesuku)/Nippon (Neo-Japanesque)/'                      \
  -e 's/Dai no Nakayoshi Tama Chan/Dai no Nakayoshi Tama-chan/'               \
  -e 's/Koyuki/Kona Yuki/'                                                    \
  -e 's/Akai Tori ~REDBIRD/Akai Tori - RED BIRD/'                             \
  -e 's/Happa Tai/Happatai/'                                                  \
  -e 's/Kodō -InsidetheSunRemix/Kodō - Inside the Sun Remix/'                 \
  -e 's/Aitashin (AlbumVersion)/ai ta kokoro (Album Version)/'                \
  -e 's/… … Noguchi San/......Noguchi-san/'                                   \
  -e 's/Akke Ni Tora Re Ta/Akke ni Torareta/'                                 \
  -e 's/Maruko Chan/Marukochan/'                                              \
  -e 's/Maru Chan/Maruchan/'                                                  \
  -e 's/Ichi Ken/Ikken/'                                                      \
  -e 's/Mono Noke Hime/Mononoke Hime/'                                        \
  -e 's/Mo Yuru/Moyuru/'                                                      \
  -e 's/Onrī Ronrīgurōrī/Onrī Ronrī Gurōrī/'                                  \
  -e 's/Kantorī Rōdo/Country Road/'                                           \
  -e 's/Sutāgeizā/Stargazer/'                                                 \
  -e 's/Zubari Maruo Kun Desho U !/Zubari Maruo-kun Deshou!/'                 \
  -e 's/Terūno Uta/Terū no Uta/'                                              \
  -e 's/Tokinonamida/Toki no Namida/'                                         \
  -e 's/Shutsuen Sha/Shutsuensha/'                                            \
  -e 's/Harehare Reyukai/Harehare Yukai/'                                     \
  -e 's/Biba★ Rokku ~JapaneseSide~/Biba★ Rokku ~Japanese Side~/'              \
  -e 's/Beibii~、Hanawa Kun Tōjō/Baby~ Hanawa Kun Tōjō/'                      \
  -e 's/Rabirinsu ~Modan Dai Ni Shō ~/Rabirinsu ~Modan Dainishō~/'            \
  -e 's/Rōrāsurūgōgōto Hamaji/Rōrāsurū Gō Gō to Hamaji/'                      \
  -e 's/Jōsha Ken/Jōshaken/'                                                  \
  -e 's/Korekushon/Collection/'                                               \
  -e 's/Kyōto Shi/Kyōto-shi/'                                                 \
  -e 's/Ima Made Nan Do Mo/Ima Made Nandomo/'                                 \
  -e 's/Yoyogi Raibuhausu/Yoyogi Live House/'                                 \
  -e 's/Tsutae Rare Yuku Michi/Tsutaerareyuku Michi/'                         \
  -e 's/Tomo Zō &Hiroshi/Tomozō \& Hiroshi/'                                  \
  -e 's/Ai o Tsukame Fujiki Kun/Ai o Tsukame Fujiki-kun/'                     \
  -e 's/Ashita 、 Tenki Ni Nare 。/Ashita, Tenki ni Nare./'                   \
  -e 's/Ki Kokorozashi Dan/Kishidan/'                                         \
  -e 's/ Kun/-kun/'                                                           \
  -e 's/Hata Aki/Hataaki/'                                                    \
  -e 's/Akita Oba Ko/Akita Obako/'                                            \
  -e 's/Date !Tachiagare Yamane-kun/Tate! Tachiagare Yamane-kun/'             \
  -e 's/ !/!/'                                                                \
  -e 's/\/aikyatchiongaku/\/ Eye-catch Ongaku/'                               \
  -e 's/ ]/]/'                                                                \
  -e 's/Gekko Hana/Gekkouka/'                                                 \
  -e 's/Kaze Ni Notsu Te/Kaze ni Notte/'                                      \
  -e 's/Daiyamondo Bajin/Diamond Virgin/'                                     \
  -e 's/HELLorHEAVEN/HELL or HEAVEN/'                                         \
  -e 's/itoshi no PsychoBreaker/~Itoshi no Psycho Breaker~/'                  
