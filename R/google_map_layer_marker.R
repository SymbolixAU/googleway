#' Add markers
#'
#' Add markers to a google map
#'
#' @inheritParams add_circles
#' @param colour string specifying the column containing the 'colour' to use for
#' the markers. One of 'red', 'blue', 'green' or 'lavender'.
#' @param title string specifying the column of \code{data} containing the 'title'
#' of the markers. The title is displayed when you hover over a marker. If blank,
#' no title will be displayed for the markers.
#' @param draggable string specifying the column of \code{data} defining if the
#' marker is 'draggable' (either TRUE or FALSE)
#' @param opacity string specifying the column of \code{data} defining the 'opacity'
#' of the maker. Values must be between 0 and 1 (inclusive).
#' @param label string specifying the column of \code{data} defining the character
#' to appear in the centre of the marker. Values will be coerced to strings, and
#' only the first character will be used.
#' @param cluster logical indicating if co-located markers should be clustered
#' when the map zoomed out
#' @param marker_icon string specifying the column of data containing a link/URL to
#' an image to use for a marker
#'
#' @examples
#' \dontrun{
#'
#' map_key <- "your api key"
#'
#' google_map(key = map_key, data = tram_stops) %>%
#'  add_markers(lat = "stop_lat", lon = "stop_lon", info_window = "stop_name")
#'
#'
#' ## using marker icons
#' iconUrl <- paste0("https://developers.google.com/maps/documentation/",
#' "javascript/examples/full/images/beachflag.png")
#'
#' tram_stops$icon <- iconUrl
#'
#' google_map(key = map_key, data = tram_stops) %>%
#'   add_markers(lat = "stop_lat", lon = "stop_lon", marker_icon = "icon")
#'
#' }
#' @export
add_markers <- function(map,
                        data = get_map_data(map),
                        id = NULL,
                        colour = NULL,
                        lat = NULL,
                        lon = NULL,
                        polyline = NULL,
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
                        digits = 4,
                        load_interval = 0){

  objArgs <- match.call(expand.dots = F)

  data <- normaliseSfData(data, "POINT")
  polyline <- findEncodedColumn(data, polyline)

  if( !is.null(polyline) && !polyline %in% names(objArgs) ) {
    objArgs[['polyline']] <- polyline
  }

  ## PARAMETER CHECKS
  if(!dataCheck(data, "add_marker")) data <- markerDefaults(1)
  layer_id <- layerId(layer_id)

  usePolyline <- isUsingPolyline(polyline)
  if( !usePolyline ) {
    objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_markers")
  }

  objArgs <- markerColourIconCheck(data, objArgs, colour, marker_icon)

  loadIntervalCheck(load_interval)
  logicalCheck(cluster)
  logicalCheck(update_map_view)
  numericCheck(digits)
  ## END PARAMETER CHECKS


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

  if( usePolyline ) {
    shape <- createPolylineListColumn(shape)
  }
  shape <- jsonlite::toJSON(shape, digits = digits)

  invoke_method(map, 'add_markers', shape, cluster, update_map_view, layer_id, usePolyline, load_interval)
}


#' clear map elements
#'
#' clears elements from a map
#'
#' @note These operations are intended for use in conjunction with
#' \link{google_map_update} in an interactive shiny environment
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param layer_id id value of the layer to be removed from the map
#'
#' @name clear
#' @export
clear_markers <- function(map, layer_id = NULL){
  layer_id <- layerId(layer_id)
  invoke_method(map, 'clear_markers', layer_id)
}



