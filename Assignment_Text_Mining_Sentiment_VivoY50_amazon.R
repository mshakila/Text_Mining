############### ASSIGNMENT TEXT MINING - Extracting Reviews and Sentiment Analysis
### Extracting Reviews from flipkart on Tecno Camon 15 mobile phone
### Extracting Reviews from amazon on VivoY50 mobile phone and perform Sentiment Analysis

'''
Business problem:  
1. To extract reviews of tecno-camon-15 mobile from flipkart website
2. To extract reviews of VivoY50 mobile from amazon website
2. To perform sentiment analysis on VivoY50 reviews
'''

# Importing required libraries
library(rvest)
library(XML)
library(magrittr)

### Extracting Reviews from flipkart on Tecno Camon 15 mobile phone

flipkart_url <- "https://www.flipkart.com/tecno-camon-15-fascinating-purple-64-gb/product-reviews/itmbff3887612ff8?pid=MOBFPYCGJZHNGGCD&lid=LSTMOBFPYCGJZHNGGCDSCS8OO&marketplace=FLIPKART"

flipkart_reviews <- NULL

for (i in 1:20){
  page_url <- read_html(as.character(paste(flipkart_url,i,sep = "=")))
  read_url <- page_url %>% html_nodes(".qwjRop div") %>% html_text()
  flipkart_reviews <- c(flipkart_reviews, read_url)
}
length(flipkart_reviews)
setwd("E:\\Text Mining")
write.table(flipkart_reviews, "tecnoCamon15_flipkart",row.names = F)

### Extracting Reviews from amazon on VivoY50 mobile phone and perform Sentiment Analysis

url1 <- "https://www.amazon.in/product-reviews/B086KDZGTZ/ref=cm_cr_getr_d_paging_btm_next_3?ie=UTF8&filterByStar=all_stars&reviewerType=all_reviews&sortBy=recent&pageNumber="
url2 <- "#reviews-filter-bar"

vivo_reviews <- NULL
for (i in 1:20){
  webpage_to_xml <- read_html(as.character(paste(url1,url2,sep=as.character(i))))
  webpage_extract <- webpage_to_xml %>% html_nodes(".review-text-content span") %>% html_text()
  vivo_reviews <- c(vivo_reviews, webpage_extract)
}
write.table(vivo_reviews, "E:\\Text Mining\\vivoY50.txt", row.names = F) # got 193 reviews

# Now we have extracted reviews. lets do some pre-processing before doing analysis

# install / load required libraries
library(tm) # for text mining
install.packages("wordcloud2")
library(wordcloud2) # to build word cloud
library(wordcloud) # word cloud generator
library(SnowballC) # for text stemming or lemmatization
library(textstem) # for text stemming or lemmatization
library(RColorBrewer) # for color palettes  

# Importing Vivo reviews data
vivo <- read.csv("E:\\Text Mining\\vivoY50.txt")
class(vivo) # now its a dataframe

x <- as.character(vivo$x) # converting the first column to character
class(x) # from dataframe converted to character type
x <- iconv(x, "UTF-8") # some special characters may not be understood by r.
# so converting all to UTF-8 which is a standard format, so can understand it

# loading the data as a corpus
x <- Corpus(VectorSource(x))
inspect(x[13:16])

x1 <- tm_map(x, tolower) # converting to lower case
inspect(x1[13:16])
x1 <- tm_map(x1, removeNumbers) # removing  numbers
x1 <- tm_map(x1, removePunctuation) # removing punctuations

x1 <- tm_map(x1, removeWords, stopwords('english')) # removing stopwords
x1 <- tm_map(x1, stripWhitespace)
x1 <- lemmatize_words(x1) # text stemming
inspect(x1[13:16])
# x1 <- tm_map(x1, stemDocument)

#### Term Document Matrix
## Converting unstructured data to structured format using TDM
tdm <- TermDocumentMatrix(x1)
class(tdm)
tdm <- as.matrix(tdm) # getting 99395 elements
class(tdm) # now converted from TDM to matrix form

# frequency
v <- sort(rowSums(tdm), decreasing = TRUE)
d <- data.frame(word=names(v) , freq=v)
head(d, 10) # top-ten words
head(d,30)

## barplot
w <- rowSums(tdm)
w_sub <- subset(w, w>=5)
barplot(w_sub, las=3, col=rainbow(20))

x1 <- tm_map(x1, removeWords, c("vivo","phone","product","mobile","amazon")) # removing other common  words
x1 <- tm_map(x1, stripWhitespace)


tdm <- TermDocumentMatrix(x1)
tdm <- as.matrix(tdm)  
w1 <- rowSums(tdm)
w_sub1 <- subset(w1, w>=8)
barplot(w_sub1, las=3, col=rainbow(30))

v1 <- sort(rowSums(tdm), decreasing = TRUE)
d1 <- data.frame(word=names(v1) , freq=v1)
head(d1,30)

## word cloud
# with all the words
wordcloud(words=names(w1), freq=w1, random.order=F, colors=rainbow(20), rot.per=0.3)
# wordcloud(words=names(w1), freq=w1, random.order=F, colors=rainbow(20), scale=c(2,.2), rot.per=0.3)
'''
The word GOOD has occured most number of times, this shows many users have liked the 
product. But we should also know in which context the word is actually used
Lets see an example, the word SAMSUNG has been used 4 times. In vivo phone reviews,
why are they talking about samsung phone, Below are the 4 reviews with word SAMSUNG:
1. It is better to go with Samsung exynos  or Xiaomi 8 pro or 9 pro
2. Nice phone look is so goodVivo y50 is 10 time better then samsung m31
3. One of the waste mobile  had ever seen in my life...sticking like samsung.waste product.sorry.
4. I have purchased this mobile due non-availability of Samsung mobile
Two reviews say samsung is better, one says vivo is better, one review says vivo is as bad as samsung

#### To visualize positive and negative words separately in the reviews
### Loading positive and negative dictionaries
#### time 25-5-2020  45:04 
'''

pos.words <- scan(file.choose(), what="character",comment.char=";") # reads from the file positive-words.txt
neg.words <- scan(file.choose(), what="character",comment.char = ";") # reads from the file negative-words.txt
pos.words <- c(pos.words,"wow","kudos","hurray") # including our own positive words

# Positive word cloud
pos.matches <- match(names(w1), c(pos.words))
pos.matches <- !is.na(pos.matches)
freq_pos_words <- w1[pos.matches]
freq_pos_words
names_freq_pos_words <- names(freq_pos_words)
wordcloud(names_freq_pos_words, freq_pos_words, colors=rainbow(20))
# wordcloud(names_freq_pos_words, freq_pos_words, colors=rainbow(20),scale=c(3.5,.2))

neg.matches <- match(names(w1), c(neg.words))
neg.matches <- !is.na(neg.matches)
freq_neg_words <- w1[neg.matches]
freq_neg_words
names_freq_neg_words <- names(freq_neg_words)
wordcloud(names_freq_neg_words, freq_neg_words, colors=brewer.pal(8,"Dark2"))

## Association between words
# find words that are highky correlated with other words
tdm <- TermDocumentMatrix(x1)
findAssocs(tdm, c("bad"), corlimit =0.30)
findAssocs(tdm, c("battery"), corlimit =0.30)
findAssocs(tdm, c("good"), corlimit =0.30)
findAssocs(tdm, "worst", corlimit = 0.3)

'''
CONCLUSIONS
We have scraped the amazon website and obtained reviews of VivoY50 mobile. 
We have also scraped the flipkart website and obtained reviews of tecno camon 15 mobile. 

Later we have used vivo reviews for further analysis.
We have pre-processed the data. We have then found the top-ten words used in the reviews.

We have built Term-document-matrix and constructed the word cloud. We have also built
the positive and negative word clouds.

We have also tried to find the association between some frequently occuring words 
to understand the customers" view point.
'''
