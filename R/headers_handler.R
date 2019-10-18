# Get login csrf token ----------------------------------------------------

login_csrf <- function() {
  url <- "https://www.instagram.com/"
  my_session <- html_session(url)
  js_node <- my_session %>% html_nodes("script")
  csrf_texts <- js_node[[4]] %>% html_text()
  token_start <- str_locate_all(pattern = "csrf_token", csrf_texts)[[1]][2] + 4
  csrf_token <- substr(csrf_texts, token_start, token_start + 31)
  return(csrf_token)
}


# login -------------------------------------------------------------------

login_handler <- function(user_name, password) {
  
  # get the csrf token to login
  csrf_token <- login_csrf()
  
  # set the headers of request
  headers <- add_headers(accept = "*/*",
                         origin = "https://www.instagram.com",
                         `content-type` = "application/x-www-form-urlencoded",
                         `sec-fetch-mode` = "cors",
                         `user-agentt` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36",
                         `x-csrftoken` = csrf_token,
                         `x-ig-app-id` = "936619743392459",
                         `x-ig-www-claim` = "hmac.AR3punfNHLFV2mzFcd-JbL6GZfSUn4Naku6MsKrEGdeNH4EE",
                         `x-instagram-ajax` = "3444e1451bad",
                         `cache-control` = "no-cache",
                         `x-requested-with` = "XMLHttpRequest")
  
  # set the body of the request
  login_body <- paste0("enc_password=&optIntoOneTap=false&password=", password, "&queryParams=%7B%7D&username=", user_name)
  
  # POST request to get login
  req <- POST(url = "https://www.instagram.com/accounts/login/ajax/", headers, body = login_body)
  
  
  res <- content(req)
  req <- NULL
  return(res)
}



# Crawlers handler --------------------------------------------------------

crawlers_handler <- function(crawlers_df, user_num) {
  
  n <- nrow(crawlers_df)
  counter <- user_num %% n
  crawler <- crawlers_df[counter, ]
  return(crawler)
}


# Logout ------------------------------------------------------------------

logout <- function() {
  detach("package:rvest", unload = TRUE)
  detach("package:httr", unload = TRUE)
  library(httr)
  library(rvest)
}



# Get follower csrf token -------------------------------------------------

follower_csrf <- function() {
  
  url <- "https://www.instagram.com/pooyahch/followers/"
  my_follower_session <- html_session(url)
  js_node <- my_follower_session %>% html_nodes("script")
  csrf_texts <- js_node[[4]] %>% html_text()
  token_start <- str_locate_all(pattern = "csrf_token", csrf_texts)[[1]][2] + 4
  csrf_token <- substr(csrf_texts, token_start, token_start + 31)
  return(csrf_token)
}




