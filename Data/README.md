Data Readme
================
Group Name:other-carp

This is a readme file that contains information on raw data set we will be using. We plan to update the raw data set every day from this repository:
https://github.com/zhukovyuri/VIINA/tree/master/Data
There are two data sets, including events and territorial control data - 

# Events:

## Codebook
- event_id: Unique event ID
- report_id: Unique ID for report that contains the event
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
- GEO_PRECISION: geographic precision of geocoded location
- GEO_API: Geocoding API used to locate event
- t_[event type]: Predicted probability that report describes event of each type (from LSTM model, see above)
- a_[actor]: Predicted probability that report describes event initiated by each actor (from LSTM model, see above)

## Categories
- t_mil: Event is about war/military operations
- t_nmil: Event is not about war/military operations (e.g. human interest story)
- t_loc: Event report includes reference to specific location
- t_san: Event report mentions economic sanctions imposed on Russia
- a_rus: Event initiated by Russian or Russian-aligned armed forces
- a_ukr: Event initiated by Ukrainian or Ukrainian-aligned armed forces
- a_civ: Event initiated by civilians
- a_other: Event initiated by a third party (e.g. U.S., EU, Red Cross)
- t_aad: Anti-air defense, Buk, shoulder-fired missiles (Igla, Strela, Stinger)
- t_airstrike: Air strike, strategic bombing, helicopter strike
- t_armor: Tank battle or assault
- t_arrest: Arrest by security services or detention of prisoners of war
- t_artillery: Shelling by field artillery, howitzer, mortar, or rockets like Grad/BM-21, Uragan/BM-27, other Multiple Launch Rocket System (MRLS)
- t_control: Establishment/claim of territorial control over population center
- t_firefight: Any exchange of gunfire with handguns, semi-automatic rifles, automatic rifles, machine guns, rocket-propelled grenades (RPGs)
- t_ied: Improvised explosive device, roadside bomb, landmine, car bomb, explosion 
- t_raid: Assault/attack by paratroopers or special forces, usually followed by a retreat
- t_occupy: Occupation of territory or building
- t_property: Destruction of property or infrastructure
- t_cyber: Cyber operations, including DDOS attacks, website defacement
- t_hospitals: Attacks on hospitals and humanitarian convoys
- t_milcas: Event report mentions military casualties
- t_civcas: Event report mentions civilian casualties

# Territorial control:

## Codebook

- geonameid: Numeric ID of populated place
- name: Name of populated place
- asciiname: Name of populated place, ASCII values
- alternatenames: Alternative spellings of place name
- longitude: Longitude coordinate of populated place
- latitude: Latitude coordinate of populated place          
- feature_code: Type of populated place (see [full list here](https://www.geonames.org/export/codes.html))
- ctr_[YYYYMMDDHHMMSS]: Control status, with timestamp (UA/RU/CONTESTED)