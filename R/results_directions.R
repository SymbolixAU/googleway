#' Direction Instructions
#'
#' @param res The result of a \code{google_directions} query
#'
#' @export
direction_instructions <- function(res) instructions(resultType(res))

instructions <- function(res) UseMethod("instructions")

#' @export
instructions.character <- function(js) jqr::jq(js, ".routes[].legs[].steps[].html_instructions")

#' @export
instructions.list <- function(lst) lst[['routes']][['legs']][[1]][['steps']][[1]][['html_instructions']]

#' @export
instructions.default <- function(js) stopMessage(js)

#' Direction Routes
#'
#' @param res The result of a \code{google_directions} query
#'
#' @export
direction_routes <- function(res) routes(resultType(res))

routes <- function(js) UseMethod("routes")

#' @export
routes.character <- function(js) jqr::jq(js, ".routes[]")

#' @export
routes.list <- function(lst) lst[['routes']]

#' @export
routes.default <- function(js) stopMessage(js)

#' Direction Legs
#'
#' @param res The result of a \code{google_directions} query
#'
#' @export
direction_legs <- function(res) legs(resultType(res))

legs <- function(js) UseMethod("legs")

#' @export
legs.character <- function(js) jqr::jq(js, ".routes[].legs[]")

#' @export
legs.list <- function(lst) lst[['routes']][['legs']][[1]]

#' @export
legs.default <- function(js) stopMessage(js)


#' Direction Steps
#'
#' @param res The result of a \code{google_directions} query
#'
#' @export
direction_steps <- function(res) steps(resultType(res))

steps <- function(js) UseMethod("steps")

#' @export
steps.character <- function(js) jqr::jq(js, ".routes[].legs[].steps[]")

#' @export
steps.list <- function(lst) lst[['routes']][['legs']][[1]][['steps']][[1]]

#' @export
steps.default <- function(js) stopMessage(js)

#' Direction Points
#'
#' @param res The result of a \code{google_directions} query
#'
#' @export
direction_points <- function(res) points(resultType(res))

#' @export
points <- function(js) UseMethod("points")

#' @export
points.character <- function(js) jqr::jq(js, ".routes[].legs[].steps[].polyline.points")

#' @export
points.list <- function(lst) lst[['routes']][['legs']][[1]][['steps']][[1]][['polyline']][['points']]

#' Direction Polyline
#'
#' @param res The result of a \code{google_directions} query
#'
#' @export
direction_polyline <- function(res) polyline(resultType(res))

polyline <- function(js) UseMethod("polyline")

#' @export
polyline.character <- function(js) jqr::jq(js, ".routes[].overview_polyline.points")

#' @export
polyline.list <- function(lst) lst[['routes']][['overview_polyline']][['points']]

#' @export
polyline.default <- function(js) stopMessage(js)
