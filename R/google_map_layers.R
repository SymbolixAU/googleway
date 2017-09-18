#' Add Traffic
#'
#' Adds live traffic information to a googleway map object
#'
#' @param map a googleway map object created from \code{google_map()}
#' @examples
#' \dontrun{
#'
#' google_map(key = "your_api_key") %>%
#'   add_traffic()
#'
#' }
#' @export
add_traffic <- function(map){
  invoke_method(map, 'add_traffic')
}


#' @rdname clear
#' @export
clear_traffic <- function(map){
  invoke_method(map, 'clear_traffic')
}

#' Add transit
#'
#' Adds public transport information to a googleway map object
#'
#' @param map a googleway map object created from \code{google_map()}
#' @examples
#' \dontrun{
#'
#' google_map(key = "your_api_key") %>%
#'   add_transit()
#'
#' }
#' @export
add_transit <- function(map){
  invoke_method(map, 'add_transit')
}

#' @rdname clear
#' @export
clear_transit <- function(map){
  invoke_method(map, 'clear_transit')
}


#' Add bicycling
#'
#' Adds bicycle route information to a googleway map object
#'
#' @param map a googleway map object created from \code{google_map()}
#' @examples
#' \dontrun{
#'
#' google_map(key = "your_api_key") %>%
#'   add_bicycling()
#'
#' }
#' @export
add_bicycling <- function(map){
  invoke_method(map, 'add_bicycling')
}

#' @rdname clear
#' @export
clear_bicycling <- function(map){
  invoke_method(map, 'clear_bicycling')
}


#' Update polylines
#'
#' Updates specific attributes of polylines. Designed to be
#' used in a shiny application.
#'
#' @note Any polylines (as specified by the \code{id} argument) that do not exist
#' in the \code{data} passed into \code{add_polylines()} will not be added to the
#' map. This function will only update the polylines that currently exist on
#' the map when the function is called.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data.frame containing the new values for the polylines
#' @param id string representing the column of \code{data} containing the id
#' values for the polylines The id values must be present in the data supplied
#' to \code{add_polylines} in order for the polylines to be udpated
#' @param stroke_colour either a string specifying the column of \code{data}
#' containing the stroke colour of each polyline, or a valid hexadecimal numeric
#' HTML style to be applied to all the polylines
#' @param stroke_opacity either a string specifying the column of \code{data}
#' containing the stroke opacity of each polyline, or a value between 0 and 1
#' that will be applied to all the polyline
#' @param stroke_weight either a string specifying the column of \code{data}
#' containing the stroke weight of each polyline, or a number indicating the width
#' of pixels in the line to be applied to all the polyline
#' @param layer_id single value specifying an id for the layer.
#' @param palette a function that generates hex RGB colours given a single number as an input.
#' Used when a variable of \code{data} is specified as a colour
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' ## coordinate columns
#' ## plot polylines using default attributes
#' df <- tram_route
#' df$id <- c(rep(1, 27), rep(2, 28))
#'
#' df$colour <- c(rep("#00FFFF", 27), rep("#FF00FF", 28))
#'
#' google_map(key = map_key) %>%
#'   add_polylines(data = df, lat = 'shape_pt_lat', lon = 'shape_pt_lon',
#'                 stroke_colour = "colour", id = 'id')
#'
#' ## specify width and colour attributes to update
#' df_update <- data.frame(id = c(1,2),
#'                         width = c(3,10),
#'                         colour = c("#00FF00", "#DCAB00"))
#'
#' google_map(key = map_key) %>%
#'   add_polylines(data = df, lat = 'shape_pt_lat', lon = 'shape_pt_lon',
#'                 stroke_colour = "colour", id = 'id') %>%
#'   update_polylines(data = df_update, id = 'id', stroke_weight = "width",
#'                    stroke_colour = 'colour')
#'
#'
#' ## encoded polylines
#' pl <- sapply(unique(df$id), function(x){
#'   encode_pl(lat = df[ df$id == x , 'shape_pt_lat'], lon = df[ df$id == x, 'shape_pt_lon'])
#' })
#'
#' df <- data.frame(id = c(1, 2), polyline = pl)
#'
#' google_map(key = map_key) %>%
#'   add_polylines(data = df, polyline = 'polyline')
#'
#' google_map(key = map_key) %>%
#'   add_polylines(data = df, polyline = 'polyline') %>%
#'   update_polylines(data = df_update, id = 'id', stroke_weight = "width",
#'                    stroke_colour = 'colour')
#'
#' }
#'
#' @export
update_polylines <- function(map, data, id,
                             stroke_colour = NULL,
                             stroke_weight = NULL,
                             stroke_opacity = NULL,
                             layer_id = NULL,
                             palette = NULL){

  ## TODO: is 'info_window' required, if it was included in the original add_polygons?

  objArgs <- match.call(expand.dots = F)
  dataCheck(data)
  layer_id <- layerId(layer_id)
  
  ## we can only update shapes that already exist with new attributes
  allCols <- polylineUpdateColumns()
  requiredColumns <- requiredLineUpdateColumns()
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
  
  
  
  # polylineUpdate <- data[, id, drop = FALSE]
  # polylineUpdate[, "id"] <- as.character(data[, id])
  # polylineUpdate <- stats::setNames(polylineUpdate, 'id')
  # 
  # layer_id <- layerId(layer_id)
  # 
  # polylineUpdate[, "stroke_colour"] <- SetDefault(stroke_colour, "#0000FF", data)
  # polylineUpdate[, "stroke_weight"] <- SetDefault(stroke_weight, 1, data)
  # polylineUpdate[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.6, data)
  # 
  # polylineUpdate <- jsonlite::toJSON(polylineUpdate, auto_unbox = T)

  invoke_method(map, 'update_polylines', shape, layer_id)
}





#' Update polygons
#'
#' Updates specific colours and opacities of specified polygons. Designed to be
#' used in a shiny application.
#'
#' @note Any polygons (as specified by the \code{id} argument) that do not exist
#' in the \code{data} passed into \code{add_polygons()} will not be added to the map.
#' This function will only update the polygons that currently exist on the map
#' when the function is called.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data.frame containing the new values for the polygons
#' @param id string representing the column of \code{data} containing the id
#' values for the polygons. The id values must be present in the data supplied
#' to \code{add_polygons} in order for the polygons to be udpated
#' @param stroke_colour either a string specifying the column of \code{data}
#' containing the stroke colour of each polygon, or a valid hexadecimal numeric
#' HTML style to be applied to all the polygons
#' @param stroke_opacity either a string specifying the column of \code{data}
#' containing the stroke opacity of each polygon, or a value between 0 and 1 that
#' will be applied to all the polygons
#' @param stroke_weight either a string specifying the column of \code{data}
#' containing the stroke weight of each polygon, or a number indicating the width of
#' pixels in the line to be applied to all the polygons
#' @param fill_colour either a string specifying the column of \code{data}
#' containing the fill colour of each polygon, or a valid hexadecimal numeric
#' HTML style to be applied to all the polygons
#' @param fill_opacity either a string specifying the column of \code{data}
#' containing the fill opacity of each polygon, or a value between 0 and 1 that
#' will be applied to all the polygons
#' @param layer_id single value specifying an id for the layer.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' pl_outer <- encode_pl(lat = c(25.774, 18.466,32.321),
#'                       lon = c(-80.190, -66.118, -64.757))
#'
#' pl_inner <- encode_pl(lat = c(28.745, 29.570, 27.339),
#'                       lon = c(-70.579, -67.514, -66.668))
#'
#' pl_other <- encode_pl(c(21,23,22), c(-50, -49, -51))
#'
#' ## using encoded polylines
#' df <- data.frame(id = c(1,1,2),
#'                  colour = c("#00FF00", "#00FF00", "#FFFF00"),
#'                  polyline = c(pl_outer, pl_inner, pl_other),
#'                  stringsAsFactors = FALSE)
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', id = 'id', fill_colour = 'colour')
#'
#' df_update <- df[, c("id", "colour")]
#' df_update$colour <- c("#FFFFFF", "#FFFFFF", "000000")
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', id = 'id', fill_colour = 'colour') %>%
#'   update_polygons(data = df_update, id = 'id', fill_colour = 'colour')
#'
#'
#' df <- aggregate(polyline ~ id + colour, data = df, list)
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', fill_colour = 'colour')
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', id = 'id', fill_colour = 'colour') %>%
#'   update_polygons(data = df_update, id = 'id', fill_colour = 'colour')
#'
#'
#' ## using coordinates
#' df <- data.frame(id = c(rep(1, 6), rep(2, 3)),
#'                  lineId = c(rep(1, 3), rep(2, 3), rep(1, 3)),
#'                  lat = c(25.774, 18.466, 32.321, 28.745, 29.570, 27.339, 21, 23, 22),
#'                  lon = c(-80.190, -66.118, -64.757, -70.579, -67.514, -66.668, -50, -49, -51))
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, lat = 'lat', lon = 'lon', id = 'id', pathId = 'lineId')
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, lat = 'lat', lon = 'lon', id = 'id', pathId = 'lineId') %>%
#'   update_polygons(data = df_update, id = 'id', fill_colour = 'colour')
#'
#' }
#'
#' @export
update_polygons <- function(map, data, id,
                            stroke_colour = NULL,
                            stroke_weight = NULL,
                            stroke_opacity = NULL,
                            fill_colour = NULL,
                            fill_opacity = NULL,
                            layer_id = NULL
                            ){

  ## TODO: is 'info_window' required, if it was included in the original add_polygons?

  polygonUpdate <- data[, id, drop = FALSE]
  polygonUpdate[, id] <- as.character(polygonUpdate[, id])

  polygonUpdate <- stats::setNames(polygonUpdate, c('id'))

  layer_id <- layerId(layer_id)

  # polygonUpdate[, id] <- as.character(data[, id])

  polygonUpdate[, "stroke_colour"] <- SetDefault(stroke_colour, "#0000FF", data)
  polygonUpdate[, "stroke_weight"] <- SetDefault(stroke_weight, 1, data)
  polygonUpdate[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.6, data)
  polygonUpdate[, "fill_colour"] <- SetDefault(fill_colour, "#FF0000", data)
  polygonUpdate[, "fill_opacity"] <- SetDefault(fill_opacity, 0.35, data)
  # polygonUpdate[, "mouse_over_group"] <- SetDefault(mouse_over_group, "NA", data)

  polygonUpdate <- jsonlite::toJSON(polygonUpdate, auto_unbox = T)

  invoke_method(map, 'update_polygons', polygonUpdate, layer_id)

}



#' Add KML
#'
#' Adds a KML layer to a map.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param kml_url URL string specifying the location of the kml layer
#' @param layer_id single value specifying an id for the layer.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' kmlUrl <- paste0('https://developers.google.com/maps/',
#' 'documentation/javascript/examples/kml/westcampus.kml')
#'
#' google_map(key = map_key) %>%
#'   add_kml(kml_url = kmlUrl)
#'
#' }
#' @export
add_kml <- function(map, kml_url, layer_id = NULL){

  urlCheck(kml_url)

  layer_id <- layerId(layer_id)

  kml <- jsonlite::toJSON(data.frame(url = kml_url))

  invoke_method(map, 'add_kml', kml, layer_id)
}





#' Add Fusion
#'
#' Adds a fusion table layer to a map.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param query a \code{data.frame} of 2 or 3 columns, and only 1 row. Two columns
#' must be 'select' and 'from', and the third 'where'. The 'select' value is the column
#' name (from the fusion table) containing the location information, and the
#' 'from' value is the encrypted table Id. The 'where' value is a string specifying the
#' 'where' condition on the data query.
#' @param styles a \code{list} object used to apply colour, stroke weight and
#' opacity to lines and polygons. See examples to see how the list should be
#' constructed.
#' @param heatmap logical indicating whether to show a heatmap.
#' @param layer_id single value specifying an id for the layer.
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' qry <- data.frame(select = 'address',
#'     from = '1d7qpn60tAvG4LEg4jvClZbc1ggp8fIGGvpMGzA',
#'     where = 'ridership > 200')
#'
#' google_map(key = map_key, location = c(41.8, -87.7), zoom = 9) %>%
#'   add_fusion(query = qry)
#'
#' qry <- data.frame(select = 'geometry',
#'    from = '1ertEwm-1bMBhpEwHhtNYT47HQ9k2ki_6sRa-UQ')
#'
#' styles <- list(
#'   list(
#'     polygonOptions = list( fillColor = "#00FF00", fillOpacity = 0.3)
#'     ),
#'   list(
#'     where = "birds > 300",
#'     polygonOptions = list( fillColor = "#0000FF" )
#'     ),
#'   list(
#'     where = "population > 5",
#'     polygonOptions = list( fillOpacity = 1.0 )
#'  )
#' )
#'
#' google_map(key = map_key, location = c(-25.3, 133), zoom = 4) %>%
#'   add_fusion(query = qry, styles = styles)
#'
#' qry <- data.frame(select = 'location',
#'     from = '1xWyeuAhIFK_aED1ikkQEGmR8mINSCJO9Vq-BPQ')
#'
#' google_map(key = map_key, location = c(0, 0), zoom = 1) %>%
#'   add_fusion(query = qry, heatmap = T)
#'
#' }
#'
#' @export
add_fusion <- function(map, query, styles = NULL, heatmap = FALSE, layer_id = NULL){

  ## TODO:
  ## - check each 'value' is a single value
  ## - update bounds on layer
  ## - info window
  ## - allow JSON style

  ## The Google Maps API can't use values inside arrays, so we need
  ## to get rid of any arrays.
  ## - remove square brackets around value
  LogicalCheck(heatmap)

  query <- gsub("\\[|\\]", "", jsonlite::toJSON(query))

  style <- jsonlite::toJSON(styles)
  style <- gsub("\\[|\\]", "", substr(style, 2, (nchar(style) - 1)))
  style <- paste0("[", style, "]")

  layer_id <- layerId(layer_id)

  invoke_method(map, 'add_fusion', query, style, heatmap, layer_id)
}

#' @rdname clear
#' @export
clear_fusion <- function(map, layer_id = NULL){

  layer_id <- layerId(layer_id)

  invoke_method(map, 'clear_fusion', layer_id)
}



