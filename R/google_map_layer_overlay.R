googleOverlayDependency <- function() {
  list(
    htmltools::htmlDependency(
      "overlay",
      "1.0.0",
      system.file("htmlwidgets/lib/overlays", package = "googleway"),
      script = c("overlay.js")
    )
  )
}


#' Add Overlay
#'
#' Adds a ground overlay to a map. The overlay can only be added from a URL
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param north northern-most latitude coordinate
#' @param east eastern-most longitude
#' @param south southern-most latitude coordinate
#' @param west western-most longitude
#' @param overlay_url URL string specifying the location of the overlay layer
#' @param layer_id single value specifying an id for the layer.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' google_map(key = map_key) %>%
#'   add_overlay(north = 40.773941, south = 40.712216, east = -74.12544, west = -74.22655,
#'                overlay_url = "https://www.lib.utexas.edu/maps/historical/newark_nj_1922.jpg")
#'
#'
#' url <- paste0("https://developers.google.com/maps/documentation/javascript",
#'   "/examples/full/images/talkeetna.png")
#'
#' google_map(key = map_key) %>%
#'   add_overlay(north = 62.400471, south = 62.281819, east = -150.005608, west = -150.287132,
#'                overlay_url = url)
#'
#'
#' }
#' @export
add_overlay <- function(map,
                        north,
                        east,
                        south,
                        west,
                        overlay_url,
                        layer_id = NULL,
                        digits = 4){

  urlCheck(overlay_url)

  latitudeCheck(north, "north")
  latitudeCheck(south, "south")
  longitudeCheck(east, "east")
  longitudeCheck(west, "west")

  layer_id <- layerId(layer_id)

  overlay <- jsonlite::toJSON(data.frame(url = overlay_url,
                                         north = north,
                                         south = south,
                                         west = west,
                                         east = east),
                              digits = digits)

  map <- addDependency(map, googleOverlayDependency())

  invoke_method(map, 'add_overlay', overlay, layer_id)
}
