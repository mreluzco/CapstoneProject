install.packages("RSQLite")
library(RSQLite)
library(tidyverse)
db_file <- "bike_share.db"
con <- dbConnect(RSQLite::SQLite(), dbname = db_file)

world_cities <- read_csv("WORLD_CITIES.csv")
bike_sharing_systems <- read_csv("BIKE_SHARING_SYSTEMS.csv")
cities_weather_forecast <- read_csv("CITIES_WEATHER_FORECAST.csv")
seoul_bike_sharing <- read_csv("SEOUL_BIKE_SHARING.csv")

dbWriteTable(con, name = "WORLD_CITIES", value = world_cities, row.names = FALSE)
dbWriteTable(con, name = "BIKE_SHARING_SYSTEMS", value = bike_sharing_systems, row.names = FALSE)
dbWriteTable(con, name = "CITIES_WEATHER_FORECAST", value = cities_weather_forecast, row.names = FALSE)
dbWriteTable(con, name = "SEOUL_BIKE_SHARING", value = seoul_bike_sharing, row.names = FALSE)