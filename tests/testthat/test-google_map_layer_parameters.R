context("map layer parameter checks")

test_that("regex detects urls", {

  expect_true(googleway:::isUrl("http://www.link.com"))
  expect_true(googleway:::isUrl("https://www.link.com"))
  expect_true(googleway:::isUrl("www.link.com"))
  expect_false(googleway:::isUrl("link.com"))
  expect_true(googleway:::isUrl("https://storage.googleapis.com/mapsdevsite/json/google.json"))

})

test_that("data checks work", {

  expect_message(
    googleway:::dataCheck(data.frame(), "test"),
    "no data supplied to test"
  )

  expect_warning(
    googleway:::dataCheck(matrix(), "test"),
    "test: currently only data.frames, sf and sfencoded objects are supported"
  )

})


test_that("marker icon check", {

  df <- tram_stops[1:5,]
  objArgs <- quote(add_markers(data = df, marker_icon = "http"))
  colour <- NULL
  marker_icon <- 'marker_icon'


  expect_true(
    googleway:::markerColourIconCheck(data = df, objArgs = objArgs,
      colour = colour, marker_icon = marker_icon) == 'add_markers(data = df, url = "marker_icon")'
  )

})

test_that("palette check identifies a function", {

  pal <- function(){}

  expect_true(
    is.function(googleway:::paletteCheck(pal))
  )

  pal <- c("#00FF00")

  expect_error(
    googleway:::paletteCheck(pal),
    "I don't recognise the type of palette you've supplied"
  )

})


test_that("pathId check corrects the id", {

  df <- tram_route[1:10,]
  df$path <- 'myPath'

  res <- googleway:::pathIdCheck(data = df, pathId = "path", usePolyline = FALSE, NULL)

  expect_true(
    sum(res$data$path == c("myPath")) == 10
  )

})

test_that("polyId check corrects the id", {

  df <- tram_route[1:10,]
  df$path <- 'myPath'

  res <- googleway:::polyIdCheck(data = df, id = "path", usePolyline = FALSE, NULL)

  expect_true(
    sum(res$data$path == c("myPath")) == 10
  )

})

