library(tidyverse)
library(RSQLite)

#Determine how many records are in the seoul_bike_sharing dataset
count_query <- "SELECT COUNT(*) from SEOUL_BIKE_SHARING"
count_result <- dbGetQuery(con, count_query)
print(count_result)

#Determine how many hours had non-zero rented bike count
nonzero_query <- "SELECT COUNT(*) from SEOUL_BIKE_SHARING where HOUR <> '0'"
nonzero_result <- dbGetQuery(con, nonzero_query)
print(nonzero_result)

#Query the weather forecast for Seoul over the next 3 hours
weather_query <- "SELECT * from CITIES_WEATHER_FORECAST LIMIT 1"
weather_result <- dbGetQuery(con, weather_query)
print(weather_result)

#Find which seasons are included in the seoul bike sharing dataset
season_query <- "SELECT DISTINCT SEASONS from SEOUL_BIKE_SHARING"
season_result <- dbGetQuery(con, season_query)
print(season_result)

#Find the first and last dates in the Seoul Bike Sharing dataset
firstdaterange_query <- "SELECT DATE AS first_date FROM SEOUL_BIKE_SHARING LIMIT 1"
firstdaterange_result <- dbGetQuery(con, firstdaterange_query)
print(firstdaterange_result)
lastdaterange_query <- "SELECT DATE AS last_date FROM SEOUL_BIKE_SHARING LIMIT 1 OFFSET 8464"
lastdaterange_result <- dbGetQuery(con, lastdaterange_query)
print(lastdaterange_result)

#Determine which date and hour had the most bike rentals
alltimehigh_query <- "SELECT DATE, HOUR from SEOUL_BIKE_SHARING where RENTED_BIKE_COUNT = (SELECT MAX(RENTED_BIKE_COUNT) FROM SEOUL_BIKE_SHARING)"
alltimehigh_result <- dbGetQuery(con, alltimehigh_query)
print(alltimehigh_result)

#Determine the average hourly temperature and the average number of bike rentals per hour over each session. List the top ten results by average bike count.
hourlypop_query <- "SELECT HOUR, AVG(TEMPERATURE), AVG(RENTED_BIKE_COUNT) from SEOUL_BIKE_SHARING GROUP BY HOUR ORDER BY AVG(RENTED_BIKE_COUNT) DESC LIMIT 10"
hourlypop_result <- dbGetQuery(con, hourlypop_query)
print(hourlypop_result)

#Find the average hourly bike count during each season (including maximum, minimum, and standard deviation)
rentalseason_query <- "SELECT SEASONS,
                    AVG(RENTED_BIKE_COUNT),
                    MAX(RENTED_BIKE_COUNT),
                    MIN(RENTED_BIKE_COUNT),
                    STDEV(RENTED_BIKE_COUNT) FROM SEOUL_BIKE_SHARING GROUP BY SEASONS"
rentalseason_result <- dbGetQuery(con, rentalseason_query)
print(rentalseason_result)

#Find the average Temperature, Humidity, Wind Speed, Visibility, Dew Point Temperature, Solar Radiation, Rainfall and Snowfall per season, and include average bike count to see if these things are correlated
weatherbike_query <- "SELECT SEASONS, AVG(RENTED_BIKE_COUNT), AVG(TEMPERATURE), AVG(HUMIDITY), AVG(WIND_SPEED), AVG(VISIBILITY), AVG(DEW_POINT_TEMPERATURE), AVG(SOLAR_RADIATION), AVG(RAINFALL), AVG(SNOWFALL) FROM SEOUL_BIKE_SHARING GROUP BY SEASONS ORDER BY AVG(RENTED_BIKE_COUNT) DESC"
weatherbike_result <- dbGetQuery(con, weatherbike_query)
print(weatherbike_result)

#Join the WORLD_CITIES and BIKE_SHARING_SYSTEMS tables to determine the total number of bikes available in Seoul, as well as City, Country Latitude, Longitude and Population in one view
join_query <- "SELECT BICYCLES, BIKE_SHARING_SYSTEMS.CITY, BIKE_SHARING_SYSTEMS.COUNTRY, LAT, LNG, POPULATION from WORLD_CITIES, BIKE_SHARING_SYSTEMS where WORLD_CITIES.CITY = BIKE_SHARING_SYSTEMS.CITY AND WORLD_CITIES.CITY = 'Seoul'"
join_result <- dbGetQuery(con, join_query)
print(join_result)

#Find all cities with similar bike counts to Seoul (15000 to 20000), and return city and country names, coordinates, population and number of bicycles
comp_scale_query <- "SELECT BICYCLES, BIKE_SHARING_SYSTEMS.CITY, BIKE_SHARING_SYSTEMS.COUNTRY, LAT, LNG, POPULATION from WORLD_CITIES, BIKE_SHARING_SYSTEMS where WORLD_CITIES.CITY = BIKE_SHARING_SYSTEMS.CITY and BICYCLES between 15000 and 20000"
comp_scale_result <- dbGetQuery(con, comp_scale_query)
print(comp_scale_result)
