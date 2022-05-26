# Load library
library(tidyverse)
library(lubridate)
library(leaflet)
library(shiny)
library(shinydashboard)
library(htmltools)
library(leaflet.extras)
library(shinyWidgets)

#open data to get factor levels for UI


############################## UI #################################
############################## ↓↓ #################################
ui <- fluidPage(
  leafletOutput(outputId = "map")
)




###################################################################
server <- function(input, output) {
  output$map <- renderLeaflet({
    leaflet()%>%
      addTiles()%>% # default map
      setView(lng = -71.0589, lat = 42.3601, zoom = 12)
  })
}
############################## ↑↑↑↑↑↑↑ #################################
############################## SERVER #################################
#
#
#
#
############################## COMPILE #################################
############################## ↓↓↓↓↓↓ #################################
shinyApp(ui, server)