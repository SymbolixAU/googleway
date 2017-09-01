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
# googleway:::direction_routes(js)
# googleway:::direction_legs(js)
# googleway:::direction_points(js)
