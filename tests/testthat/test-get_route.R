# library(testthat)
# library(googleway)
context("get route")

## api keys are not included in the package
## and so can't be tested
skip_api_key <- function() {
  skip("key not available")
}

test_that("get_route returns data.frame", {
  ## skip this test
  skip_api_key()

  df <- get_route(origin = c(-37.8179746, 144.9668636),
                  destination = c(-37.81659, 144.9841),
                  mode = "walking",
                  key = key,
                  output_format = "data.frame")

  expect_equal(class(df), "list")
  expect_equal(names(df), c("geocoded_waypoints","routes","status"))
  expect_equal(length(df[[1]]), 3)
})

test_that("incorrect mode throws error", {

  expect_error(get_route(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                         mode = "non-mode",
                         key = "abc",
                         output_format = "data.frame"),
               "'arg' should be one of \"driving\", \"walking\", \"bicycling\"")

})

test_that("incorrect output throws warning",{

  expect_error(get_route(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                         mode = "driving",
                         key = "abc",
                         output_format = "non-output"),
               "'arg' should be one of \"data.frame\", \"JSON\"")

})

test_that("origin is lat/lon", {

  expect_error(get_route(origin = c(144.9668636),
                         destination = c(-37.81659, 144.9841),
                         mode = "driving",
                         key = "abc"),
               "Origin must be either a numeric vector of lat/lon coordinates, or an address string")

})

test_that("Destination is lat/lon", {

  expect_error(get_route(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659),
                         mode = "driving",
                         key = "abc"),
               "Destination must be either a numeric vector of lat/lon coordinates, or an address string")

})


