setwd("/root/get_followers/cd-one")

source('R/requirements.R')
source('R/utils.R')
source('R/headers_handler.R')
source('R/get_followers.R')
source('R/get_followers_total.R')

influencers_df <- read.csv("data/profiles.csv", header = TRUE, stringsAsFactors = FALSE)

IDs <- influencers_df$id[1:100]

for (id in IDs) {
  get_followers_total(id)
}

