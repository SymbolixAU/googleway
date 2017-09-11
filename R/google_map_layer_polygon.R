

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
