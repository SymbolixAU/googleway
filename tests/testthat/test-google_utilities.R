context("Google utilities")

test_that("google map update not called from static R session", {
  expect_error(google_map_update(), "google_map_update must be called from the server function of a Shiny app")
})

test_that("lat and lon columns are successfully found", {

  expect_true(names(googleway:::latitude_column(data.frame(lat = c(1,2,3)), lat = NULL, "tests")) == "lat")
  expect_true(names(googleway:::latitude_column(data.frame(latitude = c(1,2,3)), lat = NULL, "tests")) == "lat")
  expect_true(names(googleway:::latitude_column(data.frame(lats = c(1,2,3)), lat = NULL, "tests")) == "lat")
  expect_true(names(googleway:::latitude_column(data.frame(latitudes = c(1,2,3)), lat = NULL, "tests")) == "lat")

  expect_error(names(googleway:::latitude_column(data.frame(myLat = c(1,2,3)), lat = NULL, "tests")) == "lat")

  expect_true(names(googleway:::longitude_column(data.frame(lon = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(longitude = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(lons = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(longitudes = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(lng = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(lngs = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(long = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(longs = c(1,2,3)), lon = NULL, "tests")) == "lng")

  expect_error(names(googleway:::longitude_column(data.frame(myLon = c(1,2,3)), lon = NULL, "tests")) == "lat")

})


test_that("invoke_remote stops on invalid map parameter", {

  expect_error(googleway:::invoke_remote("myMap"), "Invalid map parameter; googlemap_update object was expected")

})

test_that("opacity values between 0 and 1", {
  expect_error(googleway:::check_opacities(data.frame(o = 2), "o"),
               "opacity values for o must be between 0 and 1")
})

test_that("column check works", {
  expect_error(googleway:::check_for_columns(data.frame(col1 = "hi"),"col2"),
               "Could not find columns: col2 in the data")
})

test_that("hex colours works", {
  expect_error(googleway:::check_hex_colours(data.frame(hex = "123"), "hex"),
               "Incorrect colour specified in hex. Make sure the colours in the column are valid hexadecimal HTML colours")
})


test_that("google_map_update exists",{
  expect_equal(
    class(google_map_update("map", session = "now")),
    "google_map_update"
  )
})





