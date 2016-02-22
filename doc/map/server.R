library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

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




  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({


      #colorData <- zipdata[['income']]
      #pal <- colorBin("Spectral", colorData, 15, pretty = FALSE)
    



    leafletProxy("map", data = request.clean) %>%
      clearShapes() %>%
      addCircles(~longitude, ~latitude, radius=100, 
        stroke=FALSE, fillOpacity=0.4) 
  })

  

})
