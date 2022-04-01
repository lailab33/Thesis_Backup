#word cloud of the keyword information
#FINISHED

#loading libraries
library(shiny)
require(dplyr)
library(splitstackshape)
library(data.table)

#quanteda packages
library(Rcpp) #rcpp has to load before quanteda
library(quanteda)
library(readtext)
library(devtools)
library(quanteda.textmodels)

#loading the data that is needed for the shiny app
data <- read.csv("data.split.csv")

#keeping the keyword information
data <- data %>%
    select(year, id, index.keywords_01:index.keywords_90, author.keywords_01:author.keywords_19)

# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidRow(
        column (12,
                align = "Center", 
                titlePanel("Wordcloud of keyword information (index & author)"),
        )),
    
    #adding blank space for aesthetics
    br(),
    
    #row to select the date range
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
    
    #row to select the minimum frequency and the manimum number of words
    fluidRow(
        column (6,
                align = "center", 
                sliderInput("num.repetitions", #ID HERE
                            "Minimum number of repetitions:",
                            min = 1,
                            max = 264, #is set for the most repeated word: 264 (ecological)
                            value = 30)),
        column (1),
        column (6, 
                align = "center", 
                sliderInput("num.words",
                            "Number of words represented:",
                            min = 1,
                            max = 200,
                            value = 30))
    ),
    
    #wordcloud
    plotOutput(outputId = "wordcloud"),
    
    #title for the table
    fluidRow(
        column (12,
                align = "Center", 
                h4("Frequency table of the words in the cloud"),
        )),
    
    #rendering the table of words in the wordcloud
    DT::dataTableOutput("frequency.table")
)


# Define server logic required to draw a histogram
server <- function(input, output) {
    #making a reactive database that changes given the selected year
    wc.keyword.dfm <- reactive({
        #selecting the rows according to the years of interest
        data %>% 
            filter(year >= input$year_start & year <= input$year_end) %>%
            select(-year)
        
        #make a column of keyword per row
        data <-  melt(data, id.vars=c("id"), na.rm = TRUE)
        
        #selecting where the variable came from (index.keywords_01 or _02 ect)
        data %>% select(-variable)
        
        #loading just the keywords as part of the main corpus
        keyword.corpus <- corpus(data, text_field = "value")
        
        #removing punctuation from the keywords
        #removing "stopwords" (common grammatical words in the english language, 
        #which are here; https://github.com/koheiw/marimo/blob/master/yaml/stopwords_en.yml )
        wc.keyword <- tokens(keyword.corpus, remove_punct = TRUE) %>%
            tokens_remove(pattern = stopwords("en"))
        
        #creating a document-feature matrix (DFM) from the tokens object
        wc.keyword.dfm <- dfm(wc.keyword)
        
        #setting up the minimum frequency requirement
        dfm_trim(wc.keyword.dfm, min_termfreq = input$num.repetitions)
    })
    
    #making a wordcloud with quanteda
    output$wordcloud <- renderPlot({
        set.seed(132)
        quanteda.textplots::textplot_wordcloud(wc.keyword.dfm(), max_words = input$num.words, 
                                               color = c("#515E63", "#5B7DB1", "#57837B", "#32502E"))
    })
    
    #making the table of frequency numbers
    output$frequency.table <- DT::renderDataTable(
        quanteda.textstats::textstat_frequency(wc.keyword.dfm())
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
