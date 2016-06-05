context("Get route")

test_that("get route issues error",{

  expect_error(get_route(),
               "get_route\\() is deprecated and has been removed. Use google_directions\\() instead.")

})

