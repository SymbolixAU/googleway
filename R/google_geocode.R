#' Google geocoding
#'
#' Geocoding is the process of converting addresses (like "1600 Amphitheatre
#' Parkway, Mountain View, CA") into geographic coordinates (like latitude 37.423021
#' and longitude -122.083739), which you can use to place markers on a map, or position the map.
#'
#' @param address \code{string}. The street address that you want to geocode, in the
#' format used by the national postal service of the country concerned
#' @param bounds list of two, each element is a vector of lat/lon coordinates
#' representing the south-west and north-east bounding box
#' @param language \code{string}. Specifies the language in which to return the results.
#' See the list of supported languages:
#' \url{https://developers.google.com/maps/faq#using-google-maps-apis}. If no
#' langauge is supplied, the service will attempt to use the language of the domain
#' from which the request was sent
#' @param region \code{string}. Specifies the region code, specified as a ccTLD
#' ("top-level domain"). See region basing for details
#' \url{https://developers.google.com/maps/documentation/directions/intro#RegionBiasing}
#' @param key \code{string}. A valid Google Developers Geocode API key
#' @param components \code{data.frame} of two columns, component and value. Restricts
#' the results to a specific area. One or more of "route","locality","administrative_area",
#' "postal_code","country"
#' @param simplify \code{logical} Indicates if the returned JSON should be coerced into a list
#' @return Either list or JSON string of the geocoded address
#' @examples
#' \dontrun{
#' df <- google_geocode(address = "MCG, Melbourne, Australia",
#'                      key = "<your valid api key>",
#'                      simplify = TRUE)
#'
#' df$results$geometry$location
#'         lat      lng
#' 1 -37.81659 144.9841
#'
#' ## using bounds
#' bounds <- list(c(34.172684,-118.604794),
#'                c(34.236144,-118.500938))
#'
#' js <- google_geocode(address = "Winnetka",
#'                      bounds = bounds,
#'                      key = "<your valid api key>",
#'                      simplify = FALSE)
#'
#' ## using components
#' components <- data.frame(component = c("postal_code", "country"),
#'                          value = c("3000", "AU"))
#'
#'df <- google_geocode(address = "Flinders Street Station",
#'                    key = "<your valid api key>",
#'                    components = components,
#'                    simplify = FALSE)
#'
#' }
#' @export
google_geocode <- function(address,
                           bounds = NULL,
                           key,
                           language = NULL,
                           region = NULL,
                           components = NULL,
                           simplify = TRUE){

  ## parameter check - key
  if(is.null(key))
    stop("A Valid Google Developers API key is required")

  LogicalCheck(simplify)

  ## address check
  address <- fun_check_address(address)
  addres <- tolower(address)

  ## bounds check
  if(!is.null(bounds) & (!class(bounds) == "list" | !all(sapply(bounds, class) == "numeric") | length(bounds) != 2))
    stop("bounds must be a list of length 2, each item being a vector of lat/lon coordinate pairs")

  if(!all(sapply(bounds, length) == 2))
    stop("each element of bounds must be length 2 - a pair of lat/lon coordinates")

  bounds <- paste0(lapply(bounds, function(x) paste0(x, collapse = ",")), collapse = "|")

  ## language check
  if(!is.null(language) & (class(language) != "character" | length(language) > 1))
    stop("language must be a single character vector or string")

  if(!is.null(language))
    language <- tolower(language)

  ## region check
  if(!is.null(region) & (class(region) != "character" | length(region) > 1))
    stop("region must be a two-character string")

  if(!is.null(region))
    region <- tolower(region)

  ## components check
  if(!is.null(components)){
    if(!inherits(components, "data.frame") | !sum(names(components) %in% c("component","value")) == 2)
      stop("components must be a data.frame with two columns named 'component' and 'value'")

    ## error on misspelled components
    if(!any(as.character(components$component) %in% c("route","locality","administrative_area","postal_code","country")))
      stop("valid components are 'route', 'locality', 'postal_code', 'administrative_area' and 'country'")

    components = paste0(apply(components, 1, function(x) paste0(x, collapse = ":")), collapse = "|")
    components <- tolower(components)
  }

  map_url <- "https://maps.googleapis.com/maps/api/geocode/json?"

  map_url <- constructURL(map_url, c("address" = address,
                                     "bounds" = bounds,
                                     "language" = language,
                                     "region" = region,
                                     "components" = components,
                                     "key" = key))

  return(fun_download_data(map_url, simplify))

}
