source("R/get_followers_total.R")

influencers_df <- read.csv("data/profiles.csv", header = TRUE, stringsAsFactors = FALSE)

IDs <- influencers_df$id

for (id in IDs) {
  get_followers_total(id)
}

