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


