
#' @describeIn access_result the instructions from a directions query
#' @export
direction_instructions <- function(res) {
  ## instructions can be nested
  iterate_access_result(
    .access_result(resultType(res), "instructions")
    , elem= "[[c('html_instructions')]]"
  )
}

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
direction_points <- function(res) {
  iterate_access_result(
    .access_result(resultType(res), "points")
    , elem = "[[c('polyline','points')]]"
  )
}

#' @describeIn access_result the encoded polyline from a direction query
#' @export
direction_polyline <- function(res) .access_result(resultType(res), "polyline")



## iterate results
iterate_access_result <- function( ar, elem ) UseMethod("iterate_access_result")

#' @export
iterate_access_result.character <- function( ar, ... ) return( ar )

#' @export
iterate_access_result.list <- function( ar, elem ) {
  res <- c()
  for ( i in seq_len( length( ar ) ) ) {
    txt <- paste0("ar[[i]]",elem)
    res <- c(res, eval(parse(text = txt)) )
  }
  return(res)
}
