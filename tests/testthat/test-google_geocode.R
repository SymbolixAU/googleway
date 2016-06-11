context("Google geocode")

test_that("invalid key returns error",{

  expect_error(google_geocode(address = "MCG, Melbourne",
                              key = NULL,
                              simplify = FALSE),
               "A Valid Google Developers API key is required")
})


test_that("bounds are correct type",{

  ## bounds is a list
  bounds <- c(-37.842653, 144.931850)
  expect_error(google_geocode(address = "MCG, Melbourne",
                              bounds = bounds,
                              key = "abc",
                              simplify = FALSE),
               "bounds must be a list of length 2, each item being a vector of lat/lon coordinate pairs")


  ## bounds is a list of length 2
  bounds <- list(c(-37.842653, 144.931850))
  expect_error(google_geocode(address = "MCG, Melbourne",
                              bounds = bounds,
                              key = "abc",
                              simplify = FALSE),
               "bounds must be a list of length 2, each item being a vector of lat/lon coordinate pairs")

  ## each elemnt of bounds is a lat/lon pair (i.e, numeric)
  bounds <- list(c(-37.842653, 144.931850),
                 c(-37.842653))

  expect_error(google_geocode(address = "MCG, Melbourne",
                              bounds = bounds,
                              key = "abc",
                              simplify = FALSE),
               "each element of bounds must be length 2 - a pair of lat/lon coordinates")
})



test_that("language is a single string",{

  expect_error(google_geocode(address = "MCG, Melbourne",
                              language = c("en","fr"),
                              key = "abc",
                              simplify = FALSE),
               "language must be a single character vector or string")

  expect_error(google_geocode(address = "MCG, Melbourne",
                              language = 1,
                              key = "abc",
                              simplify = FALSE),
               "language must be a single character vector or string")

})


test_that("region is a single string",{

  expect_error(google_geocode(address = "MCG, Melbourne",
                              region = c("en","fr"),
                              key = "abc",
                              simplify = FALSE),
               "region must be a two-character string")

  expect_error(google_geocode(address = "MCG, Melbourne",
                              region = 1,
                              key = "abc",
                              simplify = FALSE),
               "region must be a two-character string")

})


test_that("components is a data.frame with the correct columns",{


  components <- data.frame(components = c("postal_code", "country"),
                           value = c("3000", "AU"))

  expect_error(google_geocode(address = "Flinders Street Station",
                              key = "abc",
                              components = components,
                              simplify = TRUE),
               "components must be a data.frame with two columns named 'component' and 'value'")

  components <- list(components = c("postal_code", "country"),
                     value = c("3000", "AU"))

  expect_error(google_geocode(address = "Flinders Street Station",
                              key = "abc",
                              components = components,
                              simplify = TRUE),
               "components must be a data.frame with two columns named 'component' and 'value'")

})

test_that("component types are valid",{

  components <- data.frame(component = c("country_code"),
                           value = c("AU"))

  expect_error(google_geocode(address = "Flinders Street Station",
                              key = "abc",
                              components = components,
                              simplify = TRUE),
  "valid components are 'route', 'locality', 'postal_code', 'administrative_area' and 'country'")

})





