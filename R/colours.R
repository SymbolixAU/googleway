

# Setup Colours
#
# Helper-function that calls createPalettes and createColourPalettes, and
# returns the list of colour palettes from \link{createColours}
#
# @param data data object passed into the map layer function
# @param shape object created from the data for the map layer
# @param colourColumns The columns of shape that are specified as a colour column
# @param palette palette function
setupColours <- function(data, shape, colourColumns, palette){

  palettes = createPalettes(shape, colourColumns)
  colour_palettes = createColourPalettes(data, palettes, colourColumns, palette)

  return(createColours(shape, colour_palettes))
}

# Create Palettes
#
# Creates palette names from variables in the data
#
# @param shape map object being plotted
# @param colourColumns The columns of shape that are specified as a colour column
createPalettes <- function(shape, colourColumns){

  palettes <- unique(colourColumns)
  v <- vapply(names(colourColumns), function(x) !isHexColour(shape[, x]), 0L)
  palettes <- colourColumns[which(v == T)]

  return(palettes)
}

# Create Colour Palettes
#
# Creates colour palettes for each variable
#
# @param data The data passed into the map layer function
# @param palettes the named colour palettes from createPalettes()
# @param colourColumns the columns of data containing the colours
# @param palette palette function
createColourPalettes <- function(data, palettes, colourColumns, palette){

  lapply(unique(palettes), function(x){
    list(
      variables = colourColumns[colourColumns == x],
      palette = generatePalette(
        data[[x]],
        determinePalette(palette, names(colourColumns[colourColumns == x])[1])  ## in case the same variable is mapped to two aesthetics
        )
    )
  })
}


# Create Colours
#
# creates columns of colours to map (replace) onto the shape object
#
# @param shape map shape object
# @param colour_palettes lsit of colour palettes
createColours <- function(shape, colour_palettes){

  lst <- lapply(colour_palettes, function(x){
    pal <- x[['palette']]
    vars <- x[['variables']]

    s <- sapply(attr(vars, 'names'), function(y) {
      pal[['colour']][ match(shape[[y]], pal[['variable']])]
    })
    if(length(s) == 1) s <- t(s)
    s
  })
  lst
}

determinePalette <- function(pal, aesthetic) UseMethod("determinePalette")

#' @export
determinePalette.function <- function(pal, aesthetic) pal

#' @export
determinePalette.list <- function(pal, aesthetic) pal[[aesthetic]]


# Generate Palette
#
# Generates a palette of colours from the data
#
# @param colData column/vector of data
# @param pal function palette
generatePalette <- function(colData, pal) UseMethod("generatePalette")

#' @export
generatePalette.numeric <- function(colData, pal){

  ## TODO:
  ## numeric values need to be scaled between 0 & 1 so that negatives
  ## are removed. Ensure the ordering is maintained when returned
  ## back onto the data
  ##
  ## also, handle floating point errors by using factors?

  vals <- unique(colData)
  scaledVals <- scales::rescale(vals)
  rng = range(scaledVals)
  s <- seq(rng[1], rng[2], length.out = length(scaledVals) + 1)
  f <- findInterval(scaledVals, s, all.inside = T)

  colours <- do.call(pal, list(length(scaledVals)))[f]

  constructPalette(vals, colours)
}

#' @export
generatePalette.factor <- function(colData, pal){
  facLvls <- levels(colData)
  colours <- do.call(pal, list(nlevels(colData)))
  constructPalette(facLvls, colours)
}

#' @export
generatePalette.default <- function(colData, pal) genericPalette(colData, pal)


genericPalette <- function(colData, pal){
  logLvls <- unique(colData)
  colours <- do.call(pal, list(length(logLvls)))
  constructPalette(logLvls, colours)
}

# Construct Palette
#
# Constructs a data.frame mapping a column of variables to a hex colour
#
# @param lvls data variables
# @param colours hex colours
constructPalette <- function(lvls, colours){
  stats::setNames(
    data.frame(colName = lvls, colour = removeAlpha(colours), stringsAsFactors = F),
    c("variable", "colour")
  )
}

