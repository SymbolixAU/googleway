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
#
# apiKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_API_KEY")
#
# lst <- google_geocode(address = "Flinders Street Station, Melbourne",
#                       key = apiKey)
#
# js <- google_geocode(address = "Flinders Street Station, Melbourne",
#                      key = apiKey,
#                      simplify = FALSE)
#
#
# js <- google_distance(origins = list(c("Melbourne Airport, Australia"),
#                                c("MCG, Melbourne, Australia"),
#                                c(-37.81659, 144.9841)),
#                 destinations = c("Portsea, Melbourne, Australia"),
#                 key = apiKey,
#                 simplify = FALSE)
#
# lst <- google_distance(origins = list(c("Melbourne Airport, Australia"),
#                                       c("MCG, Melbourne, Australia"),
#                                       c(-37.81659, 144.9841)),
#                        destinations = c("Portsea, Melbourne, Australia"),
#                        key = apiKey,
#                        simplify = TRUE)
