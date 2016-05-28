#' GetRoute
#'
#' Uses Google Maps Directions API to search for the route between an origin and destination.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom curl curl
#' @param origin numeric Vector of lat/lon coordinates, or an address string
#' @param destination numeric Vector of lat/lon coordinates, or an address string
#' @param mode string. One of 'driving', 'walking' or 'bicycling'
#' @param key string A valid Google Developers Directions API key
#' @param output_format string Either 'data.frame' or 'JSON'
#' @return Either data.frame or JSON string of the route between origin and destination
#' @examples
#' \dontrun{
#' ## using lat/long coordinates
#' get_route(origin = c(-37.8179746, 144.9668636),
#'           destination = c(-37.81659, 144.9841),
#'           mode = "walking",
#'           key = "<your valid api key>")
#'
#'
#'## using address string
#'get_route(origin = "Flinders Street Station, Melbourne",
#'          destination = "MCG, Melbourne",
#'          mode = "walking",
#'          key = "<your valid api key>")
#'
#' }
#' @export
get_route <- function(origin,
                     destination,
                     mode = c('driving','walking','bicycling','transit'),
                     key = NULL,
                     output_format = c('data.frame', 'JSON')){

  ## parameter check
  if(is.null(key))
    stop("A Valid Google Developers API key is required")

  mode <- match.arg(mode)
  output_format <- match.arg(output_format)

  origin <- fun_check(origin, "Origin")
  destination <- fun_check(destination, "Destination")

  ## construct url
  map_url <- paste0("https://maps.googleapis.com/maps/api/directions/json?",
                    "origin=", origin,
                    "&destination=", destination,
                    "&mode=", tolower(mode),
                    "&key=", key)

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


fun_check <- function(loc, type){
  if(is.numeric(loc) & length(loc) == 2){
    loc <- paste0(loc, collapse = ",")
  }else if(is.character(loc) & length(loc) == 1){
    loc <- gsub(" ", "+", loc)
  }else{
    stop(paste0(type, " must be either a numeric vector of lat/lon coordinates, or an address string"))
  }
}
