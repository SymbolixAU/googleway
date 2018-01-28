

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


# library(shiny)
# ui <- fluidPage(
#   google_mapOutput('map')
# )
# server <- function(input, output){
#   output$map <- renderGoogle_map({
#     google_map(key = mapKey, event_return_type = "json") %>%
#       add_polygons(data = melbourne, polyline = "polyline")
#   })
#   observeEvent(input$map_polygon_click, {
#      print(input$map_polygon_click)
#   })
# }
# shinyApp(ui, server)

