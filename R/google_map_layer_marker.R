
googleMarkerDependency <- function() {
  list(
    createHtmlDependency(
      name = "markers",
      version = "1.0.0",
      src = system.file("htmlwidgets/lib/markers", package = "googleway"),
      script = c("markers.js", "markerclusterer.js"),
      all_files = FALSE
    )
  )
}

# googleMarkerClustererDependency <- function() {
#   list(
#     htmltools::htmlDependency(
#       "MarkerClusterer",
#       "1.0.0",
#       system.file("htmlwidgets/lib/map", package = "googleway"),
#       script = "markerclusterer.js"
#     )
#   )
# }


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
#' @param cluster_options list of options used in clustering. See details.
#' @param marker_icon string specifying the column of data containing a link/URL to
#' an image to use for a marker
#' @param close_info_window logical indicating if all \code{info_windows} should close
#' when the user clicks on the map
#'
#' @details
#'
#' Cluster Options can be supplied as a named list. The available names are
#'
#' \itemize{
#'   \item{gridSize (number) - The grid size of a cluster in pixels}
#'   \item{maxZoom (number) - The maximum zoom level that a marker can be part of a cluster}
#'   \item{zoomOnClick (logical) - Whether the default behaviour of clicking on a cluster is to
#'   zoom into it}
#'   \item{averageCenter (logical) - Whether the center of each cluster should be the
#'   average of all markers in the cluster}
#'   \item{minimumClusterSize (number) - The minimum number of markers required for a cluster}
#' }
#'
#' opts <- list(
#'   minimumClusterSize = 3
#' )
#'
#' @examples
#' \dontrun{
#'
#' map_key <- "your api key"
#'
#' google_map(
#'   key = map_key
#'   , data = tram_stops
#'   ) %>%
#'  add_markers(
#'    lat = "stop_lat"
#'    , lon = "stop_lon"
#'    , info_window = "stop_name"
#'    )
#'
#'
#' ## using marker icons
#' iconUrl <- paste0("https://developers.google.com/maps/documentation/",
#' "javascript/examples/full/images/beachflag.png")
#'
#' tram_stops$icon <- iconUrl
#'
#' google_map(
#'   key = map_key
#'   , data = tram_stops
#'   ) %>%
#'   add_markers(
#'     lat = "stop_lat"
#'     , lon = "stop_lon"
#'     , marker_icon = "icon"
#'   )
#'
#' ## Clustering
#' google_map(
#'   key = map_key
#'   , data = tram_stops
#'   ) %>%
#'  add_markers(
#'    lat = "stop_lat"
#'    , lon = "stop_lon"
#'    , info_window = "stop_name"
#'    , cluster = TRUE
#'    , cluster_options = list( minimumClusterSize = 5 )
#'    )
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
                        cluster_options = list(),
                        update_map_view = TRUE,
                        digits = 4,
                        load_interval = 0,
                        focus_layer = FALSE,
                        close_info_window = FALSE
                        ){

  #objArgs <- match.call(expand.dots = F)
  objArgs <- list()
  objArgs[["id"]] <- force( id )
  objArgs[["colour"]] <- force( colour )
  objArgs[["lat"]] <- force( lat )
  objArgs[["lon"]] <- force( lon )
  objArgs[["polyline"]] <- force( polyline )
  objArgs[["title"]] <- force( title )
  objArgs[["draggable"]] <- force( draggable )
  objArgs[["opacity"]] <- force( opacity )
  objArgs[["label"]] <- force( label )
  objArgs[["info_window"]] <- force( info_window )
  objArgs[["mouse_over"]] <- force( mouse_over )
  objArgs[["mouse_over_group"]] <- force( mouse_over_group )
  objArgs[["marker_icon"]] <- force( marker_icon )
  objArgs[["layer_id"]] <- force( layer_id )
  objArgs[["cluster"]] <- force( cluster )
  objArgs[["update_map_view"]] <- force( update_map_view )
  objArgs[["digits"]] <- force( digits )
  objArgs[["load_interval"]] <- force( load_interval )
  objArgs[["focus_layer"]] <- force( focus_layer )
  objArgs[["close_info_window"]] <- force( close_info_window )

  data <- normaliseSfData(data, "POINT")
  polyline <- findEncodedColumn(data, polyline)

  if( !is.null(polyline) && !polyline %in% names(objArgs) ) {
    objArgs[['polyline']] <- polyline
  }

  ## PARAMETER CHECKS
  if(!dataCheck(data, "add_marker")) data <- markerDefaults(1)
  layer_id <- layerId(layer_id)

  usePolyline <- isUsingPolyline(polyline)
  if ( !usePolyline ) {
    objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_markers")
  }

  infoWindowChart <- NULL
  if (!is.null(info_window) && isInfoWindowChart(info_window)) {
    infoWindowChart <- info_window
    objArgs[['info_window']] <- NULL
  }

  objArgs <- markerColourIconCheck(data, objArgs, colour, marker_icon)

  ## need to do an 'infoWindowCheck'
  ## to see if the user passed in a list, taht will be used as a chart...

  ## IDEAS:
  ## - pass the data separately to JS, and let the browser find
  ## the correct data to use in the info_window from the JSON, when the marker is clicked
  ##
  ## - within the JS code, inside the `google.maps.event.addListener()` for info windows
  ## write code taht extracts the correct info window content from an InfoWindowContent JSON object
  ## Which will mean passing this object in throgh R.
  ## I can test this directly by adding in some JSON to use as the pie chart
  ## and see if plotting it works.
  ##
  ## - before 'shape contstruction', check type of info_window content. If a list,
  ## - remove it from the objArgs, and only join it on just before invoking the
  ## - js method


  loadIntervalCheck(load_interval)
  logicalCheck(focus_layer)
  logicalCheck(cluster)
  logicalCheck(update_map_view)
  logicalCheck(close_info_window)
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

  shape <- createInfoWindowChart(shape, infoWindowChart, id)
  shape <- jsonlite::toJSON(shape, digits = digits)

  map <- addDependency(map, googleMarkerDependency())

  invoke_method(map, 'add_markers', shape, cluster, cluster_options, update_map_view, layer_id, usePolyline, load_interval, focus_layer, close_info_window)
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



