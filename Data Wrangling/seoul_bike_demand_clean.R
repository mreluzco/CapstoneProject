require(tidyverse)
library(tidyverse)

#load the bike sharing system data from the csv
bike_sharing_df <- read_csv("raw_seoul_bike_sharing.csv")

#drop rows with RENTED_BIKE_COUNT NA
bike_sharing_df2 <- bike_sharing_df %>% drop_na(RENTED_BIKE_COUNT)

#impute missing temperature values with the average summer value
#calculate the average temperature in summer
summer_temps <- filter(bike_sharing_df2 %>% filter(SEASONS == "Summer"))
average_summer_temp <- summer_temps %>%
  summarize(mean_column = mean(TEMPERATURE, na.rm = TRUE))
#impute missing values
bike_sharing_df3 <- bike_sharing_df2 %>%
  replace_na(list(TEMPERATURE = 26.5))

#save the dataset
write_csv(bike_sharing_df3, "seoul_bike_sharing.csv")

#Create dummy variables to help process data in regression models
#Convert HOUR column to characters
bike_sharing_df4 <- bike_sharing_df3 %>%
  mutate(HOUR = as.character(HOUR))

#Create dummy columns for SEASONS, HOLIDAY, FUNCTIONING_DAY, and HOUR
bike_sharing_df5 <- bike_sharing_df4 %>%
  mutate(dummy = 1) %>%
  spread(key = SEASONS, value = dummy, fill = 0)

bike_sharing_df6 <- bike_sharing_df5 %>%
  mutate(dummy = 1) %>%
  spread(key = HOLIDAY, value = dummy, fill = 0)

bike_sharing_df7 <- bike_sharing_df6 %>%
  mutate(dummy = 1) %>%
  spread(key = FUNCTIONING_DAY, value = dummy, fill = 0)

bike_sharing_df8 <- bike_sharing_df7 %>%
  mutate(dummy = 1) %>%
  spread(key = HOUR, value = dummy, fill = 0)

#save converted data as CSV
write_csv(bike_sharing_df8, "seoul_bike_sharing_converted.csv")

#normalize columns
bike_sharing_df_normalized <- bike_sharing_df8 %>%
  mutate(
    RENTED_BIKE_COUNT = (RENTED_BIKE_COUNT - min(RENTED_BIKE_COUNT)) / (max(RENTED_BIKE_COUNT) - min(RENTED_BIKE_COUNT)),
    TEMPERATURE = (TEMPERATURE - min(TEMPERATURE)) / (max(TEMPERATURE) - min(TEMPERATURE)),
    HUMIDITY = (HUMIDITY - min(HUMIDITY)) / (max(HUMIDITY) - min(HUMIDITY)),
    WIND_SPEED = (WIND_SPEED - min(WIND_SPEED)) / (max(WIND_SPEED) - min(WIND_SPEED)),
    VISIBILITY = (VISIBILITY - min(VISIBILITY)) / (max(VISIBILITY) - min(VISIBILITY)),
    DEW_POINT_TEMPERATURE = (DEW_POINT_TEMPERATURE - min(DEW_POINT_TEMPERATURE)) / (max(DEW_POINT_TEMPERATURE) - min(DEW_POINT_TEMPERATURE)),
    SOLAR_RADIATION = (SOLAR_RADIATION - min(SOLAR_RADIATION)) / (max(SOLAR_RADIATION) - min(SOLAR_RADIATION)),
    RAINFALL = (RAINFALL - min(RAINFALL)) / (max(RAINFALL) - min(RAINFALL)),
    SNOWFALL = (SNOWFALL - min(SNOWFALL)) / (max(SNOWFALL) - min(SNOWFALL))
  )

#save normalized data as csv
write_csv(bike_sharing_df_normalized, "seoul_bike_sharing_converted_normalized.csv")

#re-standardize column names in all data
dataset_list <- c('seoul_bike_sharing.csv', 'seoul_bike_sharing_converted.csv', 'seoul_bike_sharing_converted_normalized.csv')

for (dataset_name in dataset_list){
  dataset <- read_csv(dataset_name)
  names(dataset) <- toupper(names(dataset))
  names(dataset) <- str_replace_all(names(dataset), " ", "_")
  write.csv(dataset, dataset_name, row.names=FALSE)
}