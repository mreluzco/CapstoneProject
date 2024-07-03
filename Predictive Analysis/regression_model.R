library("tidymodels")
library("tidyverse")
library("stringr")

#load and read the dataset
dataset_url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/seoul_bike_sharing_converted_normalized.csv"
bike_sharing_df <- read_csv(dataset_url)
spec(bike_sharing_df)

#remove DATE and FUNCTIONING_DAY columns
bike_sharing_df <- bike_sharing_df %>% 
  select(-DATE, -FUNCTIONING_DAY)

#split the data into training and testing data
set.seed(1234)
bike_split <- initial_split(bike_sharing_df, prop = 0.75)
train_data <- training(bike_split)
test_data <- testing(bike_split)

#define a linear regression model specification
lm_spec <- linear_reg() %>%
  set_engine(engine = "lm")

#fit a model with the response variable RENTED_BIKE_COUNT and predictor variables for weather conditions
lm_model_weather <- lm_spec %>%
  fit(RENTED_BIKE_COUNT ~ TEMPERATURE + HUMIDITY + WIND_SPEED + VISIBILITY + DEW_POINT_TEMPERATURE + SOLAR_RADIATION + RAINFALL + SNOWFALL, data = train_data)

#fit a model with the response variable RENTED_BIKE_COUNT with all other variables as predictor variables
lm_model_all <- lm_spec %>%
  fit(RENTED_BIKE_COUNT ~ ., data = train_data)

#create predictions on the testing dataset using both models
weather_test_results <- lm_model_weather %>%
  predict(new_data = test_data) %>%
  mutate(truth = test_data$RENTED_BIKE_COUNT)

all_test_results <- lm_model_all %>%
  predict(new_data = test_data) %>%
  mutate(truth = test_data$RENTED_BIKE_COUNT)

#calculate the R-squared and RMSE metrics for both test results
rsq_weather <- rsq(weather_test_results, truth = truth, estimate = .pred)
rsq_all <- rsq(all_test_results, truth = truth, estimate = .pred)

rmse_weather <- rmse(weather_test_results, truth = truth, estimate = .pred)
rmse_all <- rmse(all_test_results, truth = truth, estimate = .pred)

#sort the list of coefficients
sorted_coefficients <- sort(unlist(lm_model_all$fit$coefficients), decreasing = TRUE)
