
googleMarkerDependency <- function() {
  list(
    createHtmlDependency(
      name = "markers",
      version = "1.0.0",
      src = system.file("htmlwidgets/lib/markers", package = "googleway"),
      script = c("markers.js"),
      all_files = FALSE
    )
  #   , createHtmlDependency(
  #     name = "markerclusterer",
  #     version = "2.5.3",
  #     src = system.file("htmlwidgets/lib/markers", package = "googleway"),
  #     script = c("markerclusterer.js"),
  #     all_files = FALSE
  #   )
  )
}

googleMarkerClustererDependency <- function() {
  list(
    htmltools::htmlDependency(
      name = "markerClusterer",
      version = "2.5.3",
      system.file("htmlwidgets/lib/markers", package = "googleway"),
      script = "markerclusterer.js"
    )
  )
}


#' Add markers
#'
#' Add markers to a google map
#'
#' @inheritParams add_circles
#' @param colour string (hex string representation) specifying the column of containing the 'colour' to use for
#' the markers, or an single hex string to use for all the markers.
#' @param border_colour string (hex string representation) specifying the column of containing the'border colour'
#' to use for the markers. The colour should be specified as a hex string (e.g. "#FF0000"),
#' or an single hex string to use for all the markers.
#' @param glyph_colour string (hex string representation) specifying the column of containing the 'glyph colour'
#' (the center of the marker), or an single hex string to use for all the markers.
#' The colour should be specified as a hex string (e.g. "#FF0000")
#' @param scale number specifying the scale of the marker.
#' @param title string specifying the column of \code{data} containing the 'title'
#' of the markers. The title is displayed when you hover over a marker. If blank,
#' no title will be displayed for the markers.
#' @param draggable string specifying the column of \code{data} defining if the
#' marker is 'draggable' (either TRUE or FALSE)
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
#'   \item{minZoom (number - default 0) - The minimum zoom level at which clusters are generated.}
#'   \item{maxZoom (number - defualt 16) - The maximum zoom level at which clusters are generated.}
#'   \item{minPoints (number - default 2) - Minimum number of points to form a cluster.}
#'   \item{radius (number - default 40) - Cluster radius, in pixels.}
#'   \item{extent (number - default 512) - (Tiles) Tile extent. Radius is calculated relative to this value.}
#'   \item{nodeSize (number - defualt 64) - Size of the KD-tree leaf node. Affects performance.}
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
#'    , title = "stop_name"  ## shown when hovering
#'    , label = "stop_id"    ## shown in center of marker
#'    , info_window = "stop_name" ## shown when clicking on marker
#'    )
#'
#' ## Colouring markers
#' google_map(
#'   key = map_key
#'   , data = tram_stops
#'   ) %>%
#'  add_markers(
#'    lat = "stop_lat"
#'    , lon = "stop_lon"
#'    , title = "stop_name"       ## shown when hovering
#'    , label = "stop_id"         ## shown in center of marker
#'    , info_window = "stop_name" ## shown when clicking on marker
#'    , colour = "#0000FF"        ## Blue
#'    , glyph_colour = "#00FF00"  ## Green
#'    , border_colour = "#000000" ## Black
#'    )
#'
#' ## Scale markers
#' df <- tram_stops
#' df$scale <- sample(1:5, size = nrow(df), replace = TRUE)
#' google_map(
#'   key = map_key
#'   , data = df
#'   ) %>%
#'  add_markers(
#'    lat = "stop_lat"
#'    , lon = "stop_lon"
#'    , colour = "#0000FF"        ## Blue
#'    , glyph_colour = "#00FF00"  ## Green
#'    , border_colour = "#000000" ## Black
#'    , scale = "scale"
#'    )
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
#'    , cluster_options = list( minPoints = 2, radius = 100)
#'    )
#'
#' }
#' @export
add_markers <- function(map,
                        data = get_map_data(map),
                        id = NULL,
                        colour = NULL,
                        border_colour = NULL,
                        glyph_colour = NULL,
                        scale = 1.0,
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
  if(!is.null(opacity)) {
    warning("opacity argument is deprecated in 3.0.0. Specify the opacity using the alpha component of the hex string in the `colour` argument")
  }

  objArgs <- list()
  objArgs[["id"]] <- force( id )
  objArgs[["colour"]] <- force( colour )
  objArgs[["border_colour"]] <- force( border_colour )
  objArgs[["glyph_colour"]] <- force( glyph_colour )
  objArgs[["scale"]] <- force( scale )
  objArgs[["lat"]] <- force( lat )
  objArgs[["lon"]] <- force( lon )
  objArgs[["polyline"]] <- force( polyline )
  objArgs[["title"]] <- force( title )
  objArgs[["draggable"]] <- force( draggable )
  # objArgs[["opacity"]] <- force( opacity )
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

  # print(shape)

  # if(!is.null(colour)){
    # shape <- merge(shape, df_markerColours(), by.x = "colour", by.y = "colour", all.x = TRUE)
  # }

  if( usePolyline ) {
    shape <- createPolylineListColumn(shape)
  }

  shape <- createInfoWindowChart(shape, infoWindowChart, id)
  shape <- jsonlite::toJSON(shape, digits = digits)

  map <- addDependency(map, googleMarkerDependency())
  map <- addDependency(map, googleMarkerClustererDependency())

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



