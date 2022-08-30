#
# library(shiny)
#
# ui <- fluidRow(
#   googleway::google_mapOutput(
#     outputId = "map"
#   )
# )
#
# server <- function(input, output, seession) {
#   output$map <- googleway::renderGoogle_map({
#     google_map()
#   })
# }
#
# shinyApp(ui, server)
