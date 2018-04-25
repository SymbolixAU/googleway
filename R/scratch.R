

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


#
# flinders <- "dhyeFezxsZnDwAP~@ZfCL|AQDc@eEMu@KDp@jFALMBu@_GKDx@~FMBaAyFKF~@xFMDC?cAwFEBdAxFQDeAuFIB`ArFSD"
# markers <- data.frame(
#   lat = c(-37.81821,-37.8181,-37.81801,-37.81793,-37.81808,-37.81816,-37.81825,-37.81837,-37.81850,-37.81838,-37.81829,-37.81819,-37.81837,-37.81846,-37.81852,-37.81863,-37.81875,-37.81865,-37.81858,-37.81852),
#   lon = c( 144.9656, 144.966, 144.9664, 144.9667, 144.9668, 144.9664, 144.9661, 144.9657, 144.9657, 144.9662, 144.9665, 144.9669, 144.9669, 144.9666, 144.9663, 144.9658, 144.9658, 144.9663, 144.9666, 144.9670)
# )
#
# ## simulate data every 6/10/60 seconds within the polygons / close to markers?
# m <- as.matrix(googlePolylines::decode(flinders)[[1]])
# m <- rbind(m, m[1,])
# m <- m[,c(2,1)]
# sf_flinders <- sf::st_polygon(x = list(m))
#
# library(shiny)
# library(shinydashboard)
# library(googleway)
#
# ui <- dashboardPage(
#   dashboardHeader(),
#   dashboardSidebar(),
#   dashboardBody(
#     google_mapOutput(outputId = "map", height = "800px"),
#     actionButton(inputId = "circles", label = "add circles")
#   )
# )
#
# server <- function(input, output) {
#
#   set_key(read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY"))
#   autoInvalidate <- reactiveTimer(6000)
#
#   output$map <- renderGoogle_map({
#     google_map()
#   })
#
#   observe({
#     autoInvalidate()
#     pts <- sf::st_sf(geometry = sf::st_sample(sf_flinders, sample(100:500,1)))
#     google_map_update(map_id = "map") %>%
#       clear_circles() %>%
#       add_circles(pts, radius = 1, stroke_weight = 0, update_map_view = F)
#   })
# }
# shinyApp(ui, server)




