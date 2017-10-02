# df <- tram_route
# df$grp <- c(rep(1, 27), rep(2, 28))
#
# library(googleway)
# google_map(key = symbolix.utils::mapKey()) %>%
#   add_polylines(data = df, lat = "shape_pt_lat", lon = "shape_pt_lon", id = "grp")


# library(shiny)
#
# ui <- fluidPage(
#   google_mapOutput(outputId = "map", height = "800px"),
#   actionButton(inputId = "btn", label = "button")
# )
# server <- function(input, output){
#
#   mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#   output$map <- renderGoogle_map({
#
#     google_map(key = mapKey)
#
#   })
#
#
#   observeEvent(input$btn, {
#
#     ## TODO:
#     ## Why is only one layer deleted if no layer_ids are present
#     ## what is going on when more than one layer_id is specified?
#     if(input$btn %% 2 == 1){
#       google_map_update(map_id = "map") %>%
#         add_circles(data = tram_stops, lat = "stop_lat", lon = "stop_lon",
#                     fill_colour = "stop_name", stroke_colour = "stop_id", legend = T) %>%
#         add_circles(data = tram_route, lat = "shape_pt_lat", lon = "shape_pt_lon",
#                     fill_colour = "shape_pt_sequence", legend = T)
#     }else{
#       google_map_update(map_id = "map") %>%
#         clear_circles()
#     }
#   })
# }
# shinyApp(ui, server)




# library(shiny)
#
# ui <- fluidPage(
#   google_mapOutput(outputId = "map", height = "800px"),
#   actionButton(inputId = "btnMarker", label = "markers"),
#   actionButton(inputId = "btnCircles", label = "circles"),
#   actionButton(inputId = "btnPolylines", label = "polylines"),
#   actionButton(inputId = "btnPolygons", label = "polygons")
# )
#
# server <- function(input, output){
#
#   mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#   tram_route <- tram_route
#   tram_route$id <- 1
#
#   output$map <- renderGoogle_map({
#     google_map(key = mapKey)
#   })
#
#
#   observeEvent(input$btnMarker, {
#     if(input$btnMarker %% 2 == 1){
#       google_map_update(map_id = "map") %>%
#         add_markers(data = tram_stops, lat = "stop_lat", lon = "stop_lon",
#                     layer_id = 'markers')
#     }else{
#       google_map_update(map_id = "map") %>%
#         clear_markers(layer_id = 'markers')
#     }
#   })
#
#   observeEvent(input$btnCircles, {
#     if(input$btnCircles %% 2 == 1){
#       google_map_update(map_id = "map") %>%
#         add_circles(data = tram_stops, lat = "stop_lat", lon = "stop_lon",
#                     fill_colour = "stop_name", stroke_colour = "stop_id", legend = T,
#                     layer_id = 'circles')
#     }else{
#       google_map_update(map_id = "map") %>%
#         clear_circles(layer_id = 'circles')
#     }
#   })
#
#   observeEvent(input$btnPolylines, {
#     if(input$btnPolylines %% 2 == 1){
#       google_map_update(map_id = "map") %>%
#         add_polylines(data = tram_route, lat = "shape_pt_lat", lon = "shape_pt_lon",
#                     layer_id = 'polylines', stroke_colour = "id", legend = T)
#     }else{
#       google_map_update(map_id = "map") %>%
#         clear_polylines(layer_id = 'polylines')
#     }
#   })
#
#   observeEvent(input$btnPolygons, {
#     if(input$btnPolygons %% 2 == 1){
#       google_map_update(map_id = "map") %>%
#         add_polygons(data = melbourne, polyline = "polyline", fill_colour = "SA4_NAME",
#                       legend = T, layer_id = 'polygons', legend_options = list(position = "BOTTOM_RIGHT"))
#     }else{
#       google_map_update(map_id = "map") %>%
#         clear_polygons(layer_id = 'polygons')
#     }
#   })
#
# }
# shinyApp(ui, server)










