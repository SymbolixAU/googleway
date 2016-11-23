context("google map layers")



test_that("markers correctly defined", {

  m <- google_map(key = "abc")

  df <- data.frame(mylat = 1:4,
                   mylon = 1:4)

  expect_error(add_markers(map = m), "Couldn't infer latitude column for add_markers")
  expect_error(add_markers(map = m, data = df), "Couldn't infer latitude column for add_markers")

  df <- data.frame(lat = 1:4,
                   mylon = 1:4)

  expect_error(add_markers(map = m, data = df), "Couldn't infer longitude columns for add_markers")
  expect_error(add_markers(map = m, data = df, lat = "lat"), "Couldn't infer longitude columns for add_markers")

  df <- data.frame(lat = 1:4,
                   lon = 1:4)

  expect_error(add_markers(map = m, data = df, cluster = 'yes'), "cluster must be logical")



})



