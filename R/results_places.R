
#' @describeIn access_result the place_id from a places query
#' @export
place <- function(res) .access_result(resultType(res), "place")


#' @describeIn access_result the next page token from a places query
#' @export
place_next_page <- function(res) .access_result(resultType(res), 'place_next_page')


#' @describeIn access_result the place name from a places query
#' @export
place_name <- function(res) .access_result(resultType(res), 'place_name')


#' @describeIn access_result the location from a places query
#' @export
place_location <- function(res) .access_result(resultType(res), 'place_location')


#' @describeIn access_result the type of place from a places query
#' @export
place_type <- function(res) .access_result(resultType(res), 'place_type')

