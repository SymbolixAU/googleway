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






### geoJSON

# geojson_txt <- '{
#         "type" : "Feature",
#         "properties" : {
#           "id" : 1,
#           "color" : "green",
#           "strokeColor" : "blue"
#         },
#         "geometry" : {
#           "type" : "Polygon", "coordinates" : [
#             [
#               [144.88, -37.85],
#               [145.02, -37.85],
#               [145.02, -37.80],
#               [144.88, -37.80],
#               [144.88, -37.85]
#             ]
#           ]
#         }
# }'
#
# geojson_txt2 <- '{
#       "type" : "FeatureCollection",
#       "features" : [
#         {
#         "type" : "Feature",
#           "properties" : {
#           "id" : 1,
#           "fillColor" : "red",
#           "strokeColor" : "green",
#           "strokeWeight" : 1
#           },
#           "geometry" : {
#           "type" : "Polygon", "coordinates" : [
#           [
#               [144.80, -37.85],
#               [144.88, -37.85],
#               [144.88, -37.80],
#               [144.80, -37.80],
#               [144.80, -37.85]
#           ]
#         ]
#           }
#         }
#     ]
# }'
#
# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#
# style <- '{ "property" : "id", "value" : 1, "features" : { "fillColor" : "white" } }'
#
#
# google_map(key = mapKey) %>%
#   add_geojson(geojson = geojson_txt, layer_id = "hi") %>%
#   add_geojson(geojson = geojson_txt2, layer_id = "world") %>%
#   update_geojson(style = style, layer_id = "world")

### style object
# style <- ' { "fillColor" : "red" } '
#
### style specifies the node of the geoJSON

# style <- '{ "fillColor" : "yellow" }'
# google_map(key = mapKey) %>%
#   add_geojson(geojson = geojson_txt, style = style)









# library(sf)
# library(geojsonio)
#
# nc <- st_read(system.file("shape/nc.shp", package="sf"))
#
# nc$fillColor <- "red"
# nc$strokeWeight <- 0.1
#
# geo_nc <- geojson_json(nc)
#
# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# google_map(key = mapKey, location = c(34.2, -80), zoom = 6) %>%
#   add_geojson(geo_nc)
# #
#
# style <- '{ "fillColor" : "green" , "strokeColor" : "blue"}'
#
# google_map(key = mapKey) %>%
#   add_geojson(geo_nc, style = style)
#
#
# style <- '{
#   "property" : "AREA",
#   "value" : 0.1263,
#   "operator" : "<=",
#   "features" : {
#     "fillColor" : "blue"
#   }
# }'
#
#
# google_map(key = mapKey) %>%
#   add_geojson(geo_nc) %>%
#   update_geojson(style = style)

# google_map(key = mapKey) %>%
#   add_polygons(data = melbourne, polyline = "polyline",
#                fill_colour = "SA2_NAME", fill_opacity = 0.9)

#
#
#
# library(ggplot2)
#
#
# unemp <- read.csv("http://datasets.flowingdata.com/unemployment09.csv",
#                   header = FALSE, stringsAsFactors = FALSE)
# names(unemp) <- c("id", "state_fips", "county_fips", "name", "year",
#                   "?", "?", "?", "rate")
# unemp$county <- tolower(gsub(" County, [A-Z]{2}", "", unemp$name))
# unemp$county <- gsub("^(.*) parish, ..$","\\1", unemp$county)
# unemp$state <- gsub("^.*([A-Z]{2}).*$", "\\1", unemp$name)
#
# county_df <- map_data("county", parameters = c(39, 45))
#
# names(county_df) <- c("long", "lat", "group", "order", "state_name", "county")
# county_df$state <- state.abb[match(county_df$state_name, tolower(state.name))]
# county_df$state_name <- NULL
#
# state_df <- map_data("state", parameters = c(39, 45))
#
# choropleth <- merge(county_df, unemp, by = c("state", "county"))
# choropleth <- choropleth[order(choropleth$order), ]
#
# google_map(key = mapKey) %>%
#   add_polygons(data = choropleth, lat = "lat",
#                lon = "long", id = "id", pathId = "group",
#                fill_colour = "rate")
#
#
# library(data.table)
#
# setDT(choropleth)
#
# dt <- choropleth[, .(polyline = encode_pl(lat, long)), by = .(state, county, group, id, rate)]
#
# google_map(key = mapKey) %>%
#   add_polygons(data = dt, polyline = "polyline",
#                id = "id", pathId = "group",
#                fill_colour = "rate", stroke_weight = 0.1, palette = viridisLite::magma)





# library(geojsonio)
# library(sf)
# library(spatialdatatable)
# library(symbolix.utils)
# library(googleway)
#
# # usCounties <- geojson_read("http://eric.clst.org/wupl/Stuff/gz_2010_us_050_00_500k.json")
#
# # sfCounties <- st_read("http://eric.clst.org/wupl/Stuff/gz_2010_us_050_00_500k.json")
# #
# ## US census shapes
# ## https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html
# sf <- st_read("~/Downloads/cb_2016_us_county_500k/")
#
# sdtCounties <- EncodeSF(sf)
# sdtCounties
#
# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# google_map(key = mapKey) %>%
#   add_polygons(data = sdtCounties, polyline = "polyline", id = ".id",
#                fill_opacity = 0.8, stroke_weight = 0.3,
#                stroke_colour = "#FFFFFF", fill_colour = "COUNTYFP")
#
# library(tidycensus)
#
# dt_fips <- fips_codes
# setDT(dt_fips)
#
#
#
#
# sdtCounties[, `:=`(COUNTYFP = as.numeric(COUNTYFP),
#                    STATEFP = as.numeric(STATEFP))]
#
# sdtCounties[, `:=`(NAME = tolower(as.character(iconv(NAME))))]
#
# google_map(key = mapKey) %>%
#   add_polygons(data = sdtCounties[STATEFP == 7], polyline = "polyline")
#
#
# sdt <- sdtCounties[
#   unique(unemp[, .(state_fips, county_fips, rate)])
#   , on = c(COUNTY = "county_fips", STATE = "state_fips")
#   , nomatch = 0
#   ]
#
# google_map(key = mapKey()) %>%
#   add_polygons(data = sdt, polyline = "polyline", fill_opacity = 0.8,
#                stroke_weight = 0.3, stroke_colour = "#FFFFFF", fill_colour = "rate")
#

