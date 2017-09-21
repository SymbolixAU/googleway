context("kml")

test_that("kml layer works", {


  kmlUrl <- paste0('https://developers.google.com/maps/',
                   'documentation/javascript/examples/kml/westcampus.kml')

  g <- google_map(key = 'abc') %>%
    add_kml(kml_url = kmlUrl)

  expect_true(
    sum(class(g) == c("google_map", "htmlwidget")) == 2
  )

  g <- google_map(key = 'abc') %>%
    add_kml(kml_url = kmlUrl) %>%
    clear_kml()

  expect_true(
    g$x$calls[[2]]$functions == "clear_kml"
  )

})
