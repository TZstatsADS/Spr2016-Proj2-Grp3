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
                                  
                                  plotOutput("scatterCollegeIncome", height = 250)
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
                                            choices = c("Jan", "Feb"
                                            ),
                                            selected = "Jan"),
                                sliderInput("ylim",
                                            label = "Choose the range of the count",
                                            min=0, max=6000, value=c(0,6000))
                                
                                
                                
                                
                                ),
                              
                              mainPanel(plotOutput("anaom_plot"),
                                        plotOutput("heat_plot")
                                        )
                            )
                     
                   ),
                   
                                  tabPanel('bar chart',
                                                sidebarLayout(
                                                  sidebarPanel(
                                                    helpText("First graph:bar chart for complaint types. Second graph: bar chart for discriptors based on the most complaint type.
                                                             "),
                                                    #selectInput("date", 
                                                    #            label = "Choose a month to display",
                                                     #           choices = c("Jan", "Feb"
                                                     #          4 ),
                                                    #            selected = "Jan"),
                                                    textInput("caption", "Caption:", "11694")
                                                  ),
                                                  mainPanel(#plotOutput("bar.chart_plot"),
                                                            #plotOutput("bar.chart_plot1"),
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
                                            min = 1,  max = 50, value = 15),
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


