context("polylines")


test_that("polylines added and removed", {

  ##  poylline column
  m <- google_map(key = "abc")
  df <- data.frame(lat = 1:4,
                   lon = 1:4,
                   polyline = letters[1:4],
                   info_window = letters[1:4],
                   mouse_over = letters[1:4])

  ## no longer valid
  # expect_error(
  #   add_polylines(m),
  #   'No data supplied'
  #   )

  expect_error(
    add_polylines(map = m, data = df),
    'please supply the either the column containing the polylines, or the lat/lon coordinate columns'
  )

  df$id <- 1:nrow(df)
  expect_silent(add_polylines(map = m, data = df, id = 'id', lat = 'lat', lon = 'lon'))

  x <- add_polylines(map = m, data = df, id = 'id', lat = 'lat', lon = 'lon')
  js <- x$x$calls[[1]]$args[[1]]

  expect_equal(
    as.character(js),
    '[{"coords":[{"lat":1,"lng":1}],"geodesic":true,"stroke_colour":"#0000FF","stroke_weight":2,"stroke_opacity":0.6,"z_index":3,"id":1},{"coords":[{"lat":2,"lng":2}],"geodesic":true,"stroke_colour":"#0000FF","stroke_weight":2,"stroke_opacity":0.6,"z_index":3,"id":2},{"coords":[{"lat":3,"lng":3}],"geodesic":true,"stroke_colour":"#0000FF","stroke_weight":2,"stroke_opacity":0.6,"z_index":3,"id":3},{"coords":[{"lat":4,"lng":4}],"geodesic":true,"stroke_colour":"#0000FF","stroke_weight":2,"stroke_opacity":0.6,"z_index":3,"id":4}]'
  )

  expect_message(
    add_polylines(map = m, data = df, lat = 'lat', lon = 'lon'),
    "No 'id' value defined, assuming one continuous line of coordinates"
  )



  expect_true(unique(jsonlite::fromJSON(add_polylines(map = m, data = df, polyline = "polyline")$x$calls[[1]]$args[[1]])$geodesic) == TRUE)
  expect_true(unique(jsonlite::fromJSON(add_polylines(map = m, data = df, polyline = "polyline")$x$calls[[1]]$args[[1]])$stroke_colour) == "#0000FF")
  expect_true(unique(jsonlite::fromJSON(add_polylines(map = m, data = df, polyline = "polyline")$x$calls[[1]]$args[[1]])$stroke_weight) == 2)
  expect_true(unique(jsonlite::fromJSON(add_polylines(map = m, data = df, polyline = "polyline")$x$calls[[1]]$args[[1]])$stroke_opacity) == 0.6)

  expect_true("info_window" %in% names(jsonlite::fromJSON(add_polylines(map = m, data = df, polyline = "polyline", info_window = "info_window")$x$calls[[1]]$args[[1]])))
  expect_true("mouse_over" %in% names(jsonlite::fromJSON(add_polylines(map = m, data = df, polyline = "polyline", mouse_over = "mouse_over")$x$calls[[1]]$args[[1]])))

  expect_true(clear_polylines(m)$x$calls[[1]]$functions == "clear_polylines")

  expect_error(
    add_polylines(map = m, data = df, polyline = 'polyline', lat = 'lat', lon = 'lon'),
    'please use either a polyline colulmn, or lat/lon coordinate columns, not both'
  )

  ## lat/lon column
  # add_polylines(map = m, data = df, lat = 'lat', lon = 'lon')

})


test_that("polylines are updated", {

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
    update_polylines(data = df, id = "id", stroke_colour = "colour")

  expect_true(
    m$x$calls[[2]]$args[[1]] == '[{"id":1,"stroke_colour":"#00FF00","stroke_weight":2,"stroke_opacity":0.6},{"id":1,"stroke_colour":"#00FF00","stroke_weight":2,"stroke_opacity":0.6},{"id":1,"stroke_colour":"#00FF00","stroke_weight":2,"stroke_opacity":0.6},{"id":1,"stroke_colour":"#00FF00","stroke_weight":2,"stroke_opacity":0.6}]'
  )

})
