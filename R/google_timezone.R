#' Google timezone
#'
#' The Google Maps Time Zone API provides time offset data for locations on the surface of the earth. You request the time zone information for a specific latitude/longitude pair and date
#'
#' @param location vector of lat/lon pair
#' @param timestamp POSIXct The Google Maps Time Zone API uses the timestamp to determine whether or not Daylight Savings should be applied. Will default to the current system time
#' @param key string A valid Google Developers Directions API key
#' @param output_format string Either 'data.frame' or 'JSON'
#' @examples
#' \dontrun{
#' google_timezone(location = c(-37.81659, 144.9841),
#'                timestamp = as.POSIXct("2016-06-05"),
#'                output_format = "data.frame",
#'                key = key)
#' }
#'
#' @export
google_timezone <- function(location,
                            timestamp = Sys.time(),
                            output_format = c("data.frame","JSON"),
                            key = NULL
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

  ## check output format
  output_format <- match.arg(output_format)

  map_url <- paste0("https://maps.googleapis.com/maps/api/timezone/json?",
                    "&location=", location,
                    "&timestamp=", timestamp,
                    "&key=", key)

  return(fun_download_data(map_url, output_format))

}
