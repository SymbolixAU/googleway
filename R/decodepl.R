#' Decodepl
#'
#' Decodes a polyline that's generated from google's directions api \url{https://developers.google.com/maps/documentation/directions/}
#' @param encoded String. An encoded polyline
#' @return data.frame of lat/lon coordinates
#' @importFrom Rcpp evalCpp
#' @examples
#' ## polyline joining the capital cities of Australian states
#' pl <- "nnseFmpzsZgalNytrXetrG}krKsaif@kivIccvzAvvqfClp~uBlymzA~ocQ}_}iCthxo@srst@"
#'
#' df_polyline <- decodepl(pl)
#' @export
decodepl <- function(encoded){

  if(class(encoded) != "character" | is.vector(encoded))
    stop("encoded must be a single string (and not a vector of strings)")

  rcpp_decodepl(encoded)
}





