context("Google map")

test_that("default options are set", {

  expect_true(google_map(key = "abc")$x$zoom == 8)
  expect_true(google_map(key = "abc")$x$lat == -37.9)
  expect_true(google_map(key = "abc")$x$lng == 144.5)
  expect_false(google_map(key = "abc", search_box = F)$x$search_box)

})


test_that("search box is loaded", {

  expect_true(google_map(key = "abc", search_box = T)$x$search_box)

})


