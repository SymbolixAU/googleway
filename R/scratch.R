

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
#               info_window = chartList
#               )

