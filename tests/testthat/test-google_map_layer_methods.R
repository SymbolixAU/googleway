context("map layer methods")


test_that("regex detects urls", {

  expect_true(googleway:::isUrl("http://www.link.com"))
  expect_true(googleway:::isUrl("https://www.link.com"))
  expect_true(googleway:::isUrl("www.link.com"))
  expect_false(googleway:::isUrl("link.com"))
  expect_true(googleway:::isUrl("https://storage.googleapis.com/mapsdevsite/json/google.json"))

})

