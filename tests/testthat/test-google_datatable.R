context("datatable")


test_that("datatable constructed", {

  expect_true(googleway:::JsonType("") == "string")
  expect_true(googleway:::JsonType(as.Date("2017-01-01")) == "string")
  expect_true(googleway:::JsonType(as.factor(1)) == "string")
  expect_true(googleway:::JsonType(1) == "number")
  expect_true(googleway:::JsonType(1L) == "number")
  expect_true(googleway:::JsonType(T) == "boolean")
  expect_true(googleway:::JsonType(1) == "number")
  expect_true(googleway:::JsonType(as.POSIXct("2017-01-01")) == "string")
  expect_true(googleway:::JsonType(complex()) == "string")

  df <- tram_stops[1, ]
  cols <- c("stop_lat", "stop_lon")
  js <- '\"cols\":[{\"id\":\"stop_lat\",\"label\":\"stop_lat\",\"type\":\"number\"},{\"id\":\"stop_lon\",\"label\":\"stop_lon\",\"type\":\"number\"}]'
  expect_equal(googleway:::DataTableHeading(df, cols),js)

  df_res <- data.frame(
    stop_id = df$stop_id,
    info_window = '{"c":[{"v":-37.809},{"v":144.9731}]}',
    stringsAsFactors = F
  )
  df <- googleway:::DataTableColumn(df, 'stop_id', cols)
  expect_equal(df$stop_id, df_res$stop_id)
  expect_equal(df$info_window, df_res$info_window)

})
