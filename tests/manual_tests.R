## TODO:
## - editable multi-polygons: which paths get updated?
## - update shpaes in a shiny
## --- polygons
## --- polylines
## --- circles
## --- rectangles
## --- markers
## --- heatmap

#
# ui <- fluidPage(
#   google_mapOutput(outputId = "map", height = "800px")
# )
# server <- function(input, output){
#   df <- data.frame(north = -37.8459, south = -37.8508, east = 144.9378,
#                     west = 144.9236, editable = T, draggable = F)
#
#   df_poly <- melbourne[41, ]  ## a small polygon
#   df_poly$editable <- T
#   df_poly$draggable <- T
#
#
#   tram_stops$editable <- T
#   tram_stops$draggable <- T
#
#   output$map <- renderGoogle_map({
#     google_map(key = map_key) %>%
#       add_rectangles(data = df, north = 'north', south = 'south',
#                      east = 'east', west = 'west',
#                      editable = 'editable', draggable = 'draggable') %>%
#       add_circles(data = tram_stops, lat = "stop_lat", lon = "stop_lon",
#                   editable = "editable", draggable = "draggable") %>%
#       add_polygons(data = df_poly, polyline = "polyline", editable = 'editable',
#                   draggable = 'draggable') %>%
#       add_polylines(data = df_poly, polyline = "polyline", editable = "editable",
#                   draggable = "draggable")
#   })
#
#   observeEvent(input$map_circle_edit, {
#     print("circle edited")
#     print(input$map_circle_edit)
#   })
#
#   observeEvent(input$map_circle_drag, {
#     print("circle dragged")
#     # print(input$map_circle_drag)
#   })
#
#   observeEvent(input$map_rectangle_click, {
#     print("rectangle clicked")
#     print(input$map_rectangle_click)
#   })
#
#   observeEvent(input$map_rectangle_edit, {
#     print("rectangle edited")
#     print(input$map_rectangle_edit)
#   })
#
#   observeEvent(input$map_polyline_edit, {
#     print("polyline edited")
#     print(input$map_polyline_edit)
#   })
#
#   observeEvent(input$map_polyline_drag, {
#     print("polyline dragged")
#     #print(input$map_polyline_drag)
#   })
#
#   observeEvent(input$map_polygon_edit, {
#     print("polygon edited")
#     print(input$map_polygon_edit)
#   })
#
#   observeEvent(input$map_polygon_drag, {
#     print("polygon dragged")
#     #print(input$map_polyline_drag)
#   })
#
# }
# shinyApp(ui, server)



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










