########## ASSIGNMENT TEXT MINING - IMDB website - Dil Bechara (2020)
### Web scraping and extracting details

### 
'''
BUSINESS PROBLEM : 
To get the details of the movie like its title, summary, rating, cast
To get the names of other movies and serials of the actors 
'''


url <- "https://www.imdb.com/title/tt8110330/?ref_=ttexrv_exrv_tt"

title<- read_html(url) %>% html_nodes("h1") %>% html_text()
title <- trimws(title)
rating <- read_html(url) %>% html_nodes("strong span") %>% html_text()
summary <- read_html(url) %>% html_nodes(".summary_text") %>% html_text()
summary <- trimws(summary)
cast <- read_html(url) %>% html_nodes('.primary_photo+ td a') %>% html_text()
cast <- trimws(cast)

title
rating
summary
cast

### other Movies of actors/actresses (who worked in Dil Bechara)
new <- list()
s <- html_session("https://www.imdb.com/title/tt8110330/?ref_=ttexrv_exrv_tt")

for (i in cast[1:15]){
  page <- s %>% follow_link(i) %>% read_html()
  new[[i]] <- page %>% html_nodes("b a") %>% html_text()
}

new[[1]] # Sushant Singh Rajput Movie list
new[[7]] # Saif Ali Khan movie list
# similarly we can get the movies/serials of top 15 cast members of 'Dil-bechara' movie

'''
CONCLUSIONS
We have visited the imdb website and scraped the movie "Dil Bechara (2020).
We have obtained the details of the movie like name, movie rating, the actors and
actresses, and movie summary.

We have also obtained movie list of 15 cast members.
'''
