context("Google directions")


test_that("incorrect mode throws error", {
  skip("incorrect error string in match.arg")
  expect_error(google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                         mode = "non-mode",
                         key = "abc",
                         simplify = TRUE))

})

test_that("incorrect simplify throws warning",{

  expect_error(google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                         mode = "driving",
                         key = "abc",
                         simplify = "TRUE"))

})

test_that("origin is lat/lon", {

  expect_error(google_directions(origin = c(144.9668636),
                         destination = c(-37.81659, 144.9841),
                         mode = "driving",
                         key = "abc"))

})

test_that("Destination is lat/lon", {

  expect_error(google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659),
                         mode = "driving",
                         key = "abc"))

})

test_that("Avoid is a valid type", {

  expect_error(google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                         avoid = "dont avoid",
                         key = "abc",
                         simplify = TRUE))
})

test_that("Departure time is not in the past",{

  expect_error(google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                         departure_time = as.POSIXct("2015-01-01"),
                         key = "abc",
                         simplify = TRUE))

})

test_that("waypoints only valid for certain modes",{

  expect_error(google_directions(origin = "Melbourne Airport",
              destination = "Sorrento",
              waypoints = list(via = c(-37.81659, 144.9841),
                                via = "Ringwood, Victoria"),
              mode = "transit",
              key = "abc"))
})

test_that("waypoints are a list",{

  expect_error(google_directions(origin = "Melbourne Airport",
                         destination = "Sorrento",
                         waypoints = c(-37.81659, 144.9841),
                         key = "abc"))
})

test_that("map url is a single string",{

  expect_error(google_directions(origin = "Melbourne Airport",
                         destination = "Sorrento",
                         alternatives = c(FALSE, TRUE),
                         key = "abc"))
})


test_that("transit_mode issues warning when mode != transit",{

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                           destination = "Portsea, Melbourne, Australia",
                           departure_time = Sys.time() + (24 * 60 * 60),
                           waypoints = list(via = c(-37.81659, 144.9841),
                                            via = "Ringwood, Victoria"),
                           transit_mode = "bus",
                           key = "abc"))

})


test_that("waypoints are correctly named", {

  expect_error(google_directions(origin = "Melbourne Airport, Australia",
                                 destination = "Portsea, Melbourne, Australia",
                                 waypoints = list(c(-37.81659, 144.9841),
                                                  via = "Ringwood, Victoria"),
                                 key = "abc"),
               "waypoint list elements must be named either 'via' or 'stop'")

})






