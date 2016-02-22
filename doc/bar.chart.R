pus=readRDS("pus.RDS")
zip11694 <- filter(pus, pus$"Incident Zip" == 11694 & pus$Created_Month== "02")

##check how many type of complaint
length(unique(zip11694$`Complaint Type`))


table(zip11694$`Complaint Type`)

dfzip11694 = as.data.frame(ftable(zip11694$`Complaint Type`))

pickmaxtype=filter(dfzip11694, dfzip11694$Freq == max(dfzip11694$Freq))

# Add Descriptor type for the max complaint type
dzip11694=filter(zip11694, zip11694$"Complaint Type" == as.character(pickmaxtype$Var1))

Descriptor_zip11694 = as.data.frame(ftable(dzip11694$`Descriptor`))

##slect top 10 complaint type(good one)
topdfzip11694=head(arrange(dfzip11694,desc(Freq)), n = 10)

##slect top 5 Descriptor(good one)
topDes_dfzip11694=head(arrange(Descriptor_zip11694,desc(Freq)), n = 5)



Complaintplot11694<-ggplot(data=topdfzip11694, aes(x=Var1, y=Freq, fill=Var1)) +
  geom_bar(colour="black", stat="identity") +
  xlab("Complaint Type") + 
  ylab("Count") + 
  ggtitle("Complaint Type Count");Complaintplot11694

Descriptor11694<-ggplot(data=topDes_dfzip11694, aes(x=Var1, y=Freq, fill=Var1)) +
  geom_bar(colour="black", stat="identity") +
  xlab("Descriptor Type") + 
  ylab("Count") + 
  ggtitle("Descriptor Count"); Descriptor11694