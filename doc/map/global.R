#############interactive map
###################################
library(dplyr)

#load dataset
request.clean <- read.csv("/Users/sunxiaohan/Desktop/map/request.clean.csv")

####################word cloud
##################################
library(tm)
library(wordcloud)
library(memoise)

  getTermMatrix <- memoise(function(book) {
    text=request.clean$type
    
    myCorpus = Corpus(VectorSource(text))
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    myCorpus = tm_map(myCorpus, removeWords,
                      c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
    
    myDTM = TermDocumentMatrix(myCorpus,
                               control = list(minWordLength = 1))
    
    m = as.matrix(myDTM)
    
    sort(rowSums(m), decreasing = TRUE)
  })

