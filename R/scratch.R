

## TODO:
## TESTS
## - polylines - works with and without ID, for polyline and lat/lon columns
## - polygons - ditto


# library(googleway)
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 7))
# markerCharts$year <- c("2010","2011","2012","2013","2014","2015","2016")
# markerCharts$paid <- sample(1:10, size = nrow(markerCharts), replace = T)
# markerCharts$unpaid <- sample(1:10, size = nrow(markerCharts), replace = T)
#
#
# chartList <- list(data = markerCharts[markerCharts$stop_id == "17880",],
#                   type = 'bar',
#                   options = NULL)
#
# google_map(key = map_key) %>%
#   add_markers(data = tram_stops[tram_stops$stop_id == "17880",],
#               id = "stop_id",
#               #info_window = chartList
#               )


# markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 3))
# markerCharts$variable <- c("yes", "no", "maybe")
# markerCharts$value <- sample(1:10, size = nrow(markerCharts), replace = T)
#
# chartList <- list(data = markerCharts,
#                   type = 'pie',
#                   options = list(title = "my pie", is3D = TRUE))
#
# googleway:::DataTableColumn(markerCharts, "stop_id", c("variable", "value"))
# googleway:::DataTableHeading(markerCharts, cols = c("variable", "value"))
#
# google_map() %>% add_markers(data = tram_stops, info_window = chartList)


# - name: markers.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: markers.js
# - name: MarkerClusterer
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: markerclusterer.js
# - name: map_events.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: map_events.js
# - name: legend.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: legend.js
# - name: rectangles.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: rectangles.js
# - name: polylines.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: polylines.js
# - name: polygons.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: polygons.js
# - name: kml.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: kml.js
# - name: heatmap.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: heatmap.js



# - name: circles.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: circles.js

# - name: geojson.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: geojson.js
# - name: overlay.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: overlay.js
# - name: fusion.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: fusion.js
# - name: map_layers.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: map_layers.js
# - name: drawing.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: drawing.js
# - name: charts.js
# version: 1.0.0
# src: "htmlwidgets/lib"
# script: charts.js


# set_key(read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY"))
# g <- google_map() %>%
#   add_markers(data = tram_stops)
#
# g <- google_map() %>%
#   add_markers(data = tram_stops) %>%
#   add_polylines(data = tram_route, lat = "shape_pt_lat", lon = "shape_pt_lon") %>%
#   add_polygons(data = melbourne, polyline = "polyline") %>%
#   add_traffic() %>%
#   add_circles(data = tram_stops, radius = 500) %>%
#   add_heatmap(data = tram_stops)

#htmlwidgets::saveWidget(g, file = "~/Documents/development/googleway/g", selfcontained = T)
