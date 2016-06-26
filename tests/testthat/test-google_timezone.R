context("Google timezone")

test_that("location is a pair of coordinates",{

  expect_error(google_timezone(location = c(144.9841),
                               timestamp = as.POSIXct("2016-06-05"),
                               simplify = TRUE,
                               key = "abc"),
               "location must be a vector of a pair of latitude and longitude coordinates")

  expect_error(google_timezone(location = "location",
                               timestamp = as.POSIXct("2016-06-05"),
                               simplify = TRUE,
                               key = "abc"),
               "location must be a vector of a pair of latitude and longitude coordinates")

})


test_that("timestamp is POSIXct",{

  expect_error(google_timezone(location = c(-37.81659, 144.9841),
                               timestamp = "2016-06-05",
                               simplify = TRUE,
                               key = "abc"),
               "timestamp must be a POSIXct object")

})


test_that("language is a single string",{

  expect_error(google_timezone(location = c(-37.81659, 144.9841),
                               timestamp = as.POSIXct("2016-06-05"),
                               simplify = TRUE,
                               language = c("en", "fr"),
                               key = "abc"),
                "language must be a single character vector or string")

  expect_error(google_timezone(location = c(-37.81659, 144.9841),
                               timestamp = as.POSIXct("2016-06-05"),
                               simplify = TRUE,
                               language = 1,
                               key = "abc"),
               "language must be a single character vector or string")

})

test_that("simplify if logical", {

  expect_error(google_timezone(location = c(-37.81659, 144.9841),
                               timestamp = as.POSIXct("2016-06-05"),
                               simplify = "TRUE",
                               key = "abc"),
               "simplify must be logical - TRUE or FALSE")

})

test_that("Timezone Australia/Hobart is returned",{

  skip_on_cran()
  skip_on_travis()
  key <- read.dcf("./.googleAPI", fields = c("GOOGLE_API_KEY"))

  expect_equal(google_timezone(location = c(-37.81659, 144.9841),
                               timestamp = as.POSIXct("2016-06-05"),
                               simplify = TRUE,
                               key = key)$timeZoneId,
               "Australia/Hobart")

  })





