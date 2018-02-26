

## TODO:
## TESTS
## - polylines - works with and without ID, for polyline and lat/lon columns
## - polygons - ditto


# testdf <- data.frame(
#   lat=39.6477,
#   lon=-104.9402,
#   info="Test Location",
#   colour="blue"
# )
#
# api_key <- read.dcf("~/Documents/.googleAPI" ,fields = "GOOGLE_MAP_KEY")
#
# ###Doesn't work with mouse_over (shiny or console)
# google_map(location=c(testdf[1,1], testdf[1,2]), key= api_key, zoom=15) %>%
#   add_markers(data=testdf, mouse_over ="info", colour="colour", update_map_view= FALSE)

## two maps with the same layer_id ?


# library(shiny)
# library(shinydashboard)
# library(googleway)
#
# ui <- dashboardPage(
#
#   dashboardHeader(),
#   dashboardSidebar(),
#   dashboardBody(
#     box(width = 6,
#       google_mapOutput(outputId = "map")
#     ),
#     box(width = 6,
#         google_mapOutput(outputId = "pano")
#     )
#   )
# )
#
# server <- function(input, output) {
#   set_key(read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY"))
#
#   output$map <- renderGoogle_map({
#     google_map(zoom = 14, split_view = "pano")
#   })
# }
#
# shinyApp(ui, server)
