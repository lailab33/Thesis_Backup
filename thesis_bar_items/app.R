#Bar graph of the different types of items in the database
#FINISHED

#loading libraries
library(shiny)
require(dplyr)
require(ggplot2)

#loading the data that is needed for the shiny app
data <- read.csv("data.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  #centering title
  fluidRow(
    column (12,
            align = "Center", 
            titlePanel("Number of items by type")
    )),
  
  #adding blank space for aesthetics
  br(),
  
  fluidRow(
    column(5,
           align = 'center',
           selectInput(inputId = 'year_start',
                       label = NULL,
                       choices = seq(1970, 2021, 1), 
                       selected = 1970)),
    column(2, style = 'margin-top: 7px', align = 'center', p("to")),
    column(5, align = 'center',
           selectInput(inputId = 'year_end',
                       label = NULL,
                       choices = seq(1970, 2021, 1), 
                       selected = 2021))
  ),
  
  #adding a break between date range and subtitle
  br(),
  
  #bar graph of number of items by type
  fluidRow(
    column (12,
            align = "Center", 
            titlePanel("Bar graph of number of items by type"))),
    
    br(),
    
    #without placing it in the "main panel" it automatically centers better
    plotOutput(outputId = "bargraph.type", height = "400px")
  )

# Define server logic required to draw a bar graph
server <- function(input, output) {
    
    #making a reactive database that will select citation information only for the years selected in the iu
    filtered.data <- reactive({
        data %>% 
            dplyr::select(year, document.type) %>% 
            filter(year >= input$year_start & year <= input$year_end)
            
    })
    
    #making the bar graph
    output$bargraph.type <- renderPlot({
        filtered.data() %>%
            group_by(document.type) %>%
            count() %>%
            ggplot(aes(x=document.type, y=n)) +
            geom_col(fill = "#32502E") +
            labs(x = "Kinds of documents", 
                 y = "Number of documents") +
            theme_classic() +
            theme(axis.title=element_text(size=20), 
                  axis.text=element_text(size=12), 
                  axis.text.x = element_text(angle = 45, hjust = 1))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
