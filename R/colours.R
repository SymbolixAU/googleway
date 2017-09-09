## TODO:
## re-define how the data is used inside each map layer function,
## so that colours can be merged on.
## i.e., don't rely on keeping the order of the data in the SetDefault function


add_shape <- function(data = get_map_data(map),
                        id = NULL,
                        lat = NULL,
                        lon = NULL,
                        radius = NULL,
                        draggable = NULL,
                        stroke_colour = NULL,
                        stroke_opacity = NULL,
                        stroke_weight = NULL,
                        fill_colour = NULL,
                        fill_opacity = NULL,
                        mouse_over = NULL,
                        mouse_over_group = NULL,
                        info_window = NULL,
                        layer_id = NULL,
                        update_map_view = TRUE,
                        z_index = NULL,
                        digits = 4){

  objArgs <- match.call(expand.dots = F)

  if(is.null(lat)){
    lat <- find_lat_column(names(data), "add_circles", TRUE)
    objArgs[['lat']] <- lat
  }

  if(is.null(lon)){
    lon <- find_lon_column(names(data), "add_circles", TRUE)
    objArgs[['lon']] <- lon
  }

  allCols <- c('id', 'lat', 'lon', 'radius', 'draggable', 'stroke_colour', 'stroke_opacity',
               'stroke_weight', 'fill_colour', 'fill_opacity', 'mouse_over', 'mouse_over_group',
               'info_window')

  colourAttributes <- c("stroke_colour", "fill_colour")

  shape <- createMapObject(data, allCols, objArgs)

  ## for the colour columns, if they exist in the 'shape':
  ## -- if they are a hex colour, do nothing
  ## -- else, create a palette for that column
  ## --- if multiple colour columns share the same variable, only need one palette
  colourColumns <- c("stroke_colour" = stroke_colour, "fill_colour" = fill_colour)
  opacityColumns <- c("stroke_opacity", "fill_opacity")
  weightColumns <- c("stroke_weight")

  palettes <- unique(colourColumns)
  palettes <- palettes[vapply(names(colourColumns), function(x) !isHexColour(shape[, x]), 0L)]

  colour_palettes <- lapply(palettes, function(x){
    list(
      variables = colourColumns[colourColumns == x],
      palette = generatePalette(data[, x])
    )
  })

  print("-- colour palettes --")
  print(colour_palettes)

  colours <- lapply(colour_palettes, function(x){
    pal <- x[['palette']]
    vars <- x[['variables']]

    sapply(attr(vars, 'names'), function(y) {
      pal[['colour']][ match(shape[[y]], pal[['variable']]) ]
    })
  })

  print("-- colours --")
  print(colours)

  if(length(colours) > 0){
    colourNames <- dimnames(colours[[1]])[[2]]
    shape[, c(colourNames)] <- colours[[1]][, colourNames]
  }

  return(shape)
}

createMapObject <- function(data, cols, objArgs){

  argsIdx <- match(cols, names(objArgs))
  argNames <- names(objArgs)[argsIdx]
  argNames <- argNames[!is.na(argNames)]
  dataCols <- vapply(argsIdx[!is.na(argsIdx)], function(x) objArgs[[x]], "")
  return(setNames(data[, dataCols, drop = F], argNames))

}


generatePalette <- function(colData) UseMethod("generatePalette")

#' @export
generatePalette.factor <- function(colData){

  facLvls <- levels(colData)
  palFunc <- viridisLite::viridis
  colours <- do.call(palFunc, list(nlevels(colData)))

  constructPaletteDiscrete(facLvls, colours)
}

#' @export
generatePalette.character <- function(colData ){

  charLvls <- unique(colData)
  palFunc <- viridisLite::viridis
  colours <- do.call(palFunc, list(length(charLvls)))

  constructPaletteDiscrete(charLvls, colours)
}

#' @export
generatePalette.default <- function(col) stop("I can't determine the colour for ", class(col), " columns.")


constructPaletteDiscrete <- function(lvls, colours){
  setNames(
    data.frame(colName = lvls, colour = colours, stringsAsFactors = F),
    c("variable", "colour")
  )
}


# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# df <- tram_stops
#
# df$group <- factor(sample(letters[1:5], size = nrow(df), replace = T))
#
# google_map(key = mapKey) %>%
#   add_circles(data = df, lat = "stop_lat", lon = "stop_lon",
#               fill_colour = "stop_name", stroke_weight = 0)
