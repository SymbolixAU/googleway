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


