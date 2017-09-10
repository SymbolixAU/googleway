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
#   googleway:::add_polygon2(data = melbourne, id = "polygonId", fill_colour = "SA2_NAME",
#                            stroke_colour = "SA2_NAME", fill_opacity = 0.8, mouse_over_group = "SA3_NAME",
#                            pathId = "pathId", polyline = "polyline")


#
# objArgs <- quote(googleway:::add_shape(map = ., data = df[1:10, ], id = "stop_id",stroke_colour = "#FF00FF",
#                                        lat = "stop_lat", lon = "stop_lon", radius = 200,
#                                        fill_colour = "rand", mouse_over_group = "stop_name"))
#
# objArgs <- googleway:::latLonCheck(objArgs, "stop_lat", "stop_lon", names(df), "add_circles")
# names(objArgs)
#
# allCols <- c('id', 'lat', 'lng', 'radius', 'draggable', 'stroke_colour',
#              'stroke_opacity', 'stroke_weight', 'fill_colour', 'fill_opacity',
#              'mouse_over', 'mouse_over_group', 'info_window')
#
# requiredCols <- c("stroke_colour", "stroke_weight", "stroke_opacity", "radius",
#                   "fill_opacity", "fill_colour", "z_index")
#
#
# shape <- googleway:::createMapObject(df, allCols, objArgs)
# head(df)
# head(shape)
#
# colourColumns <- c("stroke_colour" = NULL,
#                    "fill_colour" = "rand")
#
#
# print(" -- palettes --")
# palettes <- googleway:::createPalettes(shape, colourColumns)
# print(palettes)
#
# print(" -- colour palettes -- ")
# colour_palettes <- googleway:::createColourPalettes(df, palettes, colourColumns)
# print(colour_palettes)
#
#
# print(" -- colours -- ")
# colours <- googleway:::createColours(shape, colour_palettes)
# colours
# head(shape, 10)
#
#
# if(length(colours) > 0){
#
#   eachColour <- sapply(colours, `[`)[, 1]
#
#   #colourNames <- sapply(colours, function(x) dimnames(x)[[2]])=
#   colourNames <- names(colours)
#   # colourNames <- dimnames(colours[[1]])[[2]]
#   # shape[, c(colourNames)] <- colours[[1]][, colourNames]
#   shape[, c(colourNames)] <- eachColour
# }
#
# requiredDefaults <- setdiff(requiredCols, names(shape))
# if(length(requiredDefaults) > 0){
#
#   defaults <- googleway:::circleDefaults(nrow(shape))
#
#   shape <- cbind(shape, defaults[, requiredDefaults])
# }
#
# shape <- jsonlite::toJSON(shape, digits = 7, auto_unbox = T)


# colourColumns <- structure(c("stop_name", "rand"), .Names = c("stroke_colour",
#                                                               "fill_colour"))
#
# palette <- googleway:::createPalettes(shape,colourColumns)
# colour_palettes <- googleway:::createColourPalettes(df, palette, colourColumns)
# googleway:::createColours(shape, colour_palettes)
#
# lapply(colour_palettes, function(x){
#   pal <- x[['palette']]
#   vars <- x[['variables']]
#
#   sapply(attr(vars, 'names'), function(y) {
#     pal[['colour']][ match(shape[[y]], pal[['variable']]) ]
#   })
# })

# DOESNT WORK: fill_colour only
# google_map(key = mapKey) %>%
#   googleway:::add_shape(data = df[1:10,], id = "stop_id",
#                         lat = "stop_lat", lon = "stop_lon", radius = 200,
#                         fill_colour = "rand", mouse_over_group = "stop_name")
#

# shape <- structure(list(id = c("17880", "17892", "17893", "18010", "18011",
# "18030"), lat = c(-37.809, -37.8094, -37.8083, -37.8076, -37.8081,
# -37.8095), lng = c(144.9731, 144.9729, 144.9731, 144.9709, 144.969,
# 144.9641), fill_colour = c(0.445825678928034, 0.942978152937198,
# 0.212424769105635, 0.0215267032474942, 0.586218127322045, -0.848655484877649
# ), mouse_over_group = c("10-Albert St/Nicholson St (Fitzroy)",
# "10-Albert St/Nicholson St (East Melbourne)", "11-Victoria Pde/Nicholson St (East Melbourne)",
# "9-La Trobe St/Victoria St (Melbourne City)", "8-Exhibition St/La Trobe St (Melbourne City)",
# "6-Swanston St/La Trobe St (Melbourne City)"), radius = c(200,
# 200, 200, 200, 200, 200)), .Names = c("id", "lat", "lng", "fill_colour",
# "mouse_over_group", "radius"), row.names = c(NA, 6L), class = "data.frame")
#
# colourColumns <- structure("rand", .Names = "fill_colour")
#
# palette <- googleway:::createPalettes(shape,colourColumns)
# googleway:::createColourPalettes(df, palette, colourColumns)
#

# DOESNT WORK: stroke_colour only
# google_map(key = mapKey) %>%
#   googleway:::add_shape(data = df[1:10,], id = "stop_id", stroke_colour = "stop_name",
#                         lat = "stop_lat", lon = "stop_lon", radius = 200,
#                         mouse_over_group = "stop_name")

# DOESNT WORK: the same colour values
# google_map(key = mapKey) %>%
#   googleway:::add_shape(data = df[1:10,], id = "stop_id", stroke_colour = "rand",
#                         lat = "stop_lat", lon = "stop_lon", radius = 200,
#                         fill_colour = "rand", mouse_over_group = "stop_name")




