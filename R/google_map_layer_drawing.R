#' Add Drawing
#'
#' Adds drawing tools to the map. Particularly useful when in an interactive (shiny) environment.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param drawing_modes string vector giving the drawing controls required.
#' One of one or more of marker, circle, polygon, polyline and rectangle
#' @param delete_on_change logical indicating if the currently drawn shapes
#' should be deleted when a new drawing mode is selected
#'
#' @examples
#' \dontrun{
#'
#' google_map(key = "your_api_key") %>%
#'   add_drawing()
#'
#' }
#' @export
add_drawing <- function(map,
                        drawing_modes = c('marker', 'circle', 'polygon', 'polyline', 'rectangle'),
                        delete_on_change = FALSE){

  logicalCheck(delete_on_change)

  drawing_modes <- jsonlite::toJSON(drawing_modes)

  ## set defaults:
  marker <- jsonlite::toJSON(markerDefaults())
  circle <- jsonlite::toJSON(circleDefaults())
  rectangle <- jsonlite::toJSON(rectangleDefaults())
  polyline <- jsonlite::toJSON(polylineDefaults())
  polygon <- jsonlite::toJSON(polygonDefaults())

  invoke_method(map,  'add_drawing', drawing_modes,
                marker, circle, rectangle, polyline, polygon, delete_on_change)
}

#' @rdname clear
#' @export
clear_drawing <- function(map){
  invoke_method(map, 'clear_drawing')
}

#' Remove drawing
#'
#' Removes the drawing controls from a map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @describeIn clear
#' @export
remove_drawing <- function(map){
  invoke_method(map, 'remove_drawing')
}

