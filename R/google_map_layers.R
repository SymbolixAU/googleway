#' Add Traffic
#'
#' Adds live traffic information to a googleway map object
#'
#' @param map a googleway map object created from \code{google_map()}
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#' google_map(key = map_key) %>%
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
#' map_key <- 'your_api_key'
#' google_map(key = map_key) %>%
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
#' map_key <- "your_api_key"
#' google_map(key = map_key) %>%
#'   add_bicycling()
#'
#' }
#' @export
add_bicycling <- function(map) {
  invoke_method(map, 'add_bicycling')
}

#' @rdname clear
#' @export
clear_bicycling <- function(map) {
  invoke_method(map, 'clear_bicycling')
}



#' Clear bounds
#'
#' A helper function to clear the javascript array of lat/lon bounds.
#'
#' @param map a googleway map object created from \code{google_map()}
#'
#' @export
clear_bounds <- function(map) {
  invoke_method(map, 'clear_bounds')
}
