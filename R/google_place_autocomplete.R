#' Google place autocomplete
#'
#' The Place Autocomplete service is a web service that returns place predictions
#' in response to an HTTP request. The request specifies a textual search string
#' and optional geographic bounds. The service can be used to provide autocomplete
#' functionality for text-based geographic searches, by returning places such as
#' businesses, addresses and points of interest as a user types.
#'
#' @param place_input \code{string} The text string on which to search.
#' The Place Autocomplete service will return candidate matches based on this
#' string and order results based on their perceived relevance.
#' @param location \code{numeric} vector of latitude/longitude coordinates (in that order)
#' the point around which you wish to retrieve place information
#' @param radius \code{numeric} The distance (in meters) within which to return
#' place results. Note that setting a radius biases results to the indicated area,
#' but may not fully restrict results to the specified area
#' @param language \code{string} The language code, indicating in which language
#' the results should be returned, if possible. Searches are also biased to the
#' selected language; results in the selected language may be given a higher ranking.
#' See the list of supported languages and their codes
#' \url{https://developers.google.com/maps/faq#languagesupport}
#' @param place_type \code{string} Restricts the results to places matching the
#' specified type. Only one type may be specified (if more than one type is provided,
#' all types following the first entry are ignored). For a list of valid types,
#' please visit \url{https://developers.google.com/places/web-service/autocomplete#place_types}
#' @param components \code{string} of length 1 which identifies a grouping of places
#' to which you would like to restrict your results. Currently, you can use
#' components to filter by country only. The country must be passed as a two
#' character, ISO 3166-1 Alpha-2 compatible country code.
#' For example: components=country:fr would restrict your results to places within France.
#' @param simplify \code{logical} - TRUE indicates the returned JSON will be coerced into a list. FALSE indicates the returend JSON will be returned as a string
#' @param key \code{string} A valid Google Developers Places API key
#'
#' @examples
#' \dontrun{
#'
#' ## search for 'Maha' Restaurant, Melbourne
#' google_place_autocomplete("Maha Restaurant", key = key)
#'
#' ## search for 'Maha' Restaurant, exclusively in Australia
#' google_place_autocomplete("maha Restaurant", component = "au", key = key)
#'
#' }
#' @export
#'

google_place_autocomplete <- function(place_input,
                                      location = NULL,
                                      radius = NULL,
                                      language = NULL,
                                      place_type = NULL,
                                      components = NULL,
                                      simplify = TRUE,
                                      key){

  ## check input is a valid character string
  if(!is.character(place_input) | length(place_input) > 1)
    stop("place_input can only be a character string of length 1")

  place_input <- gsub(" ", "+", place_input)

  LogicalCheck(simplify)

  ## check location is valid
  if(!is.null(location)){
    if(length(location) != 2 | !is.numeric(location)){
      stop("location must be a numeric vector of latitude/longitude coordinates")
    }else{
      location <- paste0(location, collapse = ",")
    }
  }

  ## check radius
  if(!is.null(radius)){
    if(!is.numeric(radius) | length(radius) != 1)
      stop("radius must be a numeric vector of length 1")
  }

  ## language check
  if(!is.null(language) & (class(language) != "character" | length(language) > 1))
    stop("language must be a single character vector or string")

  if(!is.null(language))
    language <- tolower(language)

  ## check place type
  if(!is.null(place_type)){
    if(length(place_type) > 1 | !is.character(place_type))
      stop("place_type must be a string vector of length 1")
  }

  # ## check components
  if(!is.null(components)){
    if(!is.character(components) | length(components) > 1)
      stop("components must be a string vector of length 1, and represent an ISO 3166-1 Alpha-2 country code")

    if(nchar(components) != 2)
      stop("components must be a string vector of length 1, and represent an ISO 3166-1 Alpha-2 country code")
  }

  if(!is.null(components))
    components <- paste0("country:", components)

  map_url <- "https://maps.googleapis.com/maps/api/place/autocomplete/json?"

  map_url <- constructURL(map_url, c("input" = place_input,
                                     "location" = location,
                                     "radius" = radius,
                                     "language" = language,
                                     "type" = place_type,
                                     "components" = components,
                                     "key" = key))

  return(fun_download_data(map_url, simplify))

}
