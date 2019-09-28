source("R/get_followers_total.R")

influencers_profiles_dir <- "data/profiles.csv"
influencers_profiles <- read.csv(influencers_profiles_dir)

id <- influencers_profiles[1, 2]

a <- get_followers_total(id)
