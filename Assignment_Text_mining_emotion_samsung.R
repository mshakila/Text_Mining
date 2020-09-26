########## Assignment Text Mining - Emotion Mining of Samsung reviews 

## Loading required packages
library("syuzhet")
library(lubridate,ggplot2)
library(ggplot2)
library(scales)
library(dplyr)
library(reshape2)

# Samsung review dataset
txt = readLines("E:\\Text Mining\\samsung.txt")
txt <- iconv(txt, "UTF-8") # converting to standard format
txt[1:5]
class(txt)


#get sentences for every review
example<-get_sentences(txt) 
example[1:5] 
nrc_data<-get_nrc_sentiment(example) # for each sentence apply nrc-sentiment
example[1:5]
nrc_data[1:5,]

# Bar plot for emotion mining
windows()
barplot(colSums(nrc_data), las = 1, col = rainbow(10), ylab = 'Count', main = 'Emotion scores')
# we see that the reviews are more of positive sentiments and very less of negative sentiments

# We have sentiments from various dictionaries: NRC, AFINN and BING
sentiment_bing<-get_sentiment(example,method="bing")
sentiment_afinn<-get_sentiment(example,method="afinn")
sentiment_nrc<-get_sentiment(example,method="nrc")

sum(sentiment_bing)
mean(sentiment_bing)
summary(sentiment_bing)

sum(sentiment_afinn)
mean(sentiment_afinn)
summary(sentiment_afinn)

sum(sentiment_nrc)
mean(sentiment_nrc)
summary(sentiment_nrc)
# the mean and range of emotions using Bing method is the least compared to the other two
# afinn method has the highest sum, mean and range

# Plotting barplot for the emotions
windows()
plot(sentiment_bing,type='l',main='Plot trajectory',xlab='Narative time',ylab='Emotional valence')
abline(h=0,color='red')
# most are above zero line, positive values

# Getting smooth curve
##Shape smoothing and normalization using a Fourier based transformation and low pass filtering is achieved using the get_transformed_values function as shown below.
ft_values <- get_transformed_values(
  sentiment_bing, 
  low_pass_size = 3, 
  x_reverse_len = 100,
  padding_factor = 2,
  scale_vals = TRUE,
  scale_range = FALSE
)

plot(
  ft_values, 
  type ="l", 
  main ="Nokia lumia reviews using Transformed Values", 
  xlab = "Narrative Time", 
  ylab = "Emotional Valence", 
  col = "red"
)
# using fourier transform we have obtained a smooth curve. from this we can find that
# over a period of time, the reviews have changed from more negative to more positive
# to less positive and in the end again more negative. But for a great extent the 
# emotions are positive

#Most Negative and Positive reviews
negative<-example[which.min(sentiment_nrc)]
negative 
# "\"less ram, rom and battery life is a big problem..\""
# the above sentence is considered as the most negative review using nrc

example[which.min(sentiment_bing)]
#  "I have never suffered any problem in the phone till now.
# this sentence is positive but bing method has put it in negative emotion due to the
# word 'never'

positive<-example[which.max(sentiment_nrc)]
positive
# "\"I am happy to share my review that I received a good working and all proper phone."
# the above sentence is considered as the most positive review using nrc


'''
CONCLUSIONS :

We have done emotion mining using the samsung reviews. 

We find that most of the customers share positive emotions about this product.
'''
###################################################################################




