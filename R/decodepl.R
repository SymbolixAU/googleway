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

  if(class(encoded) != "character" | length(encoded) != 1)
    stop("encoded must be a string (with length == 1)")

  tryCatch({
    rcpp_decodepl(encoded)
  },
  error = function(cond){
    message("The encoded string could not be decoded. \nYou can manually check the encoded line at https://developers.google.com/maps/documentation/utilities/polylineutility \nIf the line can successfully be manually decoded, please file an issue: https://github.com/SymbolixAU/googleway/issues ")
  })

}





