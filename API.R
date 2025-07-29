library(plumber)
library(readr)

setwd("C:/Users/keple/OneDrive/Documents/Baseball Stats/Website Code/HTML Code")

data <- read_csv("data.csv")

#* @apiTitle Baseball Stats API

# CORS filter
#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization")
  
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$status <- 200
    return(list())
  } else {
    plumber::forward()
  }
}

#* Get limited rows of data with optional offset (pagination)
#* @param limit:number Number of rows to return (default 50)
#* @param offset:number Row offset to start from (default 0)
#* @get /data
function(limit = 50, offset = 0) {
  limit <- as.numeric(limit)
  offset <- as.numeric(offset)
  total_rows <- nrow(data)
  
  if (offset >= total_rows) {
    return(data.frame())  # empty data frame if offset beyond data
  }
  
  slice_end <- min(offset + limit, total_rows)
  return(data[(offset + 1):slice_end, ])
}

#* Get data filtered by player name (exact match)
#* @param player_name:string Player name to filter
#* @get /player
function(player_name = "") {
  if (player_name == "") {
    return(list(error = "Please provide a player_name query parameter"))
  }
  subset <- data[data$player_name == player_name, ]
  return(subset)
}