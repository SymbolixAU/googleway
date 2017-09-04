
#' @describeIn access_result the coordinates from a geocode query
#' @export
geocode_coordinates <- function(res) .access_result(resultType(res), "coordinates")

#' @describeIn access_result the formatted address from a geocode query
#' @export
geocode_address <- function(res) .access_result(resultType(res), "address")
