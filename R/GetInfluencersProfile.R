source("R/get_user_profile.R")

influencers_username <- as.character(read.csv("data/export_h.csv", header = FALSE)[,1])

n <- length(influencers_username)

Profiles <- list()
j <- 1

for (i in j:n) {
  username <- influencers_username[i]
  j <- i
  Profiles[[i]] <- get_user_profile(username)
}

Profiles_df <- do.call(rbind, Profiles)
