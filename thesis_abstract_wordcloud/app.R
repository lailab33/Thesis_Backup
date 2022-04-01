#word cloud of the abstract information
#FINISHED

#loading libraries
library(shiny)
require(dplyr)
library(splitstackshape)

#quanteda packages
library(Rcpp) #rcpp has to load before quanteda
library(quanteda)
library(readtext)
library(devtools)
library(quanteda.textmodels)

#loading the data that is needed for the shiny app
data <- read.csv("data.split.csv")

#selecting the abstract sections of interest
data <- data %>%
    dplyr::select(abstract, year, id)

# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidRow(
        column (12,
                align = "Center", 
                titlePanel("Wordcloud of abstract information"),
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
                            max = 2473	, #is set for the most repeated word: 264 (ecological)
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
    wc.abstract.dfm <- reactive({
        #selecting the rows according to the years of interest
        data %>% 
            filter(year >= input$year_start & year <= input$year_end) %>%
            select(-year)
        
        #loading just the abstracts as part of the main corpus
        abstract.corpus <- corpus(data, text_field = "abstract")
        
        #removing punctuation from the abstract
        #removing "stopwords" (common grammatical words in the english language, 
        #which are here; https://github.com/koheiw/marimo/blob/master/yaml/stopwords_en.yml )
        wc.abstract <- tokens(abstract.corpus, remove_punct = TRUE) %>%
            tokens_remove(pattern = stopwords("en"))
        
        #creating a document-feature matrix (DFM) from the tokens object
        wc.abstract.dfm <- dfm(wc.abstract)
        
        #setting up the minimum frequency requirement
        dfm_trim(wc.abstract.dfm, min_termfreq = input$num.repetitions)
    })
    
    #making a wordcloud with quanteda
    output$wordcloud <- renderPlot({
        set.seed(132)
        quanteda.textplots::textplot_wordcloud(wc.abstract.dfm(), max_words = input$num.words, 
                                               color = c("#515E63", "#5B7DB1", "#57837B", "#32502E"))
    })
    
    #making the table of frequency numbers
    output$frequency.table <- DT::renderDataTable(
        quanteda.textstats::textstat_frequency(wc.abstract.dfm())
    )
}

# Run the application 
shinyApp(ui = ui, server = server)