#' Add markers
#'
#' Add markers to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude
#' coordinates, and the other specifying the longitude. If Null, the data passed
#' into \code{google_map()} will be used.
#' @param id string specifying the column containing an identifier for a marker
#' @param colour string specifying the column containing the 'colour' to use for
#' the markers. One of 'red', 'blue', 'green' or 'lavender'.
#' @param lat string specifying the column of \code{data} containing the 'latitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude'
#' coordinates. If left NULL, a best-guess will be made
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
#' @param info_window string specifying the column of data to display in an info
#' window when a marker is clicked
#' @param mouse_over string specifying the column of data to display when the
#' mouse rolls over the marker
#' @param mouse_over_group string specifying the column of data specifying which
#' groups of markers to highlight on mouseover
#' @param marker_icon string specifying the column of data containing a link/URL to
#' an image to use for a marker
#' @param layer_id single value specifying an id for the layer.
#' @param update_map_view logical specifying if the map should re-centre according
#' to the markers
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
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

  objArgs <- match.call(expand.dots = F)

  ## PARAMETER CHECKS
  if(!dataCheck(data, "add_marker")) data <- markerDefaults(1)
  layer_id <- layerId(layer_id)

  objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_markers")
  objArgs <- markerColourIconCheck(data, objArgs, colour, marker_icon)

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

  shape <- jsonlite::toJSON(shape, digits = digits)

  invoke_method(map, 'add_markers', shape, cluster, update_map_view, layer_id)
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



