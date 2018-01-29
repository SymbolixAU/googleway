context("accessors")

test_that("access result helper methods work", {

  vecJs <- c("{", "\"geocoded_waypoints\":[", "{", "\"geocoder_status\":\"OK\",",
             "\"place_id\":\"ChIJSSKDr7ZC1moRTsSnSV5BnuM\",", "\"types\":[",
             "\"establishment\",", "\"point_of_interest\",", "\"train_station\",",
             "\"transit_station\"", "]", "},")

  expect_true(
    googleway:::collapseResult(vecJs) == paste0(vecJs, collapse = "")
  )

  expect_true(googleway:::getFunc("instructions") == "direction_instructions")
  expect_true(googleway:::getFunc("polyline") == "direction_polyline")
  expect_true(googleway:::getFunc("place_name")  == "place_name")

})


test_that("access result", {

  ## only character (json) and lists are accepted
  expect_error(
    access_result(data.frame(), "polyline"),
    "I don't know how to deal with objects of type data.frame"
  )

  expect_error(
    access_result(matrix(), "polyline"),
    "I don't know how to deal with objects of type matrix"
  )

  expect_error(
    .access_result(1, "polyline"),
    "I don't know how to deal with objects of type numeric"
  )


  resJS <- '{ "routes" : [ { "overview_polyline" : { "points" : "nkyeFi_ysZz@[VOI]KsDI{EGs@A{COwNCoAHgBACAI]aJ@OEW?c@dAgRf@mFz@i@~Ah@f@LHWVy@" }  }] }'
  resLst <- list(
    routes = list(
      overview_polyline = list(
        points = "nkyeFi_ysZz@[VOI]KsDI{EGs@A{COwNCoAHgBACAI]aJ@OEW?c@dAgRf@mFz@i@~Ah@f@LHWVy@")))

  expect_true(
    access_result(resLst, "polyline") ==
    "nkyeFi_ysZz@[VOI]KsDI{EGs@A{COwNCoAHgBACAI]aJ@OEW?c@dAgRf@mFz@i@~Ah@f@LHWVy@"
  )

  pl <- "nkyeFi_ysZz@[VOI]KsDI{EGs@A{COwNCoAHgBACAI]aJ@OEW?c@dAgRf@mFz@i@~Ah@f@LHWVy@"
  x <- access_result(resJS, "polyline")
  attributes(x) <- NULL
  x <- gsub("\"", "", x)
  expect_true(
    x == pl
  )

})
