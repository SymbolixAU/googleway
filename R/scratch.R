#
# apiKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_API_KEY")
#
# lst <- google_directions(origin = c(-37.8179746, 144.9668636),
#                         destination = c(-37.81659, 144.9841),
#                         mode = "walking",
#                         key = apiKey,
#                         simplify = TRUE)
#
# js <- google_directions(origin = c(-37.8179746, 144.9668636),
#                          destination = c(-37.81659, 144.9841),
#                          mode = "walking",
#                          key = apiKey,
#                          simplify = FALSE)
#
# map_url <- "https://maps.googleapis.com/maps/api/directions/json?&origin=-37.8179746,144.9668636&destination=-37.81659,144.9841&departure_time=1504215791&alternatives=false&units=metric&mode=walking&key=AIzaSyAxBffO67pqezBmgo34qr183SFx7olhwFI"
#
# js <- googleway:::collapseResult(js)
# jqr::jq(googleway:::collapseResult(js), ".routes[].legs[].steps[].html_instructions")
#
# lst$routes$legs[[1]]$steps[[1]]$html_instructions
#
# jqr::jq(js, ".routes[].legs[].steps[].polyline.points")
#
# direction_routes(js)
# direction_legs(js)
# direction_points(js)
# direction_steps(js)
# direction_points(js)

# direction_routes(lst)
# direction_legs(lst)
# direction_points(lst)
# direction_steps(lst)


# apiKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_API_KEY")
#
# lst <- google_geocode(address = "Flinders Street Station, Melbourne",
#                       key = apiKey)
#
# js <- google_geocode(address = "Flinders Street Station, Melbourne",
#                      key = apiKey,
#                      simplify = FALSE)
#
# js2 <- googleway:::collapseResult(js)
#
# jq(js2, ".results[].geometry.location")
#
# lst$results$geometry$location





