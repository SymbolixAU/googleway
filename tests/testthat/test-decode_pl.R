# library(testthat)
# library(googleway)
context("decode pl")

test_that("polyline decoded correctly", {

  pl <- "nnseFmpzsZgalNytrXetrG}krKsaif@kivIccvzAvvqfClp~uBlymzA~ocQ}_}iCthxo@srst@"
  expect_equal(nrow(decode_pl(pl)), 8)

})




