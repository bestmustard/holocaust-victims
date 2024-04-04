library(shiny)
library(ggplot2)
library(DT)
library(readr)

# Load data
holocaust_data <- read_csv("holocaust_victims.csv")

colnames(holocaust_data) <- c("Nationality_Category", "Number_of_deportees", "Percentage_of_deportees", 
                              "Number_of_victims", "Percentage_murdered_within_category", "Percentage_of_all_victims")

jewish_deportees_by_country <- data.frame(
  Country_of_origin = c("Hungary", "Poland", "France", "The Netherlands", "Greece",
                        "The Protectorate of Bohemia and Moravia", "Concentration camps and other centers",
                        "Slovakia", "Belgium", "Germany and Austria", "Yugoslavia", "Italy", "Norway"),
  Number = c(430000, 300000, 69000, 60000, 55000, 46000, 34000, 27000, 25000, 23000, 10000, 7500, 690)
)

ui <- fluidPage(
  titlePanel("Holocaust Victims by Nationality"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("selected_nationalities", "Select Nationalities/Categories:",
                         choices = holocaust_data$Nationality_Category,
                         selected = holocaust_data$Nationality_Category),
      checkboxInput("show_total_deported", "Show Total Deported", value = TRUE),
      checkboxInput("show_jews_by_origin", "Show Jews by Country of Origin", value = FALSE)
    ),
    mainPanel(
      plotOutput("plot"),
      DTOutput("table"),
      plotOutput("plot_jews_origin")
    )
  )
)

# Server logic
server <- function(input, output) {
  
  filtered_data <- reactive({
    if (input$show_jews_by_origin) {
      return(jewish_deportees_by_country)
    } else {
      return(holocaust_data[holocaust_data$Nationality_Category %in% input$selected_nationalities,])
    }
  })
  
  output$plot <- renderPlot({
    if (input$show_total_deported) {
      gg <- ggplot(filtered_data(), aes(x = Nationality_Category, y = Number_of_deportees, fill = Nationality_Category)) +
        geom_bar(stat = "identity") +
        theme_minimal() +
        labs(title = "Number of Holocaust Deportees by Nationality/Category",
             x = "Nationality/Category",
             y = "Number of Deportees")
    } else {
      gg <- ggplot(filtered_data(), aes(x = Nationality_Category, y = Number_of_victims, fill = Nationality_Category)) +
        geom_bar(stat = "identity") +
        theme_minimal() +
        labs(title = "Number of Holocaust Victims by Nationality/Category",
             x = "Nationality/Category",
             y = "Number of Victims")
    }
    print(gg)
  })
  
  output$table <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 5))
  }, server = FALSE) # server-side processing set to FALSE for responsiveness
  
  output$plot_jews_origin <- renderPlot({
    req(input$show_jews_by_origin) # Only render this plot if the checkbox is checked
    gg <- ggplot(jewish_deportees_by_country, aes(x = reorder(Country_of_origin, -Number), y = Number, fill = Country_of_origin)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Number of Jewish Deportees to Auschwitz by Country of Origin",
           x = "Country of Origin",
           y = "Number of Deportees") +
      coord_flip() # Flip the coordinates for horizontal bars
    print(gg)
  })
  
}

shinyApp(ui = ui, server = server)
