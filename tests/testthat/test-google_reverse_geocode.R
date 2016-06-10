context("Google reverse_geocode")

test_that("incorrect location throws error",{

  expect_error(google_reverse_geocode(location = "Flinders Street Station, Melbourne",
                                      key = "abc"),
               "location must be a vector of a pair of latitude and longitude coordinates")

  expect_error(google_reverse_geocode(location = list(c(-37.81962,144.9657),
                                                      c(-37.81692, 144.9684)),
                                      key = "abc"),
               "location must be a vector of a pair of latitude and longitude coordinates")
})


test_that("result_type is a string character",{

  expect_error(google_reverse_geocode(location = c(-37.81659, 144.9841),
                                      result_type = 111,
                                      location_type = "rooftop",
                                      key = "abc"),
          "result_type must be a vector of strings")

})

test_that("language is one string",{

  expect_error(google_reverse_geocode(location = c(-37.81659, 144.9841),
                                      language = c("en","fr"),
                                      key = "abc"),
               "language must be a single character vector or string")

})





