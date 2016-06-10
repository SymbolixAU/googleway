context("Google directions")

## api keys are not included in the package
## and so can't be tested
skip_api_key <- function() {
  skip("key not available")
}

test_that("google_directions returns data.frame", {
  ## skip this test
  skip_api_key()

  df <- google_directions(origin = c(-37.8179746, 144.9668636),
                  destination = c(-37.81659, 144.9841),
                  mode = "walking",
                  key = key,
                  simplify = TRUE)

  expect_equal(class(df), "list")
  expect_equal(names(df), c("geocoded_waypoints","routes","status"))
  expect_equal(length(df[[1]]), 3)
})

# test_that("incorrect mode throws error", {
#
#   expect_error(google_directions(origin = c(-37.8179746, 144.9668636),
#                          destination = c(-37.81659, 144.9841),
#                          mode = "non-mode",
#                          key = "abc",
#                          simplify = TRUE),
#                "'arg' should be one of \"driving\", \"walking\", \"bicycling\", \"transit\"")
#
# })

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
              waypoints = list(c(-37.81659, 144.9841),
                                "Ringwood, Victoria"),
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

  skip_api_key()

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                           destination = "Portsea, Melbourne, Australia",
                           departure_time = Sys.time() + (24 * 60 * 60),
                           waypoints = list(via = c(-37.81659, 144.9841),
                                            via = "Ringwood, Victoria"),
                           transit_mode = "bus",
                           key = "abc"),
                 "You have specified a transit_mode, but are not using mode = 'transit'. Therefore this argument will be ignored")

})


test_that("warning when both arrival and departure times supplied", {

  ## skip this test
  skip_api_key()

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   departure_time = Sys.time() + (24 * 60 * 60),
                                   arrival_time = Sys.time() + (24 * 60 * 60),
                                   key = "abc"),
                 "you have supplied both an arrival_time and a departure_time - only one is allowed. The arrival_time will be ignored")

})

