# Load library
library(tidyverse)
library(lubridate)
library(leaflet)
library(shiny)
library(htmltools)
library(leaflet.extras)
library(shinyWidgets)
library(sf)
library(ggalluvial)
library(here)
library(units)
library(thematic)
library(shinythemes)

thematic_shiny()
ggplot2::theme_set(ggplot2::theme_minimal(base_size = 12))


#open data to get factor levels for UI
control_latest <- read_csv("https://raw.githubusercontent.com/zhukovyuri/VIINA/master/Data/control_latest.csv")
events_latest <- read_csv("https://raw.githubusercontent.com/zhukovyuri/VIINA/master/Data/events_latest.csv")
#write.csv(control_latest, "Data/control_latest.csv")
#write.csv(events_latest, "Data/events_latest.csv")

# use local copies for a faster loading:
# control_latest <- read_csv("../Data/control_latest.csv")
# events_latest <- read_csv("../Data/events_latest.csv")
shp <- st_read("Data/shp_city/pp624tm0074.shp")

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
  mutate(evt_type = as.factor(case_when(t_aad_b == 1 ~ "Air Strike/Defense",
                                t_airstrike_b == 1 ~ "Air Strike/Defense",
                                t_armor_b == 1 ~ "Tank/Artillery/Gun Battle/Paratroopers Attack",
                                t_arrest_b == 1 ~ "Arrest by Security Services/Hospital Attack",
                                t_artillery_b == 1 ~ "Tank/Artillery/Gun Battle/Paratroopers Attack",
                                t_firefight_b == 1 ~ "Tank/Artillery/Gun Battle/Paratroopers Attack",
                                t_ied_b == 1 ~ "Destruction of Property or Explosion",
                                t_raid_b == 1 ~ "Tank/Artillery/Gun Battle/Paratroopers Attack",
                                t_cyber_b == 1 ~ "Cyber Attack",
                                t_hospital_b == 1 ~ "Arrest by Security Services/Hospital Attack",
                                t_occupy_b == 1 ~ "Occupation of Territory or Buildings",
                                t_control_b == 1 ~ "Occupation of Territory or Buildings",
                                t_property_b == 1 ~ "Destruction of Property or Explosion",
                                TRUE ~ "Ambiguous"))) %>%
  rename(region = name_1)

regions_list <- unique(col_plot_data_1$region)

## Line chart data prep
line_plot_data <- events_latest

### prepare a binary variable indicating which of the two sides initiated the event
line_plot_data$initiated <- case_when(
  line_plot_data$a_rus_b == 1 ~ "Russia-initiated event",
  line_plot_data$a_ukr_b == 1 ~ "Ukraine-initiated event",
)

## Map data prep
events_map <- events_latest %>%
  mutate(mil_type = case_when(t_mil_b == 1 ~ "Military",
                              t_nmil_b == 1 ~ "Non Military"),
         initiator = case_when(a_rus_b == 1 ~ "Russia",
                               a_ukr_b == 1 ~ "Ukraine",
                               a_civ_b == 1 ~ "Ambiguous",
                               a_other_b == 1 ~ "Ambiguous",
                               TRUE ~ "Ambiguous"),
         # The category criteria are based on my own scale. You are welcome to modify it
         # if you have reasonable suggestions
         evt_type = case_when(t_aad_b == 1 ~ "Air Strike/Defense",
                              t_airstrike_b == 1 ~ "Air Strike/Defense",
                              t_armor_b == 1 ~ "Tank/Artillery/Gun Battle",
                              t_arrest_b == 1 ~ "Arrest by Security Services/Hospital Attack",
                              t_artillery_b == 1 ~ "Tank/Artillery/Gun Battle",
                              t_firefight_b == 1 ~ "Tank/Artillery/Gun Battle",
                              t_ied_b == 1 ~ "Destruction of Property or Explosion",
                              t_raid_b == 1 ~ "Paratroopers",
                              t_cyber_b == 1 ~ "Cyber Attack",
                              t_hospital_b == 1 ~ "Arrest by Security Services/Hospital Attack",
                              t_occupy_b == 1 ~ "Occupation of Territory or Buildings",
                              t_control_b == 1 ~ "Occupation of Territory or Buildings",
                              t_property_b == 1 ~ "Destruction of Property or Explosion",
                              TRUE ~ "Ambiguous"),
         mil_cas = ifelse(t_milcas_b == 1, "Yes", "No"),
         civ_cas = ifelse(t_civcas_b == 1, "Yes", "No"))

events_map$source <- as.factor(events_map$source)
#dates
class(events_map$date)
events_map$date <- ymd(events_map$date)
col_plot_data_1$date <- ymd(col_plot_data_1$date)
line_plot_data$date <- ymd(line_plot_data$date)

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


# 3 selection bars
ui <- fluidPage(
  theme = shinytheme("superhero"),
  titlePanel(title = "The Russo-Ukrainian War"),
  tabsetPanel(
    # Tabset 1 for maps
    tabPanel(title = "Events Mapping",
             fluidRow(
               column(4,
                      dateRangeInput(inputId = "dateRange", 
                                     label = "Date range:",
                                     start = "2022-02-23",
                                     end = control_date_max,
                                     min = "2022-02-23",
                                     max = control_date_max),
               ),
               column(4,
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
                        selected = levels(events_map$evt_type)
                      ),
                      pickerInput(inputId = "initiator", 
                                  label = "Initiator:",
                                  choices = c("Russia" = "Russia",
                                              "Ukraine" = "Ukraine",
                                              "Ambiguous" = "Ambiguous"),
                                  selected = "Russia",
                                  options = list(
                                    `actions-box` = TRUE,
                                    size = 10,
                                    `selected-text-format` = "count > 3"
                                  ),
                                  multiple = TRUE),
               ),
               column(4,
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
                      ),
                      pickerInput(
                        inputId = "mil_type", 
                        label = "Military:",
                        choices = c( "Military" = 1,
                                     "Not Military" = 0),
                        selected = c(1, 0),
                        options = list(
                          `actions-box` = TRUE,
                          size = 10,
                          `selected-text-format` = "count > 3"
                        ),
                        multiple = TRUE),
                      ),
             ),
             fluidRow(
               div(leafletOutput(outputId = "map", width = "100%", height = 600)),
             ),
             fluidRow(
               column(4,
                      plotOutput(outputId = "line_plot"),
               ),
               column(8,
                      plotOutput(outputId = "bar_plot"),
               )
             ),
             fluidRow(
               column(4,
                      radioButtons(
                        inputId = "line_plot_choice",
                        label = "Choose plot type",
                        choices = NULL,
                        selected = "n_cum",
                        inline = FALSE,
                        width = NULL,
                        choiceNames = c("Sum", "Cumulative Sum"),
                        choiceValues = c("n", "n_cum")
                      ),
               ),
             ),
             
  ),
  # Tabset 2 for control maps
  tabPanel(title = "Control Mapping",
           fluidRow(
             column(4,
                    dateRangeInput(inputId = "datecontrol", 
                                   label = "Date range:",
                                   start = "2022-02-27",
                                   end = control_date_max,
                                   min = "2022-02-27",
                                   max = control_date_max),
             ),
           ),
           fluidRow(
             column(6,
                    plotOutput(outputId = "control_map"),
             ),
             column(6,
                    plotOutput(outputId = "control_bar"),
             ),
           ),
           br(),
           "Note: In the territory control map,",
           br(),
           "RU indicates that Russia controls one city both on the start day and the end day;", br(),
           "UA indicates that Ukrain controls one city both on the start day and the end day;", br(),
           "RU2UA indicates that Russia controls one city on the start day, while Ukrain controls it on the end day;", br(),
           "UA2RU indicates that Ukrain controls one city on the start day, while Russia controls it on the end day;", br(),
           "Contested indicates that one city is being contested on the end day."
           
           
           
  )))




###################################################################
server <- function(input, output) {
  
  #---------------------First Tab---------------------------------------------
  # Create reactive data
  events_map_fil <- reactive({

    req(input$dateRange, input$initiator, input$event_type, input$sources, input$mil_type)
    events_map %>%
      filter(between(date, input$dateRange[1], input$dateRange[2])) %>%
      #filter(mil_type == input$mil_type) %>%
      filter(initiator %in% input$initiator) %>%
      filter(evt_type %in% input$event_type) %>%
      filter(t_mil_b %in% input$mil_type) %>%
      filter(source %in% input$sources)
  })
  
  col_plot_data_2 <- reactive({
    req(input$dateRange, input$event_type, input$sources, input$mil_type, cancelOutput = TRUE)
    col_plot_data_1 %>%
      filter(between(date, input$dateRange[1], input$dateRange[2])) %>%
      filter(evt_type %in% input$event_type) %>%
      filter(t_mil_b %in% input$mil_type) %>%
      filter(source %in% input$sources)
  })
  
  ### Generate the line chart
  ### In the next version of the app, add an input to switch between n_cum and n.
  output$line_plot <- renderPlot({
    
    start_date <- reactive({input$dateRange[1]})
    end_date <- reactive({input$dateRange[2]})
    
    event_selected <- reactive({
      case_when(input$event_type == "Air Strike/Defense" ~ "t_airstrike_b",
                input$event_type == "Air Strike/Defense" ~ "t_aad_b",
                input$event_type == "Tank/Artillery/Gun Battle" ~ "t_armor_b", 
                input$event_type == "Destruction of Property or Explosion" ~ "t_ied_b", 
                input$event_type == "Tank/Artillery/Gun Battle" ~ "t_artillery_b",
                input$event_type == "Tank/Artillery/Gun Battle" ~  "t_firefight_b",
                input$event_type == "Arrest by Security Services/Hospital Attack" ~ "t_arrest_b",
                input$event_type == "Arrest by Security Services/Hospital Attack" ~ "t_hospital_b",
                input$event_type == "Paratroopers" ~ "t_raid_b",
                input$event_type == "Cyber Attack" ~ "t_cyber_b",
                input$event_type == "Occupation of Territory or Buildings" ~ "t_occupy_b",
                input$event_type == "Occupation of Territory or Buildings" ~ "t_control_b",
                input$event_type == "Destruction of Property or Explosion" ~ "t_property_b",
                input$event_type == "Ambiguous" ~ "ambiguous",
      )
    })
    
    ### filter out (remove) events initiated by neither party
    line_plot_data <- line_plot_data %>%
      filter(is.na(line_plot_data$initiated) == FALSE) %>%
      filter(if_any(any_of(event_selected())) == 1) %>% # count the number of event types selected
      count(date, initiated, sort = TRUE) %>% # calculate the cumulative sum over time, grouped by the country that initiated the event
      # https://datacornering.com/cumulative-sum-or-count-in-r/
      group_by(initiated) %>%
      arrange(date, decreasing = FALSE) %>%
      mutate("n_cum" = cumsum(n))
    
    # line plot choice (sum or cummulative sum)
    line_plot_selected <- reactive({input$line_plot_choice})
    
    # generate the bar chart (column plot) with horizontal bars
    ggplot(line_plot_data, aes(x = date, y = get(line_plot_selected()), color = initiated, linetype = initiated)) +
      geom_line() +
      # add the lines indicating the selected time range
      geom_vline(xintercept = start_date(), color = "grey50") +
      geom_vline(xintercept = end_date(), color = "grey50") +
      labs(
        x = "Date",
        y = NULL,
        title = "Number of events, by initiator",
        color = NULL,
        linetype = NULL,
      ) +
    theme(
      legend.position = "bottom",
      # adjust the spacing between plots
      legend.margin = margin(1, 1, 1, 1),
      plot.margin = unit(c(1, 0, 1, 0), "cm"),
    ) +
    guides(color = guide_legend(nrow = 2, byrow=TRUE))
  }, height = 400, res = 96)
  
  
  ### Generate the bar plot
  output$bar_plot <- renderPlot({
    event_selected <- reactive({ # translate the human-readable input into the language of variables
      case_when(input$event_type == "Air Strike/Defense" ~ "t_airstrike_b",
                input$event_type == "Air Strike/Defense" ~ "t_aad_b",
                input$event_type == "Tank/Artillery/Gun Battle" ~ "t_armor_b", 
                input$event_type == "Destruction of Property or Explosion" ~ "t_ied_b", 
                input$event_type == "Tank/Artillery/Gun Battle" ~ "t_artillery_b",
                input$event_type == "Tank/Artillery/Gun Battle" ~  "t_firefight_b",
                input$event_type == "Arrest by Security Services/Hospital Attack" ~ "t_arrest_b",
                input$event_type == "Arrest by Security Services/Hospital Attack" ~ "t_hospital_b",
                input$event_type == "Paratroopers" ~ "t_raid_b",
                input$event_type == "Cyber Attack" ~ "t_cyber_b",
                input$event_type == "Occupation of Territory or Buildings" ~ "t_occupy_b",
                input$event_type == "Occupation of Territory or Buildings" ~ "t_control_b",
                input$event_type == "Destruction of Property or Explosion" ~ "t_property_b",
                input$event_type == "Ambiguous" ~ "ambiguous",
                )
      })
    ### Count the number of events by event type and region. 
    ### The following piece of script loops over all event types selected by the user to calculate the sum of the events of each type in the passed filtered data frame.
    sums_all_events <- tibble()
    for (i in 1:length(regions_list)) { # loop over all regions
      temp <- tibble(.rows = 1) # prepare the data frame with its variables
      temp$event_region <- ""
      temp$event_type <- ""
      temp$event_sum <- NA
      for (j in 1:length(event_selected())) { # loop over each event selected
        temp$event_region <- regions_list[i] # fill the name of the current (i'th) region in the row
        temp$event_type <- event_selected()[j] # fill the current event type (j'th)
        temp$event_sum <- col_plot_data_2() %>% # pass the pre-filtered data
          filter(region == regions_list[i]) %>% # keep only the current (i'th) event
          select(contains(event_selected()[j])) %>% # pass the current event type (j'th) as a column name 
          sum() # calculate the number of rows, which tells you the number of events of the current type
        sums_all_events <- bind_rows(sums_all_events, temp)
      }
    }
    
    sums_all_events <- sums_all_events %>% mutate(event_type = case_when(
      event_type == "ambiguous" ~ "Ambiguous",
      event_type == "t_aad_b" ~ "Air Strike/Defense",
      event_type ==  "t_airstrike_b" ~ "Air Strike/Defense",
      event_type == "t_armor_b"  ~ "Tank/Artillery/Gun Battle",
      event_type == "t_arrest_b"  ~ "Arrest by Security Services/Hospital Attack",
      event_type == "t_artillery_b"  ~ "Tank/Artillery/Gun Battle",
      event_type == "t_firefight_b"  ~ "Tank/Artillery/Gun Battle",
      event_type == "t_ied_b"  ~ "Destruction of Property or Explosion",
      event_type == "t_raid_b"  ~ "Paratroopers",
      event_type == "t_cyber_b"  ~ "Cyber Attack",
      event_type == "t_hospital_b"  ~ "Arrest by Security Services/Hospital Attack",
      event_type == "t_occupy_b"  ~ "Occupation of Territory or Buildings",
      event_type == "t_control_b"  ~ "Occupation of Territory or Buildings",
      event_type == "t_property_b"  ~ "Destruction of Property or Explosion"))
    
    # order by number

    # generate the bar chart (column plot) with horizontal bars
    ggplot(data = sums_all_events, 
           aes(x = event_sum, y = reorder(event_region, event_sum), fill = event_type)) +
      geom_col() +
      labs(
        y = "Region", 
        x = NULL,
        title = "Number of events within the specified time range", 
        fill = NULL
         ) +
      theme(
        legend.position = "bottom",
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.margin = margin(1, 2.5, 1, 1, unit = "cm"),
        plot.margin = unit(c(1, 1, 1, 0), "cm"),
        axis.title.y = element_text(hjust = 1, vjust = 1.05, angle = 0, margin = margin(r = -2.5, l = 2.5, unit = "cm"))
      ) +
      guides(fill = guide_legend(nrow = 4, byrow=TRUE))
  }, height = 600, res = 96)


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
                       opacity = 2,
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
                                   "Contested"="grey50")) +
      labs(title = "Territory control map, by country") +
       theme(text = element_text(size = 15)) +    
      guides(fill = guide_legend(nrow=3, byrow=TRUE))
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
                lty = 2, fill = "transparent", color = "black",
                curve_type = "linear", 
                width = .5) +
      geom_col(aes(fill = Country), width = .5, color = "black") +
      scale_fill_manual(values = c("RU" = "firebrick1",
                                   "UA" = "goldenrod1",
                                   "Contested" = "grey50")) +
      scale_y_continuous(labels = scales::percent_format(scale = 1)) +
      labs(title = "Percentage of area, by country",
           x = "Date",
           y = "Percentage") +
      theme(text = element_text(size = 15)) +    
      guides(fill = guide_legend(nrow=5, byrow=TRUE))
  })
  
}
############################## COMPILE #################################

shinyApp(ui, server)