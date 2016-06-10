context("Google elevation")

skip_api_key <- function() {
  skip("key not available")
}

test_that("df_locations is a data.frame",{

  expect_error(google_elevation(df_locations = c(-37.81659, -37.88950),
                   key = "abc",
                   simplify = TRUE),
               "df_locations should be a data.frame containing at least two columns of lat and lon coordianates")

})

# test_that("location errors on incorrect type",{
#
#   df <- data.frame(lat = c(-37.81659, -37.88950),
#                    lon = c(144.9841, 144.9841))
#
#   expect_error(google_elevation(df_locations = df,
#                                 location_type = "route",
#                                 key = "abc"),
#                "'arg' should be oneof \"individual\", \"path\"")
#
# })

test_that("df_locations contains correctly named columns",{

  df <- data.frame(lats = c(-37.81659, -37.88950),
                   lons = c(144.9841, 144.9841))

  expect_error(google_elevation(df_locations = df,
                                location_type = "path",
                                samples = 20,
                                key = "abc",
                                simplify = TRUE),
               "data.frame of locations must contain the columns lat/latitude and lon/longitude")
})

test_that("df_locations only contains one of each lat/lon columns",{

  df <- data.frame(lat = c(-37.81659, -37.88950),
                   latitude = c(-37.81659, -37.88950),
                   lon = c(144.9841, 144.9841))

  ## elevation data from the MCG to the beach at Elwood (due south)
  expect_error(google_elevation(df_locations = df,
                                location_type = "path",
                                samples = 20,
                                key = "abc",
                                simplify = TRUE),
               "Multiple possible lat/lon columns detected. Only use one column for lat/latitude and one column for lon/longitude coordinates")
})

test_that("error when samples is not logical",{

  df <- data.frame(lat = c(-37.81659, -37.88950),
                   lon = c(144.9841, 144.9841))

  expect_error(google_elevation(df_locations = df,
                                key = "abc",
                                simplify = "TRUE"),
               "simplify must be logical - TRUE or FALSE")
})

test_that("warning issued when samples is NULL", {

  ## skip this test
  skip_api_key()

  df <- data.frame(lat = c(-37.81659, -37.88950),
                   lon = c(144.9841, 144.9841))

  expect_warning(google_elevation(df_locations = df,
                                location_type = "path",
                                samples = NULL,
                                key = "abc",
                                simplify = TRUE),
               "samples has not been specified. 3 will be used")
})




