googleDrawingDependency <- function() {
  list(
    createHtmlDependency(
      name = "drawing",
      version = "1.0.0",
      src = system.file("htmlwidgets/lib/drawing", package = "googleway"),
      script = c("drawing.js"),
      all_files = FALSE
    )
  )
}

#' Add Drawing
#'
#' Adds drawing tools to the map. Particularly useful when in an interactive (shiny) environment.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param drawing_modes string vector giving the drawing controls required.
#' One of one or more of marker, circle, polygon, polyline and rectangle
#' @param delete_on_change logical indicating if the currently drawn shapes
#' should be deleted when a new drawing mode is selected (only works in a reactive environment)
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#' google_map(key = map_key) %>%
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

  map <- addDependency(map, googleDrawingDependency())

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
#' @describeIn clear removes drawing controls from a map
#' @export
remove_drawing <- function(map){
  invoke_method(map, 'remove_drawing')
}

