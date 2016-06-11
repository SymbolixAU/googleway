#' Google timezone
#'
#' The Google Maps Time Zone API provides time offset data for locations on the surface of the earth. You request the time zone information for a specific latitude/longitude pair and date
#'
#' @param location vector of lat/lon pair
#' @param timestamp POSIXct The Google Maps Time Zone API uses the timestamp to determine whether or not Daylight Savings should be applied. Will default to the current system time
#' @param language string specifies the language in which to return the results. See the list of supported languages: \url{https://developers.google.com/maps/faq#using-google-maps-apis} If no langauge is supplied, the service will attempt to use the language of the domain from which the request was sent
#' @param key string A valid Google Developers Directions API key
#' @param simplify logical Inidicates if the returned JSON should be coerced into a list
#' @return Either list or JSON string of the timezone
#' @examples
#' \dontrun{
#' google_timezone(location = c(-37.81659, 144.9841),
#'                timestamp = as.POSIXct("2016-06-05"),
#'                output_format = "data.frame",
#'                key = "<your valid api key>")
#' }
#'
#' @export
google_timezone <- function(location,
                            timestamp = Sys.time(),
                            language = NULL,
                            simplify = TRUE,
                            key
                            ){

  ## check location
  if(!is.numeric(location))
    stop("location must be a vector of a pair of latitude and longitude coordinates")

  if(!length(location) == 2)
    stop("location must be a vector of a pair of latitude and longitude coordinates")

  location <- paste0(location, collapse = ",")

  ## check timestamp
  if(!inherits(timestamp, "POSIXct"))
    stop("timestamp must be a POSIXct object")

  timestamp <- as.integer(timestamp)

  ## language check
  if(!is.null(language) & (class(language) != "character" | length(language) > 1))
    stop("language must be a single character vector or string")

  if(!is.logical(simplify))
    stop("simplify must be logical - TRUE or FALSE")

  map_url <- paste0("https://maps.googleapis.com/maps/api/timezone/json?",
                    "&location=", location,
                    "&timestamp=", timestamp,
                    "&language=", tolower(language),
                    "&key=", key)

  return(fun_download_data(map_url, simplify))

}
