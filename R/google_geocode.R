#' Google geocoding
#'
#' Geocoding is the process of converting addresses (like "1600 Amphitheatre Parkway, Mountain View, CA") into geographic coordinates (like latitude 37.423021 and longitude -122.083739), which you can use to place markers on a map, or position the map.
#'
#' @param address string The street address that you want to geocode, in the format used by the national postal service of the country concerned
#' @param bounds list of two, each element is a vector of lat/lon coordinates representing the south-west and north-east bounding box
#' @param language string specifies the language in which to return the results. See the list of supported languages: \url{https://developers.google.com/maps/faq#using-google-maps-apis} If no langauge is supplied, the service will attempt to use the language of the domain from which the request was sent
#' @param region string Specifies the region code, specified as a ccTLD ("top-level domain"). See region basing for details \url{https://developers.google.com/maps/documentation/directions/intro#RegionBiasing}
#' @param key string A valid Google Developers Directions API key
#' @param output_format string Either 'data.frame' or 'JSON'
#' @examples
#' \dontrun{
#' df <- google_geocode(address = "MCG, Melbourne, Australia",
#'                      key = key,
#'                      output_format = "data.frame")
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
#'                      key = key,
#'                      output_format = "JSON")
#'
#' }
#' @export
google_geocode <- function(address,
                           bounds = NULL,
                           key = NULL,
                           language = NULL,
                           region = NULL,
                           output_format = c("data.frame","JSON")){

  ## parameter check - key
  if(is.null(key))
    stop("A Valid Google Developers API key is required")

  ## address check
  address <- fun_check_address(address)

  ## bounds check
  if(!is.null(bounds) & (!class(bounds) == "list" | !all(sapply(bounds, class) == "numeric")))
    stop("bounds must be a list of length 2, each item being a vector of lat/lon coordinate pairs")

  if(!all(sapply(bounds, length) == 2))
    stop("each element of bounds must be length 2 - a pair of lat/lon coordinates")

  bounds <- paste0(lapply(bounds, function(x) paste0(x, collapse = ",")), collapse = "|")

  ## language check
  if(!is.null(language) & (class(language) != "character" | length(language) > 1))
    stop("language must be a single character vector or string")

  ## region check
  if(!is.null(region) & (class(region) != "character" | length(region) > 1))
    stop("region must be a two-character string")

  map_url <- paste0("https://maps.googleapis.com/maps/api/geocode/json?",
                    "&address=", tolower(address),
                    "&bounds=", bounds,
                    "&language=", tolower(language),
                    "&region=", tolower(region),
                    "&key=", key)

  if(length(map_url) > 1)
    stop("invalid map_url")

  if(output_format == "data.frame"){
    out <- jsonlite::fromJSON(map_url)
  }else if(output_format == "JSON"){
    # out <- readLines(curl::curl(map_url))
    con <- curl::curl(map_url)
    out <- readLines(con)
    close(con)   ## readLines closes a connection, but does not destroy it
  }
  return(out)

}

fun_check_address <- function(address){
  if(is.character(address) & length(address) == 1){
    address <- gsub(" ", "+", address)
  }else{
    stop("address must be a string of length 1")
  }
  return(address)
}
