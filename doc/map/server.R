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
library(gridExtra)

shinyServer(function(input, output, session) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -73.86357, lat = 40.68251, zoom = 10)
  })


  observe({


      #colorData <- zipdata[['income']]
      #pal <- colorBin("Spectral", colorData, 15, pretty = FALSE)

    leafletProxy("map", data = request.clean) %>%
      clearShapes() %>%
      addCircles(~longitude, ~latitude, radius=100, 
        stroke=FALSE, fillOpacity=0.4) 
  })
 
  #####anaom_plotter#######################
  output$anaom_plot<-renderPlot({
    
    anaom_plotter = function(complaint_list,start_date, end_date, anaom_df,total_df){
      
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
    }
    
    
    df = readRDS("../../data/full_filtered.rds")
    df$Complaint.Type[df$Complaint.Type == "HEATING"] = "HEAT/HOT WATER"
    
    anaom_df = readRDS("../../data/Anamolies.RDS")
    
    complaint_list = c("PAINT - PLASTER" ,"HEAT/HOT WATER" ,"Blocked Driveway")
    end_date <- as.Date(switch(input$date,
                               "Jan"="2014-01-31",
                               "Feb"="2014-02-28"))
    start_date = end_date-40*4
    anaom_plotter(complaint_list,start_date, end_date, anaom_df,df)
  })
  ####heat map##############################
  
  output$heat_plot<-renderPlot({
    d = readRDS("../../data/b.RDS")
  month<-switch(input$date,
                "Jan"=1,
                "Feb"=2)
  c = filter(d, Month, Year == "2012")
  ggplot(c, aes(Borough, Complaints)) + 
    geom_tile(aes(fill = Health), colour = "white")  +
    scale_fill_gradient(low = "LightSkyBlue", high = "LightCoral", na.value = "grey", limits=c(1, 4))  
  
})
  #### bar.chart##########################
  output$bar.chart_plot<-renderPlot({
    pus=readRDS("../../data/pus.RDS")
    zipcode<-as.numeric(input$caption)
    zip11694 <- filter(pus, pus$"Incident Zip" == zipcode & pus$Created_Month== "month")
    
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
  })
  
  
  output$bar.chart_plot1<-renderPlot({
    Descriptor11694<-ggplot(data=topDes_dfzip11694, aes(x=Var1, y=Freq, fill=Var1)) +
      geom_bar(colour="black", stat="identity") +
      xlab("Descriptor Type") + 
      ylab("Count") + 
      ggtitle("Descriptor Count"); Descriptor11694
  })
  ####reaction.time##################
  output$reaction.time<- renderText({
      react<-readRDS("../../data/react.RDS")
  ###filter to select zip code
  
  reaction_meadian <- filter(react, react$"i" == "10025")
  
  #output:(median reaction time, rank in the whole zip code, the top percent in the whole zip code)
  m_reaction=reaction_meadian$median_calc;m_reaction
  zrank=reaction_meadian$rank;zrank
  top_percent=reaction_meadian$rank/nrow(react)*100;top_percent
  })

  
  ####word cloud###########################
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(4,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })

})
