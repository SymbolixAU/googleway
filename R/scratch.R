#
# library(jqr)
#
# apiKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_API_KEY")
#
# js <- google_directions(origin = c(-37.8179746, 144.9668636),
#                         destination = c(-37.81659, 144.9841),
#                         mode = "walking",
#                         key = apiKey,
#                         simplify = FALSE)
#
# # Formats the JSON response into an ARRAY
# #createArray <- function(js) paste0("[", paste0(js, collapse = ""), "]")
#
# ## directions:
# ## legs:
#
# js2 <- createArray(js)
#
# js <- paste0(js, collapse = "")
#
# js %>%
#   dot() %>%
#   select(geo = .geocoded_waypoints) %>%
#   index()
#
# js %>%
#   dotindex(geocoded_waypoints)
#
# jq(js, ".geocoded_waypoints[]")
#
# legs <- jq(js, ".routes[].legs[].steps")
#
# jq(js, ".routes[].overview_polyline.points")
#
#
#
# js %>% keys()
#
#
#
# js %>%
#   index("geocoded_waypoints")
#
# js %>%
#   select(geo = .geocoded_waypoints)
#
#
#
#
#
