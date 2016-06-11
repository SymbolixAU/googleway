#' Google reverse geocoding
#'
#' Reverse geocoding is the process of converting geographic coordinates into a human-readable address.
#'
#' @param location numeric Vector of lat/lon coordinates
#' @param result_type string vector One or more address types. See \url{https://developers.google.com/maps/documentation/geocoding/intro#Types} for list of available types.
#' @param location_type string vector Specifying a location type will restrict the results to this type. If multiple types are specified, the API will return all addresses that match any of the types
#' @param language string specifies the language in which to return the results. See the list of supported languages: \url{https://developers.google.com/maps/faq#using-google-maps-apis} If no langauge is supplied, the service will attempt to use the language of the domain from which the request was sent
#' @param key string A valid Google Developers Directions API key
#' @param simplify logical Inidicates if the returned JSON should be coerced into a list
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
                                   key,
                                   simplify = TRUE){

  ## parameter check - key
  if(is.null(key))
    stop("A Valid Google Developers API key is required")

  if(!is.logical(simplify))
    stop("simplify must be logical - TRUE or FALSE")

  ## check location
  if(!is.numeric(location))
    stop("location must be a vector of a pair of latitude and longitude coordinates")

  if(!length(location) == 2)
    stop("location must be a vector of a pair of latitude and longitude coordinates")

  location <- paste0(location, collapse = ",")

  ## result_type check
  if(!is.null(result_type) & !class(result_type) == "character")
    stop("result_type must be a vector of strings")

  if(length(result_type) > 1){
    result_type <- paste0(tolower(result_type), collapse = "|")
  }else{
    result_type <- tolower(result_type)
  }

  ## location_type check
  if(!is.null(location_type)){
    location_type <- match.arg(location_type, c("rooftop","range_interpolated", "geometric_center", "approximate"))
    if(length(location_type) > 1){
      location_type <- paste0(toupper(location_type), collapse = "|")
    }else{
      location_type <- toupper(location_type)
    }
  }

  ## language check
  if(!is.null(language) & (class(language) != "character" | length(language) > 1))
    stop("language must be a single character vector or string")

  map_url <- paste0("https://maps.googleapis.com/maps/api/geocode/json?",
                    "&latlng=", location,
                    "&location_type=", location_type,
                    "&language=", tolower(language),
                    "&result_type=", tolower(result_type),
                    "&key=", key)

  if(length(map_url) > 1)
    stop("invalid map_url")

  return(fun_download_data(map_url, simplify))

}
