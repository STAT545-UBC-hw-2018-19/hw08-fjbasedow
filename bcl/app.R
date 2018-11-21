library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

bcl <- read.csv("/Users/frederikebasedow/Documents/uni/UBC Neuroscience/courses/STAT547/STAT547-HW08-repository/bcl/bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel("BC Liquor Store Inventory"),
  sidebarLayout(
    sidebarPanel(
      h5("Wondering what drink to get for tonight? This app will help you through the selection of the BC Liquor Store."),
      sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
      uiOutput("typeOutput"),
      checkboxInput("countryFilter", "Filter by country", value = FALSE),
      conditionalPanel(
        condition = "input.countryFilter",
        uiOutput("countryOutput")
      )
    ),

    mainPanel(
      h4(textOutput("summary")),
      br(), br(),
      plotOutput("coolplot"),
      br(), br(),
      DT::dataTableOutput("results")
    )
  )
)

server <- function(input, output) {
  output$typeOutput <- renderUI({
    selectInput("typeInput", "Type of drink",
      sort(unique(bcl$Type)),
      multiple = TRUE,
      selected = c("BEER", "WINE")
    )
  })

  output$subtypeOutput <- renderUI({
    selectInput("subtypeInput", "Type of wine",
      choices = c("RED", "WHITE"),
      multiple = TRUE,
      selected = "RED"
    )
  })

  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country",
      sort(unique(bcl$Country)),
      selected = "CANADA"
    )
  })

  filtered <- reactive({
    if (is.null(input$countryInput)) {
      return(NULL)
    }
    if (input$countryFilter) {
      bcl %>% filter(
        Country == input$countryInput,
        Price >= input$priceInput[1],
        Price <= input$priceInput[2],
        Type %in% input$typeInput
      )
    }
    else {
      bcl %>%
        filter(
          Price >= input$priceInput[1],
          Price <= input$priceInput[2],
          Type %in% input$typeInput
        )
    }
  })

  output$summary <- renderText({
    nDrinks <- nrow(filtered())
    paste0("We found ", nDrinks, " drinks for you")
  })

  output$coolplot <- renderPlot({
    if (is.null(filtered())) {
      return(NULL)
    }
    ggplot(filtered(), aes(Alcohol_Content, fill = Type)) +
      geom_histogram(colour = "black") +
      labs(x = "Alcohol content", y = "Number of beverages") +
      theme_bw()
  })

  output$results <- DT::renderDataTable({
    filtered()
  })
}

shinyApp(ui = ui, server = server)