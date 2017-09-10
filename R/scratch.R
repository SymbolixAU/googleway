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
# WORKS: different names for different colours
# df <- tram_stops
# df$rand <- rnorm(nrow(df))
# google_map(key = mapKey) %>%
#   googleway:::add_circle2(data = df[1:10,], id = "stop_id",
#                         lat = "stop_lat", lon = "stop_lon", radius = 200,
#                         fill_colour = "stop_name", mouse_over_group = "stop_name")
#
# google_map(key = mapKey) %>%
#   googleway:::add_polygon2(data = melbourne,  fill_colour = "SA2_NAME",
#                            stroke_colour = "SA2_NAME", fill_opacity = 0.8, mouse_over_group = "SA3_NAME",
#                            polyline = "polyline")
#
#
#
#

# pl_outer <- encode_pl(lat = c(25.774, 18.466,32.321),
#                       lon = c(-80.190, -66.118, -64.757))
#
# pl_inner <- encode_pl(lat = c(28.745, 29.570, 27.339),
#                       lon = c(-70.579, -67.514, -66.668))
#
# df <- data.frame(id = c(1, 1),
#                  polyline = c(pl_outer, pl_inner),
#                  stringsAsFactors = FALSE)
#
# df <- aggregate(polyline ~ id, data = df, list)
#
# google_map(key = mapKey, height = 800) %>%
#   googleway:::add_polygon2(data = df, polyline = "polyline")
#
#
# df <- data.frame(id = c(1,1),
#                  polyline = c(pl_outer, pl_inner),
#                  stringsAsFactors = FALSE)
#
# google_map(key = mapKey, height = 800) %>%
#   googleway:::add_polygon2(data = df, polyline = "polyline", id = "id",
#                            fill_colour = "id")
#
#
#
# df <- data.frame(myId = c(1,1,1,1,1,1,2,2,2),
#                  lineId = c(1,1,1,2,2,2,1,1,1),
#                  lat = c(26.774, 18.466, 32.321, 28.745, 29.570, 27.339, 22, 23, 22),
#                  lon = c(-80.190, -66.118, -64.757, -70.579, -67.514, -66.668, -50, -49, -51),
#                  stringsAsFactors = FALSE)
#
# google_map(key = mapKey) %>%
#   googleway:::add_polygon2(data = df, lat = 'lat', lon = 'lon', id = 'myId',
#                            pathId = 'lineId', fill_colour = "myId")


