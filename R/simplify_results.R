
collapseResult <- function(res) paste0(res, collapse = "")

resultType <- function(res) UseMethod("resultType")

#' @export
resultType.character <- function(res) collapseResult(res)

#' @export
resultType.list <- function(res) return(res)

#' @export
resultType.default <- function(res) stopMessage(res)


### DIRECTIONS API - INSTRUCTIONS ----------------------------------------------
direction_instructions <- function(js) instructions(resultType(js))

instructions <- function(js) UseMethod("instructions")

#' @export
instructions.character <- function(js) jqr::jq(js, ".routes[].legs[].steps[].html_instructions")

#' @export
instructions.list <- function(lst) lst[['routes']][['legs']][[1]][['steps']][[1]][['html_instructions']]

#' @export
instructions.default <- function(js) stopMessage(js)

### DIRECTIONS API - ROUTES ------------------------------------------------------
direction_routes <- function(js) routes(resultType(js))

routes <- function(js) UseMethod("routes")

#' @export
routes.character <- function(js) jqr::jq(js, ".routes[]")

#' @export
routes.list <- function(lst) lst[['routes']]

#' @export
routes.default <- function(js) stopMessage(js)

### DIRECTIONS API - ROUTES > LEGS ------------------------------------------------------
direction_legs <- function(js) legs(routes(resultType(js)))

legs <- function(js) UseMethod("legs")

#' @export
legs.character <- function(js) jqr::jq(js, ".legs[]")

#' @export
legs.data.frame <- function(lst) lst[['legs']]

#' @export
legs.default <- function(js) stopMessage(js)


### DIRECTIONS API - ROUTES > LEGS > STEPS ----------------------------------------------
direction_steps <- function(js) steps(resultType(js))

steps <- function(js) UseMethod("steps")

#' @export
steps.character <- function(js) jqr::jq(js, ".routes[].legs[].steps")

#' @export
steps.list <- function(lst) lst[['routes']][['legs']][[1]][['steps']]

#' @export
steps.default <- function(js) stopMessage(js)

### DIRECTIONS API - ROUTES > LEGS > STEPS > POINTS -------------------------------------

direction_points <- function(js) points(resultType(js))

#' @export
points <- function(js) UseMethod("points")

#' @export
points.character <- function(js) jqr::jq(js, ".routes[].legs[].steps[].polyline.points")

#' @export
points.list <- function(lst) lst[['routes']]

### DIRECTIONS API - ROUTES > POLYLINE --------------------------------------------------
direction_polyline <- function(js) polyline(resultType(js))

polyline <- function(js) UseMethod("polyline")

#' @export
polyline.character <- function(js) jqr::jq(js, ".routes[].overview_polyline.points")

#' @export
polyline.list <- function(lst) lst[['routes']][['overview_polyline']][['points']]

#' @export
polyline.default <- function(js) stopMessage(js)






