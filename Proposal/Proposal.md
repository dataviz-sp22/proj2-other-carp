Project 2 Proposal
================
Group Name: other-carp

# Introduction

Russian-Ukraine crisis is a long lasting problem and it caused countless
casualties nearly everyday. The earliest big confrontation can be dated
back to 2014, when two cities from Ukraine (Donetsk and Luhansk) started
revolution. From 2014 to 2022, there are several small military events
and non-military but violent events happened at the boarder of
Russia-Ukraine. In 2022, concerning the East expansion of NATO, Russia
started a war against Ukraine and brings up the confrontation. Many
people are killed and many cities are destroyed during the war. In this
project, we want to build a shiny app to illustrate the military events
happened during the recent 2022 Russia-Ukraine war and keep track of the
territory boundary or military marching of soldiers from two sides.

We choose this topic because all of us are concerned about international
confrontations. We hope that the world is peaceful and there is no war
or violent event exist any more. Also, it would be interesting to take a
look at the which place has the most attackers or military actions, and
which side has the relative advantages as the battles continued. If we
can plot every single events on a map, we will be able to discover some
patterns such as which area or city has the most violent event happen
and hopefully, we can prevent the same attacks from happening again.

What we want to do is to use shiny app and interactive plots to live
demonstrate the process of Russia-Ukraine war, including the territory
movement, military and non-military events across different time frame.
The GOAL is to create pieces of “generative” art, ie., pieces of art
that have been generated using computer input and mathematical formulas.
You can find more details on data frame below and all the codes are
included on “app.R” file in Shiny App folder.

# Data

We will use the VIINA (Violent Incident Information from News Articles
on the 2022 Russian Invasion of Ukraine) data set collected by Professor
Yuri Zhukov from the University of Michigan (see [full list
here](https://github.com/zhukovyuri/VIINA)). This is the most
comprehensive data set from the internet, which provides us extensive
information to visualize, and to recover deep insights.

It’s a near-real time multi-source event data system based on news
reports from Ukrainian and Russian media, and Zhukov geocoded and
classified them into standard conflict event categories through machine
learning. The events are GIS-ready, with temporal precision down to the
minute. The final data set was orginized and saved into two csv files.

## Event data

``` r
event <- read.csv(here("Data", "events_latest.csv"))
head(event)
```

    ##   event_id report_id location tempid source     date
    ## 1        1     37244        1 116738    ria 20220224
    ## 2        2     37244        2 116738    ria 20220224
    ## 3        3     16631        1  41810   liga 20220224
    ## 4        4     42745        1 154233  unian 20220224
    ## 5        5     42745        2 154233  unian 20220224
    ## 6        6     42745        3 154233  unian 20220224
    ##                                                  url  time
    ## 1   https://ria.ru/20220224/gorlovka-1774602728.html 00:10
    ## 2   https://ria.ru/20220224/gorlovka-1774602728.html 00:10
    ## 3 https://www.liga.net/archive/2022-02-24/all/page/4 00:23
    ## 4         https://www.unian.ua/news/archive/20220224 00:35
    ## 5         https://www.unian.ua/news/archive/20220224 00:35
    ## 6         https://www.unian.ua/news/archive/20220224 00:35
    ##                                                                                                                                 text
    ## 1                        校泻褉邪懈薪褋泻懈械 胁芯械薪薪褘械 芯斜褋褌褉械谢褟谢懈 袚芯褉谢芯胁泻褍, 蟹邪褟胁懈谢懈 胁 袛芯薪械褑泻械
    ## 2                        校泻褉邪懈薪褋泻懈械 胁芯械薪薪褘械 芯斜褋褌褉械谢褟谢懈 袚芯褉谢芯胁泻褍, 蟹邪褟胁懈谢懈 胁 袛芯薪械褑泻械
    ## 3 袨泻泻褍锌邪薪褌褘 锌械褉械褋褌邪谢懈 锌褉芯锌褍褋泻邪褌褜 胁 袣褉褘屑 褍泻褉邪懈薪褋泻懈褏 谐褉邪卸写邪薪 鈥\x93 袛械薪懈褋芯胁邪
    ## 4                                 袧邪 薪褨褔 蟹邪泻褉懈谢懈 邪械褉芯锌芯褉褌懈 啸邪褉泻芯胁邪, 袛薪褨锌褉邪 褌邪 袟邪锌芯褉褨卸卸褟
    ## 5                                 袧邪 薪褨褔 蟹邪泻褉懈谢懈 邪械褉芯锌芯褉褌懈 啸邪褉泻芯胁邪, 袛薪褨锌褉邪 褌邪 袟邪锌芯褉褨卸卸褟
    ## 6                                 袧邪 薪褨褔 蟹邪泻褉懈谢懈 邪械褉芯锌芯褉褌懈 啸邪褉泻芯胁邪, 袛薪褨锌褉邪 褌邪 袟邪锌芯褉褨卸卸褟
    ##   lang
    ## 1   ru
    ## 2   ru
    ## 3   ru
    ## 4   ua
    ## 5   ua
    ## 6   ua
    ##                                                                                                                                                                                                                                                                 address
    ## 1                                                                                                                                                                                                     校泻褉邪懈薪邪, 袛芯薪械褑泻邪褟 芯斜谢邪褋褌褜, 袚芯褉谢芯胁泻邪
    ## 2                                                                                                                                                                                                                                          校泻褉邪懈薪邪, 袛芯薪械褑泻
    ## 3 校泻褉邪懈薪邪, 7, 褍谢懈褑邪 袗谢械泻褋邪薪写褉邪 袧械胁褋泻芯谐芯, 笑械薪褌褉邪谢褜薪褘泄 褉邪泄芯薪, 小懈屑褎械褉芯锌芯谢褜, 谐芯褉芯写褋泻芯泄 芯泻褉褍谐 小懈屑褎械褉芯锌芯谢褜, 袗胁褌芯薪芯屑薪邪 袪械褋锌褍斜谢褨泻邪 袣褉懈屑, 295000-295490, 校泻褉邪褩薪邪
    ## 4                                                                                                                                                                                                                                        校泻褉邪懈薪邪, 啸邪褉褜泻芯胁
    ## 5                                                                                                                                                                                                                                            校泻褉邪懈薪邪, 袛薪械锌褉
    ## 6                                                                                                                                                                                                                                    校泻褉邪懈薪邪, 袟邪锌芯褉芯卸褜械
    ##          longitude   latitude GEO_PRECISION GEO_API t_mil_pred t_loc_pred
    ## 1        38.002536   48.30608          ADM3  Yandex  0.9999957 0.99999875
    ## 2         37.80285  48.015884          ADM3  Yandex  0.9999957 0.99999875
    ## 3 34.0994127132379 44.9536335          ADM3  Yandex 0.07369903  0.9999984
    ## 4        36.231202  49.992167          ADM3  Yandex  0.9999945  0.9999949
    ## 5        35.046181  48.464717          ADM3  Yandex  0.9999945  0.9999949
    ## 6        35.138851  47.838312          ADM3  Yandex  0.9999945  0.9999949
    ##     t_san_pred    a_rus_pred    a_ukr_pred    a_civ_pred  a_other_pred
    ## 1 0.0026274025 6.5846903e-06    0.99999976 2.2005882e-08  1.955984e-06
    ## 2 0.0026274025 6.5846903e-06    0.99999976 2.2005882e-08  1.955984e-06
    ## 3 0.0026274025 2.1235744e-05 6.1959787e-07 2.2025029e-08 1.7473878e-05
    ## 4 0.0026274025     0.9999974 3.8070377e-07 2.2008063e-08 1.9498957e-06
    ## 5 0.0026274025     0.9999974 3.8070377e-07 2.2008063e-08 1.9498957e-06
    ## 6 0.0026274025     0.9999974 3.8070377e-07 2.2008063e-08 1.9498957e-06
    ##      t_aad_pred t_airstrike_pred  t_armor_pred t_arrest_pred t_artillery_pred
    ## 1 1.8358813e-08     5.354489e-10  9.229467e-10  2.502702e-09        0.9999992
    ## 2 1.8358813e-08     5.354489e-10  9.229467e-10  2.502702e-09        0.9999992
    ## 3  1.840239e-08    5.6344074e-10  9.274112e-10 2.5483473e-09    1.4730992e-07
    ## 4 1.8365817e-08     5.261832e-10 9.2429614e-10 2.4838511e-09        0.9999989
    ## 5 1.8365817e-08     5.261832e-10 9.2429614e-10 2.4838511e-09        0.9999989
    ## 6 1.8365817e-08     5.261832e-10 9.2429614e-10 2.4838511e-09        0.9999989
    ##   t_control_pred t_killing_pred t_firefight_pred    t_ied_pred t_property_pred
    ## 1   4.610759e-08  0.00067177415    4.2698503e-10 1.7871069e-09    9.493987e-10
    ## 2   4.610759e-08  0.00067177415    4.2698503e-10 1.7871069e-09    9.493987e-10
    ## 3     0.06977734   0.0007250905     4.349069e-10 1.8600453e-09     9.49578e-10
    ## 4  4.6264397e-08    0.000672698    4.2320025e-10  1.787216e-09    9.494041e-10
    ## 5  4.6264397e-08    0.000672698    4.2320025e-10  1.787216e-09    9.494041e-10
    ## 6  4.6264397e-08    0.000672698    4.2320025e-10  1.787216e-09    9.494041e-10
    ##     t_raid_pred t_occupy_pred  t_cyber_pred t_hospital_pred t_milcas_pred
    ## 1 2.0802268e-08 1.4237527e-06 2.9313615e-06   1.4959298e-08 1.7862823e-07
    ## 2 2.0802268e-08 1.4237527e-06 2.9313615e-06   1.4959298e-08 1.7862823e-07
    ## 3     0.9999269  1.423773e-06 7.2226317e-06   1.4959241e-08 1.7847566e-07
    ## 4  2.079957e-08 1.4238042e-06  3.240145e-06   1.4959241e-08 1.7853678e-07
    ## 5  2.079957e-08 1.4238042e-06  3.240145e-06   1.4959241e-08 1.7853678e-07
    ## 6  2.079957e-08 1.4238042e-06  3.240145e-06   1.4959241e-08 1.7853678e-07
    ##   t_civcas_pred t_mil_b t_loc_b t_san_b a_rus_b a_ukr_b a_civ_b a_other_b
    ## 1  5.424299e-07       1       1       0       0       1       0         0
    ## 2  5.424299e-07       1       1       0       0       1       0         0
    ## 3 9.4689135e-08       0       1       0       0       0       0         0
    ## 4 1.4218149e-08       1       1       0       1       0       0         0
    ## 5 1.4218149e-08       1       1       0       1       0       0         0
    ## 6 1.4218149e-08       1       1       0       1       0       0         0
    ##   t_aad_b t_airstrike_b t_armor_b t_arrest_b t_artillery_b t_control_b
    ## 1       0             0         0          0             1           0
    ## 2       0             0         0          0             1           0
    ## 3       0             0         0          0             0           0
    ## 4       0             0         0          0             1           0
    ## 5       0             0         0          0             1           0
    ## 6       0             0         0          0             1           0
    ##   t_killing_b t_firefight_b t_ied_b t_property_b t_raid_b t_occupy_b t_cyber_b
    ## 1           0             0       0            0        0          0         0
    ## 2           0             0       0            0        0          0         0
    ## 3           0             0       0            0        1          0         0
    ## 4           0             0       0            0        0          0         0
    ## 5           0             0       0            0        0          0         0
    ## 6           0             0       0            0        0          0         0
    ##   t_hospital_b t_milcas_b t_civcas_b          t_nmil_pred t_nmil_b
    ## 1            0          0          0 4.29999999995712e-06        0
    ## 2            0          0          0 4.29999999995712e-06        0
    ## 3            0          0          0           0.92630097        1
    ## 4            0          0          0 5.49999999999162e-06        0
    ## 5            0          0          0 5.49999999999162e-06        0
    ## 6            0          0          0 5.49999999999162e-06        0

The first csv file includes raw events, and below is the codebook:

### Codebook

  - event\_id: Unique event ID
  - report\_id: Unique ID for report that contains the event
  - location: Index of unique locations mentioned in each event
  - tempid: Temporary numeric ID
  - source: Data source short name
  - date: Date of event report (YYYYMMDD)
  - time: Time of event report (HH:MM)
  - url: URL web address of event report
  - text: Text of event report headline/description
  - lang: Language of report (ua is Ukrainian, ru is Russian)
  - address: Address of geocoded location
  - longitude: Longitude coordinate of event location
  - latitude: Latitude coordinate of event location
  - GEO\_PRECISION: geographic precision of geocoded location
  - GEO\_API: Geocoding API used to locate event
  - t\_\[event type\]: Predicted probability that report describes event
    of each type (from LSTM model, see above)
  - a\_\[actor\]: Predicted probability that report describes event
    initiated by each actor (from LSTM model, see above)

The data includes following event categories:

### Categories

  - t\_mil: Event is about war/military operations
  - t\_nmil: Event is not about war/military operations (e.g. human
    interest story)
  - t\_loc: Event report includes reference to specific location
  - t\_san: Event report mentions economic sanctions imposed on Russia
  - a\_rus: Event initiated by Russian or Russian-aligned armed forces
  - a\_ukr: Event initiated by Ukrainian or Ukrainian-aligned armed
    forces
  - a\_civ: Event initiated by civilians
  - a\_other: Event initiated by a third party (e.g. U.S., EU, Red
    Cross)
  - t\_aad: Anti-air defense, Buk, shoulder-fired missiles (Igla,
    Strela, Stinger)
  - t\_airstrike: Air strike, strategic bombing, helicopter strike
  - t\_armor: Tank battle or assault
  - t\_arrest: Arrest by security services or detention of prisoners of
    war
  - t\_artillery: Shelling by field artillery, howitzer, mortar, or
    rockets like Grad/BM-21, Uragan/BM-27, other Multiple Launch Rocket
    System (MRLS)
  - t\_control: Establishment/claim of territorial control over
    population center
  - t\_firefight: Any exchange of gunfire with handguns, semi-automatic
    rifles, automatic rifles, machine guns, rocket-propelled grenades
    (RPGs)
  - t\_ied: Improvised explosive device, roadside bomb, landmine, car
    bomb, explosion
  - t\_raid: Assault/attack by paratroopers or special forces, usually
    followed by a retreat
  - t\_occupy: Occupation of territory or building
  - t\_property: Destruction of property or infrastructure
  - t\_cyber: Cyber operations, including DDOS attacks, website
    defacement
  - t\_hospitals: Attacks on hospitals and humanitarian convoys
  - t\_milcas: Event report mentions military casualties
  - t\_civcas: Event report mentions civilian casualties

## Territorial control

``` r
control <- read.csv(here("Data", "control_latest.csv")) %>%
  select(1:8)
```

    ## Warning in scan(file = file, what = what, sep = sep, quote = quote, dec = dec, :
    ## EOF within quoted string

``` r
head(control)
```

    ##   geonameid             name        asciiname
    ## 1    461727         Olenevka         Olenevka
    ## 2    467852 Yelyzavetyns'kyy Yelyzavetyns'kyy
    ## 3    468196      Katerynivka      Katerynivka
    ## 4    477085      Vaniushkyne      Vaniushkyne
    ## 5    485524         Svistuny         Svistuny
    ## 6    490588           Sopych           Sopych
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      alternatenames
    ## 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Karadzhi,Olenevka,Qaragy,Qara臒y,袣邪褉邪写卸懈虂,袨谢械薪械胁泻邪
    ## 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       Elizavetins'kij,Elizavetinskij,Yelizavetinskiy,Yelyzavetyns'kyy,袆谢懈蟹邪胁械褌懈薪褋褜泻懈泄,袝谢懈蟹邪胁械褌懈薪褋泻懈泄
    ## 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Katerinivka,Katerinovka,Katerynivka,Kateryniwka,Yekaterinoslavskiy,袣邪褌械褉懈薪芯胁泻邪,袣邪褌械褉懈薪褨胁泻邪,钥铡湛榨謤斋斩崭站寨铡
    ## 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Vaniushkyne,Vanjushkine,Vanyushkin,Vanyushkyne,袙邪薪褞褕泻懈薪械
    ## 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    ## 6 Sapych,Sopich,Sopici,Sopic驶,Sopych,Sopych',Sopytsch,Sop卯ci,suo pi qi,小邪锌褘褔,小芯锌懈褔,小芯锌褘褔褜,諐崭蘸斋展,绱㈢毊濂\x87",34.36082,51.8503,PPL,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA,UA\n494448,Shilova Balka,Shilova Balka,",33.31667,46.81667,PPL,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,RU,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n498959,Samiilove,Samiilove,Samiilove
    ##   longitude  latitude feature_code ctr_20220227214017
    ## 1  32.53333  45.38333        PPLA3                 RU
    ## 2  38.82056  47.84083         PPLX                 RU
    ## 3  38.75174  47.69011          PPL                 RU
    ## 4  38.27055  47.25507          PPL                 RU
    ## 5  38.40694  47.72639          PPL                 RU
    ## 6 Samijlove Samiylove     Samoylov          Samoylovo

Based on the event data set, Zhukov collected a csv file indicating
whether each district administrative center is presently under the
control of Ukrainian forces, Russian forces, or is being actively
contested between the two. This is on day - place level.

Below is the code book:

### Codebook

  - geonameid: Numeric ID of populated place
  - name: Name of populated place
  - asciiname: Name of populated place, ASCII values
  - alternatenames: Alternative spellings of place name
  - longitude: Longitude coordinate of populated place
  - latitude: Latitude coordinate of populated place  
  - feature\_code: Type of populated place (see [full list
    here](https://www.geonames.org/export/codes.html))
  - ctr\_\[YYYYMMDDHHMMSS\]: Control status, with timestamp
    (UA/RU/CONTESTED)

# Analysis/Graph Outline

# Schedule

## Week 2 (May 9 - 15)

  - write proposal
  - organize data and generate variables

## Week 3 (May 16 - 22)

  - plot maps

## Week 4 (May 23 - 29)

  - make shiny app
  - write-up

## Week 5 (May 30 - )

  - present

# Github Organization

We have three folders: Data, Proposal and Shiny App. You will find our
latest data sets regarding the events and controlled area under Data
folder. You will find our proposal under Proposal folder. You will find
our demonstration under Shiny App folder.

# References

Zhukov, Yuri (2022). “VIINA: Violent Incident Information from News
Articles on the 2022 Russian Invasion of Ukraine.” Ann Arbor: University
of Michigan, Center for Political Studies.
(<https://github.com/zhukovyuri/VIINA>, accessed 05/11/2022).
