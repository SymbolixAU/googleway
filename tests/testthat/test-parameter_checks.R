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

  expect_silent(googleway:::logicalCheck(TRUE))
  expect_error(googleway:::logicalCheck("TRUE"), 'TRUE" must be logical - TRUE or FALSE')
  expect_error(googleway:::logicalCheck(c(T, F)))

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
  expect_equal(googleway:::find_lat_column(names(df), 'test'), "lat")
  expect_equal(googleway:::find_lon_column(names(df), 'test'), "lon")

  df <- data.frame(latitude = c(1), lons = c(1))
  expect_equal(googleway:::find_lat_column(names(df), 'test'), "latitude")
  expect_equal(googleway:::find_lon_column(names(df), 'test'), "lons")

})

test_that("locations are valid", {

  ## directions: a single location is required
  df_pass <- data.frame(location = "Melbourne", stringsAsFactors = F)
  df_fail <- data.frame(location = c("Melbourne", "Sydney"), stringsAsFactors = F)
  vec_pass <- c("Melbourne")
  vec_fail <- c("Melbourne", "Sydney")
  num_pass <- c(-37, 144)
  num_fail <- c(-37, 144, -36, 146)
  lst_pass <- list(c(-37, 144))

  d_pass <- googleway:::validateLocation(df_pass)
  v_pass <- googleway:::validateLocation(vec_pass)
  l_pass <- googleway:::validateLocation(lst_pass)

  expect_error(googleway:::validateLocation(df_fail))
  expect_error(googleway:::validateLocation(vec_fail))

  expect_true(googleway:::check_location( d_pass , "origin") == "Melbourne")
  expect_true(googleway:::check_location( vec_pass, "origin") == "Melbourne")
  expect_true(googleway:::check_location( num_pass, "origin") == "-37,144")
  expect_true(googleway:::check_location( lst_pass, "origin") == "-37,144")


})





