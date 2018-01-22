context("map shape constructors")

test_that("map object created", {

  objArgs <- quote(add_circles(data = tram_stops, fill_colour = "stop_name", stroke_colour = "#FF00FF"))
  data <- googleway::tram_stops
  cols <- allCols <- googleway:::circleColumns()

  shape <- googleway:::createMapObject(data, cols, objArgs)

  expect_true(
    nrow(shape) == nrow(googleway::tram_stops)
  )

  expect_true(
    all.equal(names(shape), c("fill_colour", "stroke_colour"))
  )

  expect_true(
    unique(shape$stroke_colour) == "#FF00FF"
  )


  objArgs <- quote(add_circles(data = tram_stops, fill_colour = "stop_name", stroke_colour = viridisLite::viridis(1)))
  data <- googleway::tram_stops
  cols <- allCols <- googleway:::circleColumns()

  shape <- googleway:::createMapObject(data, cols, objArgs)

  expect_true(
    unique(shape$stroke_colour) == viridisLite::viridis(1)
  )

  objArgs <- quote(add_circles(data = tram_stops, fill_colour = "stop_name", stroke_colour = googleway:::removeAlpha(viridisLite::viridis(1))))
  data <- googleway::tram_stops
  cols <- allCols <- googleway:::circleColumns()

  shape <- googleway:::createMapObject(data, cols, objArgs)

  expect_true(
    unique(shape$stroke_colour) == "#440154"
  )



  # dataNames <- names(data)
  # argsIdx <- match(cols, names(objArgs))
  # argsIdx <- argsIdx[!is.na(argsIdx)]
  # argValues <- sapply(1:length(objArgs), function(x) objArgs[[x]])
  # dataArgs <- which(argValues %in% names(data))
  # additionalValues <- setdiff(argsIdx, dataArgs)
  # dataCols <- vapply(dataArgs, function(x) objArgs[[x]], "")
  # dataNames <- names(objArgs)[dataArgs]
  #
  # df <- stats::setNames(data[, dataCols, drop = F], dataNames)
  #

})



