require(tidyverse)
library(tidyverse)

dataset_list <- c('raw_bike_sharing_systems.csv', 'raw_seoul_bike_sharing.csv', 'raw_cities_weather_forecast.csv', 'raw_worldcities.csv')

for (dataset_name in dataset_list){
  dataset <- read_csv(dataset_name)
  
  colnames(dataset) <- stringr::str_to_upper(colnames(dataset))
  str_replace(names(dataset), " ", "_")
  write.csv(dataset, dataset_name, row.names=FALSE)
}


