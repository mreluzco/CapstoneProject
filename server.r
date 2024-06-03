# Install and import required libraries
require(shiny)
require(ggplot2)
require(leaflet)
require(tidyverse)
require(httr)
require(scales)
# Import model_prediction R which contains methods to call OpenWeather API
# and make predictions
source("model_prediction.R")


test_weather_data_generation<-function(){
  city_weather_bike_df<-generate_city_weather_bike_data()
  stopifnot(length(city_weather_bike_df)>0)
  print(city_weather_bike_df)
  return(city_weather_bike_df)
}

# Create a RShiny server
shinyServer(function(input, output){
  # Define a city list
  
  # Define color factor
  color_levels <- colorFactor(c("green", "yellow", "red"), 
                              levels = c("small", "medium", "large"))
  
  # Test generate_city_weather_bike_data() function
  city_weather_bike_df <- test_weather_data_generation()
  
  # Create another data frame called `cities_max_bike` with each row contains city location info and max bike
  # prediction for the city
  cities_max_bike <- city_weather_bike_df %>%
    group_by(CITY_ASCII) %>%
    summarize(BIKE_PREDICTION = max(BIKE_PREDICTION))
  # Observe drop-down event
  observeEvent(input$city_dropdown,{
    # Then render output plots with an id defined in ui.R
    
    # If All was selected from dropdown, then render a leaflet map with circle markers
    # and popup weather LABEL for all five cities
    if(input$city_dropdown == "All") {
      output$city_bike_map <- renderLeaflet({
        leaflet(cities_max_bike) %>% addTiles() %>%
          addCircleMarkers(data = cities_max_bike,
                           lng = cities_max_bike$LNG,
                           lat = cities_max_bike$LAT,
                           popup = ~cities_max_bike$CITY_ASCII,
                           radius = ~ifelse(cities_max_bike$BIKE_PREDICTION_LEVEL == 'small', 2, 12),
                           color = ~color_levels(cities_max_bike$BIKE_PREDICTION_LEVEL))
      })
    }
    else {
      output$city_bike_map <- renderLeaflet({
        leaflet(cities_max_bike) %>% addTiles()
      })
      observe({
        loc <- cities_max_bike %>% filter(CITY_ASCII == input$city_dropdown)
        leafletProxy("city_bike_map") %>%
          setView(lng = loc$LNG, 
                  lat = loc$LAT, 
                  zoom = 12) %>%
          clearMarkers() %>%
          addMarkers(lng = loc$LNG, lat = loc$LAT, popup = input$city_dropdown)
      })
    }
  })
})
