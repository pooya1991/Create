source("R/get_user_profile.R")

influencers_username <- as.character(read.csv("data/export_h.csv", header = FALSE)[,1])

n <- length(influencers_username)

Profiles <- list()
j <- 0

j <- j + 1
for (i in j:n) {
  username <- influencers_username[i]
  j <- i
  Profiles[[i]] <- get_user_profile(username)
}

not_exist_users <- c(135, 240, 405, 430, 472, 478, 554, 575, 630, 640, 658, 693, 701, 749, 784, 987, 1005, 1008,
                     1009, 1037, 1039, 1048, 1168, 1169, 1175, 1185, 1366, 1437, 1487, 1563)

Profiles_df <- do.call(rbind, Profiles)
save(Profiles, Profiles_df, file = "data?profiles.rda")
write.csv(Profiles_df, "data/profiles.csv")
