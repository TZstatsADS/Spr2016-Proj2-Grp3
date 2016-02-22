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
                   tabPanel("Anomal Detection"
                     
                   ),
                   tabPanel("Request Statistics",
                            navlistPanel('Choices',
                                       tabPanel('bar chart'
                                                ),
                                       tabPanel('density plot'
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


