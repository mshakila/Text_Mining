########## ASSIGNMENT TEXT MINING - IMDB website - Dil Bechara (2020)

### BUSINESS PROBLEM : 1) Extract movie reviews for any movie from IMDB and 
# perform sentiment analysis

# Importing libraries
import pandas as pd
import re  # library to clean data  
import nltk  # Natural Language Tool Kit 
nltk.download('stopwords')   
from nltk.corpus import stopwords # to get stopwords so that they can be later removed 

# importing libraries to extract reviews
from selenium import webdriver
browser = webdriver.Chrome("C:/Users/Admin/Downloads/chromedriver.exe")
from bs4 import BeautifulSoup as bs

page = "https://www.imdb.com/title/tt8110330/reviews?ref_=tt_ql_3"
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import ElementNotVisibleException
browser.get(page)
import time
reviews = []
i=1
while (i>0):
    #i=i+25
    try:
        button = browser.find_element_by_xpath('//*[@id="load-more-trigger"]')
        button.click()
        time.sleep(5)
        ps = browser.page_source
        soup=bs(ps,"html.parser")
        rev = soup.findAll("div",attrs={"class","text"})
        reviews.extend(rev)
    except NoSuchElementException:
        break
    except ElementNotVisibleException:
        break

len(reviews) # 15725
len(list(set(reviews))) # 872
     
# removing duplicates
new_reviews = list(set(reviews))
len(new_reviews) # 872
##### If we want only few recent reviews you can either press cntrl+c to break the operation in middle but the it will store 
##### Whatever data it has extracted so far #######


with open("E:\Text Mining\dil_bechara.txt","w",encoding='utf8') as output:
    output.write(str(new_reviews))

dil_bechara_rev = pd.read_csv("E:\Text Mining\dil_bechara.txt", header=None, names=["review"]) # showing 540 reviews
dil_bechara_rev.dtypes

# Normalization of data - data cleaning  
review = re.sub('[^a-zA-Z<>\/]', ' ', str(dil_bechara_rev['review'])) # removing unwanted symbols
review = re.sub('[0-9]+', " ",review) # removing numbers
review = review.lower()
review = review.split()

review = [w for w in review if not w in set(stopwords.words('english'))]
removable_words = ["sushant","sushanth","rajput","review","reviews","div",
                   "class","text","show","more","control","clickable",
                   "clickabl","ssr","singh","<div","</div>","dtype","object"]
review = [w for w in review if not w in removable_words]

review = ' '.join(review) # Joinining all the reviews into single paragraph 

# Word cloud

import matplotlib.pyplot as plt
%matplotlib qt
# in anaconda prompt : conda install -c conda-forge wordcloud
from wordcloud import WordCloud
wordcloud_ip = WordCloud(
                      background_color='black',
                      width=1800,
                      height=1400
                     ).generate(review)

plt.imshow(wordcloud_ip)
''' The audience talk mostly about Sushant Singh Rajput, that he will always
be with us, about his powerful performance and about good direction
'''

'''
CONCLUSIONS :
We have scraped the data from the imdb website. The movie details scraped
are "DIL BECHARA (2020) of Sushant Singh Rajput. 
After scraping the data we have cleaned it and plotted a wordcloud.
We have tried to get the sentiments of people/ audience about the movie
and also sentiments about the main protagonist of the movie .
'''








