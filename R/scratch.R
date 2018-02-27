

## TODO:
## TESTS
## - polylines - works with and without ID, for polyline and lat/lon columns
## - polygons - ditto




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
#     google_map(location = c(-37.817386, 144.967463),
#                zoom = 14,
#                split_view = "pano",
#                split_view_options = list(heading = 275, pitch = 20)
#                )
#   })
# }
#
# shinyApp(ui, server)

