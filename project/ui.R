library(shiny)
library(plotly)

shinyUI(fluidPage(theme="mystyles.css",
  
  titlePanel("Daily Cost of Gas and Electricity"),
  
  sidebarLayout(
    sidebarPanel(
        h4("Use the slider in the side panel to select the date range."),
        h4("Use the dropdown list to select what you want to plot."),
        h4("Use the checkbox to see a more detailed description."),
        h4("Note that the y-axis range changes depending on which plot you choose."),
       sliderInput("slider1", 
                   "Select the start and end years", 
                   min=2012, max=2016, 
                   value=c(2012,2016),
                   sep=""),
       selectInput("type",
                   "What do you want to plot?",
                   choices = c("Gas + Electricity", "Gas", "Electricity")),
       checkboxInput("desc",
                     "Show description",
                     value=FALSE)
     
    ),
    
    mainPanel(
        textOutput("description"),
        tableOutput("date_range"),
        plotlyOutput("plot1")
      
    )
  )
))
