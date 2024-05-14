require(tidyverse)
library(tidyverse)

bike_sharing_df <- read_csv("raw_bike_sharing_systems.csv")

sub_bike_sharing_df <- bike_sharing_df %>% select(COUNTRY, CITY, SYSTEM, BICYCLES)



remove_ref <- function(df, cols, pattern) {
  for(col in cols) {
    df <- df %>%
      mutate(col, str_replace_all(col, pattern, ""))
  }
  return(df)
}

result <- remove_ref(sub_bike_sharing_df, c(sub_bike_sharing_df$CITY, sub_bike_sharing_df$SYSTEM), "\\[[A-z0-9]+\\]")

result %>% 
  select(CITY, SYSTEM, BICYCLES) %>% 
  filter(find_reference_pattern(CITY) | find_reference_pattern(SYSTEM) | find_reference_pattern(BICYCLES))