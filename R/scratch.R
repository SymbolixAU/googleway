# library(shinydashboard)
# library(shiny)
# library(magrittr)
# library(leaflet)
# library(googleway)
# library(data.table)

# ui <- dashboardPage(
#   dashboardHeader(),
#   dashboardSidebar(),
#   dashboardBody(
#     sliderInput(inputId = "slider", label = "heat",
#                 min = 0, max = 100, value = 50, animate = T),
#     actionButton(inputId = "traffic", label = "traffic"),
#     box(width = 10,
#         height = 600,
#       google_mapOutput("myMap")
#     )
#   )
# )
#
#
# server <- function(input, output){
#
# set.seed(123)
# df_line$weight <- runif(nrow(df_line), min = 1, max = 100)
# # df_line$weight <- row.names(df_line)
# df_line$opacity <- 0.2
# df_line$title <- paste0("<p><b>", df_line$weight, "</b></p><p>", df_line$weight, "</p>")
# df_line$title <- sample(letters, nrow(df_line), replace = T)

   # output$myMap <- renderGoogle_map({
#
# google_map(key = map_key, data = df_line, search_box = T, height = 800) %>%
# #  add_markers(info_window = "title", title = "title", cluster = T) %>%
#   googleway:::add_polyline(data = df_routes, group = "id")
#
# df <- data.frame(polyline = c(pl, pl2, pl3))
# df$id <- c(1,2,3)
# df$weight <- runif(3)
# google_map(key = map_key, search_box = T, height = 800) %>%
#   googleway:::add_polygon(data = df, polyline = "polyline", fill_opacity = "weight")
#
#
#})
#
#   observe({
#
#     df <- df_line[df_line$weight >= (input$slider - 1), ]
#
#     google_map_update(map_id = "myMap") %>%
#      # update_heatmap()
#       clear_markers() %>%
#       add_markers(data = df, lat = "lat", lon = "lon")
#
#       # update_heatmap(data = df)
#   })
#
#   observe({
#     if(input$traffic){
#
#       if(as.numeric(input$traffic) %% 2 == 0){
#         google_map_update(map_id = 'myMap') %>%
#           add_traffic()
#       }else{
#         google_map_update(map_id = 'myMap') %>%
#           clear_traffic()
#       }
#     }
#   })
#
# }
#
# shinyApp(ui, server)
# library(png)
# key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_STATIC_MAP")
# temp_file <- tempfile()
# map_url <- paste0("https://maps.googleapis.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=12&size=400x400&key=", key)
# download.file(map_url, temp_file, mode = "wb")
# map <- readPNG(temp_file)
# map
# file.remove(temp_file)

# df <- data.frame(table(df_routes$id))
#
# df$end <- cumsum(df$Freq)
#
# df$start <- df$end - df$Freq
#
# c(1, diff(df$end))
#
# df_routes
#
# ave(df_routes[, c("lat","lon")], df_routes$id, FUN = function(x) gepaf::encodePolyline)
#
# lst <- split(df_routes, df_routes$id)
#
# lapply(lst, function(x){ gepaf::encodePolyline(x[, c("lat","lon")])   })
#
#
#
#
# group_options <- data.frame(group = c(1,2,3),
#                             strokeColour = c("#00ff00","#ff00ff","#ffff00"),
#                             strokeOpacity = c(0.3, 0.2, 0.9),
#                             strokeWeight = c(2,3,4),
#                             fillColour = c("#00ff00","#ff00ff","#ffff00"),
#                             fillOpacity = c(0.9, 0.5, 0.2))
#
#
# polyline <- lapply(split(df_routes, df_routes$id),
#                    function(x){
#                      data.frame(polyline = gepaf::encodePolyline(x[, c("lat","lon")]),
#                                 group = unique(x['id']))
#                    })
#
#
# s <- split(df_routes, df_routes$id)
#
# lapply(s, function(x){
#   ## create polyline
#   pl <- gepaf::encodePolyline(x[, c("lat", "lon")])
#   i <- unique(x[, 'id'])
#   data.frame(pl = pl, id = i)
# })





