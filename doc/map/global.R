#############interactive map
###################################
library(dplyr)

#load dataset
request.clean <- read.csv("request.clean.csv")
##anaom plot##
df = readRDS("data/full_filtered.rds")
anaom_df = readRDS("data/Anamolies.RDS")
d = readRDS("data/b.RDS")
##bar chart####
pus=readRDS("data/pus.RDS")
react<-readRDS("data/react.RDS")
reaction_meadian <- filter(react, react$"i" == "10025")
####################word cloud
##################################
library(tm)
library(wordcloud)
library(memoise)

word_fre <- read.csv("word_fre.csv")