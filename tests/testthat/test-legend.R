context("legend")


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

