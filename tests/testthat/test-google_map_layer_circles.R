
test_that("circles correctly defined", {

  m <- google_map(key = "abc")

  df <- data.frame(mylat = 1:4,
                   mylon = 1:4)

  expect_error(add_circles(map = m, data = df), "Couldn't infer latitude column for add_circles")
  expect_error(add_circles(map = m, data = df), "Couldn't infer latitude column for add_circles")

  df <- data.frame(lat = 1:4,
                   lon = 1:4,
                   info_window = letters[1:4],
                   mouse_over = letters[1:4])

  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$stroke_colour) == "#FF0000")
  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$stroke_weight) == 1)
  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$stroke_opacity) == 0.8)
  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$radius) == 50)
  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$fill_colour) == "#FF0000")
  expect_true(unique(jsonlite::fromJSON(add_circles(map = m, data = df)$x$calls[[1]]$args[[1]])$fill_opacity) == 0.35)

  expect_true("info_window" %in% names(jsonlite::fromJSON(add_circles(map = m, data = df, info_window = "info_window")$x$calls[[1]]$args[[1]])))
  expect_true("mouse_over" %in% names(jsonlite::fromJSON(add_circles(map = m, data = df, mouse_over = "mouse_over")$x$calls[[1]]$args[[1]])))


  df <- data.frame(lat = 1:4,
                   lon = 1:4,
                   colour = letters[1:4])

  circle <- add_circles(map = m,
              data = df,
              fill_colour = "colour")

  circle <- circle$x$calls[[1]]$args[[1]]

  expect_true(
    grepl("fill_colour", as.character(circle))
  )

  circle <- update_circles(map = m,
                        data = df,
                        fill_colour = "colour")

  circle <- circle$x$calls[[1]]$args[[1]]

  expect_true(
    grepl("fill_colour", as.character(circle))
  )


})

test_that("update circles defined", {

  m <- google_map(key = "abc")
  df <- data.frame(id = 1:4)
  expect_silent(update_circles(map = m, data = df))

})

test_that("clear markers circles", {

  df <- data.frame(lat = 1:4,
                   lon = 1:4)

  m <- google_map(key = "abc") %>% add_circles(data = df)

  expect_true(clear_circles(m)$x$calls[[2]]$functions == "clear_circles")

})


