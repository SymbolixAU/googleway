#' Google reverse geocoding
#'
#' Reverse geocoding is the process of converting geographic coordinates into a
#' human-readable address.
#'
#' @param location numeric vector of lat/lon coordinates.
#' @param result_type string vector - one or more address types.
#' See \url{https://developers.google.com/maps/documentation/geocoding/intro#Types}
#' for list of available types.
#' @param location_type string vector specifying a location type will restrict the
#' results to this type. If multiple types are specified, the API will return all
#' addresses that match any of the types
#' @param language string specifies the language in which to return the results.
#' See the list of supported languages: \url{https://developers.google.com/maps/faq#using-google-maps-apis}.
#' If no langauge is supplied, the service will attempt to use the language of the
#' domain from which the request was sent
#' @param key string. A valid Google Developers Geocode API key
#' @param simplify \code{logical} - TRUE indicates the returned JSON will be
#' coerced into a list. FALSE indicates the returend JSON will be returned as a string
#' @param curl_proxy a curl proxy object
#' @return Either list or JSON string of the geocoded address
#' @examples
#' \dontrun{
#' ## searching for the street address for the rooftop location type
#' google_reverse_geocode(location = c(-37.81659, 144.9841),
#'                        result_type = c("street_address"),
#'                        location_type = "rooftop",
#'                        key = "<your valid api key>")
#' }
#' @export
google_reverse_geocode <- function(location,
                                   result_type = NULL,
                                   location_type = NULL,
                                   language = NULL,
                                   key = get_api_key("reverse_geocode"),
                                   simplify = TRUE,
                                   curl_proxy = NULL
                                   ){

  ## parameter check - key
  if(is.null(key))
    stop("A Valid Google Developers API key is required")

  logicalCheck(simplify)
  location <- validateGeocodeLocation(location)
  result_type <- validateResultType(result_type)
  location_type <- validateLocationType(location_type)
  language <- validateLanguage(language)

  map_url <- "https://maps.googleapis.com/maps/api/geocode/json?"
  map_url <- constructURL(map_url, c("latlng" = location,
                                     "location_type" = location_type,
                                     "language" = language,
                                     "result_type" = result_type,
                                     "key" = key))

  return(downloadData(map_url, simplify, curl_proxy))

}
