#############interactive map
###################################
library(dplyr)
library(data.table)
library(shiny)
#setwd("/Users/bobminnich/Documents/Columbia/Courses/Applied_Data_Science/project2-group3/doc/map")
#load dataset
request.clean <- read.csv("data/request.clean.csv")
##anaom plot##

df = readRDS("data/full_filtered.RDS")
anaom_df = readRDS("data/Anamolies.RDS")
d = readRDS("data/b.RDS")
##bar chart####
pus=readRDS("data/pus.RDS")
react<-readRDS("data/react.RDS")
####################word cloud
##################################
library(wordcloud)
df.smaller =read.csv('data/smaller.csv')
word_fre <- read.csv("data/word_fre.csv")

#aa = filter(df, df$Date  "2016-02-16" & df$Date >= "2014-09-01")
#aaa=df[,c("Complaint.Type","Date")]
#saveRDS(aaa,"full_filtered.RDS" )
#df = filter(df[,c("Complaint.Type","Date")], 'Date' < "2016-02-16" & 'Date' >= "2014-09-01")
#dff=readRDS("/Users/sunxiaohan/.Trash/project2-group3/data/full_filtered.rds")
#df.smaller = dff[sample(nrow(df),100),]
#saveRDS(df.smaller,"smaller.RDS" )
#write.csv(df.smaller,'data/smaller.csv')
