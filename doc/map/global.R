#############interactive map
###################################
library(dplyr)

#load dataset
request_short <- read.csv("~/Desktop/project2/311_Service_Requests_from_2010_to_Present.csv")
request_short$Latitude=jitter(request_short$Latitude)
request_short$Longitude=jitter(request_short$Longitude)

request.clean=request_short%>%
  select(
    latitude=Latitude,
    longitude=Longitude,
    zipcode=Incident.Zip,
    type=Complaint.Type
  )
request.clean=na.omit(request.clean)


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

