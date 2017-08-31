
collapseResult <- function(res) paste0(res, collapse = "")

### DIRECTIONS API - LEGS ------------------------------------------------------
direction_legs <- function(js) legs(collapseResult(js))

legs <- function(js) UseMethod("legs")

#' @export
legs.character <- function(js) jqr::jq(js, ".routes[].legs")

#' @export
legs.default <- function(js) stopMessage(js)


### DIRECTIONS API - LEGS > STEPS ----------------------------------------------

direction_steps <- function(js) steps(collapseResult(js))

steps <- function(js) UseMethod("steps")

#' @export
steps.character <- function(js) jqr::jq(js, ".routes[].legs[].steps")

#' @export
steps.default <- function(js) stopMessage(js)

### DIRECTIONS API - POLYLINE --------------------------------------------------
direction_polyline <- function(js) polyline(collapseResult(js))

polyline <- function(js) UseMethod("polyline")

#' @export
polyline.character <- function(js) jqr::jq(js, ".routes[].overview_polyline.points")

#' @export
polyline.default <- function(js) stopMessage(js)






