

### DIRECTIONS - instructions --------------------------------------------------

#' @describeIn access_result the instructions from a directions query
#' @export
direction_instructions <- function(res) instructions(resultType(res))

instructions <- function(res) UseMethod("instructions")

#' @export
instructions.character <- function(js) resultJs(js, jsAccessor("instructions"))

#' @export
instructions.list <- function(lst) lst[['routes']][['legs']][[1]][['steps']][[1]][['html_instructions']]

#' @export
instructions.default <- function(js) stopMessage(js)


### DIRECTIONS - routes  -------------------------------------------------------

#' @describeIn access_result the routes from a directions query
#' @export
direction_routes <- function(res) routes(resultType(res))

routes <- function(js) UseMethod("routes")

#' @export
routes.character <- function(js) resultJs(js, jsAccessor("routes"))

#' @export
routes.list <- function(lst) lst[['routes']]

#' @export
routes.default <- function(js) stopMessage(js)


### DIRECTIONS - legs ----------------------------------------------------------

#' @describeIn access_result the legs from a directions query
#' @export
direction_legs <- function(res) legs(resultType(res))

legs <- function(js) UseMethod("legs")

#' @export
legs.character <- function(js) resultJs(js, jsAccessor("legs"))

#' @export
legs.list <- function(lst) lst[['routes']][['legs']][[1]]

#' @export
legs.default <- function(js) stopMessage(js)


### DIRECTIONS - steps ---------------------------------------------------------

#' @describeIn access_result the steps from a directions query
#' @export
direction_steps <- function(res) steps(resultType(res))

steps <- function(js) UseMethod("steps")

#' @export
steps.character <- function(js) resultJs(js, jsAccessor("steps"))

#' @export
steps.list <- function(lst) lst[['routes']][['legs']][[1]][['steps']][[1]]

#' @export
steps.default <- function(js) stopMessage(js)


### DIRECTIONS - points --------------------------------------------------------

#' @describeIn access_result the points from a directions query
#' @export
direction_points <- function(res) points(resultType(res))

#' @export
points <- function(js) UseMethod("points")

#' @export
points.character <- function(js) resultJs(js, jsAccessor("points"))

#' @export
points.list <- function(lst) lst[['routes']][['legs']][[1]][['steps']][[1]][['polyline']][['points']]


### DIRECTIONS - polyline ------------------------------------------------------

#' @describeIn access_result the encoded polyline from a direction query
#' @export
direction_polyline <- function(res) polyline(resultType(res))

polyline <- function(js) UseMethod("polyline")

#' @export
polyline.character <- function(js) resultJs(js, jsAccessor("polyline"))

#' @export
polyline.list <- function(lst) lst[['routes']][['overview_polyline']][['points']]

#' @export
polyline.default <- function(js) stopMessage(js)
