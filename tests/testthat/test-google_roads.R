context("roads")

test_that("path is correct length", {

  df <- data.frame(lat = 1:101, lon = 1:101)
  expect_error(
    google_snapToRoads(key = 'abc', df_path = df),
    "the maximum number of pairs of coordinates that can be supplied is 100"
    )

})

test_that("download attempted", {

  df <- data.frame(lat = 1:10, lon = 1:10)
  expect_error(
    google_snapToRoads(df_path = df, key = 'abc'),
    'HTTP error 400.'
  )



})
