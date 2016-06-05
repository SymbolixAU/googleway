#' Google elevation
#'
#' The Google Maps Elevation API provides elevation data for all locations on the surface of the earth, including depth locations on the ocean floor (which return negative values).
#'
#' @param locations
#' @param key string A valid Google Developers Directions API key
#' @param output_format string Either 'data.frame' or 'JSON'
#' @return Either data.frame or JSON string of the elevation data
#' @examples
#' \dontrun{
#'
#' ## elevation data for the MCG in Melbourne
#' location <- c(-37.81659, 144.9841)
#' google_elevation(locations = location,
#'                  key = "<your valid api key>",
#'                  output_format = "data.frame")
#'
#' }
#'
#' @export
google_elevation <- function(locations,
                             key,
                             output_format = c("data.frame","JSON")
                             ){

  ## locations can be a single lat/lon pair,
  ## or a data.frame of lat/lon pairs.

  ## check location
  if(!is.numeric(location))
    stop("location must be a vector of a pair of latitude and longitude coordinates")

  if(!length(location) == 2)
    stop("location must be a vector of a pair of latitude and longitude coordinates")

  locations <- paste0(location, collapse = ",")

  ## check output format
  output_format <- match.arg(output_format)


  map_url <- paste0("https://maps.googleapis.com/maps/api/elevation/json?",
                    "&locations=", locations,
                    "&key=",key)

  return(fun_download_data(map_url, output_format))
}
