## TODO:
## re-define how the data is used inside each map layer function,
## so that colours can be merged on.
## i.e., don't rely on keeping the order of the data in the SetDefault function


add_shape <- function(map,
                      data = get_map_data(map),
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

  layer_id <- LayerId(layer_id)
  objArgs <- match.call(expand.dots = F)

  ## correct lon to lng
  names(objArgs)[which(names(objArgs) == "lon")] <- "lng"

  if(is.null(lat)){
    lat <- find_lat_column(names(data), "add_circles", TRUE)
    objArgs[['lat']] <- lat
  }

  if(is.null(lon)){
    lon <- find_lon_column(names(data), "add_circles", TRUE)
    objArgs[['lng']] <- lon
  }

  allCols <- c('id', 'lat', 'lng', 'radius', 'draggable', 'stroke_colour',
               'stroke_opacity', 'stroke_weight', 'fill_colour', 'fill_opacity',
               'mouse_over', 'mouse_over_group', 'info_window')

  requiredCols <- c("stroke_colour", "stroke_weight", "stroke_opacity", "radius",
                    "fill_opacity", "fill_colour", "z_index")

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

  colours <- lapply(colour_palettes, function(x){
    pal <- x[['palette']]
    vars <- x[['variables']]

    sapply(attr(vars, 'names'), function(y) {
      pal[['colour']][ match(shape[[y]], pal[['variable']]) ]
    })
  })

  if(length(colours) > 0){
    colourNames <- dimnames(colours[[1]])[[2]]
    shape[, c(colourNames)] <- colours[[1]][, colourNames]
  }

  requiredDefaults <- setdiff(requiredCols, names(shape))
  # print(requiredDefaults)
  shape$stroke_colour <- shape$fill_colour
  shape$stroke_weight <- 0
  shape$stroke_opacity <- 0.5
  shape$radius <- 100
  shape$fill_opacity <- 0.5
  shape$z_index <- 1

  shape <- jsonlite::toJSON(shape, digits = digits)

  invoke_method(map, data, 'add_circles', shape, update_map_view, layer_id)

  # return(shape)

}

createMapObject <- function(data, cols, objArgs){

  types <- sapply(objArgs, class)
  # print(which(types == "character"))
  argsIdx <- match(cols, names(objArgs))
  argsIdx <- intersect(which(types == "character"), argsIdx)

  # print(argsIdx[!is.na(argsIdx)])

  argNames <- names(objArgs)[argsIdx]
  argNames <- argNames[!is.na(argNames)]
  print(argNames)

  # dataCols <- vapply(argsIdx[!is.na(argsIdx)], function(x) objArgs[[x]], "")
  dataCols <- vapply(which(types == "character"), function(x) objArgs[[x]], "")
  return(setNames(data[, dataCols, drop = F], argNames))
}


generatePalette <- function(colData) UseMethod("generatePalette")


#' @export
generatePalette.numeric <- function(colData){

  vals <- unique(colData)
  rng = range(vals)
  s <- seq(rng[1], rng[2], length.out = length(vals) + 1)
  f <- findInterval(vals, s, all.inside = T)
  colours <- viridisLite::viridis(length(vals))[f]

  constructPalette(vals, colours)
}

#' @export
generatePalette.factor <- function(colData){

  facLvls <- levels(colData)
  palFunc <- viridisLite::viridis
  colours <- do.call(palFunc, list(nlevels(colData)))

  constructPalette(facLvls, colours)
}

#' @export
generatePalette.character <- function(colData ){

  charLvls <- unique(colData)
  palFunc <- viridisLite::viridis
  colours <- do.call(palFunc, list(length(charLvls)))

  constructPalette(charLvls, colours)
}

#' @export
generatePalette.default <- function(col) stop("I can't determine the colour for ", class(col), " columns.")


constructPalette <- function(lvls, colours){
  setNames(
    data.frame(colName = lvls, colour = colours, stringsAsFactors = F),
    c("variable", "colour")
  )
}
