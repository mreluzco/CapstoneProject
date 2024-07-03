install("tidyverse")
install("tidymodels")

library("tidymodels")
library("tidyverse")
library("stringr")

# Dataset URL
dataset_url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/seoul_bike_sharing_converted_normalized.csv"
bike_sharing_df <- read_csv(dataset_url)
spec(bike_sharing_df)

#remove date and functioning day columns
bike_sharing_df <- bike_sharing_df %>% 
  select(-DATE, -FUNCTIONING_DAY)

#define linear regression model specification
lm_spec <- linear_reg() %>%
  set_engine("lm") %>% 
  set_mode("regression")

#split data into training and testing sets
set.seed(1234)
data_split <- initial_split(bike_sharing_df, prop = 4/5)
train_data <- training(data_split)
test_data <- testing(data_split)

# Fit a linear model with higher order polynomial on some important variables 
lm_poly <- lm(RENTED_BIKE_COUNT ~ poly(TEMPERATURE, 6) + poly(HUMIDITY, 4) + poly(RAINFALL, 6) + poly(SNOWFALL, 2), data = train_data)

# Use predict() function to generate test results for `lm_poly`
test_results <- lm_poly %>%
  predict(newdata = test_data) %>%
  as.data.frame() %>%
  mutate(truth = test_data$RENTED_BIKE_COUNT)

#Change negative prediction results to zero
test_results[test_results<0] <- 0

#calculate R-squared and rmse values for the model
poly_rsq <- rsq(test_results, truth = truth, estimate = .)
poly_rsq
poly_rmse <- rmse(test_results, truth = truth, estimate = .)
poly_rmse

#add interaction terms to the linear model to try to refine it
lm_poly2 <- lm(RENTED_BIKE_COUNT ~ poly(TEMPERATURE, 6) * poly(HUMIDITY, 4) + poly(RAINFALL, 6) + poly(SNOWFALL, 2), data = train_data)

#calculate the R-squared and rmse values for the new model
test_results2 <- lm_poly2 %>%
  predict(newdata = test_data) %>%
  as.data.frame() %>%
  mutate(truth = test_data$RENTED_BIKE_COUNT)

poly_rsq2 <- rsq(test_results2, truth = truth, estimate = .)
poly_rsq2
poly_rmse2 <- rmse(test_results2, truth = truth, estimate = .)
poly_rmse2

#define a glmnet specification
glmnet_spec <- linear_reg(penalty = 1, mixture = 1) %>%
  set_engine("glmnet") %>%
  set_mode("regression")  

install.packages('glmnet')
library('glmnet')



