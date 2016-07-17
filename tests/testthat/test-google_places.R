context("Google places")


test_that("search string or location specified", {

  expect_error(google_places(),
               "One of 'search_string' or 'location' must be specified")

})

test_that("location is a numeric vector",{

  expect_error(google_places(location = c("Melbourne, Australia")),
               "location must be a numeric vector of latitude/longitude coordinates")

  expect_error(google_places(location = c(-37.9)),
               "location must be a numeric vector of latitude/longitude coordinates")

  expect_error(google_places(location = c(-37.9, 144.5, 0)),
               "location must be a numeric vector of latitude/longitude coordinates")

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

  expect_error(google_places(location = c(-37.817839,144.9673254)),
               "you must specify a radius if only using a 'location' search, and rankby is not equal to 'distance'")

})

test_that("radius is not used when rankby == distance",{

  expect_error(google_places(location = c(-37.817839,144.9673254),
                             radius = 200,
                             rankby="distance"),
               "radius can not be supplied if rankby == 'distance'")
})

test_that("rankby ignored when search_string", {

  skip_on_cran()
  skip_on_travis()

  key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_API_KEY")
  expect_warning(google_places(search_string = "Restaurants in Melbourne, Australia",
                               radius = 200,
                               rankby="prominence",
                               key = key),
                 "The 'rankby' argument is ignored when using a 'search_string'")

})

test_that("keyword, name or place_type specified when rankby == 'distance'", {

  expect_error(google_places(search_string = "Restaurangs in Melbourne, Australia",
                             rankby = "distance"),
               "you have specified rankby to be 'distance', so you must provide one of 'keyword','name' or 'place_type'")

})


test_that("name used with search string issues warning",{

  skip_on_cran()
  skip_on_travis()

  key <- read.dcf(file = "~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  expect_warning(google_places(search_string = "Restaurants in Melbourne, Australia",
                               name = "Maha",
                               key = key),
                 "The 'name' argument is ignored when using a 'search_string'")

})


test_that("rankby used with search_string is ignored", {

  skip_on_cran()
  skip_on_travis()

  key <- read.dcf(file = "~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  expect_warning(google_places(search_string = "Restaurangs in Melbourne, Australia",
                               rankby = "prominence",
                               key = key),
                 "The 'rankby' argument is ignored when using a 'search_string'")

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
               "open_now must be logical of length 1")

})

test_that("page_token is valid",{

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             page_token = TRUE),
               "page_token must be a string of length 1")
})

