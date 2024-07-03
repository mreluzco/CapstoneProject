require("rvest")

library(rvest)

url <- "https://en.wikipedia.org/wiki/List_of_bicycle-sharing_systems"

root_node <- read_html(url)

table_nodes <- html_nodes(root_node, "table")

table <- html_table(table_nodes[[1]], fill = TRUE)

write.csv(table, file = "raw_bike_sharing_systems.csv", row.names = FALSE)
