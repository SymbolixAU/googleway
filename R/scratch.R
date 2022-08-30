#
# ## Can we hook into the addListenerOnce(, 'idle', )?
#
# library(shiny)
# library(googleway)
#
# set_key(secret::get_secret("GOOGLE"))
#
# ui <- fluidRow(
#   googleway::google_mapOutput(
#     outputId = "map"
#   )
#   , googleway::google_mapOutput(
#     outputId = "map2"
#   )
# )
#
# server <- function(input, output, seession) {
#   output$map <- googleway::renderGoogle_map({
#     google_map()
#   })
#
#   output$map2 <- googleway::renderGoogle_map({
#     google_map()
#   })
#
#   observeEvent(input$map_initialised, {
#     print("map initilased")
#   })
#
#   observeEvent(input$map2_initialised, {
#     print("map2 initilased")
#   })
# }
#
# shinyApp(ui, server)
