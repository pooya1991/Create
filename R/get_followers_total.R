source("R/get_followers.R")

get_followers_total <- function(id) {
  k <- 0
  t <- 0
  n_followers <- 2
  end_cursor <- NULL
  cursors <- vector()
  followers <- list()
  while(k < n_followers) {
    res <- get_followers(id = id, after = end_cursor, k = k)
    if(is.null(res$followers_df)) {
      Sys.sleep(1)
    } else {
      k <- k + nrow(res$followers_df)
      followers_df_tem <- res$followers_df
      end_cursor <- res$end_cursor
      n_followers <- res$follower_count
      t <- t + 1
      cat(k / n_followers)
      cursors[t] <- ifelse(is.null(end_cursor), 0, end_cursor)
      followers[[t]] <- res$followers_df
      if(t %% 200 == 0) {
        Sys.sleep(10)
      }
    }
  }
  followers_total <- do.call(rbind, followers)
  followers_total <- unique(followers_total)
  return(followers_total)
}

