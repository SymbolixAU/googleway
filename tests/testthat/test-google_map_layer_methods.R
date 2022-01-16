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

  class(js) <- 'json'
  expect_true(
    googleway:::validateGeojson(js)$source == "local"
  )

  expect_error(googleway:::validateGeojson(data.frame()))

  ## invalid json
  expect_error(
    googleway:::validateGeojson('{ "invalid" , json }'),
    "invalid JSON"
    )

})

test_that("update style is validated", {

  ## invalid JSON
  style <- '{ "invalid" , "JSON" }'

  expect_error(
    googleway:::validateStyleUpdate(style),
    "invalid JSON"
  )

  style <- '{ "fillColor" : "color" }'

  expect_true(class(googleway:::validateStyleUpdate(style)) == "json")


  style <- list(fillColor = "color")
  expect_true(class(googleway:::validateStyleUpdate(style)) == "json")

  expect_error(
    googleway:::validateStyleUpdate(data.frame())
  )

})


test_that("style is validated", {

  style <- '{ "invalid" , "JSON"  }'
  expect_error(
    googleway:::validateStyle(style),
    "invalid JSON"
  )

  style <- '{ "fillColor" : "color" }'
  expect_true(class(googleway:::validateStyle(style)) == "list")
  expect_true(googleway:::validateStyle(style)$type == "all")
  expect_true(googleway:::validateStyle(style)$style == style)


  style <- list(fillColor = "color")
  expect_true(googleway:::validateStyle(style)$type == "individual")

  expect_error(
    googleway:::validateStyle(data.frame())
  )

})













