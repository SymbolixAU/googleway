context("parameter checks")

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

test_that("LogicalCheck handles various arguments", {

  expect_silent(googleway:::LogicalCheck(TRUE))
  expect_error(googleway:::LogicalCheck("TRUE"), 'TRUE" must be logical - TRUE or FALSE')
  expect_error(googleway:::LogicalCheck(c(T, F)))

})

test_that("latitude column is found", {

  df <- data.frame(myLat = c(1))
  expect_error(
    googleway:::latitude_column(df, NULL, 'test'),
    "Couldn't infer latitude column for test"
  )

  expect_error(
    googleway:::latitude_column(df, 'lat', 'test'),
    "Could not find columns: lat in the data"
  )

  df <- data.frame(lat = c(1))
  expect_silent(
    googleway:::latitude_column(df, NULL, 'test')
  )

})

test_that("longitude column is found", {

  df <- data.frame(myLon = c(1))
  expect_error(
    googleway:::longitude_column(df, NULL, 'test'),
    "Couldn't infer longitude columns for test"
  )

  expect_error(
    googleway:::longitude_column(df, 'lon', 'test'),
    "Could not find columns: lon in the data"
  )

  df <- data.frame(lon = c(1))
  expect_silent(
    googleway:::longitude_column(df, NULL, 'test')
  )

})

test_that("lat & lon are found", {

  df <- data.frame(lat = c(1), lon = c(1))
  expect_equal(googleway:::find_lat_column(names(df), 'test'), list(lat = "lat"))
  expect_equal(googleway:::find_lon_column(names(df), 'test'), list(lon = "lon"))

  df <- data.frame(latitude = c(1), lons = c(1))
  expect_equal(googleway:::find_lat_column(names(df), 'test'), list(lat = "latitude"))
  expect_equal(googleway:::find_lon_column(names(df), 'test'), list(lon = "lons"))


})

