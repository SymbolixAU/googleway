context("Google elevation")


test_that("df_locations is a data.frame",{

  expect_error(google_elevation(df_locations = c(-37.81659, -37.88950),
                   key = "abc",
                   output_format = "data.frame"),
               "df_locations should be a data.frame containing at least two columns of lat and lon coordianates")

})


test_that("df_locations contains correctly named columns",{

  df <- data.frame(lats = c(-37.81659, -37.88950),
                   lons = c(144.9841, 144.9841))

  expect_error(google_elevation(df_locations = df,
                                location_type = "path",
                                samples = 20,
                                key = "abc",
                                output_format = "data.frame"),
               "data.frame of locations must contain the columns lat/latitude and lon/longitude")
})

test_that("warning issued when samples == NULL", {

  df <- data.frame(lat = c(-37.81659, -37.88950),
                   lon = c(144.9841, 144.9841))

  expect_warning(google_elevation(df_locations = df,
                                location_type = "path",
                                samples = NULL,
                                key = "abc",
                                output_format = "data.frame"),
               "samples has not been specified. 3 will be used")

})








