context("Google places")


test_that("search string or location specified", {

  expect_error(google_places(),
               "One of 'search_string' or 'location' must be specified")

})

test_that("location is a numeric vector",{

  expect_error(google_places(location = c("Melbourne, Australia")),
               "location must be a vector of a pair of latitude and longitude coordinates")

  expect_error(google_places(location = c(-37.9)),
               "location must be a vector of a pair of latitude and longitude coordinates")

  expect_error(google_places(location = c(-37.9, 144.5, 0)),
               "location must be a vector of a pair of latitude and longitude coordinates")

})

test_that("radar is logical",{

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             radar = "yes"),
               "radar must be logical")

})

test_that("radius is numeric > 0 & <= 50000",{

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             radius = -1),
               "radius must be numeric between 0 and 50000")

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             radius = 100000),
               "radius must be numeric between 0 and 50000")

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             radius = "20000"))
})

test_that("radius is supplied when location search",{

  expect_error(
    google_places(location = c(-37.817839,144.9673254)),
    "you must specify a radius if only using a 'location' search"
    )

})


test_that("rankby ignored when search_string", {

  expect_warning(google_places(search_string = "Restaurants in Melbourne, Australia",
                               radius = 200,
                               rankby="prominence",
                               key = "abc"))

})

test_that("place type is specified correctly", {

  expect_error(google_places(search_string = "here",
                key = "abc",
                place_type = c("hospital", "airport")))

})


test_that("search string ignored when rankby is used", {

  expect_warning(
    google_places(search_string = "Restaurangs in Melbourne, Australia",
                  rankby = "distance", key = 'abc'),
    "The 'rankby' argument is ignored when using a 'search_string'"
    )

  expect_error(
    google_places(location = c(-37, 144),
                rankby = 'distance'),
    "you must specify a radius if only using a 'location' search"
    )

  expect_warning(
    google_places(location = c(-37, 144), keyword = "restaurant",radius = 3,
                  rankby = 'distance', key = 'abc'),
    "radius is ignored when rankby == 'distance'"
  )

})




test_that("name used with search string issues warning",{

  expect_warning(google_places(search_string = "Restaurants in Melbourne, Australia",
                               name = "Maha",
                               key = "abc"))

})


test_that("rankby used with search_string is ignored", {

  expect_warning(google_places(search_string = "Restaurangs in Melbourne, Australia",
                               rankby = "prominence",
                               key = "abc"))

})

test_that("price_range is valid",{

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             price_range = 3),
               "price_range must be a numeric vector of length 2")

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             price_range = c("0", "4")),
               "price_range must be a numeric vector of length 2")

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             price_range = c(0, 5)),
               "price_range must be between 0 and 4 inclusive")

})

test_that("open_now is logical", {

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             open_now = "TRUE"),
               "open_now must be logical - TRUE or FALSE")

})

test_that("page_token is valid",{

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             page_token = TRUE),
               "page_token must be a string of length 1")
})


test_that("radar options throws errors", {

  expect_warning(google_places(radar = T, key = "abc", search_string = "here", location = c(-37, 145), radius = 1, keyword = "there"))
  expect_error(google_places(radar = T, key = "abc", location = c(-37, 145)))
  expect_error(google_places(radar = T, key = "abc", keyword = "here"))
  expect_error(google_places(radar = T, key = "abc", location = c(-37, 145), keyword = "here"))
  expect_true("html_attributions" %in% names(google_places(radar = T, key = "abc", location = c(-37, 145), keyword = "here", radius = 2)))

})





