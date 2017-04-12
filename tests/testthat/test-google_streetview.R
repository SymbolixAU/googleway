context("static streetview")


test_that("locations and panorama id", {

  expect_error(google_streetview(location = NULL, panorama_id = NULL))
  expect_error(google_streetview(location = "location", panorama_id = "panorama"))
  expect_error(google_streetview(location = c("lat", "lon")))

})

test_that("heading is correct",{
  expect_error(google_streetview(location = c(1,1), heading = -1))
  expect_error(google_streetview(location = c(1,1), heading = c(0, 360)))
  expect_error(google_streetview(location = c(1,1), heading = c("36")))
})


test_that("response is logical", {
  expect_error(google_streetview(location = c(1,1), response_check = "TRUE"))
  expect_error(google_streetview(location = c(1,1), response_check = c(T, F)))
})

test_that("fov is between 0 and 120", {

  expect_error(google_streetview(location = c(1,1), fov = -1))
  expect_error(google_streetview(location = c(1,1), fov = 121))
  expect_error(google_streetview(location = c(1,1), fov = c(0, 120)))

})

test_that("size is correct size", {
  expect_error(google_streetview(location = c(1,1), size = c(1)))
  expect_error(google_streetview(location = c(1,1), size = c("a","b")))
})


test_that("pitch is correct value",{

  expect_error(google_streetview(location = c(1,1), pitch = -180))
  expect_error(google_streetview(location = c(1,1), pitch = c(0, 90)))
})


# test_that("response check fails ", {
#   expect_error(
#     google_streetview(location = c(1,1), key = "key", response_check = T)
#     )
# })

test_that("html is returned", {
  expect_equal(
    google_streetview(location = c(1, 1), output = "html", key = "key"),
    "https://maps.googleapis.com/maps/api/streetview?&location=1,1&size=400x400&fov=90&pitch=0&key=key"
  )
})


# test_that("plot fails", {
#   expect_error(google_streetview(location = c(1, 1), output = "plot", key = "key"))
# })



