## TODO:
## re-define how the data is used inside each map layer function,
## so that colours can be merged on.
## i.e., don't rely on keeping the order of the data in the SetDefault function


add_circle2 <- function(map,
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

  ## TODO:
  ## parameter checks

  layer_id <- LayerId(layer_id)
  objArgs <- match.call(expand.dots = F)

  objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_circles")

  allCols <- c('id', 'lat', 'lng', 'radius', 'draggable', 'stroke_colour',
               'stroke_opacity', 'stroke_weight', 'fill_colour', 'fill_opacity',
               'mouse_over', 'mouse_over_group', 'info_window')

  requiredCols <- c("stroke_colour", "stroke_weight", "stroke_opacity", "radius",
                    "fill_opacity", "fill_colour", "z_index")


  shape <- createMapObject(data, allCols, objArgs)

  ## for the colour columns, if they exist in the 'shape':
  ## -- if they are a hex colour, do nothing
  ## -- else, create a palette for that column
  ## --- if multiple colour columns share the same variable, only need one palette
  colourColumns <- c("stroke_colour" = stroke_colour,
                     "fill_colour" = fill_colour)

  palettes <- createPalettes(shape, colourColumns)
  colour_palettes <- createColourPalettes(data, palettes, colourColumns)
  colours <- createColours(shape, colour_palettes)

  if(length(colours) > 0){

    eachColour <- sapply(colours, `[`)[, 1]
    colourNames <- names(colours)
    shape[, c(unname(colourNames))] <- eachColour
  }

  requiredDefaults <- setdiff(requiredCols, names(shape))
  if(length(requiredDefaults) > 0){
    defaults <- circleDefaults(nrow(shape))

    shape <- cbind(shape, defaults[, requiredDefaults])
  }

  shape <- jsonlite::toJSON(shape, digits = digits)

  invoke_method(map, data, 'add_circles', shape, update_map_view, layer_id)
}



add_polygon2 <- function(map,
                         data = get_map_data(map),
                         polyline = NULL,
                         lat = NULL,
                         lon = NULL,
                         id = NULL,
                         pathId = NULL,
                         stroke_colour = NULL,
                         stroke_weight = NULL,
                         stroke_opacity = NULL,
                         fill_colour = NULL,
                         fill_opacity = NULL,
                         info_window = NULL,
                         mouse_over = NULL,
                         mouse_over_group = NULL,
                         draggable = NULL,
                         editable = NULL,
                         update_map_view = TRUE,
                         layer_id = NULL,
                         z_index = NULL,
                         digits = 4){

  ## TODO:
  ## - parameter checks
  ## - holes must be wound in the opposite direction

  layer_id <- LayerId(layer_id)
  objArgs <- match.call(expand.dots = F)

  # objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_circles")

  allCols <- c('polyline', 'id', 'lat', 'lng', 'pathId', 'draggable', 'editable', 'stroke_colour',
               'stroke_opacity', 'stroke_weight', 'fill_colour', 'fill_opacity',
               'mouse_over', 'mouse_over_group', 'info_window')

  requiredCols <- c("stroke_colour", "stroke_weight", "stroke_opacity",
                    "fill_opacity", "fill_colour", "z_index")


  shape <- createMapObject(data, allCols, objArgs)

  ## for the colour columns, if they exist in the 'shape':
  ## -- if they are a hex colour, do nothing
  ## -- else, create a palette for that column
  ## --- if multiple colour columns share the same variable, only need one palette
  colourColumns <- c("stroke_colour" = stroke_colour,
                     "fill_colour" = fill_colour)

  palettes <- createPalettes(shape, colourColumns)
  colour_palettes <- createColourPalettes(data, palettes, colourColumns)
  colours <- createColours(shape, colour_palettes)

  if(length(colours) > 0){

    eachColour <- sapply(colours, `[`)[, 1]
    colourNames <- names(colours)
    shape[, c(unname(colourNames))] <- eachColour
  }

  requiredDefaults <- setdiff(requiredCols, names(shape))
  if(length(requiredDefaults) > 0){
    defaults <- polygonDefaults(nrow(shape))

    shape <- cbind(shape, defaults[, requiredDefaults])
  }

  f <- paste0(polyline, " ~ " , paste0(setdiff(names(shape), polyline), collapse = "+") )
  shape <- stats::aggregate(stats::formula(f), data = shape, list)

  shape <- jsonlite::toJSON(shape, digits = digits)

  usePolyline <- TRUE

  invoke_method(map, data, 'add_polygons', shape, update_map_view, layer_id, usePolyline)
}



createColours <- function(shape, colour_palettes){

  lst <- lapply(colour_palettes, function(x){
    pal <- x[['palette']]
    vars <- x[['variables']]

    l <- lapply(attr(vars, 'names'), function(y) {
      pal[['colour']][ match(shape[[y]], pal[['variable']]) ]
    })
    unlist(l)
  })
}

createColourPalettes <- function(data, palettes, colourColumns){

  lapply(palettes, function(x){
    list(
      variables = colourColumns[colourColumns == x],
      palette = generatePalette(data[, x])
    )
  })

}

createPalettes <- function(shape, colourColumns){

  palettes <- unique(colourColumns)
  v <- vapply(names(colourColumns), function(x) !googleway:::isHexColour(shape[, x]), 0L)
  palettes <- colourColumns[which(v == T)]

  return(palettes)
}

latLonCheck <- function(objArgs, lat, lon, names, layer_call){

  ## change lon to lng
  names(objArgs)[which(names(objArgs) == "lon")] <- "lng"

  if(is.null(lat)){
    lat <- find_lat_column(names(data), "add_circles", TRUE)
    objArgs[['lat']] <- lat
  }

  if(is.null(lon)){
    lon <- find_lon_column(names(data), "add_circles", TRUE)
    objArgs[['lng']] <- lon
  }
  return(objArgs)
}

circleDefaults <- function(n){
  data.frame("stroke_colour" = rep("#FF0000",n),
             "stroke_weight" = rep(1,n),
             "stroke_opacity" = rep(0.8,n),
             "radius" = rep(50,n),
             "fill_colour" = rep("#FF0000",n),
             "fill_opacity" = rep(0.35,n),
             "z_index" = rep(4,n),
             stringsAsFactors = FALSE)
}

polygonDefaults <- function(n){
  data.frame("stroke_colour" = rep("#0000FF",n),
             "stroke_weight" = rep(1,n),
             "stroke_opacity" = rep(0.6,n),
             "fill_colour" = rep("#FF0000",n),
             "fill_opacity" = rep(0.35,n),
             "z_index" = rep(1,n),
             stringsAsFactors = FALSE)
}

createMapObject <- function(data, cols, objArgs){

  dataNames <- names(data)

  argsIdx <- match(cols, names(objArgs)) ## those taht exist in 'cols'
  argsIdx <- argsIdx[!is.na(argsIdx)]

  argValues <- sapply(1:length(objArgs), function(x) objArgs[[x]])

  dataArgs <- which(argValues %in% names(data)) ## those where there is a column of data

  additionalValues <- setdiff(argsIdx, dataArgs)

  dataCols <- vapply(dataArgs, function(x) objArgs[[x]], "")
  dataNames <- names(objArgs)[dataArgs]

  df <- setNames(data[, dataCols, drop = F], dataNames)

  if(length(additionalValues) > 0){

    extraCols <- lapply(additionalValues, function(x){
      setNames(as.data.frame(rep(objArgs[[x]], nrow(df)), stringsAsFactors = F), names(objArgs)[x])
    })

    df <- cbind(df, do.call(cbind, extraCols))
  }
  return(df)
}


generatePalette <- function(colData) UseMethod("generatePalette")

#' @export
generatePalette.numeric <- function(colData){

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
  colours <- viridisLite::viridis(length(scaledVals))[f]

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
    data.frame(colName = lvls, colour = removeAlpha(colours), stringsAsFactors = F),
    c("variable", "colour")
  )
}
