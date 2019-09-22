library(rjson)
library(instaR)
library(httr)
json_file <- "https://www.instagram.com/creatorden/?__a=1"
json_data <- fromJSON(paste(readLines(json_file), collapse=""))
user <- json_data$graphql$user
biography <- user[["biography"]]
blocked_by_viewer <- user[["blocked_by_viewer"]]
followers <- user[["edge_followed_by"]][["count"]]
following <- user[["edge_follow"]][["count"]]
Name <- user[["full_name"]]
username <- user[["username"]]
id <- user[["id"]]
bussiness <- user[["is_business_account"]]
joinRecently <- user[["is_joined_recently"]]
bussinessCategory <- user[["business_category_name"]]
private <- user[["is_private"]]
picURL <- user[["profile_pic_url"]]
picUrlHD <- user[["profile_pic_url_hd"]]




user_media <- getUserMedia(username , token)
