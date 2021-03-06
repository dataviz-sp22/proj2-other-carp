Project 2 Proposal
================
Group Name: other-carp

# Introduction

In this project, we plan to build a Shiny app with interactive plots to
visualize Russian-Ukraine crisis, which will help calling people’s
attention, and recover deep insights to make peace.

Russian-Ukraine crisis is a long lasting problem and it caused countless
casualties nearly everyday. The earliest big confrontation can be dated
back to 2014, when pro-Russian separatists in two cities in Ukraine,
Donetsk and Luhansk, started revolts. From 2014 to 2022, there were
several small military events and non-military but violent events
happened in Ukraine in the area close to the Russian-Ukrainian border.
In 2022, allegedly concerned with the potential Eastward expansion of
NATO, Russia started a war against Ukraine by attacking targets in the
whole country using air weapons and by invading its land territory from
multiple sides at the same time. Millions of refugees fled the country,
dozens of thousands of people including civilians have been killed in
targeted and untargeted attacks, many people have been tortured and
robbed of their life assets, and many cities have been destroyed within
several weeks. In this project, we want to build a shiny app to
illustrate the military events happened during the recent 2022
Russia-Ukraine war and keep track of the territory boundary or military
marching of soldiers from two sides.

We have chosen this topic, because all of us are concerned about
international confrontations. We wish the world were peaceful and there
were no wars or violent events anymore.

We are also motivated by the opportunity of enhancing the study of the
war in its specific aspects, such as place has the most attackers or
military actions, and which side has the relative advantages as the
battles continue. If we can plot every single events on a map, we will
be able to discover some patterns such as which area or city has the
most violent event happen. Perhaps insights with tools such as ours
could be somehow used prevent the same attacks from happening again.

We want to use shiny app and interactive plots to live demonstrate the
process of Russia-Ukraine war, including the territory movement,
military and non-military events across different timeframes.

You can find more details on data frame below and all the codes are
included on “app.R” file in Shiny App folder.

# Data

We will use the VIINA (Violent Incident Information from News Articles
on the 2022 Russian Invasion of Ukraine) data set collected by Professor
Yuri Zhukov from the University of Michigan (see [full list
here](https://github.com/zhukovyuri/VIINA)). This is the most
comprehensive data set from the internet, which provides us extensive
information to visualize.

It’s a near-real time multi-source event data system based on news
reports from Ukrainian and Russian media, and Zhukov geocoded and
classified them into standard conflict event categories through machine
learning. The events are GIS-ready, with temporal precision down to the
minute. The final data set was orginized and saved into two csv files.

## Event data

``` r
event <- read.csv(here("Data", "events_latest.csv")) %>%
  select(6:18) %>%
  select(!address)
head(event)
```

    ##       date                                                url  time
    ## 1 20220224   https://ria.ru/20220224/gorlovka-1774602728.html 00:10
    ## 2 20220224   https://ria.ru/20220224/gorlovka-1774602728.html 00:10
    ## 3 20220224 https://www.liga.net/archive/2022-02-24/all/page/4 00:23
    ## 4 20220224         https://www.unian.ua/news/archive/20220224 00:35
    ## 5 20220224         https://www.unian.ua/news/archive/20220224 00:35
    ## 6 20220224         https://www.unian.ua/news/archive/20220224 00:35
    ##                                                                  text lang
    ## 1           Украинские военные обстреляли Горловку, заявили в Донецке   ru
    ## 2           Украинские военные обстреляли Горловку, заявили в Донецке   ru
    ## 3 Оккупанты перестали пропускать в Крым украинских граждан – Денисова   ru
    ## 4               На ніч закрили аеропорти Харкова, Дніпра та Запоріжжя   ua
    ## 5               На ніч закрили аеропорти Харкова, Дніпра та Запоріжжя   ua
    ## 6               На ніч закрили аеропорти Харкова, Дніпра та Запоріжжя   ua
    ##   longitude latitude GEO_PRECISION GEO_API t_mil_pred t_loc_pred  t_san_pred
    ## 1  38.00254 48.30608          ADM3  Yandex 0.99999570  0.9999988 0.002627403
    ## 2  37.80285 48.01588          ADM3  Yandex 0.99999570  0.9999988 0.002627403
    ## 3  34.09941 44.95363          ADM3  Yandex 0.07369903  0.9999984 0.002627403
    ## 4  36.23120 49.99217          ADM3  Yandex 0.99999450  0.9999949 0.002627403
    ## 5  35.04618 48.46472          ADM3  Yandex 0.99999450  0.9999949 0.002627403
    ## 6  35.13885 47.83831          ADM3  Yandex 0.99999450  0.9999949 0.002627403

The first csv file includes raw events, and below is the codebook:

### Codebook

-   event_id: Unique event ID
-   report_id: Unique ID for report that contains the event
-   location: Index of unique locations mentioned in each event
-   tempid: Temporary numeric ID
-   source: Data source short name
-   date: Date of event report (YYYYMMDD)
-   time: Time of event report (HH:MM)
-   url: URL web address of event report
-   text: Text of event report headline/description
-   lang: Language of report (ua is Ukrainian, ru is Russian)
-   address: Address of geocoded location
-   longitude: Longitude coordinate of event location
-   latitude: Latitude coordinate of event location
-   GEO_PRECISION: geographic precision of geocoded location
-   GEO_API: Geocoding API used to locate event
-   t\_\[event type\]: Predicted probability that report describes event
    of each type (from LSTM model, see above)
-   a\_\[actor\]: Predicted probability that report describes event
    initiated by each actor (from LSTM model, see above)

The data includes following event categories:

### Categories

-   t_mil: Event is about war/military operations
-   t_nmil: Event is not about war/military operations (e.g. human
    interest story)
-   t_loc: Event report includes reference to specific location
-   t_san: Event report mentions economic sanctions imposed on Russia
-   a_rus: Event initiated by Russian or Russian-aligned armed forces
-   a_ukr: Event initiated by Ukrainian or Ukrainian-aligned armed
    forces
-   a_civ: Event initiated by civilians
-   a_other: Event initiated by a third party (e.g. U.S., EU, Red Cross)
-   t_aad: Anti-air defense, Buk, shoulder-fired missiles (Igla, Strela,
    Stinger)
-   t_airstrike: Air strike, strategic bombing, helicopter strike
-   t_armor: Tank battle or assault
-   t_arrest: Arrest by security services or detention of prisoners of
    war
-   t_artillery: Shelling by field artillery, howitzer, mortar, or
    rockets like Grad/BM-21, Uragan/BM-27, other Multiple Launch Rocket
    System (MRLS)
-   t_control: Establishment/claim of territorial control over
    population center
-   t_firefight: Any exchange of gunfire with handguns, semi-automatic
    rifles, automatic rifles, machine guns, rocket-propelled grenades
    (RPGs)
-   t_ied: Improvised explosive device, roadside bomb, landmine, car
    bomb, explosion
-   t_raid: Assault/attack by paratroopers or special forces, usually
    followed by a retreat
-   t_occupy: Occupation of territory or building
-   t_property: Destruction of property or infrastructure
-   t_cyber: Cyber operations, including DDOS attacks, website
    defacement
-   t_hospitals: Attacks on hospitals and humanitarian convoys
-   t_milcas: Event report mentions military casualties
-   t_civcas: Event report mentions civilian casualties

## Territorial control

``` r
control <- read.csv(here("Data", "control_latest.csv")) %>%
  select(1:8)
head(control)
```

    ##   geonameid             name        asciiname
    ## 1    461727         Olenevka         Olenevka
    ## 2    467852 Yelyzavetyns'kyy Yelyzavetyns'kyy
    ## 3    468196      Katerynivka      Katerynivka
    ## 4    477085      Vaniushkyne      Vaniushkyne
    ## 5    485524         Svistuny         Svistuny
    ## 6    490588           Sopych           Sopych
    ##                                                                                           alternatenames
    ## 1                                                       Karadzhi,Olenevka,Qaragy,Qarağy,Караджи́,Оленевка
    ## 2         Elizavetins'kij,Elizavetinskij,Yelizavetinskiy,Yelyzavetyns'kyy,Єлизаветинський,Елизаветинский
    ## 3 Katerinivka,Katerinovka,Katerynivka,Kateryniwka,Yekaterinoslavskiy,Катериновка,Катеринівка,Կատերինովկա
    ## 4                                               Vaniushkyne,Vanjushkine,Vanyushkin,Vanyushkyne,Ванюшкине
    ## 5                                                                                                       
    ## 6   Sapych,Sopich,Sopici,Sopicʻ,Sopych,Sopych',Sopytsch,Sopîci,suo pi qi,Сапыч,Сопич,Сопычь,Սոպիչ,索皮奇
    ##   longitude latitude feature_code ctr_20220227214017
    ## 1  32.53333 45.38333        PPLA3                 RU
    ## 2  38.82056 47.84083         PPLX                 RU
    ## 3  38.75174 47.69011          PPL                 RU
    ## 4  38.27055 47.25507          PPL                 RU
    ## 5  38.40694 47.72639          PPL                 RU
    ## 6  34.36082 51.85030          PPL                 UA

Based on the event data set, Zhukov collected a csv file indicating
whether each district administrative center is presently under the
control of Ukrainian forces, Russian forces, or is being actively
contested between the two. This is on day - place level.

Below is the code book:

### Codebook

-   geonameid: Numeric ID of populated place
-   name: Name of populated place
-   asciiname: Name of populated place, ASCII values
-   alternatenames: Alternative spellings of place name
-   longitude: Longitude coordinate of populated place
-   latitude: Latitude coordinate of populated place  
-   feature_code: Type of populated place (see [full list
    here](https://www.geonames.org/export/codes.html))
-   ctr\_\[YYYYMMDDHHMMSS\]: Control status, with timestamp
    (UA/RU/CONTESTED)

# Analysis Outline

## The goals of our analysis

In our analysis, we are especially interested in two broad questions:

1.  How do the sides of the conflict compare? In particular, how they
    have been affected relatively to each other in terms of the type and
    the number of events; how does their activity differ, especially in
    the case of events that do not depend on being the invader vs. the
    the defender(what we mean here is that along with the war, not only
    Russian-Ukraine troops harm civilians, but other non-military events
    such as robbery); how does the control by a given side impact the
    event type occurrence?

2.  How can the events improve our spatial understanding of the war?
    More specifically, how do areas of Ukraine differ in terms of event
    type, count, and density? Which regions were most affected? How have
    the centers of gravity of the war events (broadly or narrowly
    defined) shifted and changed their importance over time?

## Minor Remarks Regarding the Tools of Analysis

For the first question, it will be useful to determine the impact each
side of the conflict had on a given territory with relation to the
events there. This can be achieved by counting the time a region is
controlled by each side. Then, on the map, this could be represented by
an alpha value or a scale that goes from one color to the next.

For the second question, a network analysis can be useful: If the events
are nodes and the temporal or spatial distances between them are ties
(with strenghts proportional to the distances), then we can obtain the
centrality and connectedness of various locations in Ukraine as measures
of their importance in the war. These two values, in turn, can be
represented on the map as the sizes of the nodes.

# Visualization Outline

## Map

In our visualization, we would like to combine the information from both
datasets to create one map with switchable layers. As a result, the user
will be able to see both the events and the territorial division at a
given point in time (rather than separately like in the dataset author’s
own visualizations <https://github.com/zhukovyuri/VIINA>). Moreover, our
goal is to vastly improve the number and quality of features as well as
aesthetics as compared to the existing Shiny App based on the VIINA
project: <https://schardata.shinyapps.io/viina/>. We hope that the end
result of our project will be attractive to the author of the dataset,
his original audience, and broader groups of people interested in the
past and current states of the ongoing war.

Graphs will (hopefully) be able to be generated as shots of what the
interactive visualization is showing with the specified parameters.

The graph will show the map of Ukraine as a part of a larger world atlas
(like OpenStreetMap).

### Map details

In terms of geoms, the map will containt `geom_point()` and
`geom_density_2d()` with appropriate modifications. The `geom_label()`
function does not seem too useful, but we will consider adding it.

We would like the app to generate maps with both choropleths and
heatmaps as derivatives (sort of) of maps with points (e.g. a map with
points being a more fundamental version of a density map).

We are considering the following main features of the map generator:

    • Select and shift of the time interval width on a timeline. On the map, there will be a timeline axis with a scalable and shiftable interval. The endpoints of the interval will be able to be determined numerically as well.

    • Indicate and/or filter source origin (at least case by case, like in the original visualization)

    • Show the time when X percent was under the Russian occupation

    • Show the times when region X was under the Russian occupation on the timeline

    • Include an event counter up to a specific date or between dates

    • Show the territorial division (based on the territorial control dataset). Show or highlight only one of the sides of conflict

We are also considering the following additional features:

    • save the map as an image file

    • show event details
        ○ title
        ○ type of event
        ○ text
        ○ time
        ○ address
        ○ lon/lat of event
        ○ url
        
    • show only event reports of types X, Y, Z
        ○ Add a tree: military/non-military selector boxes first and then each of the more specific category selector boxes
        ○ Add also boxes independent of military/non-military classification (e.g. by whom it was initiated)

## Bar charts

Bar charts will be helpful to generate whenever the user is less
interested in the geographic location and more interested in direct or
precise comparisons between spatial units. This seems especially
relevant for question 1, where the location matters less than a the mere
assignment to a particular side of the conflict.

In terms of geoms, we will consider using `geom_bar` and `geom_col()`.
We will allow the user to facet by location with `facet_wrap()` function
and/or the `geofacet` package.

## Line trends

We will allow the user to generate plots of events over time with
`geom_line()` and apply filters to modify narrow the data sample or make
cross-group comparisons, such as the number of tank battles or assults
by the side controlling the territory in the first month of the
conflict.

# Limitations and Suggestions for Future Research

The location or the affiliation of the news source that reported an
event may be crucial for understanding the results of analysis, as the
freedom of press and the journalistic standards likely vary drastically
between Ukraine and Russia. Thus, future research could add a variable
and a corresponding app feature that enables the distiction between the
Ukrainian and Russian sources. However, enhancing the dataset itself is
beyond the scope of our project.

Future research could also develop and implement in a visualized form
predictions about the spatial developments of the war over time.

# Schedule

## Week 2 (May 9 - 15)

-   write proposal
-   organize data and generate variables

## Week 3 (May 16 - 22)

-   plot maps

## Week 4 (May 23 - 29)

-   make shiny app
-   write-up

## Week 5 (May 30 - )

-   present

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
