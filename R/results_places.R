
#' @describeIn access_result the place_id from a places query
#' @export
place <- function(res) .access_result(resultType(res), "place")

#' @describeIn access_result the next page token from a places query
#' @export
place_next_page <- function(res) .access_result(resultType(res), 'place_next_page')
