context("colours")

test_that("generate palette methods are called", {

  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    cplx = complex(5),
                    bool = c(rep(T, 3), rep(F, 2)),
                    stringsAsFactors = F)

  ## numeric
  expectedDf <- data.frame(variable = letters[1:5],
                           colour = googleway:::removeAlpha(viridisLite::viridis(5)),
                           stringsAsFactors = F)

  res <- googleway:::generatePalette(dat[, 'val'], viridisLite::viridis)

  expect_true(
    identical(
      expectedDf,
      res
    )
  )

  ## logical
  tCols <- googleway:::removeAlpha(viridisLite::viridis(2))
  expectedDf <- data.frame(variable = c(T,F),
                           colour = tCols,
                           stringsAsFactors = F)

  res <- googleway:::generatePalette(dat[, 'bool'], viridisLite::viridis)

  expect_true(
    identical(
      expectedDf,
      res
    )
  )

  ## default called
  expect_true(
    googleway:::generatePalette(dat[, 'cplx'], viridisLite::viridis)$colour == "#440154"
  )

})

test_that("list of palettes correctly applied", {

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

  expectedColours <- googleway:::createColours(shape, colour_palettes)

  generatedColours <- googleway:::setupColours(dat, shape, colourColumns, lstPalette)

  expect_true(
    identical(expectedColours, generatedColours)
  )

})

test_that("only the specified legend is created for different variables", {

  ## where different variables are mapped
  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  lstPalette <- list(
    stroke_colour = viridisLite::viridis,
    fill_colour = viridisLite::inferno
    )

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = "val"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "val")

  pal <- googleway:::createPalettes(shape, colourColumns)

  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, lstPalette)

  ## we only want to construct the legend if the user wants it

  ## all legends
  legend <- T
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    legend[[1]]$colourType == "stroke_colour"
  )

  expect_true(
    legend[[2]]$colourType == "fill_colour"
  )

  ## no legends
  legend <- F
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    length(legend) == 0
  )

  legend <- c(stroke_colour = T, fil_colour = F)
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    legend[[1]]$colourType == "stroke_colour"
  )

  expect_true(
    length(legend) == 1
  )

  legend <- list(stroke_colour = F, fil_colour = T)
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    length(legend) == 0
  )

  legend <- F
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    length(legend) == 0
  )


  # legend <- c(stroke_colour = F, fill_colour = F)
  # legend <- googleway:::constructLegend(colour_palettes, legend)
  #
  # expect_true(
  #   is.null(legend[[1]])
  # )
  # expect_true(
  #   is.null(legend[[2]])
  # )

})


test_that("only the specified legend is created for one variable mapped twice", {

  ## where different variables are mapped
  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  lstPalette <- list(
    stroke_colour = viridisLite::viridis,
    fill_colour = viridisLite::inferno
  )

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = "id"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "id")

  pal <- googleway:::createPalettes(shape, colourColumns)

  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, lstPalette)

  ## we only want to construct the legend if the user wants it

  ## all legends
  legend <- T
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    legend[[1]]$colourType == "fill_colour"
  )

  expect_true(
    length(legend) == 1
  )

  ## no legends
  legend <- F
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    length(legend) == 0
  )

  ## we're turning one off, but one variable is mapped... what does this mean..?
  legend <- c(stroke_colour = T, fill_colour = F)
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    length(legend) == 0
  )

  legend <- list(stroke_colour = F, fil_colour = T)
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    length(legend) == 0
  )

  legend <- F
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    length(legend) == 0
  )

  #
#   legend <- c(stroke_colour = F, fill_colour = F)
#   legend <- googleway:::constructLegend(colour_palettes, legend)
#
#   expect_true(
#     is.null(legend[[1]])
#   )
#   expect_true(
#     length(legend) == 1
#   )

})



test_that("only the specified legend is created for one variable, the other is NULL", {

  ## where different variables are mapped
  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  lstPalette <- list(
    stroke_colour = viridisLite::viridis,
    fill_colour = viridisLite::inferno
  )

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = NULL))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = NULL)

  pal <- googleway:::createPalettes(shape, colourColumns)

  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, lstPalette)

  ## we only want to construct the legend if the user wants it

  ## all legends
  legend <- T
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    legend[[1]]$colourType == "stroke_colour"
  )

  expect_true(
    length(legend) == 1
  )

  ## no legends
  legend <- F
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    length(legend) == 0
  )

  legend <- list(stroke_colour = F, fil_colour = T)
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    length(legend) == 0
  )

  legend <- F
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    length(legend) == 0
  )

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = NULL, fill_colour = "id"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = NULL, "fill_colour" = "id")

  pal <- googleway:::createPalettes(shape, colourColumns)

  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, lstPalette)

  legend <- list(fill_colour = T, stroke_colour = T)
  legend <- googleway:::constructLegend(colour_palettes, legend)

  expect_true(
    length(legend) == 1
  )

  expect_true(
    legend[[1]]$colourType == "fill_colour"
  )

})




test_that("legend options are assigned to legends", {

  ## TODO:
  ## different legend options for stroke & fill
  ## one legend option to apply to both stroke & fill

  # given a constructed legend, update it with legend_options
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


  ## options to apply to both palettes
  legend_options <- list(
    title = "new legend title",
    css = 'max-width : 120px; max-height : 160px; overflow : auto;',
    position = "BOTTOM_LEFT",
    prefix = NULL,
    suffix = NULL
  )

  legend <- googleway:::addLegendOptions(legend, legend_options)

  expect_true(
    legend[[1]]$title == legend_options$title
  )

  expect_true(
    legend[[2]]$title == legend_options$title
  )

  expect_true(
    legend[[1]]$css == legend_options$css
  )

  expect_true(
    legend[[2]]$css == legend_options$css
  )

  expect_true(
    legend[[1]]$position == legend_options$position
  )

  expect_true(
    legend[[2]]$position == legend_options$position
  )


  ## options to apply to individual palettes
  legend_options <- list(
    fill_colour = list(
      title = "fill title",
      css = 'max-width : 120px; max-height : 160px; overflow : auto;',
      position = "BOTTOM_LEFT"
    ),
    stroke_colour = list(
      title = "stroke title",
      css = 'max-width : 120px; max-height : 160px; overflow : auto;',
      position = "LEFT_TOP"
    )
  )

  legend <- googleway:::constructLegend(colour_palettes, legend = T)
  legend <- googleway:::addLegendOptions(legend, legend_options)

  expect_true(
    legend[[1]]$position == legend_options$fill_colour$position
  )

  expect_true(
    legend[[2]]$position == legend_options$stroke_colour$position
  )

  legend_options <- list(
    fill_colour = list(
      position = "TOP_LEFT"
    )
  )

  legend <- googleway:::constructLegend(colour_palettes, legend = T)
  legend <- googleway:::addLegendOptions(legend, legend_options)

  expect_true(
    legend[[1]]$position == "TOP_LEFT"
  )

  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  lstPalette <- list(stroke_colour = viridisLite::viridis,
                     fill_colour = viridisLite::inferno)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = NULL, fill_colour = "val"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = NULL, "fill_colour" = "val")

  pal <- googleway:::createPalettes(shape, colourColumns)

  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, lstPalette)

  legend_options <- list(
    fill_colour = list(
      position = "TOP_LEFT"
    )
  )

  legend <- googleway:::constructLegend(colour_palettes, legend = T)
  legend <- googleway:::addLegendOptions(legend, legend_options)


  expect_true(
    legend[[1]]$position == "TOP_LEFT"
  )

})



test_that("setup colours ",{

  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = NULL))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = NULL)

  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)

  expectedColours <- googleway:::createColours(shape, colour_palettes)

  generatedColours <- googleway:::setupColours(dat, shape, colourColumns, viridisLite::viridis)

  expect_true(
    identical(expectedColours, generatedColours)
  )

})

test_that("columns of colours are correctly mapped to shape object", {

  ## one-row data.frame
  dat <- data.frame(id = c(1),
                    val = letters[1],
                    val2 = letters[15],
                    stringsAsFactors = F)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = NULL))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = NULL)
  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)

  colours <- googleway:::createColours(shape, colour_palettes)

  expect_equal(
    lapply(colours, length),
    list(1)
  )

  ## one row data.frame, two colours
  dat <- data.frame(id = c(1),
                    val = letters[1],
                    val2 = letters[15],
                    stringsAsFactors = F)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = "val"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "val")
  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)

  colours <- googleway:::createColours(shape, colour_palettes)

  expect_equal(
    lapply(colours, length),
    list(1, 1)
  )



  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                      val = letters[1:5],
                      val2 = letters[11:15],
                      stringsAsFactors = F)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = NULL))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = NULL)
  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)

  expectedColours <- googleway:::removeAlpha(viridisLite::viridis(2))
  colours <- googleway:::createColours(shape, colour_palettes)

  expectedColours <- c(rep(expectedColours[1], 3), rep(expectedColours[2], 2))

  expect_true(
    sum(colours[[1]] == expectedColours) == 5
  )

  expect_equal(
    lapply(colours, length),
    list(5)
  )

  ## unordered data
  dat <- data.frame(id = c(rep(3,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = NULL))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = NULL)
  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)

  expectedColours <- googleway:::removeAlpha(viridisLite::viridis(2))
  colours <- googleway:::createColours(shape, colour_palettes)

  expectedColours <- c(rep(expectedColours[2], 3), rep(expectedColours[1], 2))

  expect_true(
    sum(colours[[1]] == expectedColours) == 5
  )

  expect_equal(
    lapply(colours, length),
    list(5)
  )

  dat <- data.frame(id = c(rep(3,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = "val"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "val")
  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)

  expectedColours <- googleway:::removeAlpha(viridisLite::viridis(2))
  colours <- googleway:::createColours(shape, colour_palettes)

  expectedColours <- c(rep(expectedColours[2], 3), rep(expectedColours[1], 2))

  expect_true(
    sum(colours[[1]] == expectedColours) == 5
  )

  expect_equal(
    lapply(colours, length),
    list(5, 5)
  )


})



test_that("replace Variable colours extracts correct names", {

  ## one variable used once
  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = NULL))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = NULL)
  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)

  expectedColours <- googleway:::removeAlpha(viridisLite::viridis(2))
  colours <- googleway:::createColours(shape, colour_palettes)

  expect_true(
    sum(sapply(colours, colnames) == "stroke_colour") == 1
  )

  expectedDf <- data.frame(id = dat$id,
                           stroke_colour = c(rep(expectedColours[1],3), rep(expectedColours[2], 2)),
                           stringsAsFactors = F)

  res <- googleway:::replaceVariableColours(shape, colours)
  expect_true(
    identical(
      res,
      expectedDf
    )
  )


  ## one variable used twice
  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = "id"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "id")
  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)

  expectedColours <- googleway:::removeAlpha(viridisLite::viridis(2))
  colours <- googleway:::createColours(shape, colour_palettes)

  expectedDf <- data.frame(id = dat$id,
                           stroke_colour = c(rep(expectedColours[1],3), rep(expectedColours[2], 2)),
                           fill_colour = c(rep(expectedColours[1],3), rep(expectedColours[2], 2)),
                           stringsAsFactors = F)

  res <- googleway:::replaceVariableColours(shape, colours)

  expect_true(
    identical(
      expectedDf,
      res
    )
  )




  ## two variables used once each
  dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
                    val = letters[1:5],
                    val2 = letters[11:15],
                    stringsAsFactors = F)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = "val"))
  shape <- googleway:::createMapObject(dat, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "val")
  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)

  expectedIdColours <- googleway:::removeAlpha(viridisLite::viridis(2))
  expectedValColours <- googleway:::removeAlpha(viridisLite::viridis(5))

  colours <- googleway:::createColours(shape, colour_palettes)

  expectedDf <- data.frame(id = dat$id,
                           stroke_colour = c(rep(expectedIdColours[1],3), rep(expectedIdColours[2], 2)),
                           fill_colour = expectedValColours,
                           stringsAsFactors = F)

  res <- googleway:::replaceVariableColours(shape, colours)

  expect_true(
    identical(
      expectedDf,
      res
    )
  )


})


test_that("colour palette names created", {

  ## don't create palettes if the column is a hex colour
  shape <- data.frame(id = 1:5,
                      val = letters[1:5],
                      val2 = letters[11:15],
                      stringsAsFactors = F)

  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "val", fill_colour = "val2"))
  shape <- googleway:::createMapObject(shape, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'val', "fill_colour" = NULL)
  pal <- googleway:::createPalettes(shape, colourColumns)

  expect_true(
    pal == c("stroke_colour" = "val")
  )

  colourColumns <- c("stroke_colour" = 'val', "fill_colour" = "val2")
  pal <- googleway:::createPalettes(shape, colourColumns)

  expect_true(
    sum(pal == c("stroke_colour" = "val", "fill_colour" = "val2")) == 2
  )

})


test_that("palettes generated", {

  data <- data.frame(id = 1:5,
                      val = letters[1:5],
                      val2 = letters[11:15],
                      stringsAsFactors = F)

  ## one palette for one variable
  allCols <- c("id", "val", "val2")
  objArgs <- quote(add_polygons(id = "id", stroke_colour = "val", fill_colour = "val2"))
  shape <- googleway:::createMapObject(data, allCols, objArgs)

  colourColumns <- c("stroke_colour" = 'val', "fill_colour" = NULL)
  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(data, pal, colourColumns, viridisLite::viridis)

  expect_true(length(colour_palettes) == 1)
  expect_true(
    sum(colour_palettes[[1]]$variables == c("val")) == 1
  )

  ## one palette for the same variable used twice
  colourColumns <- c("stroke_colour" = 'val', "fill_colour" = "val")
  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(data, pal, colourColumns, viridisLite::viridis)

  expect_true(
    sum(colour_palettes[[1]]$variables == c("val", "val")) == 2
  )
  expect_true(length(colour_palettes) == 1)


  ## two palettes for two variables
  colourColumns <- c("stroke_colour" = 'val', "fill_colour" = "val2")
  pal <- googleway:::createPalettes(shape, colourColumns)
  colour_palettes <- googleway:::createColourPalettes(data, pal, colourColumns, viridisLite::viridis)


  expect_true(length(colour_palettes) == 2)

  expect_true(
    colour_palettes[[1]]$variables == c("val")
  )

  expect_true(
    colour_palettes[[2]]$variables == c("val2")
  )

})



test_that("hexcolour validation", {

  expect_true(googleway:::isHexColour("#0") == FALSE)
  expect_true(googleway:::isHexColour("#00") == FALSE)
  expect_true(googleway:::isHexColour("#00000") == FALSE)
  expect_true(googleway:::isHexColour("#0000000") == FALSE)
  expect_true(googleway:::isHexColour("#000000000") == FALSE)

  expect_true(googleway:::isHexColour("#000") == TRUE)
  expect_true(googleway:::isHexColour("#0000") == TRUE)
  expect_true(googleway:::isHexColour("#000000") == TRUE)
  expect_true(googleway:::isHexColour("#00000000") == TRUE)

})


test_that("RGBA colours remove alpha", {

  expect_true(
    identical(
      googleway:::removeAlpha(c("#000000FF", "#FFFFFF00")),
      c("#000000", "#FFFFFF")
    )
  )

  ## alpha not removed
  expect_true(
    identical(
      googleway:::removeAlpha(c("#FFFFFF", "#000000")),
      c("#FFFFFF", "#000000")
    )
  )

})


test_that("generate palette works on all data types", {

  ## TODO:
  ## - floats
  ## - characters

  ## LOGICAL
  vals <- c(T, T, F, F)
  colours <- viridisLite::viridis(2)
  df <- googleway:::generatePalette(vals, viridisLite::viridis)

  expect_true(
    identical(
      df[, 'colour'],
      googleway:::removeAlpha(colours)
    )
  )

  ## INTEGER
  vals <- 1L:5L
  colours <- viridisLite::viridis(5)
  df <- googleway:::generatePalette(vals, viridisLite::viridis)

  expect_true(
    identical(
      df[, 'colour'],
      googleway:::removeAlpha(colours)
    )
  )

  ## NUMERIC
  vals <- 1.1:5.1
  colours <- viridisLite::viridis(5)
  df <- googleway:::generatePalette(vals, viridisLite::viridis)

  expect_true(
    identical(
      df[, 'colour'],
      googleway:::removeAlpha(colours)
    )
  )


  ## FACTORS
  vals <- as.factor(letters[1:5])
  colours <- viridisLite:::viridis(5)
  df <- googleway:::generatePalette(vals, viridisLite::viridis)

  expect_true(
    identical(
      df[, 'colour'],
      googleway:::removeAlpha(colours)
    )
  )

})

test_that("correct palette is determined", {

  pal <- list(fill_colour = viridisLite::inferno,
              stroke_colour = viridisLite::viridis)

  v <- googleway:::determinePalette(pal, 'fill_colour')

  expect_true(
    v(1) == "#000004FF"
  )

  v <- googleway:::determinePalette(pal, 'stroke_colour')

  expect_true(
    v(1) == "#440154FF"
  )



  # dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
  #                   val = letters[1:5],
  #                   val2 = letters[11:15],
  #                   stringsAsFactors = F)
  #
  # lstPalette <- list(
  #   stroke_colour = viridisLite::viridis,
  #   fill_colour = viridisLite::inferno
  # )
  #
  # allCols <- c("id", "val", "val2")
  # objArgs <- quote(add_polygons(id = "id", stroke_colour = "id", fill_colour = "id"))
  # shape <- googleway:::createMapObject(dat, allCols, objArgs)
  #
  # colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "id")
  #
  # pal <- googleway:::createPalettes(shape, colourColumns)
  #
  # unique(pal)
  #
  # lapply(unique(pal), function(x){
  #   list(
  #     variables = colourColumns[colourColumns == x],
  #     palette = googleway:::generatePalette(
  #       dat[, x],
  #       ## if one variable is mapped to two
  #       googleway:::determinePalette(lstPalette, names(colourColumns[colourColumns == x])[1])
  #       )
  #   )
  # })
  #
  # colour_palettes <- googleway:::createColourPalettes(dat, pal, colourColumns, lstPalette)
})


test_that("variables mapped to correct colour", {

  ## FACTORS
  vals <- as.factor(letters[c(5,3,1,2,4)])
  colours <- viridisLite:::viridis(5)

  df <- googleway:::generatePalette(vals, viridisLite::viridis)

  expect_true(
    ## element-wise matching of colours
    sum(df[, 'colour'] == googleway:::removeAlpha(colours)) == 5
  )

  ## NUMERIC
  vals <- c(5, 3, 1, 2, 4)
  colours <- viridisLite::viridis(5)

  df <- googleway:::generatePalette(vals, viridisLite::viridis)

  expect_true(
    ## element-wise matching of colours
    sum(df[, 'colour'] == googleway:::removeAlpha(colours)) == 0
  )

  expect_true(
    sum(df[ with(df, order(vals)) , 'colour'] == googleway:::removeAlpha(colours)) == 5
  )

})


test_that("data frame of colours is created",{

  df <- data.frame(variable = 1:5, colour = "#000000", stringsAsFactors = F)
  expect_true(
    identical(df, googleway:::constructPalette(1:5, "#000000"))
  )
})


