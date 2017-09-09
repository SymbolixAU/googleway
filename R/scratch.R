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
#   googleway:::add_shape(data = tram_stops, id = "stop_id",
#                         lat = "stop_lat", lon = "stop_lon", fill_colour = "stop_name")


#
#
# googleway:::add_shape(tram_stops, lat = "stop_lat", lon = "stop_lon",
#                       stroke_colour = "stop_name", fill_colour = "stop_name")



# numericColours <- c(1, 2, 3.3, 3.333, 500, 2000)
#
# rank(numericColours)
#
# map2color <- function(x,pal,limits=NULL){
#   if(is.null(limits))
#     limits=range(x)
#
#   s <- seq(limits[1],limits[2], length.out = length(pal)+1)
#   f <- findInterval(x, s, all.inside=TRUE)
#   pal[f]
# }
#
# rng <- range(numericColours)
# s <- seq(rng[1], rng[2], length.out = 5 + 1)
# f <- findInterval(numericColours, s, all.inside = T)
# viridisLite::viridis(length(numericColours))[f]
#
#
# map2color(numericColours, viridisLite::viridis(length(numericColours)))




# colour_palettes <- list(structure(list(variables = structure(c("colour", "colour"
# ), .Names = c("stroke_colour", "fill_colour")), palette = structure(list(
#   variable = c("a", "b", "c", "d", "e"), colour = c("#440154FF",
#                                                     "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF")), .Names = c("variable",
#                                                                                                                      "colour"), row.names = c(NA, -5L), class = "data.frame")), .Names = c("variables",
#                                                                                                                                                                                            "palette")))
#
# shape <- df[, c("colour", "colour")]
# shape <- setNames(shape, c("fill_colour", "stroke_colour"))
#
# colours <- lapply(colour_palettes, function(x){
#   pal <- x[['palette']]
#   vars <- x[['variables']]
#
#   sapply(attr(vars, 'names'), function(y) {
#     pal[['colour']][ match(shape[[y]], pal[['variable']]) ]
#   })
#
# })
#
# colourNames <- dimnames(colours[[1]])[[2]]
# shape[, c(colourNames)] <- colours[[1]][, colourNames]


