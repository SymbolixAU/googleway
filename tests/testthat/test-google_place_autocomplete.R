context("Google places autocomplete")


test_that("place input is valid", {

    expect_error(google_place_autocomplete(place_input = c("place 1", "place 2")),
               "place_input can only be a character string of length 1")

})

test_that("location is valid", {

  expect_error(google_place_autocomplete(place_input = "here",
                                         location = c("lat", "lon"),
                                         key = "abc"),
               "location must be a vector of a pair of latitude and longitude coordinates")

  expect_error(google_place_autocomplete(place_input = "here",
                                         location = c(-37, 144, 0),
                                         key = "abc"),
               "location must be a vector of a pair of latitude and longitude coordinates")

})

test_that("radius is valid",{

  expect_error(google_place_autocomplete(place_input = "here",
                                         radius = c(1,2),
                                         key = "abc"),
               "radius must be numeric vector of length 1")

  expect_error(google_place_autocomplete(place_input = "here",
                                         radius = list(1),
                                         key = "abc"),
               "radius must be numeric vector of length 1")
})


test_that("language is valid", {

  expect_error(google_place_autocomplete(place_input = "here",
                                         language = c("english", "french"),
                                         key = "abc"),
               "language must be a single string")

})

test_that("place type is valid", {

  expect_error(google_place_autocomplete(place_input = "here",
                                         place_type = c("type 1", "type 2"),
                                         key = "abc"),
               "place_type must be a string vector of length 1")

})

test_that("components are valid", {

  expect_error(google_place_autocomplete(place_input = "here",
                                         components = "abc",
                                         key = "abc"),
               "components must be two characters and represent an ISO 3166-1 Alpha-2 country code")

  expect_error(google_place_autocomplete(place_input = "here",
                                         components = c("ab", "abc"),
                                         key = "abc"),
               "components must be two characters and represent an ISO 3166-1 Alpha-2 country code")

})

test_that("places autocomplete object is created", {

  p <- google_place_autocomplete(place_input = "here", key = "abc")
  expect_true("predictions" %in% names(p))
})




