source("R/utils.R")
source("R/headers_handler.R")

get_followers <- function(id, after, k, csrf_token) {
  
  # set the headers of follower request
  headers <- add_headers(accept = "*/*",
                         `sec-fetch-mode` = "cors",
                         `user-agentt` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36",
                         `x-csrftoken` = csrf_token,
                         `x-ig-app-id` = "936619743392459",
                         `x-ig-www-claim` = "hmac.AR3punfNHLFV2mzFcd-JbL6GZfSUn4Naku6MsKrEGdeNHyZp",
                         `cache-control` = "no-cache",
                         `x-requested-with` = "XMLHttpRequest")
  
  # Check if this is the first request to get the followers
  if(k > 1) {
    
    # set the url params
    base_url <- 'https://www.instagram.com/graphql/query/?query_hash=c76146de99bb02f6415203be841dd25a&variables=%7B\"id\"%3A\"'
    rest_url <- '\"%2C\"include_reel\"%3Atrue%2C\"fetch_mutual\"%3Afalse%2C\"first\"%3A50%2C\"after\"%3A\"'
    last_url <- '\"%7D'
    
    url <- paste0(base_url, id, rest_url, after, last_url)
    
  } else {
    
    # set the url params for first request without any after parameter
    base_url <- "https://www.instagram.com/graphql/query/?query_hash=c76146de99bb02f6415203be841dd25a&variables=%7B%22id%22%3A%22"
    last_url <- "%22%2C%22include_reel%22%3Atrue%2C%22fetch_mutual%22%3Afalse%2C%22first%22%3A100%7D"
    
    url <- paste0(base_url, id, last_url)
  }
  
  # request the followers list
  req_result <- GET(url, headers)
  req_content <- content(req_result)
  
  # Get the outputs of the request
  end_cursor <- req_content$data$user$edge_followed_by$page_info$end_cursor
  follower_count <- req_content$data$user$edge_followed_by$count
  edges <- req_content$data$user$edge_followed_by$edges
  
  # Prepare the result of the function in list format
  followers_list <- lapply(edges, parser_followers)
  followers_df <- do.call(rbind, followers_list)
  
  result <- list(end_cursor = end_cursor, follower_count = follower_count,
                 followers_df = followers_df)
  
  return(result)
  
}
