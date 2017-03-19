#' Decode PL
#'
#' Decodes an encoded polyline into the series of lat/lon coordinates that specify the path
#'
#' @note
#' An encoded polyline is generated from google's polyline encoding algorithm (\url{https://developers.google.com/maps/documentation/utilities/polylinealgorithm}).
#'
#' @seealso \link{encode_pl}, \link{google_directions}
#'
#' @param encoded String. An encoded polyline
#' @return data.frame of lat/lon coordinates
#' @importFrom Rcpp evalCpp
#' @examples
#' ## polyline joining the capital cities of Australian states
#' pl <- "nnseFmpzsZgalNytrXetrG}krKsaif@kivIccvzAvvqfClp~uBlymzA~ocQ}_}iCthxo@srst@"
#'
#' df_polyline <- decode_pl(pl)
#' df_polyline
#' @export
decode_pl <- function(encoded){

  if(class(encoded) != "character" | length(encoded) != 1)
    stop("encoded must be a string of length 1")

  tryCatch({
    rcpp_decode_pl(encoded)
  },
  error = function(cond){
    message("The encoded string could not be decoded. \nYou can manually check the encoded line at https://developers.google.com/maps/documentation/utilities/polylineutility \nIf the line can successfully be manually decoded, please file an issue: https://github.com/SymbolixAU/googleway/issues ")
  })

}


#' Encode PL
#'
#' Encodes a series of lat/lon coordinates that specify a path into an encoded polyline
#'
#' @note
#' An encoded polyline is generated from google's polyline encoding algorithm (\url{https://developers.google.com/maps/documentation/utilities/polylinealgorithm}).
#'
#' @seealso \link{decode_pl}
#'
#' @param lat vector of latitude coordinates
#' @param lon vector of longitude coordinates
#'
#' @examples
#' encode_pl(lat = c(38.5, 40.7, 43.252), lon = c(-120.2, -120.95, -126.453))
#' ## "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
#'
#'
#' @return string encoded polyline
#'
#' @export
encode_pl <- function(lat, lon){

  # if(!inherits(df, "data.frame"))
  #   stop("encoding algorithm only works on data.frames")

  if(length(lat) != length(lon))
    stop("lat and lon must be the same length")

  tryCatch({
    rcpp_encode_pl(lat, lon, length(lat))
  },
  error = function(cond){
    message("The coordinates could not be encoded")
  })
}









