source("R/utils.R")

get_followers <- function(id, after, k) {
  # define the headers of GET request
  headers <- add_headers(`accept` = "*/*", `accept-encoding` = "gzip, deflate, br", `accept-language` = "en-US,en;q=0.9", 
                         `cookie` = 'ig_cb=1; mid=XYZzPQAEAAHRSJsI6bHlLVQIdu5N; fbm_124024574287414=base_domain=.instagram.com; shbid=1590; shbts=1570029676.9215505; fbsr_124024574287414=7zOdl9MED7C9ZNM_UQt3qYv35V6_DXRFmxKGmW6oIVI.eyJ1c2VyX2lkIjoiMTAwMDAxMTY0ODQzMzI2IiwiY29kZSI6IkFRQ09LZm5NRllwVEFQUVVieC1FZS1fWnFiQjYtQjlGQWtFUkg1a1FEaGwtR2FSazZia3BmNTk1cm9UVG94THlrSHQyN0hNaUd3Ti10bnBlbUVVTlhvbHoxNXdQZnNIYWNMSTZoaGVyQUJzZVl6Z1BUMUVGRUZTNWVTSjB5U1BBQlhrQ2RHcHhQeUp5Y2lUaHpla0FEdmJVRGRvQ0dvX04tLV91MFhJUklYWkdzdDRVV3ZZajhJNElaZl9uWGFHdEV1Zy1RVUtYb2ZiRW9sQ0tFSjl2UXR6d0JKUnJWalQwNGZuRXdYLVFwMzVodFpwRVRKZGVUd2ctQ2dZbklnLTZBTkljb3lMU1gtbFJZV3BseWxfbTROeTNMSEREVWJUbDJiazU5SkdqeUlPLXlINGdzUVdGQlA3UU1aclhXNDY4c2g3Y28yLXlHcEtXV1kwaXVadTJwUzV6Iiwib2F1dGhfdG9rZW4iOiJFQUFCd3pMaXhuallCQUlWSDhaQXo5WkNhV1FTMGwzT09pWFpBaVFtalhVUHNWMFJvMFdsTWhaQnRFZUtaQzhsemxwbVBHWVpBN0NaQ0daQzJPaFRwOWRpUElkRGpNa0hCalVNSkp2ZEVobHNraWhHWkFHRXVaQ3ZRRkROYVNNeXVHQ0FQSHgwenhaQlhta2dRdEZpSmNXWU1MN282WkJORjhYZk44SFV6dWtjejlxdVpCYjVYN0JaQ2FHbUthNCIsImFsZ29yaXRobSI6IkhNQUMtU0hBMjU2IiwiaXNzdWVkX2F0IjoxNTcwMDM2ODM4fQ; csrftoken=v0H0xmT33dmj0TBWcgr50BEY9TQdzqOr; ds_user_id=1275316459; sessionid=1275316459%3AKHH1yoIdKMxmWj%3A15; urlgen="{\"5.160.53.194\": 42337\054 \"134.19.177.25\": 49453}:1iFiba:XEyd959zvzoPoZILpAX0eKjA3aY', 
                         `sec-fetch-mode` = "cors", `sec-fetch-site` = "same-origin",
                         `user-agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36",
                         `x-csrftoken` = "xZpNV45ToXJzh9ARj3wJPdOATvSSnPME", `x-ig-app-id` = "936619743392459", `x-ig-www-claim` = "hmac.AR0Q3uCAju1vbb_lgktr6vwsFHCiogfYeKgl6X_dQrvtkx4y",
                         `x-requested-with` = "XMLHttpRequest")
  
  # headers <- headers_list[[i]]
  
  if(k > 1) {
    base_url <- 'https://www.instagram.com/graphql/query/?query_hash=c76146de99bb02f6415203be841dd25a&variables=%7B\"id\"%3A\"'
    rest_url <- '\"%2C\"include_reel\"%3Atrue%2C\"fetch_mutual\"%3Afalse%2C\"first\"%3A50%2C\"after\"%3A\"'
    last_url <- '\"%7D'
    
    url <- paste0(base_url, id, rest_url, after, last_url)
  } else {
    base_url <- "https://www.instagram.com/graphql/query/?query_hash=c76146de99bb02f6415203be841dd25a&variables=%7B%22id%22%3A%22"
    last_url <- "%22%2C%22include_reel%22%3Atrue%2C%22fetch_mutual%22%3Afalse%2C%22first%22%3A100%7D"
    
    url <- paste0(base_url, id, last_url)
  }
  
  req_result <- GET(url, headers)
  req_content <- content(req_result)
  
  end_cursor <- req_content$data$user$edge_followed_by$page_info$end_cursor
  follower_count <- req_content$data$user$edge_followed_by$count
  edges <- req_content$data$user$edge_followed_by$edges
  
  followers_list <- lapply(edges, parser_followers)
  followers_df <- do.call(rbind, followers_list)
  
  result <- list(end_cursor = end_cursor, follower_count = follower_count,
                 followers_df = followers_df)
  
  return(result)
  
}
