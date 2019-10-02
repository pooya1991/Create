source("R/get_followers_total.R")

# influencers_profiles_dir <- "data/profiles.csv"
# influencers_profiles <- read.csv(influencers_profiles_dir)

# ids <- influencers_profiles[11:20, 2]

# for (i in 1:10) {
#   id <- ids[i]
#   followers_total <- get_followers_total(id)
#   save(followers_total, file = paste0("data/", id, ".rda"))
# }

id <- 2966061840

followers_total <- get_followers_total(id)
