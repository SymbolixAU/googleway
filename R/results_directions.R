
#' @describeIn access_result the instructions from a directions query
#' @export
direction_instructions <- function(res) .access_result(resultType(res), "instructions")

#' @describeIn access_result the routes from a directions query
#' @export
direction_routes <- function(res) .access_result(resultType(res), "routes")

#' @describeIn access_result the legs from a directions query
#' @export
direction_legs <- function(res) .access_result(resultType(res), "legs")

#' @describeIn access_result the steps from a directions query
#' @export
direction_steps <- function(res) .access_result(resultType(res), "steps")

#' @describeIn access_result the points from a directions query
#' @export
direction_points <- function(res) .access_result(resultType(res), "points")

#' @describeIn access_result the encoded polyline from a direction query
#' @export
direction_polyline <- function(res) .access_result(resultType(res), "polyline")
