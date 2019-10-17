source("R/get_followers.R")

get_followers_total <- function(id) {
  
  # Initializing the values
  k <- 0
  n_followers <- 2
  crawlers_counter <- 1
  cursor <- NULL
  followers <- list()
  initialize_follower(id)
  
  # control the requests number
  t <- 0
  
  # get the fake users data
  fake_users <- read.csv("data/fake_users.csv")[, c("Username", "Pass")]
  
  # select the user to login and crawl
  user <- crawlers_handler(fake_users, crawlers_counter)
  
  # Login with users
  login_status <- login_handler(user$Username, user$Pass)
  if(is.null(login_status$authenticated)) {
    logout()
    login_status <- login_handler(user$Username, user$Pass)
    csrf_token <- follower_csrf()
  } else {
    # Get the csrf token for getting follower service
    csrf_token <- follower_csrf()
  }
  
  # while loop to get all the followers
  while(k < n_followers) {
    
    # get the followers
    res <- get_followers(id = id, after = cursor, k = k, csrf_token = csrf_token)
    
    # check the response of the get_followers service
    if(is.null(res$followers_df)) {
      
      t <- t + 1
      logout()
      crawlers_counter <- crawlers_counter + 1
      
      # select the user to login and crawl
      user <- crawlers_handler(fake_users, crawlers_counter)
      
      # Login with users
      login_status <- login_handler(user$Username, user$Pass)
      
      # Get the csrf token for getting follower service
      csrf_token <- follower_csrf()
      
      if(t %% 10 == 0) {
        Sys.sleep(300)
      }
      
    } else {
      
      k <- k + nrow(res$followers_df)
      followers_df_tem <- res$followers_df
      end_cursor_temp <- res$end_cursor
      n_followers <- res$follower_count
      cursor <- ifelse(is.null(end_cursor_temp), cursor, end_cursor_temp)
      write_followers(id = id, followers_df = followers_df_tem, cursor = cursor, completion_percent = floor((k / n_followers) * 100))
    }
  }
}

