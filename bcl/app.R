library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel("BC Liquor Store Inventory"),
  sidebarLayout(
    sidebarPanel(
      h4("Wondering what drink to get for tonight? This app will help you through the selection of the BC Liquor Store."),
      sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
      uiOutput("typeOutput"),
      #conditionalPanel(
       # condition = "input.typeInput %in% 'WINE'",
        #uiOutput("subtypeOutput")
        #),
      # create checkbox for option to filter for country
      checkboxInput("countryFilter", "Filter by country", value = FALSE),
      
      # make country panel conditional depending on if country filter option is selected
      conditionalPanel(
        condition = "input.countryFilter",
        uiOutput("countryOutput")
      )
    ),

    mainPanel(
      # create text output to display number of options with current selections
      h4(textOutput("summary")),
      br(), br(),
      plotOutput("coolplot"),
      br(), br(),
      # create fancy table with sorting options using DT package
      dataTableOutput("results")
    )
  )
)

server <- function(input, output) {
  # create panel to select type of beverage
  output$typeOutput <- renderUI({
    selectInput("typeInput", "Type of drink",
                sort(unique(bcl$Type)), # create sorted list of beverages, each displayed once
                multiple = TRUE, # allow for multiple types to be selected at once
                selected = c("BEER", "WINE") # default selection is beer and wine
    )
  })
  
  #output$subtypeOutput <-
   # renderUI({
    #  selectInput("subtypeInput", "Type of wine",
     #             choices = c("RED", "WHITE"),
      #            multiple = TRUE,
       #           selected = "RED")
    #})
  
  # create panel to select country
  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country",
                sort(unique(bcl$Country)), # create sorted list of countries, each displayed once
                multiple = TRUE, # allow for multiple countries to be selected at the same time
                selected = "CANADA"
    )
  })
  
  filtered <- reactive({
    # return null if no country is selected
    if (is.null(input$countryInput)) {
      return(NULL)
    }
    # filter bcl data by country, price and type of drink if a specific country is selected
    if (input$countryFilter) {
      bcl %>% filter(
        Country == input$countryInput,
        Price >= input$priceInput[1],
        Price <= input$priceInput[2],
        Type %in% input$typeInput
      )
    }
    # filter bcl data by price and type of drink only if no country is selected
    else {
      bcl %>%
        filter(
          Price >= input$priceInput[1],
          Price <= input$priceInput[2],
          Type %in% input$typeInput
        )
    }
  })
  
  # create text that summarizes how many drinks were found in total with current selection (in main panel)
  output$summary <- renderText({
    nDrinks <- nrow(filtered())
    paste0("We found ", nDrinks, " drinks for you")
  })
  
  output$coolplot <- renderPlot({
    # return nothing when filtered() doesn't include any data, i.e. there are zero results from selection
    if (is.null(filtered())) {
      return(NULL)
    }
    ggplot(filtered(), aes(Alcohol_Content, fill = Type)) +
      geom_histogram(colour = "black") +
      labs(x = "Alcohol content", y = "Number of beverages") +
      theme_bw() +
      theme(axis.title=element_text(size=14, face = "bold"),
            legend.title = element_text(size = 14, face ="bold"),
            legend.text = element_text(size = 14))
  })
  
  # use DT package to create cool table that allows for sorting
  output$results <- renderDataTable({
    filtered()
  })
}

shinyApp(ui = ui, server = server)