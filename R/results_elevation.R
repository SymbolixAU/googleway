
#' @describeIn access_result the elevation from an elevation query
#' @export
elevation <- function(res) .access_result(resultType(res), "elevation")


#' @describeIn access_result the elevation from an elevation query
#' @export
elevation_location <- function(res) .access_result(resultType(res), "elev_location")

