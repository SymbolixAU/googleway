
#' @describeIn access_result the origin addresses from a distance query
#' @export
distance_origins <- function(res) .access_result(resultType(res), "dist_origins")

#' @describeIn access_result the destination addresses from a distance query
#' @export
distance_destinations <- function(res) .access_result(resultType(res), "dist_destinations")

#' @describeIn access_result the element results from a distance query
#' @export
distance_elements <- function(res) .access_result(resultType(res), "dist_elements")
