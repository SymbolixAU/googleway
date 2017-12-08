context("google map layers")


test_that("markers correctly defined", {

  m <- google_map(key = "abc")

  df <- data.frame(mylat = 1:4,
                   mylon = 1:4)

#  expect_error(add_markers(map = m), "No data supplied") ## no longer relevent
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

test_that("marker exmaples work", {

  map_key <- "api"

  ## map specifying lat & lon, and using defaults for opacity and colour
  g <- google_map(key = map_key, data = tram_stops[1, ]) %>%
    add_markers(lat = "stop_lat", lon = "stop_lon", info_window = "stop_name")

  expectedDf <- data.frame(lat = tram_stops[1, "stop_lat"],
                           lng = tram_stops[1, "stop_lon"],
                           info_window = tram_stops[1, "stop_name"],
                           opacity = googleway:::markerDefaults(1)[, 'opacity'],
                           colour = googleway:::markerDefaults(1)[, 'colour'],
                           stringsAsFactors = F)

  expect_equal(
    expectedDf,
    jsonlite::fromJSON(g$x$calls[[1]]$args[[1]])
  )
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
      '[{"lat":1,"lng":1,"fill_colour":1},{"lat":2,"lng":2,"fill_colour":1},{"lat":3,"lng":3,"fill_colour":1},{"lat":4,"lng":4,"fill_colour":1}]'
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

  g <- google_map(key = 'abc') %>%
    add_overlay(north = 40.773941, south = 40.712216, east = -74.12544, west = -74.22655,
                overlay_url = "https://www.lib.utexas.edu/maps/historical/newark_nj_1922.jpg")

  expect_true(
    sum(class(g) == c("google_map", "htmlwidget")) == 2
  )

})



test_that("map layer parameter checks work", {


  ## Drawing
  g <- google_map(key = 'abc') %>%
    add_drawing()

  expect_true(
    sum(class(g) == c("google_map", "htmlwidget")) == 2
  )

  g <- google_map(key = 'abc') %>%
    clear_drawing()

  expect_true(
    sum(class(g) == c("google_map", "htmlwidget")) == 2
  )


  ## Rectangles
  df <- data.frame(north = 33.685, south = 33.671, east = -116.234, west = -116.251)

  m <- google_map(key = "abc")
  r <- add_rectangles(m, data = df, north = "north", south = "south", east = "east", west = "west")

  expect_true(r$x$calls[[1]]$functions == "add_rectangles")
  expect_true(r$x$calls[[1]]$args[[1]] == '[{"north":33.685,"east":-116.234,"south":33.671,"west":-116.251,"stroke_colour":"#FF0000","stroke_weight":1,"stroke_opacity":0.8,"fill_opacity":0.35,"fill_colour":"#FF0000","z_index":2}]')

})


test_that("drag drop geojson invoked", {

  m <- google_map(key = 'abc') %>%
    add_dragdrop()

  expect_true(
    m$x$calls[[1]]$functions == "drag_drop_geojson"
  )

})












