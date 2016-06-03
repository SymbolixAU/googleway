#' GetRoute
#'
#' Uses Google Maps Directions API to search for the route between an origin and destination.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom curl curl
#' @param origin numeric Vector of lat/lon coordinates, or an address string
#' @param destination numeric Vector of lat/lon coordinates, or an address string
#' @param mode string. One of 'driving', 'walking' or 'bicycling'
#' @param departure_time POSIXct. Specifies the desired time of departure. Must be in the future (i.e. greater than \code{sys.time()}). If no value is specified it defaults to \code{Sys.time()}
#' @param alternatives logical If set to true, specifies that the Directions service may provide more than one route alternative in the response
#' @param avoid character Vector stating which features should be avoided. One of 'tolls', 'highways', 'ferries' or 'indoor'
#' @param units string metric or imperial. Note: Only affects the text displayed within the distance field. The values are always in metric
#' @param traffic_model string One of 'best_guess', 'pessimistic' or 'optimistic'. Only valid with a departure time
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
                     departure_time = NULL,
                     alternatives = c(FALSE, TRUE),
                     avoid = NULL,
                     units = c("metric", "imperial"),
                     traffic_model = NULL,
                     key = NULL,
                     output_format = c('data.frame', 'JSON')){

  ## parameter check
  if(is.null(key))
    stop("A Valid Google Developers API key is required")

  mode <- match.arg(mode)
  output_format <- match.arg(output_format)
  units <- match.arg(units)
  traffic_model <- match.arg(traffic_model)

  if(!all(tolower(avoid) %in% c("tolls","highways","ferries","indoor")) & !is.null(avoid)){
    stop("avoid must be one of tolls, highways, ferries or indoor")
  }else{
    if(length(avoid) > 1){
      avoid <- paste0(tolower(avoid), collapse = "+")
    }else{
      avoid <- tolower(avoid)
      }
  }

  if(!is.null(departure_time) & !inherits(departure_time, "POSIXct"))
    stop("departure_time must be a POSIXct object")

  if(!is.null(departure_time)){
    if(departure_time < Sys.time()){
      stop("departure_time must not be in the past")
    }
  }

  if(!is.logical(alternatives))
    stop("alternatives must be logical - TRUE or FALSE")

  if(!is.null(traffic_model) & is.null(departure_time))
    stop("traffic_model is only accepted with a valid departure_time")

  origin <- fun_check_location(origin, "Origin")
  destination <- fun_check_location(destination, "Destination")
  departure_time <- ifelse(is.null(departure_time), as.integer(Sys.time()), as.integer(departure_time))

  ## construct url
  map_url <- paste0("https://maps.googleapis.com/maps/api/directions/json?",
                    "origin=", origin,
                    "&destination=", destination,
                    "&departure_time=", departure_time,
                    "&alternatives=", tolower(alternatives),
                    "&avoid=", avoid,
                    "&units=", tolower(units),
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


fun_check_location <- function(loc, type){
  if(is.numeric(loc) & length(loc) == 2){
    loc <- paste0(loc, collapse = ",")
  }else if(is.character(loc) & length(loc) == 1){
    loc <- gsub(" ", "+", loc)
  }else{
    stop(paste0(type, " must be either a numeric vector of lat/lon coordinates, or an address string"))
  }
}
