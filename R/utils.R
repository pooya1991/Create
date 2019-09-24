
# libraries ---------------------------------------------------------------

library(httr)


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
  result <- data.frame(id, username, full_name, profile_pic_url, is_private,
                       is_verified, typename)
  return(result)
}




# time out handler --------------------------------------------------------

time_out_handler <- function(time, func, args) {
  Sys.sleep(time)
  command_args <- paste(args, collapse = ", ")
  command_text <- paste0(func, "(", command_args, ")")
  res <- eval(command_text)
}
