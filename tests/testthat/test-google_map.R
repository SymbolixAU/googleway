context("Google map")

test_that("default options are set", {

  g <- google_map(key = "abc", location = NULL, zoom = NULL, search_box = F, styles = NULL)
  expect_true(g$x$zoom == 8)
  expect_true(g$x$lat == -37.9)
  expect_true(g$x$lng == 144.5)
  expect_false(g$x$search_box)
  expect_null(g$x$styles)
  expect_true(g$dependencies[[1]]$head == "<script src=\"https://maps.googleapis.com/maps/api/js?key=abc&libraries=visualization,geometry,places,drawing\"></script><script type=\"text/javascript\" src=\"https://www.gstatic.com/charts/loader.js\"></script>")
  expect_true(is.list(g$x))
  expect_true(inherits(g, "google_map"))

})


test_that("search box is loaded", {

  g <- google_map(key = "abc", search_box = T)
  expect_true(g$x$search_box)
  expect_true(g$dependencies[[1]]$head == "<script src=\"https://maps.googleapis.com/maps/api/js?key=abc&libraries=visualization,geometry,places,drawing\"></script><script type=\"text/javascript\" src=\"https://www.gstatic.com/charts/loader.js\"></script>")
})

test_that("split view option defaults are set", {

  expect_true(
    googleway:::splitViewOptions(NULL)$heading == 34
  )
  expect_true(
    googleway:::splitViewOptions(NULL)$pitch == 10
  )

})

test_that("attributes and map data is attached", {

  g <- google_map(key = "abc", data = data.frame(id = 1:3, val = letters[1:3]))

  expect_true(
    all(
      attributes(g$x)$names ==
        c("lat", "lng","zoom","styles","search_box", "update_map_view", "zoomControl",
          "mapType", "mapTypeControl", "scaleControl", "streetViewControl", "rotateControl",
          "fullscreenControl","event_return_type", "split_view", "split_view_options",
          "geolocation")
      )
    )
  expect_true(inherits(attributes(g$x)$google_map_data, "data.frame"))

})


test_that("libraries are turned off", {

  g <- google_map(key = "abc", libraries = c("visualization", "drawing"))
  expect_true(g$dependencies[[1]]$head == "<script src=\"https://maps.googleapis.com/maps/api/js?key=abc&libraries=visualization,drawing\"></script><script type=\"text/javascript\" src=\"https://www.gstatic.com/charts/loader.js\"></script>")

})

test_that("google_mapOutput created", {

  skip("requires connection")

  g <- google_mapOutput(outputId = "map")
  expect_true("shiny.tag.list" %in% class(g))
  expect_true("list" %in% class(g))
  expect_true(g[[1]]$attribs$class == "google_map html-widget html-widget-output")

  g <- renderGoogle_map(expr = "abc")
  expect_true("shiny.render.function" %in% class(g))
  expect_true("function" %in% class(g))

})

