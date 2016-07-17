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


test_that("radius is a > 0 & <= 50000",{

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             radius = -1),
               "Radius must be positivie, and less than or equal to 50,000")

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             radius = 100000),
               "Radius must be positivie, and less than or equal to 50,000")
})

test_that("rankby != distance when radius is supplied",{

  expect_error(google_places(search_string = "Restaurants in Melbourne, Australia",
                             radius = 200,
                             rankby="distance"),
               "'rankby' can not be 'distance' when a radius is supplied")
})

test_that("keyword, name or type specified when rankby == 'distance'", {

  expect_error(google_places(search_string = "Restaurangs in Melbourne, Australia",
                             rankby = "distance"),
               "you have specified rankby to be 'distance', so you must provide one of 'keyword','name' or 'type'")

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






