context("rectangles")

test_that("rectangles work", {

  df <- data.frame(id = 1, north = 33.685, south = 33.671, east = -116.234, west = -116.251)

  m <- google_map(key = "abc") %>%
    add_rectangles(data = df, north = "north", south = "south", east = "east", west = "west")

  expect_true(
    sum(class(m) == c("google_map", "htmlwidget")) == 2
  )

  df_update <- data.frame(id = 1, colour = "#00FF00")

  m <- google_map(key = "abc") %>%
    add_rectangles(data = df, north = "north", south = "south", east = "east", west = "west") %>%
    update_rectangles(data = df_update, fill_colour = "colour")

  expect_true(
    m$x$calls[[1]]$functions == "add_rectangles"
  )

  expect_true(
    m$x$calls[[2]]$functions == "update_rectangles"
  )

  m <- google_map(key = "abc") %>%
    add_rectangles(data = df, north = "north", south = "south", east = "east", west = "west") %>%
    clear_rectangles()

  expect_true(
    m$x$calls[[1]]$functions == "add_rectangles"
  )

  expect_true(
    m$x$calls[[2]]$functions == "clear_rectangles"
  )

})

