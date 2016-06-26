context("Google directions")

test_that("google_directions returns data.frame", {

  skip_on_cran()
  skip_on_travis()

  key <- read.dcf(file = "~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  df <- google_directions(origin = c(-37.8179746, 144.9668636),
                  destination = c(-37.81659, 144.9841),
                  mode = "walking",
                  key = key,
                  simplify = TRUE)

  expect_equal(class(df), "list")
  expect_equal(names(df), c("geocoded_waypoints","routes","status"))
  expect_equal(length(df[[1]]), 3)
})

test_that("incorrect mode throws error", {
  skip("incorrect error string in match.arg")
  expect_error(google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                         mode = "non-mode",
                         key = "abc",
                         simplify = TRUE),
               "'arg' should be one of \"driving\", \"walking\", \"bicycling\", \"transit\"")

})

test_that("incorrect simplify throws warning",{

  expect_error(google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                         mode = "driving",
                         key = "abc",
                         simplify = "TRUE"),
               "simplify must be logical - TRUE or FALSE")

})

test_that("origin is lat/lon", {

  expect_error(google_directions(origin = c(144.9668636),
                         destination = c(-37.81659, 144.9841),
                         mode = "driving",
                         key = "abc"),
               "Origin must be either a numeric vector of lat/lon coordinates, or an address string")

})

test_that("Destination is lat/lon", {

  expect_error(google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659),
                         mode = "driving",
                         key = "abc"),
               "Destination must be either a numeric vector of lat/lon coordinates, or an address string")

})

test_that("Avoid is a valid type", {

  expect_error(google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                         avoid = "dont avoid",
                         key = "abc",
                         simplify = TRUE),
               "avoid must be one of tolls, highways, ferries or indoor")
})

test_that("Departure time is not in the past",{

  expect_error(google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                         departure_time = as.POSIXct("2015-01-01"),
                         key = "abc",
                         simplify = TRUE),
               "departure_time must not be in the past")

})

test_that("waypoints only valid for certain modes",{

  expect_error(google_directions(origin = "Melbourne Airport",
              destination = "Sorrento",
              waypoints = list(via = c(-37.81659, 144.9841),
                                via = "Ringwood, Victoria"),
              mode = "transit",
              key = "abc"),
              "waypoints are only valid for driving, walking or bicycling modes")
})

test_that("waypoints are a list",{

  expect_error(google_directions(origin = "Melbourne Airport",
                         destination = "Sorrento",
                         waypoints = c(-37.81659, 144.9841),
                         key = "abc"),
               "waypoints must be a list")
})

test_that("map url is a single string",{

  expect_error(google_directions(origin = "Melbourne Airport",
                         destination = "Sorrento",
                         alternatives = c(FALSE, TRUE),
                         key = "abc"),
               "invalid map_url")
})


test_that("transit_mode issues warning when mode != transit",{

  skip_on_cran()
  skip_on_travis()

  key <- read.dcf(file = "~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                           destination = "Portsea, Melbourne, Australia",
                           departure_time = Sys.time() + (24 * 60 * 60),
                           waypoints = list(via = c(-37.81659, 144.9841),
                                            via = "Ringwood, Victoria"),
                           transit_mode = "bus",
                           key = key),
                 "You have specified a transit_mode, but are not using mode = 'transit'. Therefore this argument will be ignored")

})


test_that("waypoints are correctly named", {

  expect_error(google_directions(origin = "Melbourne Airport, Australia",
                                 destination = "Portsea, Melbourne, Australia",
                                 waypoints = list(c(-37.81659, 144.9841),
                                                  via = "Ringwood, Victoria"),
                                 key = "abc"),
               "waypoint list elements must be named either 'via' or 'stop'")

})

test_that("warning when both arrival and departure times supplied", {

  skip_on_cran()
  skip_on_travis()

  key <- read.dcf(file = "~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   departure_time = Sys.time() + (24 * 60 * 60),
                                   arrival_time = Sys.time() + (24 * 60 * 60),
                                   key = key),
                 "you have supplied both an arrival_time and a departure_time - only one is allowed. The arrival_time will be ignored")

})

test_that("transit mode warning",{

  skip_on_cran()
  skip_on_travis()

  key <- read.dcf(file = "~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   transit_mode = "train",
                                   key = key),
                 "You have specified a transit_mode, but are not using mode = 'transit'. Therefore this argument will be ignored")
})

test_that("transit mode choices are valid",{

  skip("incorrect error string in match.arg")

  expect_error(google_directions(origin = "Melbourne Airport, Australia",
                                 destination = "Portsea, Melbourne, Australia",
                                 mode = "transit",
                                 transit_mode = "transit_mode",
                                 key = "abc"),
               "'arg' should be one of \"bus\", \"subway\", \"train\", \"tram\", \"rail\"")


})

test_that("transit_routing_preferences issues warning", {

  skip_on_cran()
  skip_on_travis()

  key <- read.dcf(file = "~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   transit_routing_preference = "less_walking",
                                   key = key),
                 "You have specified a transit_routing_preference, but are not using mode = 'transit'. Therefore this argument will be ignored")

})


test_that("valid routing preferences", {

  skip("incorrect error string in match.arg")

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   mode = "transit",
                                   transit_mode = "train",
                                   transit_routing_preference = "hills are yum",
                                   key = "abc"),
                 "'arg' should be one of \"less_walking\", \"fewer_transfers\"")

})


