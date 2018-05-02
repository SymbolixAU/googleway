context("roads")

test_that("path is correct length", {

  df <- data.frame(lat = 1:101, lon = 1:101)
  expect_error(
    google_snapToRoads(key = 'abc', df_path = df),
    "the maximum number of pairs of coordinates that can be supplied is 100"
    )
})

test_that("download attempted - sanp to roads", {

  err <- "There was an error downloading results. Please manually check the following URL is valid by entering it into a browswer. If valid, please file a bug report citing this URL note: your API key has been removed, so you will need to add that back in https://roads.googleapis.com/v1/snapToRoads?&path=1,1%7C2,2%7C3,3%7C4,4%7C5,5%7C6,6%7C7,7%7C8,8%7C9,9%7C10,10&interpolate=FALSE&key="
  df <- data.frame(lat = 1:10, lon = 1:10)
  expect_error(
    paste0(google_snapToRoads(df_path = df, key = 'abc'), collapse = "")
#     'HTTP error 400.'
  )
})

test_that("download attempted - nearest roads", {

  df <- data.frame(lat = 1:10, lon = 1:10)
  expect_error(
    google_nearestRoads(df_points = df, key = 'abc')
#    'HTTP error 400.'
  )
})

test_that("download attempted - speed limits", {

  df <- data.frame(lat = 1:10, lon = 1:10)
  expect_error(
    google_speedLimits(df_path = df, key = 'abc')
    # 'HTTP error 400.'
  )
})

test_that("place ids are valid", {

  df <- data.frame(place = sample(letters, size = 101, replace = T))
  expect_error(
    google_speedLimits(placeIds = df$place, key = 'abc'),
    "the maximum number of placeIds allowed is 100"
  )

})
