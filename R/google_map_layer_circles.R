
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
