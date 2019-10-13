library(rlang)
library(httr)
library(rvest)
library(stringr)

# Get the csfr token ------------------------------------------------------

url <- "https://www.instagram.com/"
my_session <- try(html_session(url), silent = TRUE)
js_node <- my_session %>% html_nodes("script")
csrf_texts <- js_node[[4]] %>% html_text()
token_start <- str_locate_all(pattern = "csrf_token", csrf_texts)[[1]][2] + 4
csrf_token <- substr(csrf_texts, token_start, token_start + 31)

# Ajax --------------------------------------------------------------------

login_headers <- add_headers(accept = "*/*",
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

res <- POST(
  url = "https://www.instagram.com/accounts/login/ajax/", login_headers,
  body = "enc_password=&optIntoOneTap=false&password=Cd1984!&queryParams=%7B%7D&username=brothycase"
)

status_code(res)
content(res)
detach("package:rvest", unload = TRUE)
detach("package:httr", unload = TRUE)



# Get the followers -------------------------------------------------------

page_url <- "https://www.instagram.com/siirsokaktadir/followers/"
my_follower_session <- try(read_html(page_url), silent = TRUE)
js_node <- my_follower_session %>% html_nodes("script")
csrf_texts <- js_node[[4]] %>% html_text()
token_start <- str_locate_all(pattern = "csrf_token", csrf_texts)[[1]][2] + 4
csrf_token <- substr(csrf_texts, token_start, token_start + 31)

follower_headers <- add_headers(accept = "*/*",
                       `sec-fetch-mode` = "cors",
                       `user-agentt` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36",
                       `x-csrftoken` = csrf_token,
                       `x-ig-app-id` = "936619743392459",
                       `x-ig-www-claim` = "hmac.AR3punfNHLFV2mzFcd-JbL6GZfSUn4Naku6MsKrEGdeNHyZp",
                       `cache-control` = "no-cache",
                       `x-requested-with` = "XMLHttpRequest")

res <- GET(url = "https://www.instagram.com/graphql/query/?query_hash=c76146de99bb02f6415203be841dd25a&variables=%7B%22id%22%3A%22946163646%22%2C%22include_reel%22%3Atrue%2C%22fetch_mutual%22%3Afalse%2C%22first%22%3A12%2C%22after%22%3A%22QVFBdVAzb0JsbHctUFZ1dFVGbDd5YnZKWFZEMnZKZlNPbmhzZFBqSmNvZlFlWUk5NnE3VHBFYUdXVzNtSVdaY3FkMXZGNThDc0ZnMjlTMkRBakhpZEdUMQ%3D%3D%22%7D", follower_headers)

status_code(res)
req <- content(res)
req$data$user$edge_followed_by$edges


# Log out -----------------------------------------------------------------

page_url <- "https://www.instagram.com/brothycase/"
my_follower_session <- html_session(page_url)
js_node <- my_follower_session %>% html_nodes("script")
csrf_texts <- js_node[[5]] %>% html_text()
token_start <- str_locate_all(pattern = "csrf_token", csrf_texts)[[1]][2] + 4
csrf_token <- substr(csrf_texts, token_start, token_start + 31)

logout_headers <- add_headers(origin = "https://www.instagram.com/",
                       `upgrade-insecure-requests` = 1,
                       `content-type` = "application/x-www-form-urlencoded",
                       `user-agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36",
                       `sec-fetch-mode` = "navigate",
                       `sec-fetch-user` = "?1",
                       accept = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
                       `cache-control`= "no-cache")

url <- "https://www.instagram.com/accounts/logout/"
logout_body <- paste0("csrfmiddlewaretoken=", csrf_token)
req <- POST(url = url, logout_headers, body = logout_body)

status_code(req)
html_text(content(req))
