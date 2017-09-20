context("Google distance")

# test_that("google_distance returns data.frame", {
#
#   skip_on_cran()
#   skip_on_travis()
#   key <- read.dcf("~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))
#
#   df <- google_distance(origins = list(c(-37.8179746, 144.9668636)),
#                         destinations = list(c(-37.81659, 144.9841)),
#                         mode = "walking",
#                         key = key,
#                         simplify = TRUE)
#
#   expect_equal(class(df), "list")
#   expect_equal(names(df), c("destination_addresses","origin_addresses","rows","status"))
# })
#

test_that("origins are lat/lon", {

  expect_error(google_distance(origins = list(c(144.9668636)),
                               destinations = c(-37.81659, 144.9841),
                               mode = "driving",
                               key = "abc"),
               "Origins elements must be either a numeric vector of lat/lon coordinates, or an address string")

})

test_that("Destinations are lat/lon", {

  expect_error(google_distance(origins = list(c(-37.8179746, 144.9668636)),
                               destinations = c(-37.81659),
                               mode = "driving",
                               key = "abc"),
               "Destinations elements must be either a numeric vector of lat/lon coordinates, or an address string")

})

test_that("Avoid is a valid type", {

  expect_error(google_distance(origins = list(c(-37.8179746, 144.9668636)),
                                 destinations = list(c(-37.81659, 144.9841)),
                                 avoid = "dont avoid",
                                 key = "abc",
                                 simplify = TRUE),
               "avoid can only include tolls, highways, ferries or indoor")
})

test_that("Departure time is not in the past",{

  expect_error(google_distance(origins = list(c(-37.8179746, 144.9668636)),
                               destinations = list(c(-37.81659, 144.9841)),
                                 departure_time = as.POSIXct("2015-01-01"),
                                 key = "abc",
                                 simplify = TRUE),
               "departure_time must not be in the past")

})

# test_that("waypoints only valid for certain modes",{
#
#   expect_error(google_distance(origins = "Melbourne Airport",
#                                  destinations = "Sorrento",
#                                  waypoints = list(c(-37.81659, 144.9841),
#                                                   "Ringwood, Victoria"),
#                                  mode = "transit",
#                                  key = "abc"),
#                "waypoints are only valid for driving, walking or bicycling modes")
# })

# test_that("waypoints are a list",{
#
#   expect_error(google_distance(origins = "Melbourne Airport",
#                                  destinations = "Sorrento",
#                                  waypoints = c(-37.81659, 144.9841),
#                                  key = "abc"),
#                "waypoints must be a list")
# })

# test_that("alternatives either TRUE or FALSE",{
#
#   expect_error(google_distance(origins = "Melbourne Airport",
#                                  destinations = "Sorrento",
#                                  alternatives = c(FALSE, TRUE),
#                                  key = "abc"))
# })

test_that("transit_mode issues warning when mode != transit",{

  expect_warning(google_distance(origins = "Melbourne Airport, Australia",
                                 destinations = "Portsea, Melbourne, Australia",
                                 departure_time = Sys.time() + (24 * 60 * 60),
                                 transit_mode = "bus",
                                 key = "abc"),
                 "You have specified a transit_mode, but are not using mode = 'transit'. Therefore this argument will be ignored")

})

test_that("warning when both arrival and departure times supplied", {

  expect_warning(google_distance(origins = "Melbourne Airport, Australia",
                                   destinations = "Portsea, Melbourne, Australia",
                                   departure_time = Sys.time() + (24 * 60 * 60),
                                   arrival_time = Sys.time() + (24 * 60 * 60),
                                   key = "abc"),
                 "you have supplied both an arrival_time and a departure_time - only one is allowed. The arrival_time will be ignored")

})


test_that("data frames are accepted", {

  g <- google_distance(origins = tram_stops[1:5, c("stop_lat", "stop_lon")],
                       destinations = tram_stops[10:12, c("stop_lat", "stop_lon")],
                       key = "abc")

  expect_true( g$status == "REQUEST_DENIED")


  expect_error(
    google_distance(origins = tram_stops[1:5, ],
                    destinations = tram_stops[10:12, c("stop_lat", "stop_lon")],
                    key = "abc"),
    "A data.frame can have a maximum of two columns"
  )

})







