Final Project Write up
================
The Other Carp team: Bohan Yang, Paweł Rybacki, Zihan Zhu
2022/5/31

# Introduction

In this project, we build a Shiny app with interactive plots to
visualize Russian-Ukraine crisis, which help calling people’s attention,
and recover deep insights to make peace.

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
most violent event happen. Perhaps our insights could be somehow used to
prevent the same attacks from happening again.

We used interactive plots to live demonstrate the process of
Russia-Ukraine war, including the territory movement, military and
non-military events across different timeframes.

Here is the link to our shiny app:
<https://wdxbh1998.shinyapps.io/UkrainWar>

# Data

We used the VIINA (Violent Incident Information from News Articles on
the 2022 Russian Invasion of Ukraine) data set collected by Professor
Yuri Zhukov from the University of Michigan (see [full list
here](https://github.com/zhukovyuri/VIINA)). This is the most
comprehensive data set from the internet, which provides us extensive
information to visualize.

It’s a near-real time multi-source event data system based on news
reports from Ukrainian and Russian media, and Zhukov geocoded and
classified them into standard conflict event categories through machine
learning. The events are GIS-ready, with temporal precision down to the
minute. The final data set was orginized and saved into two csv files,
descriptions of which are in the Appendix.

# Analysis

## 1. Using a map to show events that happened during the war in Ukraine.

### App functionality overview

On our shiny app, we build a map that contains all of the events
happened during the war.

<img src="./Figure/event_1.png" width="100%" /> As you can see from the
picture above, the first map contains 5 selection criteria. The first
selection criteria is the date range. Users can freely choose which time
period they want to inspect and the data will be filtered by date range.
Since the data from VIINA repo is updating, our shiny app will also be
updating.

The rest of 4 selection criteria are based on event types. There are 7
event types will different color schemes. They are Air Strike/Defense,
Arrest by Security Services/Hospital Attack, Destruction of Property or
Explosion, Occupation of Territory or Buildings, Cyber Attack,
Tank/Artillery/Gun Battle, and Ambiguous. Users can choose to see one of
the 7 types of events, all of the events or anything in between. The
initiator selection bar basically filter the data points by whether the
event is initiated by Russia or by Ukraine, or ambiguous. Also, users
can choose to see all of those on their own will. The military selection
bar is designated to filter the data points into two categories, one
indicating the event is done by military, another indicating the event
is done by non-military or third party organizations. The last selection
criteria is the news source. Since all of the data points on the map
come from either Ukrainian or Russian news, we think it is necessary for
the users to freely decide which news they believe and which news they
don’t believe. Therefore, we have in total 14 news sources which users
can select.

<img src="./Figure/event_2.png" width="100%" /> If you click the bubbles
on the map, the map will zoom in and eventually, you will see every
events that are included inside one bubble. Each point on the bubble has
different color, and the color correspond to the event type color. Users
can also click the points for more information. By clicking one of the
points, as shown on the graph above, users can see the Date, Time, Event
Type, Initiator, Military Casualties, Civilian Casualties and Url for
the news. Users can also click the Url if they are interested in the
original news press.

### Some analytical insights

By making a visualization like this, we at least know some summary
statistics of the data. For example, when we look at the number of
events that took place during the whole war, we notice that Donetsk,
Luhansk and Kiev are three cities that suffered the most. It is
reasonable because Donetsk and Luahnsk are close to Russia. And because
they did not have good relationship with Ukraine. Kiev are the capital
of Ukraine, it is reasonable to assume that lots of special force or
cyber attack will happen in this city in order to disable the head
quarter of Ukraine.

Same patterns apply to coastal cities such as Odessa, Mykolaiv, and
Kherson. Usually, coastal cities are important for military operation
because not only country can launch attack from sea, but also country
can get reinforcement from shipment. Therefore, it is very important for
country to conquer the coastal cities.

From the map, we understand which area in Ukraine has the most number of
events happened and it is very useful for our following analysis.

## 2. Using plots to contextualize the events on the map.

The two plots below the map provide more contextual understanding of the
events that show up on the map. They are connected to two of the map’s
inputs: date range and event type.

### App functionality overview

<img src="./Figure/Tab1_1.jpg" width="100%" /> The line plot is designed
to answer the questions of 1) how the number of events changed over
time, 2) how the activity of the two sides of conflict differs, and 3)
how this difference changes over time. Thus, the lines on the plot of
number of events over time are separated for Ukraine and Russia, and
time range selected by the user is indicated with two vertical bars on
the full timeline. Moreover, the user can choose between displaying the
number of events per day and the cumulative sum of events to better
understand the war dynamics.

The bar plot helps answer how the number of war events and the type of
events vary by region.To that end, the chart is displaying horizontal
bars decomposed by event type for each region. In addition, the regions
are ordered by the total number of events in the specified the time
period.

### Some analytical insights

As an example, let’s compare the first month (February 23rd to March
23rd) to the most recent month (April 30th to May 30st) and use data for
all events.

*The plots for all event types and the range between February 23rd to
March 23rd:* <img src="./Figure/Tab1_2.jpg" width="100%" />

*The plots for all event types and the range between April 30th to May
30st:* <img src="./Figure/Tab1_3.jpg" width="100%" />

From the line plot, we can see that Russia has initiated
disproportionately more events than Ukraine in the first month, while
this advantage shrunk over time (except for mid-April) and is not large
in the most recent month. The bar plot seems to indicate that air
strike, air defense, arrest by security services, and hospital attacks
have been the most frequent event types in both periods. However, the
relative importance of explosions and other forms of destruction of
property has decreased, while the occupations of territory and buildings
(especially in Donetsk) have increased between the first and the most
recent month. In both periods, Crimea stands out as an interesting
case–the formerly annexed territory mostly faces cyber attacks, and
other war events are marginal.

Moreover, comparing the two regions with the help of the bar plot tells
us that while the Eastern regions of Donetsk and Kharkiv have been
prominent in the earliest and the latest phases of the war, the center
of gravity shifted away from Kiev and its surrounding region, and toward
Odessa, Dnipropetrovsk, and Luhansk.

## 3. Using a map and a plots to display territorial control changes during the course of the war.

### App functionality overview

We allow readers to choose the start and ending date, and we will
compare the difference between these two days to present the dynamic of
territory control. We need to note that we only compare these two days
but omit what happened between these two days.

<img src="./Figure/Tab2_1.png" width="100%" />

We generate a “control” variable, defined as this:

-   RU: Russia controls one city both on the start day and the end day
-   UA: Ukraine controls one city both on the start day and the end day
-   RU2UA: Russia controls one city on the start day, while Ukraine
    controls it on the end day
-   UA2RU: Ukraine controls one city on the start day, while Russia
    controls it on the end day
-   Contested: one city is being contested at the end day

We chose that color based on the color of the national flags: Russia’s
control is red and pink; Ukraine’s control is golden and yellow.

There is also a bar plot, indicating each country’s territory proportion
of Ukraine territory and adding lines to show the time trend, making it
more apparent to show the increase/decrease of proportion.

Besides, we designed our program robustly, allowing readers only to
choose one day. Then there will not be any “RU2UA” or “UA2RU” variable
on the map, and there will only be one bar in the bar chart.

<img src="./Figure/Tab2_2.png" width="100%" />

### Some analytical insights

From the territory control map and bar plot, the reader will be able to
observe the dynamic of the war. For instance, through the comparison
between 2-27 and 05-30, we can observe many important facts:

1.  Western and middle Ukraine is relatively peaceful, and Russia
    concentrates on northern, southern, and especially eastern Ukraine.
2.  Ukraine has already retaken the northern part.
3.  Russia controls south-eastern Ukraine steadily and has more power in
    eastern Ukraine (might be because this part shares a border with
    Russia and has strong separatist forces prone to Russia).
4.  Russia attacked several new cities, including the north-eastern part
    and the north side of south-eastern Ukraine.
5.  Ukraine controls about 75% of its territory. During the war,
    Russia’s control increased a little, and now the proportion of the
    contested area is small.

# Conclusion

We designed a Shiny App to visualize the Russian-Ukraine crisis to call
people’s attention, provide up-to-date information, and recover deep
insights about it. It includes two parts. The first part analyses events
happening in Ukraine. We plot them on a map to visualize geographical
patterns and contextualize them in a line plot and bar chart. The second
part plots territory control. Readers can explore the dynamic of
territory control from the map, and they can also observe the proportion
of each country’s control.

Admittedly, the app is a little computationally heavy and thus runs
somewhat sluggishly on free hosting services. However, our code
repository is publicly available for anyone interested in running the
app locally. We sincerely hope that the insights our project inspires
and the further studies that our Shiny App facilitates will eventually
contribute to a more peaceful world!

# Appendix

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

### Data processing for Tab 2

The control dataset from Zhukov is on the geographical location level,
indicating which country is controlling the geographical point at a
specific time (year-month-day-hour). Firstly, we organized the data to
the day-level by calculating each point’s mode of the controlling
country on each day. For instance, if there are six observations (1 am,
5 am, 9 am, etc.) for one point in one day, and in five obs, it belongs
to Russia, we will conclude that it belongs to Russia on the day.

Secondly, we conduct a spatial-join on each point to cities and define
one city’s controlling country as the mode of points. For instance, on
May 1, if Ukraine controls 60 points of Kyiv, while Russia controls
eight points, we will conclude that Ukraine controls Kyiv. Besides,
since the control data was collected based on news, for some days there
is no news regarding one city, then we will assume that city belongs to
Ukraine - if Russia controls it, there should be news reporting.

### Data processing for plots in Tab 1

The first step of data preparation was a spatial join with a Ukraine map
shapefile to assign the observations from the original dataset into the
highest administrative units (regions) of Ukraine.

The line plot takes dates as an input. It also takes the selected event
types as an input and recodes them in order to pass them as
variable/column names. The data is narrowed down to the time range and
only the selected categories, and only the events for which initiation
is clear between the two sides. Finally, the plot code includes a
reactive function indicating the sum or the cumulative sum as the
dependent variable.

The bar plot also take dates an an input and takes the selected event
types as an input and recodes them in order to pass them as
variable/column names. The data is narrowed down to the time range and
only the selected categories.

It was key that then a function loops over regions and the selected
event types to calculate the sums of events for each region/type
combination. The sums for each region and each event type are saved in a
new data frame used by the plot.
