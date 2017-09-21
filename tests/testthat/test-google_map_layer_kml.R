context("kml")

test_that("kml layer works", {


  kmlUrl <- paste0('https://developers.google.com/maps/',
                   'documentation/javascript/examples/kml/westcampus.kml')

  g <- google_map(key = 'abc') %>%
    add_kml(kml_url = kmlUrl)

  expect_true(
    sum(class(g) == c("google_map", "htmlwidget")) == 2
  )

})
