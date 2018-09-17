context("on load")

test_that("options are created", {

  expect_silent(googleway:::.onLoad())
  expect_true(is.list(getOption("googleway")))
  expect_true(length(getOption("googleway")[['google']]) == 14)

})
