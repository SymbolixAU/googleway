context("Google reverse_geocode")

test_that("incorrect location is valid",{

  expect_error(google_reverse_geocode(location = "Flinders Street Station, Melbourne",
                                      key = "abc"),
               "location must be a vector of a pair of latitude and longitude coordinates")

  expect_error(google_reverse_geocode(location = list(c(-37.81962,144.9657),
                                                      c(-37.81692, 144.9684)),
                                      key = "abc"),
               "location must be a vector of a pair of latitude and longitude coordinates")
})

test_that("location_type is valid", {


  expect_true(
    google_reverse_geocode(location = c(-37, 144),
                           location_type = c("rooftop", "approximate"),
                           key = 'abc')$error_message == "The provided API key is invalid. "
    )

})


test_that("result_type is valid",{

  expect_error(
    google_reverse_geocode(location = c(-37.81659, 144.9841),
                           result_type = 111,
                           location_type = "rooftop",
                           key = "abc"),
          "result_type must be a vector of strings")


    expect_true(
      google_reverse_geocode(location = c(-37.81659, 144.9841),
                             result_type = c("street_address", "route", "intersection"),
                             key = 'abc')$error_message == "The provided API key is invalid. "
    )


})

test_that("language is one string",{

  expect_error(google_reverse_geocode(location = c(-37.81659, 144.9841),
                                      language = c("en","fr"),
                                      key = "abc"),
               "language must be a single string")

})

test_that("location type set correctly", {

  expect_error(google_reverse_geocode(location = c(-37.81659, 144.9841),
                                      location_type = "garden",
                                      key = "abc"))

})

test_that("reverse geocode attempted", {

  expect_true(google_reverse_geocode(location = c(-37.81659, 144.9841),
                         key = "abc")$error_message == "The provided API key is invalid. ")

  expect_true(is.list(google_reverse_geocode(location = c(-37.81659, 144.9841),
                                     key = "abc")$results))

})



