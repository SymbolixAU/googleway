context("Google package")

test_that("transit mode warning",{

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   transit_mode = "train",
                                   key = "abc"))
})

test_that("transit mode choices are valid",{

  skip("incorrect error string in match.arg")

  expect_error(google_directions(origin = "Melbourne Airport, Australia",
                                 destination = "Portsea, Melbourne, Australia",
                                 mode = "transit",
                                 transit_mode = "transit_mode",
                                 key = "abc"))


})

test_that("transit_routing_preferences issues warning", {

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   transit_routing_preference = "less_walking",
                                   key = "abc"))

})


test_that("valid routing preferences", {

  skip("incorrect error string in match.arg")

  expect_error(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   mode = "transit",
                                   transit_mode = "train",
                                   transit_routing_preference = "hills are yum",
                                   key = "abc"))

})

test_that("warning when both arrival and departure times supplied", {

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   departure_time = Sys.time() + (24 * 60 * 60),
                                   arrival_time = Sys.time() + (24 * 60 * 60),
                                   key = "abc"))

})




