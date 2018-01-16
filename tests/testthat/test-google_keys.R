context("keys")

test_that("key options returned", {

  x <- google_keys()

  expect_true(
    inherits(x, "googleway_api")
  )
})

test_that("keys are cleared", {

  set_key("my_key")
  clear_keys()
  x <- google_keys()

  v <- unname(sapply(x[[1]], `[`))

  expect_true(
    sum(is.na(v)) == 13
  )

1})

test_that("default key set", {

  clear_keys()

  set_key("my_key")

  x <- google_keys()

  expect_true(
    x[[1]][['default']] == "my_key"
  )

  v <- unname(sapply(x[[1]], `[`))

  expect_true(
    sum(is.na(v)) == 12
  )

  expect_true(
    v[1] == "my_key"
  )

})

test_that("specific key set", {

  clear_keys()

  set_key("my_key", "directions")
  x <- google_keys()

  expect_true(
    x[[1]][['directions']] == "my_key"
  )

  v <- unname(sapply(x[[1]], `[`))

  expect_true(
    sum(is.na(v)) == 12
  )

  expect_true(
    v[3] == "my_key"
  )

})


test_that("get_api_key retrieves api key", {

  clear_keys()
  set_key("my_key", "map")

  expect_true(
    googleway:::get_api_key("map") == "my_key"
  )

})

test_that("default api key returned", {

  clear_keys()
  set_key("my_key")

  expect_true(
    googleway:::get_default_key() == "my_key"
  )

  expect_true(
    googleway:::get_api_key("directions") == "my_key"
  )

})

test_that("api keys printed", {

  expect_silent(
    google_keys()
  )

11})


