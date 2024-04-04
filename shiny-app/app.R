library(shiny)
library(ggplot2)
library(DT)

# Load the data
holocaust_data <- read.csv("holocaust_victims.csv")

# Define the UI
ui <- fluidPage(
  titlePanel("Holocaust Victims by Nationality"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("selected_nationalities", "Select Nationalities/Categories:",
                         choices = holocaust_data$Nationality.Category,
                         selected = holocaust_data$Nationality.Category)
    ),
    mainPanel(
      plotOutput("plot"),
      DTOutput("table")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Reactive expression to filter data based on selections
  filtered_data <- reactive({
    holocaust_data[holocaust_data$Nationality.Category %in% input$selected_nationalities,]
  })
  
  # Render the plot
  output$plot <- renderPlot({
    gg <- ggplot(filtered_data(), aes(x = Nationality.Category, y = Number.of.victims, fill = Nationality.Category)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Number of Holocaust Victims by Nationality",
           x = "Nationality/Category",
           y = "Number of Victims")
    print(gg)
  })
  
  # Render the table
  output$table <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 5))
  }, server = FALSE) # server-side processing set to FALSE for responsiveness
}

# Run the application
shinyApp(ui = ui, server = server)
