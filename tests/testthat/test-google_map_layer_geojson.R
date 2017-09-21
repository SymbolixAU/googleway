context("geojson")


test_that("geojson layer works", {

  m <- google_map(key = 'abc') %>%
    add_geojson(data = '{}')

  expect_true(
    sum(class(m) == c("google_map", "htmlwidget")) == 2
  )

})


test_that("clear geojson works", {

  m <- google_map(key = 'abc') %>%
    add_geojson(data = '{}') %>%
    clear_geojson()

  expect_true(
    m$x$calls[[2]]$functions == "clear_geojson"
  )
})


test_that("udpate geojson works", {

  m <- google_map(key = 'abc') %>%
    add_geojson(data = '{}') %>%
    update_geojson(style = '{}')

  expect_true(
    m$x$calls[[2]]$functions == "update_geojson"
  )
})
