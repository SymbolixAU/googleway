
#' @describeIn access_result the coordinates from a geocode query
#' @export
geocode_coordinates <- function(res) .access_result(resultType(res), "coordinates")

#' @describeIn access_result the formatted address from a geocode query
#' @export
geocode_address <- function(res) .access_result(resultType(res), "address")

#' @describeIn access_result the address components from a geocode query
#' @export
geocode_address_components <- function(res) .access_result(resultType(res), "address_components")

#' @describeIn access_result the place id from a geocode query
#' @export
geocode_place <- function(res) .access_result(resultType(res), "geoe_place_id")
