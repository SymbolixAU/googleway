context("Google places details")


test_that("language is valid", {

  expect_error(google_place_details(language = c("english", "french")),
               "language must be a single character vector or string")

})

test_that("google place details is set",{

  g <- google_place_details(place_id = "abc", key = "abc")
  expect_true("html_attributions" %in% names(g))


})

