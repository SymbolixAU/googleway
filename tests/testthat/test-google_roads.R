context("roads")

test_that("path is correct length", {

  df <- data.frame(lat = 1:101, lon = 1:101)
  expect_error(
    google_snapToRoads(key = 'abc', df_path = df),
    "the maximum number of pairs of coordinates that can be supplied is 100"
    )

})

test_that("download attempted - sanp to roads", {

  df <- data.frame(lat = 1:10, lon = 1:10)
  expect_error(
    google_snapToRoads(df_path = df, key = 'abc'),
    'HTTP error 400.'
  )
})

test_that("download attempted - nearest roads", {

  df <- data.frame(lat = 1:10, lon = 1:10)
  expect_error(
    google_nearestRoads(df_points = df, key = 'abc'),
    'HTTP error 400.'
  )
})

test_that("download attempted - speed limits", {

  df <- data.frame(lat = 1:10, lon = 1:10)
  expect_error(
    google_speedLimits(df_path = df, key = 'abc'),
    'HTTP error 400.'
  )
})

test_that("place ids are valid", {

  df <- data.frame(place = sample(letters, size = 101, replace = T))
  expect_error(
    google_speedLimits(placeIds = df$place, key = 'abc'),
    "the maximum number of placeIds allowed is 100"
  )

})
