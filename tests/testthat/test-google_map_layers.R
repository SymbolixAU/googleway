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

  df <- data.frame(lat = 1:4,
                   lon = 1:4,
                   title = letters[1:4],
                   draggable = TRUE,
                   opacity = 0.1,
                   label = letters[1:4],
                   info_window = letters[1:4],
                   mouse_over = letters[1:4])

  expect_true("title" %in% names(jsonlite::fromJSON(add_markers(map = m, data = df, title = "title")$x$calls[[1]]$args[[1]])))
  expect_true("draggable" %in% names(jsonlite::fromJSON(add_markers(map = m, data = df, draggable = "draggable")$x$calls[[1]]$args[[1]])))
  expect_true("opacity" %in% names(jsonlite::fromJSON(add_markers(map = m, data = df, opacity = "opacity")$x$calls[[1]]$args[[1]])))
  expect_true("label" %in% names(jsonlite::fromJSON(add_markers(map = m, data = df, label = "label")$x$calls[[1]]$args[[1]])))
  expect_true("info_window" %in% names(jsonlite::fromJSON(add_markers(map = m, data = df, info_window = "info_window")$x$calls[[1]]$args[[1]])))
  expect_true("mouse_over" %in% names(jsonlite::fromJSON(add_markers(map = m, data = df, mouse_over = "mouse_over")$x$calls[[1]]$args[[1]])))

})

test_that("clear markers invoked", {

  df <- data.frame(lat = 1:4,
                   lon = 1:4)

  m <- google_map(key = "abc") %>% add_markers(data = df)

  expect_true(clear_markers(m)$x$calls[[2]]$functions == "clear_markers")

})

thest_that("update styles correctly invoked", {


  style <- "abc"
  m <- google_map(key = "abc")

  expect_error(update_style(m, style = T))

  expect_true(update_style(m, style = "{}")$x$calls[[2]]$functions == "update_style")

})


test_that("circles correctly defined", {

  m <- google_map(key = "abc")

  df <- data.frame(mylat = 1:4,
                   mylon = 1:4)

  expect_error(add_circles(map = m), "Couldn't infer latitude column for add_circles")
  expect_error(add_circles(map = m, data = df), "Couldn't infer latitude column for add_circles")

  df <- data.frame(lat = 1:4,
                   lon = 1:4,
                   info_window = letters[1:4],
                   mouse_over = letters[1:4])

  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$stroke_colour) == "#FF0000")
  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$stroke_weight) == 2)
  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$stroke_opacity) == 0.8)
  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$radius) == 100)
  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$fill_colour) == "#FF0000")
  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$fill_opacity) == 0.35)

  expect_true("info_window" %in% names(jsonlite::fromJSON(add_circles(map = m, data = df, info_window = "info_window")$x$calls[[1]]$args[[1]])))
  expect_true("mouse_over" %in% names(jsonlite::fromJSON(add_circles(map = m, data = df, mouse_over = "mouse_over")$x$calls[[1]]$args[[1]])))


})


test_that("clear markers circles", {

  df <- data.frame(lat = 1:4,
                   lon = 1:4)

  m <- google_map(key = "abc") %>% add_circles(data = df)

  expect_true(clear_circles(m)$x$calls[[2]]$functions == "clear_circles")

})









