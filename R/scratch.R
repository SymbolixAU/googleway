#
# apiKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_API_KEY")


## elevation data from the MCG to the beach at Elwood (due south)
# df <- data.frame(lat = c(-37.81659, -37.88950),
#                  lon = c(144.9841, 144.9841))
#
# lst <- google_places(search_string = "Restaurants in Melbourne, Australia",
#                      key = apiKey)
#
# js <- google_places(search_string = "Restaurants in Melbourne, Australia",
#                      key = apiKey, simplify = FALSE)


# df_points <- read.table(text = "lat lon
# 60.1707 24.9426
#                         60.1708 24.9424
#                         60.1709 24.9423", header = T)
#
# js <- google_nearestRoads(df_points, key = apiKey, simplify = FALSE)
#
# lst <- google_nearestRoads(df_points, key = apiKey, simplify = TRUE)
#


# lst <- google_geocode(address = "MCG, Melbourne, Australia",
#                       key = apiKey,
#                       simplify = TRUE)
#
#
#
# js <- google_geocode(address = "MCG, Melbourne, Australia",
#                       key = apiKey,
#                       simplify = FALSE)
#
# geocode_type(js)
#
# geocode_type(lst)
#
#
# lst <- google_reverse_geocode(location = c(38.36648, -76.48020), key = apiKey)
#
# geocode_type(lst)
#
# z <- 1
# foo <- function(df, x, y = NULL, z){
#   #mget(c("x", "y"))
#   print(match.call(expand.dots = F))
#   mf <- match.call(expand.dots = F)
#   mf
#   #m <- match(c("x","y"), names(mf), 0)
#
#   #mf <- mf[c(1, m)]
#
#   #mf$drop.unused.levels <- TRUE
#   #mf[[1]] <- as.name("model.frame")
#   #mf <- eval.parent(mf)
#   #mf
# }
# df <- data.frame(val = 1, val2 = "a")
#
# res <- foo(df, x = "val", z = "val")
#
# str(res)
# names(res)
#
# cols <- c('x','y','z')
# m <- match(cols, names(res))
#
# n <- names(res)[m]
# n <- n[!is.na(n)]
# v <- vapply(m[!is.na(m)], function(x) res[[x]], "")
# setNames(df[, v], n)
#
# circle <- function(data, stroke_colour = NULL, fill_colour = NULL,
#                    stroke_weight = NULL){
#
#   objArgs <- match.call(expand.dots = F)
#   dput(objArgs)
#   cols <- c("stroke_colour", "fill_colour", "stroke_weight")
#
#   googleway:::createMapObject(data, cols, objArgs)
#
# }

# df <- data.frame(lat = 1:20, lon = 11:30,
#                  strings = sample(letters[1:5], 20, replace = T),
#                  id = 1:5)
#
# df$colour <- viridisLite::viridis(nrow(df))
# df$fac <- factor(df$colour)
#
# googleway:::add_shape(df, id = "id", stroke_colour = "colour")
# googleway:::add_shape(df, id = "id", stroke_colour = "strings")
# googleway:::add_shape(df, id = "id", stroke_colour = "id")

# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# google_map(key = mapKey) %>%
#   googleway:::add_shape(data = tram_stops, id = "stop_id", stroke_colour = "stop_name",
#                         lat = "stop_lat", lon = "stop_lon", radius = 200,
#                         fill_colour = "stop_name")


## UP TO:
# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# df <- tram_stops
# df$rand <- rnorm(nrow(df))
# google_map(key = mapKey) %>%
#   add_circles(data = df[1:10,], id = "stop_id", stroke_colour = "stop_id", fill_colour = "stop_lat",
#                         lat = "stop_lat", lon = "stop_lon", radius = 200,
#                         mouse_over_group = "stop_name") %>%
#   update_circles(data = df[1:10,], id = "stop_id", fill_colour = "rand")
#
# google_map(key = mapKey) %>%
#   add_polygon(data = melbourne, fill_colour = "SA2_NAME", stroke_colour = "SA2_NAME",
#                            fill_opacity = 0.8, mouse_over_group = "SA2_NAME",
#                            polyline = "polyline", palette = viridisLite::inferno)


# df <- data.frame(id = 1, north = 33.685, south = 33.671, east = -116.234, west = -116.251)
#
# google_map(key = mapKey) %>%
#   add_rectangles(data = df, id = "id", north = 'north', south = 'south',
#                  east = 'east', west = 'west', fill_colour = "north") %>%
#   update_rectangles(data = df, id = "id", stroke_colour = "#000000", fill_colour = "#FFAAFF")



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


## TODO:
## TESTS
## - polylines - works with and withotu ID, for polyline and lat/lon columns
## - polygons - ditto

























