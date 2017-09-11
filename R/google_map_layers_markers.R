add_markers2 <- function(map,
                        data = get_map_data(map),
                        id = NULL,
                        colour = NULL,
                        lat = NULL,
                        lon = NULL,
                        title = NULL,
                        draggable = NULL,
                        opacity = NULL,
                        label = NULL,
                        info_window = NULL,
                        mouse_over = NULL,
                        mouse_over_group = NULL,
                        marker_icon = NULL,
                        layer_id = NULL,
                        cluster = FALSE,
                        update_map_view = TRUE,
                        digits = 4){


  ## TODO:
  ## - parameter checks

  layer_id <- LayerId(layer_id)
  objArgs <- match.call(expand.dots = F)

  objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_markers")

  if(!is.null(colour) & !is.null(marker_icon))
    stop("only one of colour or icon can be used")

  ## 'fix' icon url
  if(!is.null(marker_icon)){
    objArgs[['url']] <- marker_icon
    objArgs[['marker_icon']] <- NULL
  }

  allCols <- markerColumns()
  requiredCols <- requiredMarkerColumns()

  shape <- createMapObject(data, allCols, objArgs)

  requiredDefaults <- setdiff(requiredCols, names(shape))

  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "marker")
  }

  if(!is.null(colour)){
    shape <- merge(shape, df_markerColours(), by.x = "colour", by.y = "colour", all.x = TRUE)
  }

  shape <- jsonlite::toJSON(shape, digits = digits)

  print(" -- invoking markers -- ")
  invoke_method(map, data, 'add_markers', shape, cluster, update_map_view, layer_id)
}
