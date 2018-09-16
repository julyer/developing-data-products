library(lubridate)
library(ggplot2)
library(plotly)
library(shiny)

# Read in data
df <- read.csv("./data/gas-electricity-prices.csv")

# Create date objects out of start and end dates
df$start_date <- as.Date(df$start_date)
df$end_date <- as.Date(df$end_date)

for (i in 1:dim(df)[1]) {
    startDt <- df$start_date[i]
    endDt <- df$end_date[i]
    dates <- seq.Date(startDt, endDt, "day")
    df$total_days[i] <- length(dates)
    # calculate per day rate
    df$amount_per_day[i] <- as.numeric(
        as.character(
            format(round(df$amount[i] / df$total_days[i], 
                         digits=2), nsmall=2)))
}

shinyServer(function(input, output) {
    
    sliderValues <- reactive({
    
       data.frame(
           
        Start = input$slider1[1],
        End = input$slider1[2]
       )
        
    })
    
    output$date_range <- renderTable({
        sliderValues()
    })
    
    data_subset <- reactive({
        slider_start <- input$slider1[1]
        slider_end <- input$slider1[2]
        
        if (input$type == "Gas + Electricity") {
            a <- subset(df, year(start_date) >= slider_start & year(end_date) <= slider_end) 
        } else if (input$type == "Gas") {
            a <- subset(df, year(start_date) >= slider_start & year(end_date) <= slider_end & type=="gas")
        } else if (input$type == "Electricity") {
            a <- subset(df, year(start_date) >= slider_start & year(end_date) <= slider_end & type=="electricity")
        }
           
       
        return(a)
        
     })
    
   

  
  output$plot1 <- renderPlotly({
      p <- ggplot(data_subset(), aes(x=end_date, y=amount_per_day, group=type)) +
          geom_line(aes(color=type)) +
          geom_point(aes(color=type)) +
          labs(x="", y = "Cost per day (€)") +
          theme(legend.title=element_blank())
          
                 
      
      ggplotly(p)
         
  })
 
  output$description <- renderText({
      b <- ifelse (input$desc, "This is a visualisation of the cost of gas and electricity for a 3 bedroom house in Ireland. The data was accumulated from old bills scattered around the place. The date ranges of these bills varied widely so an average cost per day was calculated by dividing a total cost by the number of days in the date range covered in each bill. The plot clearly shows the seasonal fluctuation in the price of gas. This is much less evident in the cost of electricity through the year although the electricity-only plot does show some seasonal change - although much less dramatic.", "") 
      return(b)
  })
  
})
