setwd("/getFollowers")

source('/getFollowers/R/requirements.R')
source('/getFollowers/R/utils.R')
source('/getFollowers/R/headers_handler.R')
source('/getFollowers/R/get_followers.R')
source('/getFollowers/R/get_followers_total.R')

influencers_df <- read.csv("data/profiles.csv", header = TRUE, stringsAsFactors = FALSE)

IDs <- influencers_df$id[1:100]

for (id in IDs) {
  get_followers_total(id)
}

