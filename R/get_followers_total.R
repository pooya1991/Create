source("R/get_followers.R")

get_followers_total <- function(id) {
  k <- 1
  t <- 0
  n_followers <- 2
  end_cursor <- NULL
  followers <- list()
  while(k < n_followers) {
    res <- get_followers(id = id, after = end_cursor, k = k)
    followers_df_tem <- res$followers_df
    end_cursor <- res$end_cursor
    n_followers <- res$follower_count
    if(is.null(res$followers_df)) {
      k <- k + 1
    } else {
      k <- k + nrow(res$followers_df)
    }
    t <- t + 1
    followers[[t]] <- res$followers_df
    if(t %% 900 == 0) {
      Sys.sleep(900)
    }
  }
  followers_total <- do.call(rbind, followers)
  return(followers_total)
}

