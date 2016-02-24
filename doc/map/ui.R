library(shiny)
library(leaflet)
#install.packages("shinythemes")
library(shinythemes)


shinyUI(navbarPage("311 Requests", id="nav",theme = "bootstrap.css",
                   
                   tabPanel("Interactive Map",
                            div(class="outer",
                                
                                tags$head(
                                  # Include our custom CSS
                                  includeCSS("styles.css"),
                                  includeScript("gomap.js")
                                ),
                                
                                leafletOutput("map", width="100%", height="100%"),
                                
                                # Shiny versions prior to 0.11 should use class="modal" instead.
                                absolutePanel(
                                  
                                  id = "controls", class = "panel panel-default", fixed = TRUE,
                                  draggable = TRUE, top = 100, left = 20, right = 'auto', bottom = "auto",
                                  width = 240, height = "auto",
                                  
                                  h2("311 Solution"),
                                  strong('We are here to help ysou become 
                                         more efficient and direct in 
                                         running your 311 operations 
                                         to help increase productivity 
                                         and awareness of what is 
                                         going on in your city.'),
                                  h2('Contributors'),
                                  h4('Robert Carl Minnich'),
                                  h4('Yuhan Sun'),
                                  h4('Zehao Wang'),
                                  h4('Yuan Zhao')
                                  
                                  
                                  
                                  )
                                
                                )
                            ),
                   tabPanel("Anomal Detection",
                            sidebarLayout(
                              sidebarPanel(
                                helpText("Create demographic maps with 
                                         information from the 311 dataset."),
                                
                                selectInput("date", 
                                            label = "Choose a month to display",
                                            choices = c("Jan", "Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec"
                                            ),
                                            selected = "Jan"),
                                sliderInput("ylim",
                                            label = "Choose the range of the count",
                                            min=0, max=6000, value=c(0,6000))
                                
                                
                                
                                
                                ),
                              
                              mainPanel(plotOutput("anaom_plot",click="plot_click"),
                                        plotOutput("heat_plot"),
                                        verbatimTextOutput("info")
                                        )
                            )
                     
                   ),
                   
                                  tabPanel('bar chart',
                                                
                                                sidebarLayout(
                                                  sidebarPanel(
                                                    helpText("First graph:bar chart for complaint types. Second graph: bar chart for discriptors based on the most complaint type.
                                                             "),
                                                    selectInput("date1", 
                                                                label = "Choose a month to display",
                                                                choices = c("Jan", "Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec"
                                                                ),
                                                                selected = "Jan"),
                                                    textInput("caption", "Caption:", "11694")
                                                  ),
                                                  mainPanel(
                                                    textOutput("Text1"),
                                                    textOutput("Text2"),
                                                    textOutput("Text3"),
                                                    plotOutput("bar.chart_plot"),
                                                    plotOutput("bar.chart_plot1")
                                                            )
                                                )
                                                ),
                                       
                                                  
                                                  
                                            
                                       
                            
                  
                   tabPanel("Word Cloud",
                            # Application title
                            titlePanel("Word Cloud"),
                            
                            sidebarLayout(
                              # Sidebar with a slider and selection inputs
                              sidebarPanel(
                                hr(),
                                sliderInput("freq",
                                            "Minimum Frequency:",
                                            min = 50,  max = 500, value = 15),
                                sliderInput("max",
                                            "Maximum Number of Words:",
                                            min = 1,  max = 300,  value = 100)
                              ),
                              
                              # Show Word Cloud
                              mainPanel(
                                plotOutput("plot")
                              )
                            )
                   ),
                   tabPanel("Dataset"
                            
                   ),
                   
                   conditionalPanel("false", icon("crosshair"))
))


