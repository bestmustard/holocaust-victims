library(shiny)
library(DT)

deported_jews <- data.frame(
  Country_of_Origin = c("Hungary", "Poland", "France", "The Netherlands", "Greece",
                        "The Protectorate of Bohemia and Moravia (Theresienstadt)",
                        "Concentration camps and other centers", "Slovakia",
                        "Belgium", "Germany and Austria", "Yugoslavia", "Italy", "Norway"),
  Number = c(430000, 300000, 69000, 60000, 55000, 46000, 34000, 27000, 25000, 23000, 10000, 7500, 690)
)

prisoners_auschwitz <- data.frame(
  Nationality = c("Jews", "Poles", "Roma", "Soviet captives", "Czech", "Belarussian", 
                  "German", "French", "Russian", "Yugoslavian", "Ukrainian", "Other"),
  Number = c(200000, 140000, 21000, 12000, 9000, 6000, 4000, 4000, 1500, 800, 500, 200)
)

ui <- fluidPage(
  titlePanel("Holocaust Demographics"),
  fluidRow(
    column(6, 
           h4("Deported Jews by Country of Origin"), # Adding a title for the first datatable
           DTOutput("table_deported")
    ),
    column(6, 
           h4("Prisoners at Auschwitz by Nationality"), # Adding a title for the second datatable
           DTOutput("table_prisoners")
    )
  )
)

server <- function(input, output) {
  output$table_deported <- renderDT({
    datatable(deported_jews, options = list(pageLength = 15), rownames = FALSE)
  })
  
  output$table_prisoners <- renderDT({
    datatable(prisoners_auschwitz, options = list(pageLength = 15), rownames = FALSE)
  })
}

shinyApp(ui = ui, server = server)
