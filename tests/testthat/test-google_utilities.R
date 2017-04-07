context("Googleutilities")

test_that("google map update not called from static R session", {
  expect_error(google_map_update(), "google_map_update must be called from the server function of a Shiny app")
})



test_that("invoke_remote stops on invalid map parameter", {

  expect_error(googleway:::invoke_remote("myMap"), "Invalid map parameter; googlemap_update object was expected")

})


test_that("google_map_update exists",{
  expect_equal(
    class(google_map_update("map", session = "now")),
    "google_map_update"
  )
})





