context("map layer methods")


test_that("goejson is validated", {

  ## url is validated
  url <- 'https://storage.googleapis.com/mapsdevsite/json/google.json'
  expect_true(
    googleway:::validateGeojson(url)$geojson ==
      url
    )
  expect_true(
    googleway:::validateGeojson(url)$source == "url"
  )

  ## JSON
  js <- '{ }'
  expect_true(
    googleway:::validateGeojson(js)$geojson == "{ }"
  )

  expect_true(
    googleway:::validateGeojson(js)$source == "local"
  )

  expect_error(googleway:::validateGeojson(data.frame()))

})
