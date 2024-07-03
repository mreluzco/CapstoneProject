#API Key: f18693430f0978f5e467497f60664bc4

install.packages("httr")
require("rvest")
library(httr)

current_weather_url <- 'https://api.openweathermap.org/data/2.5/weather'

your_api_key <- "f18693430f0978f5e467497f60664bc4"
current_query <- list(q = "Seoul", appid = your_api_key, units="metric")

response <- GET(current_weather_url, query=current_query)

json_result <- content(response, as="parsed")

weather <- c()
visibility <- c()
temp <- c()
temp_min <- c()
temp_max <- c()
pressure <- c()
humidity <- c()
wind_speed <- c()
wind_deg <- c()

weather <- c(weather, json_result$weather[[1]]$main)
visibility <- c(visibility, json_result$visibility)
temp <- c(temp, json_result$main$temp)
temp_min <- c(temp_min, json_result$main$temp_min)
temp_max <- c(temp_max, json_result$main$temp_max)
pressure <- c(pressure, json_result$main$pressure)
humidity <- c(humidity, json_result$main$humidity)
wind_speed <- c(wind_speed, json_result$wind$speed)
wind_deg <- c(wind_deg, json_result$wind$deg)

weather_data_frame <- data.frame(weather=weather, 
                                 visibility=visibility, 
                                 temp=temp, 
                                 temp_min=temp_min, 
                                 temp_max=temp_max, 
                                 pressure=pressure, 
                                 humidity=humidity, 
                                 wind_speed=wind_speed, 
                                 wind_deg=wind_deg)


