context("map urls")

test_that("urls constructed", {
  expect_true(googleway:::constructURL("https://www.helloworld.com/", c(foo = "bar")) == "https://www.helloworld.com/&foo=bar")
  expect_equal("qry", googleway:::validateLocationQuery("qry"))
  expect_equal(googleway:::validateLocationQuery(1:2), "1,2")
  expect_error(googleway:::validateLocationQuery(1:3), "Expecting either a string or a vector of lat/lon coordinates")
  expect_equal(googleway:::constructWaypoints2(list("a","b")), "a|b")
  expect_error(googleway:::constructWaypoints2(c()), "I was expecting a list of waypoints")

  expect_equal(googleway:::validatePanoFov(10), 10)
  expect_error(googleway:::validatePanoFov(1), "expecting a fov value between 10 and 100")
  expect_error(googleway:::validatePanoFov(1:2), "expecting a single fov value")

  expect_equal(googleway:::validatePanoHeading(1), 1)
  expect_error(googleway:::validatePanoHeading(-360), "expecting a heading value between -180 and 360")

})


