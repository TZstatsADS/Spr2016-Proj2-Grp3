library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(data.table)
library(plotrix)
library(ggplot2)
library(RColorBrewer)
#library(gridExtra)

shinyServer(function(input, output, session) {

  ## Interactive Map ###########################################

  col=c('darkred','yellow','red','darkseagreen','deepskyblue','khaki','lightgreen',
        'orange','gold','purple')
  #pal <- colorFactor(col, domain = var)
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -73.958, lat = 40.801453, zoom = 12)
    #Columbia 
    #40.807747, -73.962954
    #40.801453, -73.951850
  })
  
  
  observe({
    
    var=c( "Street Condition","HEAT/HOT WATER"='Heat/Hot Water' ,
           "Illegal Parking","Blocked Driveway",
          "UNSANITARY CONDITION"='Unsanitary Condition',
          "Street Light Condition","PAINT/PLASTER"='Paint/Plaster',
          "PLUMBING"='Plumbing',"Sewer","Noise")
    pal <- colorFactor(col, domain = var)
    
    
    leafletProxy("map", data = request.clean) %>%
      clearShapes() %>%
      addCircles(~longitude, ~latitude, radius=80, 
                 stroke=FALSE, fillOpacity=0.4,color=~pal(type),popup=request.clean$type) %>%
      addLegend("bottomright", pal = pal, values = ~type,
                title = "Request Type",
                opacity = 1
      )
  })
 
  #####anaom_plotter#######################
  #####anaom_plotter#######################
  output$anaom_plot<-renderPlot({
    
    
    
    df$Complaint.Type[df$Complaint.Type == "HEATING"] = "HEAT/HOT WATER"
    
    end_date <- as.Date(switch(input$date,
                               "Jan"="2015-01-31",
                               "Feb"="2015-02-28",
                               "Mar"="2015-03-31",
                               "Apr"="2015-04-30",
                               "May"="2015-05-31",
                               "Jun"="2015-06-30",
                               "Jul"="2015-07-31",
                               "Aug"="2015-08-31",
                               "Sept"="2015-09-30",
                               "Oct"="2015-10-31",
                               "Nov"="2015-11-30",
                               "Dec"="2015-12-31"))
    
    month<-switch(input$date,
                  "Jan"=1,
                  "Feb"=2,
                  "Mar"=3,
                  "Apr"=4,
                  "May"=5,
                  "Jun"=6,
                  "Jul"=7,
                  "Aug"=8,
                  "Sept"=9,
                  "Oct"=10,
                  "Nov"=11,
                  "Dec"=12)
    
    Complaints_Month_filtered = filter(d, Month == month & Year == "2015")
    test = group_by(Complaints_Month_filtered, Complaints, count = sum(Counts))
    #                         grop_by.Complaint.Type <- group_by(Complaints_Month_filtered["Complaints", "Created.Date"], Complaint.Type)
    #                         Complaint.Type <- summarize(grop_by.Complaint.Type,count = n())
    #                         
    #                         print(Complaints_Month_filtered)
    #                         Filter_Index = order(Complaint.Type$count, decreasing = TRUE)
    #                         print(Filter_Index)
    #                         Complaint.Type_filtered = Complaints_Month_filtered[Filter_Index[1:10],]
    
    complaint_list = c("PAINT - PLASTER" ,"HEAT/HOT WATER" ,"Blocked Driveway")
    
    
    Filter_Index = order(test$count, decreasing = TRUE)
    #print(Filter_Index)
    Unique_Complaints = as.character(test$Complaints)
    #print(Unique_Complaints)
    complaint_list = test$Complaints[Filter_Index[1:5]]
    print(complaint_list)
    
    start_date = end_date-40*4
    df_filter <- filter(df, Complaint.Type %in% complaint_list)
    grop_by.Date.Complaint <- group_by(df_filter, Date,Complaint.Type)
    Top.Complaints.Day <- summarise(grop_by.Date.Complaint,count = n())
    Sum_group_anoms_dates = filter(anaom_df, Complaint.Type %in% complaint_list)
    b = ggplot(data=Top.Complaints.Day, aes(x=Date, y=count, group=Complaint.Type, colour=Complaint.Type)) +
      geom_line() +
      geom_point(data=Sum_group_anoms_dates, aes(x=Date, y=count,colour = Complaint.Type), size=2)+
      xlim(c(start_date, end_date))+
      ylim(c(input$ylim[1],input$ylim[2]))
    
    print(b)
    
  })
  ####heat map##############################
  
  output$heat_plot<-renderPlot({
    
  month<-switch(input$date,
                "Jan"=1,
                "Feb"=2,
                "Mar"=3,
                "Apr"=4,
                "May"=5,
                "Jun"=6,
                "Jul"=7,
                "Aug"=8,
                "Sept"=9,
                "Oct"=10,
                "Nov"=11,
                "Dec"=12)
  c = filter(d, Month == month, Year == "2015")
  ggplot(c, aes(Borough, Complaints)) + 
    geom_tile(aes(fill = Health), colour = "white")  +
    scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey", limits=c(1, 4))  
  
})
  
#   ####click plot####################
#   output$info<-renderPrint({
#     #newdf = readRDS("Top.Complaints.Day.RDS")
#     nearPoints(df,input$plot_click, threshold = 1000, maxpoints = 1,
#                addDist = TRUE, xvar = "Date", yvar = "count")})
  
  
  #### bar.chart##########################
  output$bar.chart_plot<-renderPlot({
    
    zipcode<-as.numeric(input$caption)
    month1<-switch(input$date1,
                  "Jan"="01",
                  "Feb"="02",
                  "Mar"="03",
                  "Apr"="04",
                  "May"="05",
                  "Jun"="06",
                  "Jul"="07",
                  "Aug"="08",
                  "Sept"="09",
                  "Oct"="10",
                  "Nov"="11",
                  "Dec"="12")
    zip11694 <- filter(pus, pus$"Incident Zip" == zipcode & pus$Created_Month== month1)
    
    ##check how many type of complaint
    #length(unique(zip11694$`Complaint Type`))
    
    
    #table(zip11694$`Complaint Type`)
    
    dfzip11694 = as.data.frame(ftable(zip11694$`Complaint Type`))
    
    pickmaxtype=filter(dfzip11694, dfzip11694$Freq == max(dfzip11694$Freq))
    
    # Add Descriptor type for the max complaint type
    dzip11694=filter(zip11694, zip11694$"Complaint Type" == as.character(pickmaxtype$Var1))
    
    Descriptor_zip11694 = as.data.frame(ftable(dzip11694$`Descriptor`))
    
    ##slect top 10 complaint type(good one)
    topdfzip11694=head(arrange(dfzip11694,desc(Freq)), n = 10)
  
    
    Complaintplot11694<-ggplot(data=topdfzip11694, aes(x=Var1, y=Freq, fill=Var1)) +
      geom_bar(colour="black", stat="identity") +
      xlab("Complaint Type") + 
      ylab("Count") + 
      coord_flip() + 
      guides(fill=FALSE) + 
      ggtitle("Complaint Type Count")
    print(Complaintplot11694)
    
    
  })
  
  
  output$bar.chart_plot1<-renderPlot({
    zipcode<-as.numeric(input$caption)
    month1<-switch(input$date1,
                   "Jan"="01",
                   "Feb"="02",
                   "Mar"="03",
                   "Apr"="04",
                   "May"="05",
                   "Jun"="06",
                   "Jul"="07",
                   "Aug"="08",
                   "Sept"="09",
                   "Oct"="10",
                   "Nov"="11",
                   "Dec"="12")
    zip11694 <- filter(pus, pus$"Incident Zip" == zipcode & pus$Created_Month== month1)
    
    ##check how many type of complaint
    #length(unique(zip11694$`Complaint Type`))
    
    
    #table(zip11694$`Complaint Type`)
    
    dfzip11694 = as.data.frame(ftable(zip11694$`Complaint Type`))
    
    pickmaxtype=filter(dfzip11694, dfzip11694$Freq == max(dfzip11694$Freq))
    
    # Add Descriptor type for the max complaint type
    dzip11694=filter(zip11694, zip11694$"Complaint Type" == as.character(pickmaxtype$Var1))
    
    Descriptor_zip11694 = as.data.frame(ftable(dzip11694$`Descriptor`))
    ##slect top 5 Descriptor(good one)
    topDes_dfzip11694=head(arrange(Descriptor_zip11694,desc(Freq)), n = 5)
    Descriptor11694<-ggplot(data=topDes_dfzip11694, aes(x=Var1, y=Freq, fill=Var1)) +
      geom_bar(colour="black", stat="identity") +
      xlab("Descriptor Type") + 
      ylab("Count") + 
      coord_flip() + 
      ggtitle("Descriptor Count")
    print(Descriptor11694)
  })
  
  
  
  ####reaction.time##################
  output$Text1<- renderText({
    zipcode<-as.numeric(input$caption)
    ###filter to select zip code
  #output:(median reaction time, rank in the whole zip code, the top percent in the whole zip code)
  reaction_meadian <- filter(react, react$"i" == zipcode)
    
  m_reaction=reaction_meadian$median_calc
  paste("the median of the reaction time is", m_reaction)
  
  })
  output$Text2<- renderText({
    zipcode<-as.numeric(input$caption)
    ###filter to select zip code
    #output:(median reaction time, rank in the whole zip code, the top percent in the whole zip code)
    reaction_meadian <- filter(react, react$"i" == zipcode)
    
    zrank=reaction_meadian$rank
    paste("the rank of the reaction time is", zrank)
  })
  output$Text3<- renderText({
    zipcode<-as.numeric(input$caption)
    ###filter to select zip code
    #output:(median reaction time, rank in the whole zip code, the top percent in the whole zip code)
    reaction_meadian <- filter(react, react$"i" == zipcode)
    
    top_percent=reaction_meadian$rank/nrow(react)*100
    paste("the top percent of the reaction time is", top_percent)
  })
  ####word cloud###########################
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    
    wordcloud_rep(word_fre[,1], word_fre[,2], scale=c(4,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
  
  ####Data Set Summary####################
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(df.smaller[, input$show_vars, drop = FALSE])
  })
  
})
