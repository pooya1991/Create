library(readxl)
library(httr)
library(dplyr)

crawlers_header <- read_xlsx("data/list_header_ali.xlsx", col_types = "text")

headers_list <- list()

n <- nrow(crawlers_header)
for (i in 1:n) {
  heads <- crawlers_header[i, ]
  headers_list[[i]] <- add_headers(`accept` = "*/*", `accept-encoding` = "gzip, deflate, br", `accept-language` = "en-US,en;q=0.9", 
                                   `cookie` = paste0('ig_cb=1; mid=', heads$mid, '; fbm_124024574287414=base_domain=.instagram.com; csrftoken=', heads$csrftoken, '; shbid=', heads$shbid, '; shbts=', heads$shbts, '; ds_user_id=', heads$ds_user_id, '; sessionid=', heads$sessionid, '; rur=', heads$rur, '; urlgen=', heads$urlgen), 
                                   `sec-fetch-mode` = "cors", `sec-fetch-site` = "same-origin",
                                   `user-agent` = heads$`user-agent`,
                                   `x-csrftoken` = heads$`x-csrftoken`, `x-ig-app-id` = heads$`x-ig-app-id`, `x-ig-www-claim` = heads$`x-ig-www-claim`,
                                   `x-requested-with` = "XMLHttpRequest")
}

headers <- add_headers(`accept` = "*/*", `accept-encoding` = "gzip, deflate, br", `accept-language` = "en-US,en;q=0.9", 
                       `cookie` = 'ig_cb=1; mid=XYZzPQAEAAHRSJsI6bHlLVQIdu5N; fbm_124024574287414=base_domain=.instagram.com; csrftoken=aymuHN3T5Bx6uxjWcyLiJimjviQBqJGi; shbid=1590; shbts=1570029676.9215505; ds_user_id=1275316459; sessionid=1275316459%3AkjsYHPYuQd5zDZ%3A3; rur=FRC; urlgen="{\"5.160.53.194\": 42337\054 \"134.19.177.25\": 49453}:1iFgRu:djOlA_spjxURTIjw6bd_SmQDs-o"', 
                       `sec-fetch-mode` = "cors", `sec-fetch-site` = "same-origin",
                       `user-agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36",
                       `x-csrftoken` = "aymuHN3T5Bx6uxjWcyLiJimjviQBqJGi", `x-ig-app-id` = "936619743392459", `x-ig-www-claim` = "hmac.AR2MQ0ZinmSffUgr0FOTX3PLoUJoO6PoMnWkUSx8E5kfdIDJ",
                       `x-requested-with` = "XMLHttpRequest")
