# library(testthat)
# library(googleway)
context("decode pl")

test_that("polyline decoded correctly", {

  pl <- "nnseFmpzsZgalNytrXetrG}krKsaif@kivIccvzAvvqfClp~uBlymzA~ocQ}_}iCthxo@srst@"
  expect_equal(nrow(decode_pl(pl)), 8)

})

test_that("error message for invalid encoded type", {
  pl <- c("a","b")
  expect_error(decode_pl(pl),
               "encoded must be a string of length 1")
   pl <- 123
   expect_error(decode_pl(pl),
                "encoded must be a string of length 1")
})

