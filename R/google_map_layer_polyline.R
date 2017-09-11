

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

  if(is.null(id)){
    id <- 'id'
    objArgs[['id']] <- id

    if(usePolyline){
      data[, id] <- 1:nrow(data)
    }else{
      data[, id] <- 1
    }
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

    ids <- unique(shape[, id])
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
