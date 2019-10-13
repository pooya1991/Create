
# Make a dataframe of crawlers --------------------------------------------

crawlers <- read.csv("data/fake_users.csv")[1:4, 1:2]
save(crawlers, file = "data/crawlers.rda")
