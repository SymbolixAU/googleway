context("polygons")

test_that("polygons added and removed", {

  m <- google_map(key = "abc")
  df <- data.frame(lat = 1:4,
                   lon = 1:4,
                   polyline = letters[1:4],
                   info_window = letters[1:4],
                   mouse_over = letters[1:4])

  expect_error(add_polygons(m))

  expect_true(unique(jsonlite::fromJSON(add_polygons(map = m, data = df, polyline = "polyline")$x$calls[[1]]$args[[1]])$stroke_colour) == "#0000FF")
  expect_true(unique(jsonlite::fromJSON(add_polygons(map = m, data = df, polyline = "polyline")$x$calls[[1]]$args[[1]])$stroke_weight) == 1)
  expect_true(unique(jsonlite::fromJSON(add_polygons(map = m, data = df, polyline = "polyline")$x$calls[[1]]$args[[1]])$stroke_opacity) == 0.6)

  expect_true("info_window" %in% names(jsonlite::fromJSON(add_polygons(map = m, data = df, polyline = "polyline", info_window = "info_window")$x$calls[[1]]$args[[1]])))
  expect_true("mouse_over" %in% names(jsonlite::fromJSON(add_polygons(map = m, data = df, polyline = "polyline", mouse_over = "mouse_over")$x$calls[[1]]$args[[1]])))

  m <- google_map(key = "abc")
  df <- data.frame(lat = 1:4,
                   lon = 1:4,
                   id = 1,
                   polyline = letters[1:4],
                   info_window = letters[1:4],
                   mouse_over = letters[1:4])

  expect_message(
    add_polygons(map = m, data = df, lat = 'lat', lon = 'lon'),
    "No 'id' value defined, assuming one continuous line of coordinates"
  )

  expect_message(
    add_polygons(map = m, data = df, lat = 'lat', lon = 'lon', id = 'id'),
    "No 'pathId' value defined, assuming one continuous line per polygon"
  )

  expectedDf <- data.frame()

  expect_true(
    add_polygons(map = m, data = df, lat = 'lat', lon = 'lon', id = 'id')$x$calls[[1]]$args[[1]] ==
      '[{"coords":[[{"lat":1,"lng":1},{"lat":2,"lng":2},{"lat":3,"lng":3},{"lat":4,"lng":4}]],"stroke_colour":"#0000FF","stroke_weight":1,"stroke_opacity":0.6,"fill_opacity":0.35,"fill_colour":"#FF0000","z_index":1,"id":1}]'
  )

  expect_true(clear_polygons(m)$x$calls[[1]]$functions == "clear_polygons")

})


test_that("polygons are updated", {

  m <- google_map(key = "abc")
  df <- data.frame(lat = 1:4,
                   lon = 1:4,
                   id = 1,
                   polyline = letters[1:4],
                   colour = c("#00FF00"))

  df_update <- df
  df_update$colour <- "#FF00FF"

  m <- m %>%
    add_polygons(data = df, id = "id", lat = "lat", lon = "lon", fill_colour = "colour") %>%
    update_polygons(data = df, id = "id", fill_colour = "colour")

  expect_true(
    m$x$calls[[2]]$args[[1]] == '[{"id":1,"fill_colour":"#00FF00","stroke_colour":"#0000FF","stroke_weight":1,"stroke_opacity":0.6,"fill_opacity":0.35},{"id":1,"fill_colour":"#00FF00","stroke_colour":"#0000FF","stroke_weight":1,"stroke_opacity":0.6,"fill_opacity":0.35},{"id":1,"fill_colour":"#00FF00","stroke_colour":"#0000FF","stroke_weight":1,"stroke_opacity":0.6,"fill_opacity":0.35},{"id":1,"fill_colour":"#00FF00","stroke_colour":"#0000FF","stroke_weight":1,"stroke_opacity":0.6,"fill_opacity":0.35}]'
  )

})






