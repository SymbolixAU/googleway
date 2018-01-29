context("Googleutilities")

test_that("google map update not called from static R session", {
  expect_error(google_map_update(), "google_map_update must be called from the server function of a Shiny app")
})


test_that("google_map_update errors outside shiny", {

  m <- google_map(key = "abc")
  expect_error(
    google_map_update(m),
    "google_map_update must be called from the server function of a Shiny app"
  )

})


test_that("invoke_remote stops on invalid map parameter", {

  expect_error(googleway:::invoke_remote("myMap"), "Invalid map parameter; googlemap_update object was expected")

})

test_that("invoke_remote creates map object", {

  m <- google_map(key = 'abc')
  class(m) <- 'google_map_update'

  expect_error(
    googleway:::invoke_remote(m, 'myMethod'),
    'argument is of length zero'
  )

})


test_that("formula resolves", {

  f <- formula(x ~ y)

  expect_error(
    googleway:::resolveFormula(f, data.frame(x = 1, y = 2)),
    "Unexpected two-sided formula: x ~ y"
  )

  f <- formula(~"col")
  df <- data.frame(col = 1)
  expect_true(
    googleway:::resolveFormula(f, data = df) == "col"
  )
})

test_that("google_map_update exists",{
  expect_equal(
    class(google_map_update("map", session = "now")),
    "google_map_update"
  )
})


test_that("layer_id set to default", {

  expect_equal(
    googleway:::layerId(NULL),
    "defaultLayerId"
  )

  expect_error(
    googleway:::layerId(c(1,2)),
    "please provide a single value for 'layer_id'"
  )

  expect_equal(
    googleway:::layerId(1),
    1
  )

})

test_that("map styles defined correctly", {
  expect_true(is.character(map_styles()$night))

  n <- names(map_styles())

  expect_true(length(n) == 6)
  expect_true(length(setdiff(c("standard", "silver", "retro", "dark", "night", "aubergine"), n)) == 0)
  expect_true(length(setdiff(n, c("standard", "silver", "retro", "dark", "night", "aubergine"))) == 0)

})

test_that("constructWaypoints works", {

  waypoints <- list(c(-37, 144))

  expect_true(
    googleway:::constructWaypoints(waypoints, FALSE) == "-37,144"
  )

  waypoints <- list(via = c(-37, 144))
  expect_true(
    googleway:::constructWaypoints(waypoints, FALSE) == "via:-37,144"
  )


})

