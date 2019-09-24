library(jsonlite)
source("R/utils.R")
func <- "get_user_profile"

get_user_profile <- function(username) {
  base_url <- "https://www.instagram.com/"
  last_url <-"/?__a=1"
  url <- paste0(base_url, username, last_url)
  
  json_content <- tryCatch(fromJSON(url),
                           error = time_out_handler(1, func, username),
                           finally = cat(paste0(username, "\n")))
  
  user <- json_content$graphql$user
  
  bio <- user$biography
  if(is.null(bio)) {
    bio <- NA
  }
  external_url <- user$external_url
  if(is.null(external_url)) {
    external_url <- NA
  }
  followers_count <- user$edge_followed_by$count
  following_count <- user$edge_follow$count
  full_name <- user$full_name
  if(is.null(full_name) | full_name == "") {
    full_name <- NA
  }
  id <- user$id
  is_business_account <- user$is_business_account
  if(is_business_account) {
    business_category <- user$business_category_name
  } else {
    business_category <- NA
  }
  is_joined_recently <- user$is_joined_recently
  is_private <- user$is_private
  is_verified <- user$is_verified
  profile_pic_url <- user$profile_pic_url
  
  profile <- data.frame(id = id, bio = bio, full_name = full_name, username = username, followers_count = followers_count,
                        following_count = following_count, external_url = external_url, is_business_account = is_business_account,
                        business_category = business_category, is_private = is_private, is_verified = is_verified,
                        is_joined_recently = is_joined_recently, profile_pic_url = profile_pic_url)

  # colnames(profile) <- c("id", "bio", "full_name", "username", "followers_count", "following_count", "external_url", "is_business_account,
  #                        business_category", "is_private", "is_verified", "is_joined_recently", "profile_pic_url")
  # 
  return(profile)
}
