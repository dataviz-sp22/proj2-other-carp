# Load library
library(tidyverse)
library(lubridate)
library(leaflet)
library(shiny)
library(htmltools)
library(leaflet.extras)
library(shinyWidgets)
library(sf)
<<<<<<< HEAD
library(ggalluvial)
library(here)
library(units)
ggplot2::theme_set(ggplot2::theme_minimal(base_size = 12))
=======
>>>>>>> b0f98526fe6d0fdef1bc5f98885bff8a0babacfd
#library(colorblindr)

#open data to get factor levels for UI
control_latest <- read_csv("https://raw.githubusercontent.com/zhukovyuri/VIINA/master/Data/control_latest.csv")
events_latest <- read_csv("https://raw.githubusercontent.com/zhukovyuri/VIINA/master/Data/events_latest.csv")
shp <- st_read("shp_city/pp624tm0074.shp")

#function
mode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

#Data Wrangling
## Column plot data prep
### Assign events to specific regions with the help of spatial joint and a shapefile of Ukraine divided into regions.
col_plot_data_1 <- events_latest %>%
  st_as_sf(coords = c("longitude", "latitude"),
           crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") %>% 
  st_join(shp, left = FALSE) %>%
  st_drop_geometry() %>%
  mutate(evt_type = as.factor(case_when(t_aad_b == 1 ~ "t_airstrike_b",
                                t_airstrike_b == 1 ~ "t_airstrike_b",
                                t_armor_b == 1 ~ "Tank/Artillery/Bomb/Gun Battle",
                                t_arrest_b == 1 ~ "Arrest by Security Services/Hospital Attack",
                                t_artillery_b == 1 ~ "Tank/Artillery/Bomb/Gun Battle",
                                t_firefight_b == 1 ~ "Tank/Artillery/Bomb/Gun Battle",
                                t_ied_b == 1 ~ "Tank/Artillery/Bomb/Gun Battle",
                                t_raid_b == 1 ~ "Cyber Attack/Paratroopers",
                                t_cyber_b == 1 ~ "Cyber Attack/Paratroopers",
                                t_hospital_b == 1 ~ "Arrest by Security Services/Hospital Attack",
                                t_occupy_b == 1 ~ "Control/Destroy of Territory",
                                t_control_b == 1 ~ "Control/Destroy of Territory",
                                t_property_b == 1 ~ "Control/Destroy of Territory",
                                TRUE ~ "Ambiguous"))) %>%
  rename(region = name_1)

regions_list <- unique(col_plot_data_1$region)


events_map <- events_latest%>%
  mutate(mil_type = case_when(t_mil_b == 1 ~ "Military",
                              t_nmil_b == 1 ~ "Non Military"),
         initiator = case_when(a_rus_b == 1 ~ "Russia",
                               a_ukr_b == 1 ~ "Ukraine",
                               a_civ_b == 1 ~ "Ambiguous",
                               a_other_b == 1 ~ "Ambiguous",
                               TRUE ~ "Ambiguous"),
         # The category criteria are based on my own scale. You are welcome to modify it
         # if you have reasonable suggestions
         evt_type = case_when(t_aad_b == 1 ~ "t_airstrike_b",
                              t_airstrike_b == 1 ~ "t_airstrike_b",
                              t_armor_b == 1 ~ "Tank/Artillery/Bomb/Gun Battle",
                              t_arrest_b == 1 ~ "Arrest by Security Services/Hospital Attack",
                              t_artillery_b == 1 ~ "Tank/Artillery/Bomb/Gun Battle",
                              t_firefight_b == 1 ~ "Tank/Artillery/Bomb/Gun Battle",
                              t_ied_b == 1 ~ "Tank/Artillery/Bomb/Gun Battle",
                              t_raid_b == 1 ~ "Cyber Attack/Paratroopers",
                              t_cyber_b == 1 ~ "Cyber Attack/Paratroopers",
                              t_hospital_b == 1 ~ "Arrest by Security Services/Hospital Attack",
                              t_occupy_b == 1 ~ "Control/Destroy of Territory",
                              t_control_b == 1 ~ "Control/Destroy of Territory",
                              t_property_b == 1 ~ "Control/Destroy of Territory",
                              TRUE ~ "Ambiguous"),
         mil_cas = ifelse(t_milcas_b == 1, "Yes", "No"),
         civ_cas = ifelse(t_civcas_b == 1, "Yes", "No"))

events_map$source <- as.factor(events_map$source)
#dates
class(events_map$date)
events_map$date <- ymd(events_map$date)

#clickable urls
events_map$url <- paste0("<a href='",events_map$url,"'>",events_map$url,"</a>")

# Color scale for mil_type
#events_map$mil_type <- as.factor(events_map$mil_type)
#pal <- colorFactor(palette=c("#DA291C","#414141"), domain=events_map$mil_type)

# Color scale for evt_type
events_map$evt_type <- as.factor(events_map$evt_type)
pal <- colorFactor(palette="viridis", domain=events_map$evt_type)

# Color scale for initiator
#events_map$initiator <- as.factor(events_map$initiator)
#pal <- colorFactor(palette=c("Gray","Red","Blue"), domain=events_map$initiator)


## Control part
shp <- st_read("Data/shp_city/pp624tm0074.shp") %>%
  dplyr::select(name_1, name_2)


control_date_max <- names(control_latest) %>%
  grep("ctr_", ., value = TRUE) %>%
  max(.) %>%
  substr(., 5, 12)

control_date_max <- paste0(substr(control_date_max, 1, 4),'-',
                           substr(control_date_max, 5, 6),'-',
                           substr(control_date_max, 7, 8))


############################## UI #################################
############################## ????????????? #################################


# I create more than 3 selection bars, but only 3 are shown. 
ui <- fluidPage(
  titlePanel(title = "Russia-Ukraine Crises"),
  tabsetPanel(
    # Tabset 1 for maps
    tabPanel(title = "Events Mapping",
            sidebarLayout(sidebarPanel(dateRangeInput(inputId = "dateRange", 
                            label = "Date range:",
                            start = "2022-02-23",
                            end = control_date_max,
                            min = "2022-02-23",
                            max = control_date_max),
             #selectInput(inputId = "initiator", 
                         #label = "Initiator:",
                         #choices = c("Russia" = "Russia",
                           #"Ukraine" = "Ukraine",
                           #"Ambiguous" = "Ambiguous"),
                         #selected = "Russia",
                         #multiple = TRUE),
             #selectInput(inputId = "mil_type", 
                         #label = "Military Type:",
                         #choices = c("Military" = "Military",
                           #"Non-military" = "Not Military")),
             pickerInput(
               inputId = "event_type",
               label = "Event Type",
               choices = levels(events_map$evt_type),
               multiple = TRUE,
               options = list(
                 `actions-box` = TRUE,
                 size = 10,
                 `selected-text-format` = "count > 3"
               ),
               selected = "t_airstrike_b"
             ),
             pickerInput(
               inputId = "sources",
               label = "Select News Source:",
               choices = levels(events_map$source),
               options = list(
                 `actions-box` = TRUE,
                 size = 10,
                 `selected-text-format` = "count > 3"
               ),
               multiple = TRUE,
               selected = levels(events_map$source),
             )),
             mainPanel(
               leafletOutput(outputId = "map"),
               plotOutput(outputId = "bar_plot"),
               )
             )
            # place line plots and bar plots here
             ),
    # Tabset 2 for control maps
    tabPanel(title = "Control Mapping",
             sidebarLayout(sidebarPanel(dateRangeInput(inputId = "datecontrol", 
                                                       label = "Date range:",
                                                       start = "2022-02-27",
                                                       end = control_date_max,
                                                       min = "2022-02-27",
                                                       max = control_date_max)),
             mainPanel(
               plotOutput(outputId = "control_map"),
               plotOutput(outputId = "control_bar")
               ),
             )
)))




###################################################################
server <- function(input, output) {
  
  #---------------------First Tab---------------------------------------------
  # Create reactive data
  events_map_fil <- reactive({
    req(input$dateRange)
    events_map %>%
      filter(between(date, input$dateRange[1], input$dateRange[2]))%>%
      #filter(mil_type == input$mil_type) %>%
      #filter(initiator %in% input$initiator) %>%
      filter(evt_type %in% input$event_type) %>%
      filter(source %in% input$sources)
  })
  
  col_plot_data_2 <- reactive({
    req(input$dateRange)
    col_plot_data_1 %>%
      filter(between(date, input$dateRange[1], input$dateRange[2]))%>%
      filter(evt_type %in% input$event_type) %>%
      filter(source %in% input$sources)
  })
  
  ### Bar plot code
  output$bar_plot <- renderPlot({
    ### Count the number of events by event type and region. The following loops over all event types selected by the user to calculate the sum of the events of each type in the filtered data frame.
    event_selected <- reactive({input$event_type})
    sums_all_events <- tibble()
    for (i in 1:length(regions_list)) {
      temp <- tibble(.rows = 1)
      temp$event_region <- ""
      temp$event_type <- ""
      temp$event_sum <- NA
      for (j in 1:length(event_selected())) {
        temp$event_region <- regions_list[i]
        temp$event_type <- event_selected()[j]
        temp$event_sum <- col_plot_data_2() %>% 
          filter(region == regions_list[i]) %>%
          select(contains(event_selected()[j])) %>% 
          sum()
        sums_all_events <- bind_rows(sums_all_events, temp)
      }
    }
    
    # generate the bar chart (column plot) with horizontal bars
    ggplot(data = sums_all_events, aes(x = event_sum, y = event_region, fill = event_type)) +
      geom_col() +
      labs(y = "Region", x = "Event Type") +
      theme(
        legend.position = "bottom",
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank()
      )
    
  }, res = 96)


  # Draw the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Esri") %>%
      setView(lng =32.1656, lat = 47.5794, zoom = 6) %>%
      leaflet.extras::addResetMapButton()
  })
  
  # Observer used for redrawing the map when user change any input
  observe({
    leafletProxy("map", data = events_map_fil()) %>%
      clearMarkers() %>%
      clearControls()%>%
      clearMarkerClusters()%>%
      addCircleMarkers(~longitude, ~latitude,
                       color = ~pal(events_map_fil()$evt_type),
                       radius = 4,
                       #fillOpacity = .7,
                       stroke = FALSE,
                       popup  = paste("Date", events_map_fil()$date, "<br>",
                                      "Time", events_map_fil()$time, "<br>",
                                      "Event Type:", events_map_fil()$evt_type, "<br>",
                                      "Initiator:", events_map_fil()$initiator, "<br>",
                                      "Military Casualities Reported:", events_map_fil()$mil_cas, "<br>",
                                      "Civilian Casualities Reported:", events_map_fil()$civ_cas, "<br>",
                                      "Url:", events_map_fil()$url),
                       clusterOptions = markerClusterOptions())%>%
      addLegend(title = "Event Type",
        pal = pal,
        values = ~evt_type
      )
  })
  #---------------------Second Tab---------------------------------------------
  # Create reactive data

  
  control <- reactive({
    req(input$datecontrol)
    start <- input$datecontrol[1] %>%
      str_replace_all(., "-", "")
    end <- input$datecontrol[2] %>%
      str_replace_all(., "-", "")
    
    
    control <- control_latest %>%
      dplyr::select(geonameid, longitude, latitude, 
                    contains(start), contains(end)) %>%
      reshape2::melt(id.vars = c("longitude", "latitude", "geonameid"),
                     value.name = "control") %>%
      mutate(date = substr(variable, 5, 12),
             control = ifelse(control == "UA",1,
                              ifelse(control == "RU", 2, 3)))  %>%
      group_by(geonameid, longitude, latitude, date) %>%
      summarise(control = mode(control)) %>%
      st_as_sf(coords = c("longitude", "latitude"),
               crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") %>% 
      st_join(shp, left = FALSE) %>%
      st_drop_geometry() %>%
      group_by(name_1, name_2, date) %>%
      summarise(control = mode(control)) %>%
      mutate(control = ifelse(control == "1","UA",
                              ifelse(control == "2", "RU", "Contested"))) %>%
      spread(key = date, value = control) 
    
    control$Country <- ifelse(get(start, control) == "UA" 
                              & get(end, control) == "RU", 
                              "UA2RU", "")
    control$Country <- ifelse(get(start, control) == "RU" 
                              & get(end, control) == "UA", 
                              "RU2UA", control$Country)
    control$Country <- ifelse(get(start, control) == get(end, control), 
                              get(start, control), control$Country)
    control$Country <- ifelse(control$Country == "",
                              get(end, control), control$Country)
    control$Country <- ifelse(is.na(control$Country), "UA", control$Country)
    
    control <-  sp::merge(shp, control,
                          by = c("name_1", "name_2"), all=F)
    
    control
  })
  
  output$control_map <- renderPlot({
    ggplot(data = control()) +
      geom_sf(aes(fill=Country)) +
      scale_fill_manual(values = c("RU" = "firebrick1",
                                   "UA2RU" = "hotpink",
                                   "UA" = "goldenrod1",
                                   "RU2UA" = "yellow2",
                                   "Contested"="blue"))
  })
  
  
  df_area <- reactive({
    control() %>%
      mutate(area = st_area(.)) %>%
      st_drop_geometry() %>%
      dplyr::select(-Country) %>%
      reshape2::melt(id.vars = c("name_1", "name_2", "area"),
                     value.name = "control") %>%
      dplyr::rename(date = variable) %>%
      mutate(control = ifelse(is.na(control), "UA", control),
             area = drop_units(area)) %>%
      mutate(control = factor(control, levels= rev(c("UA", "RU", "Contested"))),
             date = factor(date)) %>%
      group_by(date, control) %>%
      dplyr::summarise(area = sum(area)) %>%
      group_by(date) %>%
      mutate(total_area = sum(area),
             prop = round(area/total_area,3)*100) %>%
      rename(Country = control)
  })
  
  
  output$control_bar <- renderPlot({
    ggplot(df_area(),
           aes(y = prop, x = date)) +
      geom_flow(aes(alluvium = Country), alpha= .9, 
                lty = 2, fill = "white", color = "black",
                curve_type = "linear", 
                width = .5) +
      geom_col(aes(fill = Country), width = .5, color = "black") +
      scale_fill_manual(values = c("RU" = "firebrick1",
                                   "UA" = "goldenrod1",
                                   "Contested" = "blue")) +
      scale_y_continuous(labels = scales::percent_format(scale = 1)) +
      labs(title = "Percentage of area controled by each country",
           x = "Date",
           y = "Percentage")
  })
  
}
############################## COMPILE #################################
############################## ???????????????????????????????????????? #################################
shinyApp(ui, server)