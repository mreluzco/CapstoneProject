require(tidyverse)
library(tidyverse)

#load data and select relevant columns
bike_sharing_df <- read_csv("raw_bike_sharing_systems.csv")

sub_bike_sharing_df <- bike_sharing_df %>% select(COUNTRY, CITY, SYSTEM, BICYCLES)


#remove reference numbers
remove_ref <- function(strings) {
  ref_pattern <- "\\[[A-z0-9]+\\]"
  strings <- stringr::str_replace_all(strings, ref_pattern,"")
  strings <- trimws(strings)
  return(strings)
}

sub_bike_sharing_df2 <- sub_bike_sharing_df %>% 
  mutate(SYSTEM = remove_ref(SYSTEM), CITY = remove_ref(CITY), BICYCLES = remove_ref(BICYCLES))


#convert digital substrings to numeric type
extract_num <- function(columns){
  digitals_pattern <- "[0-9]+"
  columns <- str_extract(columns, digitals_pattern)
  columns <- as.numeric(columns)
}

sub_bike_sharing_df3 <- sub_bike_sharing_df2 %>%
  mutate(BICYCLES = extract_num(BICYCLES))

#write a new csv with the cleaned data
write_csv(sub_bike_sharing_df3, "bike_sharing_systems.csv")




