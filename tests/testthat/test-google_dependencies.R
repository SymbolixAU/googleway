context("dependencies")


test_that("dependencies load", {

  ## CIRCLES
  m <- google_map(key = "abc", data = tram_stops) %>%
    add_circles()

  expect_true("circles" %in% sapply(m$dependencies, function(x) x[['name']]))

  ## DRAGDROP
  m <- google_map(key = "abc") %>%
    add_dragdrop()

  expect_true("geojson" %in% sapply(m$dependencies, function(x) x[['name']]))

  ## DRAWING
  m <- google_map(key = "abc", data = tram_stops) %>%
    add_drawing()

  expect_true("drawing" %in% sapply(m$dependencies, function(x) x[['name']]))

  ## FUSION
  ## DRAGDROP
  m <- google_map(key = "abc") %>%
    add_fusion(query = "{}")

  expect_true("fusion" %in% sapply(m$dependencies, function(x) x[['name']]))

  ## GEOJSON
  m <- google_map(key = "abc") %>%
    add_geojson(data = geo_melbourne)

  expect_true("geojson" %in% sapply(m$dependencies, function(x) x[['name']]))

  ## HEATMAP
  ## DRAGDROP
  m <- google_map(key = "abc", data = tram_stops) %>%
    add_heatmap()

  expect_true("heatmap" %in% sapply(m$dependencies, function(x) x[['name']]))

  ## KML
  m <- google_map(key = "abc") %>%
    add_kml(kml_url = "http://www.symbolix.com.au")

  expect_true("kml" %in% sapply(m$dependencies, function(x) x[['name']]))


  ## MARKERS
  m <- google_map(key = "abc", data = tram_stops) %>%
    add_markers()

  expect_true("markers" %in% sapply(m$dependencies, function(x) x[['name']]))

  ## MARKERCLUSTERER
  m <- google_map(key = "abc", data = tram_stops) %>%
    add_markers()

  expect_true("markers" %in% sapply(m$dependencies, function(x) x[['name']]))

  ## OVERLAY
  m <- google_map(key = "abc", data = tram_stops) %>%
    add_overlay(north = 0, east = 0, south = 0, west = 0, overlay_url = "http://www.symbolix.com.au")

  expect_true("overlay" %in% sapply(m$dependencies, function(x) x[['name']]))

  ## POLYONS
  m <- google_map(key = "abc") %>%
    add_polygons(data = melbourne, polyline = "polyline")

  expect_true("polygons" %in% sapply(m$dependencies, function(x) x[['name']]))

  ## POLYLINES
  m <- google_map(key = "abc", data = tram_route) %>%
    add_polylines(lat = "shape_pt_lat", lon = "shape_pt_lon")

  expect_true("polylines" %in% sapply(m$dependencies, function(x) x[['name']]))

  ## RECTANGLES
  m <- google_map(key = "abc", data = tram_stops) %>%
    add_rectangles()

  expect_true("rectangles" %in% sapply(m$dependencies, function(x) x[['name']]))

})




