#'  Geocode Coordinates
#'
#' @param res The result of a \code{google_geocode} query
#'
#' @export
geocode_coordinates <- function(res) coordinates(resultType(res))

coordinates <- function(res) UseMethod("coordinates")

#' @export
coordinates.character <- function(js) jqr::jq(js, ".results[].geometry.location")

#' @export
coordinates.list <- function(lst) lst[['results']][['geometry']][['location']]

coordinates.default <- function(res) stopMessage(res)

