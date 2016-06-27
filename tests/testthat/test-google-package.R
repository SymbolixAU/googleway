context("Google package")

test_that("transit mode warning",{

  skip_on_cran()
  skip_on_travis()

  key <- read.dcf(file = "~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   transit_mode = "train",
                                   key = key),
                 "You have specified a transit_mode, but are not using mode = 'transit'. Therefore this argument will be ignored")
})

test_that("transit mode choices are valid",{

  skip("incorrect error string in match.arg")

  expect_error(google_directions(origin = "Melbourne Airport, Australia",
                                 destination = "Portsea, Melbourne, Australia",
                                 mode = "transit",
                                 transit_mode = "transit_mode",
                                 key = "abc"),
               "'arg' should be one of \"bus\", \"subway\", \"train\", \"tram\", \"rail\"")


})


test_that("transit_routing_preferences issues warning", {

  skip_on_cran()
  skip_on_travis()

  key <- read.dcf(file = "~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   transit_routing_preference = "less_walking",
                                   key = key),
                 "You have specified a transit_routing_preference, but are not using mode = 'transit'. Therefore this argument will be ignored")

})


test_that("valid routing preferences", {

  skip("incorrect error string in match.arg")

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   mode = "transit",
                                   transit_mode = "train",
                                   transit_routing_preference = "hills are yum",
                                   key = "abc"),
                 "'arg' should be one of \"less_walking\", \"fewer_transfers\"")

})

test_that("warning when both arrival and departure times supplied", {

  skip_on_cran()
  skip_on_travis()

  key <- read.dcf(file = "~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  expect_warning(google_directions(origin = "Melbourne Airport, Australia",
                                   destination = "Portsea, Melbourne, Australia",
                                   departure_time = Sys.time() + (24 * 60 * 60),
                                   arrival_time = Sys.time() + (24 * 60 * 60),
                                   key = key),
                 "you have supplied both an arrival_time and a departure_time - only one is allowed. The arrival_time will be ignored")

})




