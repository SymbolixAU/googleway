# ### Drawing deletes on change
# library(shiny)
# ui <- fluidPage(
#   google_mapOutput(outputId = "map")
# )
# server <- function(input, output){
#
#   output$map <- renderGoogle_map({
#     mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#     google_map(key = mapKey) %>%
#       add_drawing(delete_on_change = T)
#   })
# }
# shinyApp(ui, server)

# ## HEATMAP UPDATE MAP VIEW
# library(shinydashboard)
# header1 <- dashboardHeader(
#   title = "My Dashboard"
# )
#
# sidebar1 <- dashboardSidebar(
#   sidebarMenu(
#     uiOutput("colours"),
#     sliderInput("opacity", "Opacity:",
#                 min = 0, max = 1,
#                 value = 0.5, step = 0.05),
#     sliderInput("radius", "Radius:",
#                 min = 0, max = 0.01,
#                 value = 0.005, step = 0.001),
#     radioButtons("dissipating", "Dissipating:",
#                  choices = c(TRUE, FALSE), selected = FALSE),
#     actionButton("weights", label = "Randomise Weights:")
#   ) #sidebarMenu
# ) #dashboardSidebar
#
# body1 <- dashboardBody(
#   fluidRow(
#     tabBox(
#       title = "TabBox Title 1",
#       id = "tabset1", height = "400px", width = 11,
#       selected = "Tab1",
#       tabPanel("Tab1",
#                google_mapOutput("Map1")
#       ),
#       tabPanel("Tab2", "Tab content 2")
#     )
#   )
# )
#
# ui <- dashboardPage(header1, sidebar1, body1)
#
# server <- function(input, output, session) {
#
#   df <- tram_stops
#   df$weight <- 100
#   cols <- sample(colours(), 10)
#
#   output$colours <- renderUI({
#     checkboxGroupInput("colours", "Colours (at least 2 required):", choices = cols, selected = cols[1:3])
#   })
#
#   #  map_key <- "your_key"
#   map_key <- read.dcf("~/Documents/.googleAPI" ,fields = "GOOGLE_MAP_KEY")
#
#   opacity <- reactive({
#     return(input$opacity)
#   })
#
#   radius <- reactive({
#     return(input$radius)
#   })
#
#   dissipating <- reactive({
#     return(as.logical(input$dissipating))
#   })
#
#   gradient <- reactive({
#     return(input$colours)
#   })
#
#   ## plot the map
#   output$Map1 <- renderGoogle_map({
#     google_map(key = map_key, data = df, zoom = 2, search_box = F) %>%
#       add_heatmap(weight = "weight",
#                   option_opacity = 0.5,
#                   option_radius = ifelse(dissipating(), 0.005 * 1000, 0.005),
#                   option_dissipating = FALSE,
#                   option_gradient = cols[1:3]
#       )
#
#   })
#
#   observeEvent(input$opacity, {
#     google_map_update(map_id = "Map1") %>%
#       update_heatmap(data = df,
#                      option_opacity = opacity(),
#                      option_radius = ifelse(dissipating(), radius() * 1000, radius()),
#                      option_dissipating = dissipating(),
#                      option_gradient = gradient(),
#                      update_map_view = F,
#                      weight = "weight")
#   })
#
#   observeEvent(input$radius, {
#     google_map_update(map_id = "Map1") %>%
#       update_heatmap(data = df,
#                      option_opacity = opacity(),
#                      option_radius = ifelse(dissipating(), radius() * 1000, radius()),
#                      option_dissipating = dissipating(),
#                      option_gradient = gradient(),
#                      update_map_view = F,
#                      weight = "weight")
#   })
#
#   observeEvent(input$dissipating, {
#     google_map_update(map_id = "Map1") %>%
#       update_heatmap(data = df,
#                      option_opacity = opacity(),
#                      option_radius = radius() * 1000,
#                      option_dissipating = dissipating(),
#                      option_gradient = gradient(),
#                      update_map_view = F,
#                      weight = "weight")
#   })
#
#   observeEvent(input$colours, {
#
#     google_map_update(map_id = "Map1") %>%
#       update_heatmap(data = df,
#                      option_opacity = opacity(),
#                      option_radius = ifelse(dissipating(), radius() * 1000, radius()),
#                      option_dissipating = dissipating(),
#                      option_gradient = gradient(),
#                      update_map_view = F,
#                      weight = "weight")
#   })
#
#   observeEvent(input$weights, {
#
#     df$weight <- sample(100:500, nrow(df), replace = T)
#
#     google_map_update(map_id = "Map1") %>%
#       update_heatmap(data = df,
#                      option_opacity = opacity(),
#                      option_radius = ifelse(dissipating(), radius() * 1000, radius()),
#                      option_dissipating = dissipating(),
#                      option_gradient = gradient(),
#                      update_map_view = F,
#                      weight = "weight")
#
#   })
#
# }
# shinyApp(ui, server)

# ## Info windows are updated

# library(shiny)
#
# ui <- fluidPage(
#   google_mapOutput(outputId = "map"),
#   actionButton(inputId = "btn", label = "randNumber")
# )
#
# server <- function(input, output){
#
#
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#   df <- melbourne
#   df$rand <- as.character(rnorm(nrow(df)))
#
#   output$map <- renderGoogle_map({
#     google_map(key = map_key) %>%
#       add_polygons(data = df, polyline = "polyline",
#                    info_window = "rand", id = "polygonId")
#   })
#
#   observeEvent(input$btn, {
#
#     df <- melbourne
#     df$rand <- as.character(rnorm(nrow(df)))
#
#     google_map_update(map_id = "map") %>%
#       update_polygons(data = df, id = "polygonId", info_window = "rand")
#
#   })
#
# }
# shinyApp(ui, server)


# # place details returned to shiny
# library(shiny)
#
# ui <- fluidPage(
#   google_mapOutput(outputId = "map")
# )
# server <- function(input, output){
#
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#   output$map <- renderGoogle_map({
#     google_map(key = map_key, search_box = T, event_return_type = 'json')
#   })
#
#   observeEvent(input$map_place_search, {
#     event <- input$map_place_search
#     print(event)
#   })
# }
# shinyApp(ui, server)

# updating heatmap legend
# library(shiny)
#
# ui <- fluidPage(
#   sliderInput(inputId = "sample", label = "sample", min = 1, max = 10,
#               step = 1, value = 10),
#   google_mapOutput(outputId = "map")
# )
#
# server <- function(input, output){
#
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#   # set.seed(20170417)
#   df <- tram_route[sample(1:nrow(tram_route), size = 10 * 100, replace = T), ]
#   df$weight <- 1:nrow(df)
#   option_gradient <- c('orange', 'blue', 'mediumpurple4', 'snow4', 'thistle1')
#
#   output$map <- renderGoogle_map({
#     google_map(key = map_key) %>%
#       add_heatmap(data = df, weight = "weight", lat = "shape_pt_lat", lon = "shape_pt_lon",
#                   option_gradient = option_gradient,
#                   option_radius = 0.001, legend = T)
#   })
#
#   observeEvent(input$sample,{
#
#     df <- tram_route[sample(1:nrow(tram_route), size = input$sample * 100, replace = T), ]
#     df$weight <- 1:nrow(df)
#     google_map_update(map_id = "map") %>%
#       update_heatmap(data = df, weight = "weight", lat = "shape_pt_lat",
#                      lon = "shape_pt_lon", legend = T,
#                      option_gradient = option_gradient,
#                      update_map_view = F)
#   })
# }
#
# shinyApp(ui, server)


# observing map edits
# ui <- fluidPage(
#   google_mapOutput(outputId = "map", height = "800px")
# )
# server <- function(input, output){
#
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
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

## Circle legend add/remove
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



## Multiple legends
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


# library(shiny)
#
# ui <- fluidPage(
#   google_mapOutput(outputId = "map", height = "800px")
# )
#
# server <- function(input, output){
#
#   mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#   output$map <- renderGoogle_map({
#     google_map(key = mapKey) %>%
#       add_drawing(drawing_modes = c("circle"))
#   })
#
#
#   observeEvent(input$map_circlecomplete, {
#     print(input$map_circlecomplete)
#   })
# }
# shinyApp(ui, server)








