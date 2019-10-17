
# libraries ---------------------------------------------------------------

library(httr)
library(dplyr)

# follower json parser ----------------------------------------------------

parser_followers <- function(json) {
  node <- json$node
  id <- node$id
  username <- node$username
  full_name <- node$full_name
  profile_pic_url <- node$profile_pic_url
  is_private <- node$is_private
  is_verified <- node$is_verified
  typename <- node$reel$owner$`__typename`
  result <- data.frame(id, username, full_name, profile_pic_url, is_private, is_verified, typename)
  return(result)
}


# time out handler --------------------------------------------------------

time_out_handler <- function(time, func, args) {
  Sys.sleep(time)
  command_args <- paste(args, collapse = ", ")
  command_text <- paste0(func, "(", command_args, ")")
  res <- eval(command_text)
}


# save the followers ------------------------------------------------------

write_followers <- function(id, followers_df, cursor, completion_percent) {
  followers_dist <- paste0("data/followers/", id, ".txt")
  sink(followers_dist, append = TRUE)
  followr_text <- followers_converter(followers_df, cursor, completion_percent)
  cat(followr_text)
  sink()
}



# followers to string converter -------------------------------------------

followers_converter <- function(df, cursor, completion_percent) {
  n <- nrow(df)
  df %>% mutate_if(is.factor, as.character) -> df
  follower_lines <- vector()
  cursor <- ifelse(is.na(cursor), "first_req", cursor)
  for (i in 1:n) {
    followr_data <- df[i, ]
    follower_lines[i] <- paste(paste(followr_data, collapse = ","), cursor, completion_percent, sep = ",")
  }
  result <- paste0(paste(follower_lines, collapse = "\n"), "\n")
  return(result)
}



# Initializing the file of followers --------------------------------------

initialize_follower <- function(id) {
  
  followers_dist <- paste0("data/followers/", id, ".txt")
  column_names <- c("id", "username", "full_name", "profile_pic_url", "is_private", "is_verified", "typename", "cursor", "completion_percent")
  
  if(file.exists(followers_dist)) {
    return()
  } else {
    sink(followers_dist, append = TRUE)
    header_text <- paste0(paste(column_names, collapse = ","), "\n")
    cat(header_text)
    sink()
  }
  
}







