context("legend")


test_that("legend values are formatted", {


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


