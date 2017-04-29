#' GetRoute
#'
#' This function is deprecated. Please use \link{google_directions}
#' @param ... arguments passed to google_directions. Legacy - so that old 'get_route() calls will still enter this function.
#' @export
get_route <- function(...){
  stop("get_route() is deprecated and has been removed. Use google_directions() instead.")
}
