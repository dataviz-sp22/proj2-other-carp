# Load library
library(tidyverse)
library(lubridate)
library(leaflet)
library(shiny)
library(htmltools)
library(leaflet.extras)
library(shinyWidgets)
library(colorblindr)

#open data to get factor levels for UI
control_latest <- read_csv("control_latest.csv")
events_latest <- read_csv("events_latest.csv")

#Data Wrangling

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
         evt_type = case_when(t_aad_b == 1 ~ "Air Strike/Defense",
                              t_airstrike_b == 1 ~ "Air Strike/Defense",
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



############################## UI #################################
############################## 鈫撯啌 #################################


# I create more than 3 selection bars, but only 3 are shown. 
ui <- fluidPage(
  titlePanel(title = "Russia-Ukraine Crises"),
  tabsetPanel(
    # Tabset 1 for maps
    tabPanel(title = "Events Mapping",
            sidebarLayout(sidebarPanel(dateRangeInput(inputId = "dateRange", 
                            label = "Date range:",
                            start = "2022-02-23",
                            end = Sys.Date()),
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
               selected = "Air Strike/Defense"
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
             mainPanel(leafletOutput(outputId = "map")))
            # place line plots and bar plots here
             ),
    # Tabset 2 for control maps
    tabPanel(title = "Control Mapping",
             )
  ),
)




###################################################################
server <- function(input, output) {
  
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
      addCircleMarkers(~longitude, ~latitude,
                       color = ~pal(events_map_fil()$evt_type),
                       radius = 4,
                       #fillOpacity = .7,
                       stroke = FALSE,
                       popup  = paste("Date", events_map_fil()$date, "<br>",
                                      "Time", events_map_fil()$time, "<br>",
                                      "Event Type:", events_map_fil()$mil_type, "<br>",
                                      "Initiator:", events_map_fil()$initiator, "<br>",
                                      "Military Casualities Reported:", events_map_fil()$mil_cas, "<br>",
                                      "Civilian Casualities Reported:", events_map_fil()$civ_cas, "<br>",
                                      "Url:", events_map_fil()$url))%>%
      addLegend(title = "Event Type",
        pal = pal,
        values = ~evt_type
      )
  })
}
############################## 鈫戔啈鈫戔啈鈫戔啈鈫? #################################
############################## SERVER #################################
#
#
#
#
############################## COMPILE #################################
############################## 鈫撯啌鈫撯啌鈫撯啌 #################################
shinyApp(ui, server)