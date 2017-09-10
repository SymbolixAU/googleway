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
                        digits = 4,
                        palette = NULL){

  ## TODO:
  ## parameter checks

  if(is.null(palette)){
    palette <- viridisLite::viridis
  }else{
    if(!is.function(palette)) stop("palette needs to be a function")
  }

  layer_id <- LayerId(layer_id)
  objArgs <- match.call(expand.dots = F)

  objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_circles")

  allCols <- circleColumns()
  requiredCols <- requiredShapeColumns()
  colourColumns <- shapeAttributes(fill_colour, stroke_colour)

  shape <- createMapObject(data, allCols, objArgs)

  # palettes <- createPalettes(shape, colourColumns)
  # colour_palettes <- createColourPalettes(data, palettes, colourColumns, palette)
  # colours <- createColours(shape, colour_palettes)
  colours <- setupColours(data, shape, colourColumns, palette)

  if(length(colours) > 0){
    shape <- replaceVariableColours(shape, colours)
  }

  requiredDefaults <- setdiff(requiredCols, names(shape))
  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "circle")
  }

  shape <- jsonlite::toJSON(shape, digits = digits)

  print(" -- invoking circles -- ")
  invoke_method(map, data, 'add_circles', shape, update_map_view, layer_id)
}


add_polyline2 <- function(map,
                          data = get_map_data(map),
                          polyline = NULL,
                          lat = NULL,
                          lon = NULL,
                          id = NULL,
                          geodesic = NULL,
                          stroke_colour = NULL,
                          stroke_weight = NULL,
                          stroke_opacity = NULL,
                          info_window = NULL,
                          mouse_over = NULL,
                          mouse_over_group = NULL,
                          update_map_view = TRUE,
                          layer_id = NULL,
                          z_index = NULL,
                          digits = 4,
                          palette = NULL){

  objArgs <- match.call(expand.dots = F)

  if(is.null(polyline) & (is.null(lat) | is.null(lon)))
    stop("please supply the either the column containing the polylines, or the lat/lon coordinate columns")

  if(!is.null(polyline) & (!is.null(lat) | !is.null(lon)))
    stop("please use either a polyline colulmn, or lat/lon coordinate columns, not both")

  if(!inherits(data, "data.frame"))
    stop("Currently only data.frames are supported")

  if(is.null(palette)){
    palette <- viridisLite::viridis
  }else{
    if(!is.function(palette)) stop("palette needs to be a function")
  }

  if(!is.null(polyline)){
    usePolyline <- TRUE
  }else{
    usePolyline <- FALSE
    objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_polygons")
  }

  layer_id <- LayerId(layer_id)

  allCols <- polylineColumns()
  requiredCols <- requiredLineColumns()
  colourColumns <- lineAttributes(stroke_colour)

  shape <- createMapObject(data, allCols, objArgs)
  colours <- setupColours(data, shape, colourColumns, palette)

  if(length(colours) > 0){
    shape <- replaceVariableColours(shape, colours)
  }

  requiredDefaults <- setdiff(requiredCols, names(shape))

  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "polyline")
  }

  if(!usePolyline){

    ## using coordinates
    ids <- unique(shape[, 'id'])
    n <- names(shape)[names(shape) %in% objectColumns("polylineCoords")]
    keep <- setdiff(n, c('id', 'lat', 'lng'))

    lst_polyline <- objPolylineCoords(shape, ids, keep)

    shape <- jsonlite::toJSON(lst_polyline, digits = digits, auto_unbox = T)

  }else{

    n <- names(shape)[names(shape) %in% objectColumns("polylinePolyline")]
    shape <- shape[, n, drop = FALSE]

    shape <- jsonlite::toJSON(shape, auto_unbox = T)
  }

  print(" -- invoking polylines -- ")
  invoke_method(map, data, 'add_polylines', shape, update_map_view, layer_id, usePolyline)
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
                         digits = 4,
                         palette = NULL){

  ## TODO:
  ## - parameter checks
  ## - holes must be wound in the opposite direction

  ## palette argument:
  ## a function that can generate a sequence of RGB HEX colours.
  ## viridisLite::viridis is default
  ##
  ## if different palettes are required for different variables...
  ## do something...

  objArgs <- match.call(expand.dots = F)

  if(is.null(polyline) & (is.null(lat) | is.null(lon)))
    stop("please supply the either the column containing the polylines, or the lat/lon coordinate columns")

  if(!is.null(polyline) & (!is.null(lat) | !is.null(lon)))
    stop("please use either a polyline colulmn, or lat/lon coordinate columns, not both")

  if(!inherits(data, "data.frame"))
    stop("Currently only data.frames are supported")

  if(is.null(palette)){
    palette <- viridisLite::viridis
  }else{
    if(!is.function(palette)) stop("palette needs to be a function")
  }

  if(!is.null(polyline)){
    usePolyline <- TRUE
  }else{
    usePolyline <- FALSE
    objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_polygons")
  }

  layer_id <- LayerId(layer_id)

  allCols <- polygonColumns()
  requiredCols <- requiredShapeColumns()
  colourColumns <- shapeAttributes(fill_colour, stroke_colour)

  shape <- createMapObject(data, allCols, objArgs)
  colours <- setupColours(data, shape, colourColumns, palette)

  if(length(colours) > 0){
    shape <- replaceVariableColours(shape, colours)
  }

  requiredDefaults <- setdiff(requiredCols, names(shape))

  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "polygon")
  }

  ## TODO:
  ## list columns
  ## lat-lon values
  ## (same os add_polygons)

  if(usePolyline){

    if(!is.list(shape[, polyline])){
      f <- paste0(polyline, " ~ " , paste0(setdiff(names(shape), polyline), collapse = "+") )
      shape <- stats::aggregate(stats::formula(f), data = shape, list)
    }

    shape <- jsonlite::toJSON(shape, digits = digits)

  }else{

    ids <- unique(shape[, 'id'])
    n <- names(shape)[names(shape) %in% objectColumns("polygonCoords")]
    keep <- setdiff(n, c("id", "pathId", "lat", "lng"))

    lst_polygon <- objPolygonCoords(shape, ids, keep)

    shape <- jsonlite::toJSON(lst_polygon, digits = digits, auto_unbox = T)
  }

  print(" -- invoking polygons -- ")
  invoke_method(map, data, 'add_polygons', shape, update_map_view, layer_id, usePolyline)
}


setupColours <- function(data, shape, colourColumns, palette){

  palettes = createPalettes(shape, colourColumns)
  colour_palettes = createColourPalettes(data, palettes, colourColumns, palette)

  return(createColours(shape, colour_palettes))
}


replaceVariableColours <- function(shape, colours){

  eachColour <- sapply(colours, `[`)
  colourNames <- sapply(colours, names)
  shape[, c(unname(colourNames))] <- eachColour
  return(shape)

}

addDefaults <- function(shape, requiredDefaults, shapeType){

  n <- nrow(shape)
  defaults <- switch(shapeType,
                     "circle" = circleDefaults(n),
                     "polygon" = polygonDefaults(n),
                     "polyline" = polylineDefaults(n))

  #  defaults <- polygonDefaults(nrow(shape))
  shape <- cbind(shape, defaults[, requiredDefaults])
}

lineAttributes <- function(stroke_colour){
  c("stroke_colour" = stroke_colour)
}

shapeAttributes <- function(fill_colour, stroke_colour){
  c("stroke_colour" = stroke_colour,
    "fill_colour" = fill_colour)
}

requiredLineColumns <- function(){
  c("geodesic","stroke_colour","stroke_weight","stroke_opacity","z_index")
}

requiredShapeColumns <- function(){
  c("stroke_colour", "stroke_weight", "stroke_opacity",
    "fill_opacity", "fill_colour", "z_index")
}

polylineColumns <- function(){
  c('polyline', 'id', 'lat', 'lng', 'stroke_colour', 'stroke_opacity',
    'stroke_weight', 'mouse_over', 'mouse_over_group', 'info_window')
}

polygonColumns <- function(){
  c('polyline', 'id', 'lat', 'lng', 'pathId', 'draggable', 'editable', 'stroke_colour',
    'stroke_opacity', 'stroke_weight', 'fill_colour', 'fill_opacity',
    'mouse_over', 'mouse_over_group', 'info_window')
}

circleColumns <- function(){
  c('id', 'lat', 'lng', 'radius', 'draggable', 'stroke_colour',
    'stroke_opacity', 'stroke_weight', 'fill_colour', 'fill_opacity',
    'mouse_over', 'mouse_over_group', 'info_window')
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

polylineDefaults <- function(n){
  data.frame(
    "geodesic" = rep(TRUE, n),
    "stroke_colour" = rep("#0000FF", n),
    "stroke_weight" = rep(2, n),
    "stroke_opacity" = rep(0.6, n),
    "z_index" = rep(3, n)
  )
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
