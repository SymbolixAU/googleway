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


