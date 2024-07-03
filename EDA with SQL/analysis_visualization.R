library(tidyverse)
library(ggplot2)

#load the data
seoul_bike_sharing <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/seoul_bike_sharing.csv"  
bike_share_df <- read_csv(seoul_bike_sharing)

#make date column date class data, and SEASONS and FUNCTIONING_DAY factors
bike_share_df$DATE <- as.Date(bike_share_df$DATE, "%d/%m/%Y")
bike_share_df$SEASONS <- as.factor(bike_share_df$SEASONS)
bike_share_df$FUNCTIONING_DAY <- as.factor(bike_share_df$FUNCTIONING_DAY)
bike_share_df

#cast HOURS as a categorical variable and coerce levels to be sequenced
bike_share_df$HOUR <- factor(bike_share_df$HOUR, ordered = TRUE)

#calculate the number of holidays
holiday_entries <- sum(bike_share_df$HOLIDAY == "Holiday")
holiday_number <- holiday_entries/24
print(holiday_number)
#result is 17

#calculate the percentage of records that fall on a holiday
holiday_pct <- (17/365)*100
print(holiday_pct)
#result is 4.657534

#calculate the number of records we expect to have, given that this is a full year of data
records_num <- 365*24
print(records_num)
#result is 8760

#given the observations for the FUNCTIONING_DAY how many records must there be
entry_count <- sum(bike_share_df$FUNCTIONING_DAY == "Yes")
print(entry_count)
#result is 8465

#group data by seasons and calculate the seasonal total rainfall and snowfall
library(dplyr)
grouped_df <- bike_share_df %>%
  group_by(SEASONS)

summary <- grouped_df %>%
  summarize(total_rainfall = sum(RAINFALL),
            total_snowfall = sum(SNOWFALL))

print(summary)

#create a scatter plot of RENTED_BIKE_COUNT vs DATE
ggplot(bike_share_df) +
  geom_point(aes(x=DATE, y=RENTED_BIKE_COUNT, alpha = 0.3)) 

#create the same plot, but using hours as the color
ggplot(bike_share_df) +
  geom_point(aes(x=DATE, y=RENTED_BIKE_COUNT, color=HOUR, alpha = 0.3)) 

#create a histogram overlaid with a kernel density curve
ggplot(bike_share_df) +
  geom_histogram(aes(x=RENTED_BIKE_COUNT, y=..density..),  fill = "white", color = "black") +
  geom_density((aes(x = RENTED_BIKE_COUNT, y = ..density..)))

#use a scatter plot to visualize the correlation between RENTED_BIKE_COUNT and TEMPERATURE by SEASONS
ggplot(bike_share_df) +
  geom_point(aes(x=TEMPERATURE, y=RENTED_BIKE_COUNT), alpha = 0.5) +
  facet_wrap(~ SEASONS)

#create a display of four boxplots of RENTED_BIKE_COUNT vs HOUR grouped by SEASONS
ggplot(bike_share_df) +
  geom_boxplot(aes(x = HOUR, y = RENTED_BIKE_COUNT)) +
  facet_wrap(~ SEASONS)

#group data by DATE and use the summarize function to calculate the total rainfall and snowfall. plot the results
grouped_data <- bike_share_df %>%
  group_by(DATE) %>%
  summarize(
    daily_rainfall = sum(RAINFALL),
    daily_snowfall = sum(SNOWFALL))

ggplot(grouped_data) +
  geom_point(aes(x = DATE, y=daily_rainfall), color = "red") +
  geom_point(aes(x = DATE, y=daily_snowfall), color = "blue") +
  labs(x = "Date", y = "Daily Precipitation") 

#determine how many days had snowfall
snow_days <- grouped_data %>%
  summarize(snowfall_days = sum(daily_snowfall !=0))

snow_days