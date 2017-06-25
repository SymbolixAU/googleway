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

  ## colours
  df$colour <- c("red", "blue", "green", "lavender")
  expect_silent(add_markers(map = m, data = df, colour = "colour"))

  df$colour <- c("red", "blue", "green", "lavendar")
  expect_error(
    add_markers(map = m, data = df, colour = "colour"),
    "colours must be either red, blue, green or lavender"
    )


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

test_that("clear search invoked", {

  m <- google_map(key = "abc")
  expect_silent(clear_search(map = m))

})

test_that("update styles correctly invoked", {

  style <- "abc"
  m <- google_map(key = "abc")

  expect_error(update_style(m, style = T))

  expect_true(update_style(m, style = "{}")$x$calls[[1]]$functions == "update_style")

})


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



test_that("heatmap correctly defined", {

  m <- google_map(key = "abc")

  df <- data.frame(mylat = 1:4,
                   mylon = 1:4)

  expect_error(add_heatmap(map = m, data = df), "Couldn't infer latitude column for add_heatmap")
  expect_error(add_heatmap(map = m, data = df), "Couldn't infer latitude column for add_heatmap")

  df <- data.frame(lat = 1:4,
                   lon = 1:4)

  expect_true(add_heatmap(map = m, data = df)$x$calls[[1]]$functions == "add_heatmap")
  expect_error(add_heatmap(map = m, data = df, option_opacity = 2))
  expect_error(add_heatmap(map = m, data = df, option_dissipating = "yes"))
  expect_error(add_heatmap(map = m, data = df, option_radius = "1"))

  expect_true(add_heatmap(m, data = df)$x$calls[[1]]$functions == "add_heatmap")

  expect_error(
    add_heatmap(m, data = df, option_gradient = c("blue")),
    "please provide at least two gradient colours"
  )

  expect_true(
    add_heatmap(m, data = df, option_gradient = c("red", "blue"))$x$calls[[1]]$args[[1]] ==
      '[{"lat":1,"lng":1,"weight":1},{"lat":2,"lng":2,"weight":1},{"lat":3,"lng":3,"weight":1},{"lat":4,"lng":4,"weight":1}]'
  )

  expect_true(
    add_heatmap(m, data = df, option_gradient = c("red", "blue"))$x$calls[[1]]$args[[2]] ==
      '[{"dissipating":false,"radius":0.01,"opacity":0.6,"gradient":["rgba(255,0,0,0)","rgba(0,0,255,1)"]}]'
  )

})

test_that("clear heatmaps invoked correctly",{

  df <- data.frame(lat = 1:4,
                   lon = 1:4)

  m <- google_map(key = "abc") %>% add_heatmap(data = df)

  expect_true(update_heatmap(m, data = df)$x$calls[[2]]$functions == "update_heatmap")
  expect_true(clear_heatmap(m)$x$calls[[2]]$functions == "clear_heatmap")

})

test_that("layers added and removed", {

  m <- google_map(key = "abc") %>% add_traffic()
  expect_true(m$x$calls[[1]]$functions == "add_traffic")

  m <- google_map(key = "abc") %>% clear_traffic()
  expect_true(m$x$calls[[1]]$functions == "clear_traffic")

  m <- google_map(key = "abc") %>% add_bicycling()
  expect_true(m$x$calls[[1]]$functions == "add_bicycling")

  m <- google_map(key = "abc") %>% clear_bicycling()
  expect_true(m$x$calls[[1]]$functions == "clear_bicycling")

  m <- google_map(key = "abc") %>% add_transit()
  expect_true(m$x$calls[[1]]$functions == "add_transit")

  m <- google_map(key = "abc") %>% clear_transit()
  expect_true(m$x$calls[[1]]$functions == "clear_transit")

})


test_that("polylines added and removed", {

  ##  poylline column
  m <- google_map(key = "abc")
  df <- data.frame(lat = 1:4,
                  lon = 1:4,
                  polyline = letters[1:4],
                  info_window = letters[1:4],
                  mouse_over = letters[1:4])

  expect_error(
    add_polylines(m),
    'please supply the either the column containing the polylines, or the lat/lon coordinate columns'
    )

  df$id <- 1:nrow(df)
  expect_silent(add_polylines(map = m, data = df, id = 'id', lat = 'lat', lon = 'lon'))

  x <- add_polylines(map = m, data = df, id = 'id', lat = 'lat', lon = 'lon')
  js <- x$x$calls[[1]]$args[[1]]

  expect_equal(
    as.character(js),
    '[{"coords":[{"lat":1,"lng":1}],"geodesic":true,"stroke_colour":"#0000FF","stroke_weight":2,"stroke_opacity":0.6,"z_index":3,"id":"1"},{"coords":[{"lat":2,"lng":2}],"geodesic":true,"stroke_colour":"#0000FF","stroke_weight":2,"stroke_opacity":0.6,"z_index":3,"id":"2"},{"coords":[{"lat":3,"lng":3}],"geodesic":true,"stroke_colour":"#0000FF","stroke_weight":2,"stroke_opacity":0.6,"z_index":3,"id":"3"},{"coords":[{"lat":4,"lng":4}],"geodesic":true,"stroke_colour":"#0000FF","stroke_weight":2,"stroke_opacity":0.6,"z_index":3,"id":"4"}]'
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

  expect_true(
    add_polygons(map = m, data = df, lat = 'lat', lon = 'lon', id = 'id')$x$calls[[1]]$args[[1]] ==
    '[{"coords":[[{"lat":1,"lng":1},{"lat":2,"lng":2},{"lat":3,"lng":3},{"lat":4,"lng":4}]],"stroke_colour":"#0000FF","stroke_weight":1,"stroke_opacity":0.6,"fill_colour":"#FF0000","fill_opacity":0.35,"z_index":1,"id":"1"}]'
  )

  expect_true(clear_polygons(m)$x$calls[[1]]$functions == "clear_polygons")

})

test_that("map overlays coordinates are accurate", {

  expect_error(google_map(key = 'abc') %>%
                 add_overlay(north = 40.773941, south = 1000, east = -74.12544, west = -74.22655,
                             overlay_url = "https://www.lib.utexas.edu/maps/historical/newark_nj_1922.jpg")
  )

  expect_error(google_map(key = 'abc') %>%
                 add_overlay(north = 40.773941, south = 40.712216, east = -274.12544, west = -74.22655,
                             overlay_url = "https://www.lib.utexas.edu/maps/historical/newark_nj_1922.jpg")
  )

  expect_error(google_map(key = 'abc') %>%
                 add_overlay(north = 40.773941, south = 40.712216, east = -74.12544, west = -274.22655,
                             overlay_url = "https://www.lib.utexas.edu/maps/historical/newark_nj_1922.jpg")
  )

  expect_error(google_map(key = 'abc') %>%
                 add_overlay(north = 240.773941, south = 40.712216, east = -74.12544, west = -74.22655,
                             overlay_url = "https://www.lib.utexas.edu/maps/historical/newark_nj_1922.jpg")
  )

})

