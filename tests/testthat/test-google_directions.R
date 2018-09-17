context("Google directions")

## issue 65
test_that("url encoded correctly", {

  expect_equal(
    URLencode("https://www.google.com/&avoid=highways|tolls"),
    "https://www.google.com/&avoid=highways%7Ctolls"
  )

})


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

  expect_error(
    google_directions(origin = c(-37.8179746, 144.9668636),
                     destination = c(-37.81659, 144.9841),
                     avoid = "dont avoid",
                     key = "abc",
                     simplify = TRUE),
               "avoid can only include tolls, highways, ferries or indoor"
    )

  expect_silent(
    google_directions(origin = c(-37.8179746, 144.9668636),
                      destination = c(-37.81659, 144.9841),
                      avoid = c("tolls","highways"),
                      key = "abc",
                      simplify = TRUE)
  )

})

test_that("Departure time is not in the past",{

  expect_error(
    google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                         departure_time = as.POSIXct("2015-01-01"),
                         key = "abc",
                         simplify = TRUE),
    "departure_time for driving mode must not be in the past"
    )

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

  expect_warning(
    google_directions(origin = "Melbourne Airport, Australia",
                     destination = "Portsea, Melbourne, Australia",
                     departure_time = Sys.time() + (24 * 60 * 60),
                     waypoints = list(via = c(-37.81659, 144.9841),
                                      via = "Ringwood, Victoria"),
                     transit_mode = "bus",
                     key = "abc"),
    "You have specified a transit_mode, but are not using mode = 'transit'. Therefore this argument will be ignored"
    )
})

test_that("transit_mode is valid", {

  expect_error(
    google_directions(origin = "Melbourne Airport, Australia",
                      destination = "Portsea, Melbourne, Australia",
                      departure_time = Sys.time() + (24 * 60 * 60),
                      waypoints = list(via = c(-37.81659, 144.9841),
                                       via = "Ringwood, Victoria"),
                      mode = "transit",
                      transit_mode = "bike",
                      key = "abc")
  )
})


test_that("waypoints are correctly named", {

  expect_error(
    google_directions(origin = "Melbourne Airport, Australia",
                       destination = "Portsea, Melbourne, Australia",
                       waypoints = list(c(-37.81659, 144.9841),
                                        via = "Ringwood, Victoria"),
                       key = "abc"),
               "waypoint list elements must be named either 'via' or 'stop'")

})

test_that("waypoints are optimised", {

  expect_error(
    google_directions(origin = "Melbourne Airport, Australia",
                      destination = "Portsea, Melbourne, Australia",
                      waypoints = list(via = c(-37.81659, 144.9841),
                                       via = "Ringwood, Victoria"),
                      optimise_waypoints = TRUE,
                      key = "abc"),
    "waypoints can only be optimised for stopovers. Each waypoint in the list must be named as stop"
    )

})


test_that("transit_routing_preferences are valid",{


  expect_error(
    google_directions(origin = "Melbourne Airport, Australia",
                      destination = "Portsea, Melbourne, Australia",
                      departure_time = Sys.time() + (24 * 60 * 60),
                      mode = "transit",
                      transit_mode = "bus",
                      transit_routing_preference = 'less walking',
                      key = "abc")
  )
})

test_that("routing preferences are valid2", {

  skip("call to api")

  expect_silent(
    google_directions(origin = "Melbourne Airport, Australia",
                    destination = "Portsea, Melbourne, Australia",
                    departure_time = Sys.time() + (24 * 60 * 60),
                    mode = "transit",
                    transit_mode = "bus",
                    transit_routing_preference = 'less_walking',
                    key = "abc")
  )

  expect_silent(
    google_directions(origin = "Melbourne Airport, Australia",
                      destination = "Portsea, Melbourne, Australia",
                      departure_time = Sys.time() + (24 * 60 * 60),
                      mode = "transit",
                      transit_mode = "bus",
                      transit_routing_preference = c('less_walking','fewer_transfers'),
                      key = "abc")
  )


})

test_that("traffic model is valid",{

  skip("request to api")

  d <- google_directions(origin = "Melbourne Airport, Australia",
                      destination = "Portsea, Melbourne, Australia",
                      departure_time = Sys.time() + (24 * 60 * 60),
                      traffic_model = "best guess",
                      key = "abc")

  expect_true(d$status == "REQUEST_DENIED")

  d <- google_directions(origin = "Melbourne Airport, Australia",
                    destination = "Portsea, Melbourne, Australia",
                    departure_time = Sys.time() + (24 * 60 * 60),
                    traffic_model = "best_guess",
                    key = "abc")

  expect_true(d$status == "REQUEST_DENIED")

  ## depature time is set if omitted
  d <- google_directions(origin = "Melbourne Airport, Australia",
                    destination = "Portsea, Melbourne, Australia",
                    traffic_model = "best_guess",
                    key = "abc")

  expect_true(d$status == "REQUEST_DENIED")

  origin <- "ChIJFzmq66lZ1moRkPAvBXZWBA8" # melbourne airport
  destination <- "ChIJUZN5TAg21GoRQOWMIXVWBAU" # protsea

  d <- google_directions(origin = origin,
                         destination = destination,
                         traffic_model = "best_guess",
                         key = 'abc')

  expect_true(d$status == "REQUEST_DENIED")

})


