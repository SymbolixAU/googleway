context("info window")

## TODO(tests):
## - no 'id' value supplied

test_that("info window chart checks", {

  expect_true(googleway:::isInfoWindowChart(list()))
  expect_false(googleway:::isInfoWindowChart(c()))
})

test_that("info window list creates chart", {
  markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 5),
      day = rep(c("Mon", "Tues", "Weds", "Thurs", "Fri"), times = nrow(tram_stops) ),
      val1 = rep(c(20, 31, 50, 77, 68), times = nrow(tram_stops) ),
      val2 = rep(c(28, 38, 55, 77, 66), times = nrow(tram_stops) ),
      val3 = rep(c(38, 55, 77, 66, 22), times = nrow(tram_stops) ),
      val4 = rep(c(45, 66, 80, 50, 15), times = nrow(tram_stops) ) )

  chartList <- list(data = markerCharts,
     type = 'candlestick',
     options = list(legend = 'none',
       bar = list(groupWidth = "100%"),
       candlestick = list(
         fallingColor = list( strokeWidth = 0, fill = "#a52714"),
         risingColor = list( strokeWidth = 0, fill = "#0f9d58")
         )
       ))

  mapObject <- tram_stops
  mapObject <- googleway:::InfoWindow(chartList, mapObject, 'stop_id')
  expect_true(nrow(mapObject) == nrow(tram_stops))  ## the data remains same length
  expect_true(all(sapply(mapObject$info_window, jsonlite::validate))) ## valid JSON
  expect_true(all(sapply(mapObject$chart_options, jsonlite::validate))) ## valid JSON


})

test_that("id is required for using a chart", {

  expect_error(
    googleway:::InfoWindow(list(), mapObject, id = NULL),
    "When using a chart as an info window you need to supply the 'id' which links the data to the chart"
  )

  expect_error(
    google_map(key = "abc") %>% add_markers(data = tram_stops, info_window = list()),
    "When using a chart as an info window you need to supply the 'id' which links the data to the chart"
  )

  expect_error(googleway:::InfoWindow(c()), "info_window must be a list, column name or single value")
})


