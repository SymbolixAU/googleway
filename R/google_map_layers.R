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



