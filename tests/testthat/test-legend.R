context("legend")


test_that("gradient legends return correct rows",{

  ## A gradient legend should have an even number of bins and spacing between numbers
  ##
  ## we want to keep the min & max colours
  ## but we may not want to use the values associated wtih those colours because the
  ## numbers may not space nicely

  n <- 234
  palette <- data.frame(variable = 1:n, colour = viridisLite::inferno(n) )

})

test_that("legend resolves", {

  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  lstPalette <- list(stroke_colour = viridisLite::viridis,
                     fill_colour = viridisLite::inferno)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = "val"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "val")

  pal <- googleway:::createPalettes(shape, colourColumns)

  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, lstPalette)

  legend <- googleway:::resolveLegend(T, NULL, colour_palettes)

  expect_true(
    legend[[1]]$colourType == "stroke_colour"
  )

  expect_true(
    legend[[2]]$title == "val"
  )

})

test_that("legend values are prefixed & suffixed", {


  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  lstPalette <- list(stroke_colour = viridisLite::viridis,
                     fill_colour = viridisLite::inferno)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = "val"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "val")

  pal <- googleway:::createPalettes(shape, colourColumns)

  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, lstPalette)

  legend <- googleway:::constructLegend(colour_palettes, legend = T)

  legend_options <- list(
    fill_colour = list(
      title = "new legend title",
      css = 'max-width : 120px; max-height : 160px; overflow : auto;',
      position = "BOTTOM_LEFT",
      prefix = "MyVal",
      suffix = NULL
    ),
    stroke_colour = list(
      suffix = "%%%%"
    )
  )

  legend <- googleway:::addLegendOptions(legend, legend_options)

  expect_true(
    legend[[1]]$legend[1, 'variable'] == "MyVala"
  )

  expect_true(
    legend[[2]]$legend[2, 'variable'] == "2%%%%"
  )

})

test_that("legends are formatted", {

  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = 10000000:10000004,
                    val2 = seq.POSIXt(from = as.POSIXct("2017-10-01 00:00:00", tz = "Australia/Melbourne"), by = "1 day", length.out = 5),
                    stringsAsFactors = F)

  lstPalette <- list(stroke_colour = viridisLite::viridis,
                     fill_colour = viridisLite::inferno)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "val2", fill_colour = "val"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'val2', "fill_colour" = "val")

  pal <- googleway:::createPalettes(shape, colourColumns)

  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, lstPalette)

  legend <- googleway:::constructLegend(colour_palettes, legend = T)
  legend <- googleway:::addLegendOptions(legend, NULL)

  expect_true(
    legend[[1]]$legend[1, 'variable'] == "10,000,000"
  )

  expect_true(
    legend[[2]]$legend[1, 'variable'] == "2017-10-01"
  )

})


test_that("legend is reveresed", {

  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = 10000000:10000004,
                    val2 = seq.POSIXt(from = as.POSIXct("2017-10-01 00:00:00", tz = "Australia/Melbourne"), by = "1 day", length.out = 5),
                    stringsAsFactors = F)

  lstPalette <- list(stroke_colour = viridisLite::viridis,
                     fill_colour = viridisLite::inferno)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "val2", fill_colour = "val"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'val2', "fill_colour" = "val")

  pal <- googleway:::createPalettes(shape, colourColumns)

  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, lstPalette)

  legendOptions <- list(
    reverse = T
  )

  legend <- googleway:::constructLegend(colour_palettes, legend = T)
  legend <- googleway:::addLegendOptions(legend, legendOptions)

  expect_true(
    legend[[1]]$legend[1, 'variable'] == as.Date("2017-10-05")
  )

  expect_true(
    legend[[2]]$legend[1, 'variable'] == "10,000,004"
  )

  legendOptions <- list(
    fill_colour = list(
      reverse = T
    )
  )

  legend <- googleway:::constructLegend(colour_palettes, legend = T)
  legend <- googleway:::addLegendOptions(legend, legendOptions)

  expect_true(
    legend[[2]]$legend[1, 'variable'] == as.Date("2017-10-01")
  )

  expect_true(
    legend[[1]]$legend[1, 'variable'] == "10,000,004"
  )

})






