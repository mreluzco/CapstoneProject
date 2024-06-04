# Load required libraries
require(leaflet)


# Create a RShiny UI
shinyUI(
  fluidPage(padding=5,
            titlePanel("Bike-sharing demand prediction app"), 
            # Create a side-bar layout
            sidebarLayout(
              # Create a main panel to show cities on a leaflet map
              mainPanel(
                # leaflet output with id = 'city_bike_map', height = 1000
                leafletOutput("city_bike_map", height = 1000)
              ),
              # Create a side bar to show detailed plots for a city
              sidebarPanel(
                sidebarPanel(
                  selectInput(inputId="city_dropdown",
                              label = "Cities",
                              choices = c("All", "Seoul", "Suzhou", "London", "New York", "Paris"))
                # select drop down list to select city
              ))
  )))