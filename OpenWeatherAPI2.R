# Create some empty vectors to hold data temporarily

# City name column
city <- c()
# Weather column, rainy or cloudy, etc
weather <- c()
# Sky visibility column
visibility <- c()
# Current temperature column
temp <- c()
# Max temperature column
temp_min <- c()
# Min temperature column
temp_max <- c()
# Pressure column
pressure <- c()
# Humidity column
humidity <- c()
# Wind speed column
wind_speed <- c()
# Wind direction column
wind_deg <- c()
# Forecast timestamp
forecast_datetime <- c()
# Season column
# Note that for season, you can hard code a season value from levels Spring, Summer, Autumn, and Winter based on your current month.
season <- c()

# Get forecast data for a given city list
get_weather_forecaset_by_cities <- function(city_names){
  df <- data.frame()
  for (city_name in city_names){
    # Forecast API URL
    forecast_url <- 'https://api.openweathermap.org/data/2.5/forecast'
    # Create query parameters
    forecast_query <- list(q = city_name, appid = "f18693430f0978f5e467497f60664bc4", units="metric")
    # Make HTTP GET call for the given city
    weather_response <- GET(forecast_url, query = forecast_query)
    json_list <- content(weather_response, as="parsed")
    # Note that the 5-day forecast JSON result is a list of lists. You can print the reponse to check the results
    results <- json_list$list
    # Loop the json result
    for(result in results) {
      city <- c(city, json_list$city_name)
      weather <- c(weather, json_list$weather)
      visibility <- c(visibility, json_list$visibility)
      temp <- c(temp, json_list$temp)
      temp_min <- c(temp_min, json_list$temp_min)
      temp_max <- c(temp_max, json_list$temp_max)
      pressure <- c(pressure, json_list$pressure)
      humidity <- c(humidity, json_list$humidity)
      wind_speed <- c(wind_speed, json_list$wind_speed)
      wind_deg <- c(wind_deg, json_list$wind_deg)
      forecast_datetime <- c(forecast_datetime, json_list$forecast_datetime)
      season <- c(season, json_list$season)
    }
    
    # Add the R Lists into a data frame
    df <- data.frame(city=cities,
                     weather=weather,
                     visibility=visibility,
                     temp=temp,
                     temp_min=temp_min,
                     temp_max=temp_max,
                     pressure=pressure,
                     humidity=humidity,
                     wind_speed=wind_speed,
                     wind_deg=wind_deg,
                     forecast_datetime=forecast_datetime,
                     season=season)
  }
  
  # Return a data frame
  return(df)
  
}

cities <- c("Seoul", "Washington, D.C.", "Paris", "Suzhou")
cities_weather_df <- get_weather_forecaset_by_cities(cities)

# Write cities_weather_df to `cities_weather_forecast.csv`
write.csv(cities_weather_df, "cities_weather_forecast.csv", row.names=FALSE)