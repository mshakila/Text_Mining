#### ASSIGNMENT TWITTER a/c of the Rock and Sentiment Analysis

'''
Business problem:  
1. To extract tweets - extracted tweets of theRock
2. To perform sentiment analysis on these tweets
'''
### Loading libraries 
library("twitteR")
library("ROAuth")
library(base64enc)
library(httpuv)

cred <- OAuthFactory$new(consumerKey='FXTquJNbgDG2dH81XYVqNZFAb', # Consumer Key (API Key)
                         consumerSecret='3y0ALNFzJ8JKyxzFd0ba9FWSUpNSWhPisEIZOB6WCTtcGvP6SO', #Consumer Secret (API Secret)
                         requestURL='https://api.twitter.com/oauth/request_token',
                         accessURL='https://api.twitter.com/oauth/access_token',
                         authURL='https://api.twitter.com/oauth/authorize')

save(cred, file="twitter authentication.Rdata")

load("twitter authentication.Rdata")

setup_twitter_oauth("FXTquJNbgDG2dH81XYVqNZFAb", # Consumer Key (API Key)
                    "3y0ALNFzJ8JKyxzFd0ba9FWSUpNSWhPisEIZOB6WCTtcGvP6SO", #Consumer Secret (API Secret)
                    "529590041-qOXLd769cQEUTbXg3iRqCd33pC1K6xoORrGOMJDh",  # Access Token
                    "WlqZJwXFQzf64IuojkbKh1jdT5cnSY8U44pqmz6Sc1d4A")  #Access Token Secret

#registerTwitterOAuth(cred)

# Extracting tweets of Irrfan Khan - got very few tweets
Tweets_irfank <- userTimeline('irrfank', n = 1000,includeRts = T) # includeRts=T
TweetsDF <- twListToDF(Tweets_irfank)
dim(TweetsDF) # 104 tweets only obtained
View(TweetsDF)
write.csv(TweetsDF, "E:\\Text Mining\\Tweets_irfank.csv",row.names = F)

# Extracting tweets of Sushant Singh Rajput ( now managed by Team) - got a few tweets
Tweets_ssrTeam <- userTimeline('Team_SushantSR', n=1000, includeRts = T) # 
TweetsDF <- twListToDF(Tweets_ssr)
dim(TweetsDF) # # 262 tweets only obtained
View(TweetsDF) 
write.csv(TweetsDF, "E:\\Text Mining\\Tweets_ssrTeam.csv", row.names = F)

# Extracting tweets of Dwayne Johson aka the Rock - got many tweets hence did
# further analysis on his tweets
Tweets_rock <- userTimeline('TheRock', n = 1000,includeRts = T) # includeRts=T
TweetsDF <- twListToDF(Tweets_rock)
dim(TweetsDF) # 997 tweets with 16 columns
View(TweetsDF)
write.csv(TweetsDF, "E:\\Text Mining\\Tweets_Rock.csv",row.names = F)

# Let us now do Sentiment Analysis on the tweets of THE-ROCK
# The Rock is ring name of Dwayne Johnson. He is a wrestler, a football player and now an actor

rock_txt <- read.csv("E:\\Text Mining\\Tweets_Rock.csv", header = TRUE)

str(rock_txt)
View(rock_txt)
length(rock_txt) # 16 variables
class(rock_txt)
x <- as.character(rock_txt$text)
class(x)
length(x) # 997 reviews have been obtained
# x <- iconv(x, "UTF-8") # converting all to standard format for R to understand

# Corpus
install.packages("tm")
library(tm)

x <- Corpus(VectorSource(x))

inspect(x[1:3])
inspect(x[996:997])

################# Data Cleansing
# Remove URL's from corpus

removeURL <- content_transformer(function(z) gsub("(f|ht)tp(s?)://\\S+", "", z, perl=T))
x1 <- tm_map(x, removeURL) 
inspect(x[1:3])
inspect(x1[1:3]) # as can be seen urls are removed

# to convert to lower, remove punctuations, numbers, stopwords
x1 <- tm_map(x1, tolower)
inspect(x1[1])

x1 <- tm_map(x1, removePunctuation)
inspect(x1[1])

x1 <- tm_map(x1, removeNumbers)
inspect(x1[1])

x1 <- tm_map(x1, removeWords, stopwords('english'))
inspect(x1[1])

library(textstem)
inspect(x1[15])
lemmatize_words(list("run","running","ran"))
x1 <- lemmatize_words(x1) # get root word
inspect(x1[1])

# removing other words which are names of D.Johson
x1 <- tm_map(x1, removeWords, c("therock","rock","dwayne","johnson"))

x1 <- tm_map(x1, stripWhitespace)
inspect(x1[1])

# converting unstructured data to structured format
tdm <- TermDocumentMatrix(x1)
tdm
class(tdm)
# terms: 3765, documents: 997
# Non-/sparse entries: 9945/3743760

m <- as.matrix(tdm)
class(m)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word=names(v), freq=v)
head(d,10) # top 10 words
head(d,20)
# the top frequency word used by the Rock is 'thank'. when we look at this word in
# original file we find that he is thanking people for their posts, etc
# second top-most word is Teremana. Rock is the founder of this tequila and he tweets 
# many a times about it.

# Barplot
w <- rowSums(m)
w_sub <- subset(w, w>=30)
barplot(w_sub, las=3, col=rainbow(30))

# building word cloud
library(wordcloud)
library(RColorBrewer)
par(bg="grey")

png(file="WordCloud.png",width=1000,height=700, bg="grey")
wordcloud(words = d$word, freq = d$freq,min.freq = 1, random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))

wordcloud(words=names(w), freq=w, min.freq=1,random.order=F, colors=rainbow(20), rot.per=0.3)

library(wordcloud2)
wordcloud2(d, size = 0.7)

'''
CONCLUSIONS:
We have extracted the tweets of Dwayne Johnson, famously called the-Rock. We have 
done pre-processing and built word cloud using the cleaned data.

We have plotted bargraph of top terms he has used in his tweets. 
We have also extracted tweets of Irrfan Khan and Sushant Singh Rajput. 

'''
