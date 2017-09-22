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


test_that("incorrect encoded string throws error",{

  pl <- "abc"
  expect_message(decode_pl(pl),
               "The encoded string could not be decoded. \nYou can manually check the encoded line at https://developers.google.com/maps/documentation/utilities/polylineutility \nIf the line can successfully be manually decoded, please file an issue: https://github.com/SymbolixAU/googleway/issues ")

})

test_that("polyline encoded correctly", {

  expect_equal(
    encode_pl(lat = c(38.5, 40.7, 43.252), lon = c(-120.2, -120.95, -126.453)),
    "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
  )

})

test_that("polyline encoding error message", {

  expect_error(
    encode_pl(lat = c(-91, -90, -89), lon = c(0, 1)),
    "lat and lon must be the same length"
  )

  expect_message(
    encode_pl(lat = "a", lon = "b"),
    "The coordinates could not be encoded"
  )

})
