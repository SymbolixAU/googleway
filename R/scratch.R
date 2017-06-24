#
#
# library(googleway)
#
# ## using a valid Google Maps API key
# key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_API_KEY")
#
# ## Using the first and last coordinates as the origin/destination
# origin <- c(17.48693, 78.38945)
# destination <- c(17.47077, 78.35874)
#
# # and the coordinates in between as waypoints
# waypoints <- list(via = c(17.49222, 78.39643),
#                   via = c(17.51965, 78.37835),
#                   via = c(17.49359, 78.40079),
#                   via = c(17.49284, 78.40686)
# )
# ## use 'stop' in place of 'via' for stopovers
#
# ## get the directions from Google Maps API
# res <- google_directions(origin = origin,
#                          destination = destination,
#                          waypoints = waypoints,
#                          key = key)
#
# key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#
# pl <- data.frame(polyline = res$routes$overview_polyline$points)
#
# google_map(key = key) %>%
#   add_polylines(data = pl, polyline = "polyline")
