#' @useDynLib googleway
#' @importFrom Rcpp evalCpp
#' @importFrom jsonlite fromJSON
#' @importFrom curl curl
NULL



directions_data <- function(base_url,
                            information_type = c("directions","distance"),
                            origin,
                            destination,
                            mode = c('driving','walking','bicycling','transit'),
                            departure_time = NULL,
                            arrival_time = NULL,
                            waypoints = NULL,
                            alternatives = FALSE,
                            avoid = NULL,
                            units = c("metric", "imperial"),
                            traffic_model = NULL,
                            transit_mode = NULL,
                            transit_routing_preference = NULL,
                            language = NULL,
                            region = NULL,
                            key,
                            simplify = TRUE){

  ## parameter check
  if(is.null(key))
    stop("A Valid Google Developers API key is required")

  mode <- match.arg(mode)
  units <- match.arg(units)
  traffic_model <- match.arg(traffic_model)

  if(!is.logical(simplify))
    stop("simplify must be logical - TRUE or FALSE")

  ## transit_mode is only valid where mode = transit
  if(!is.null(transit_mode) & mode != "transit"){
    warning("You have specified a transit_mode, but are not using mode = 'transit'. Therefore this argument will be ignored")
    transit_mode <- NULL
  }else if(!is.null(transit_mode) & mode == "transit"){
    transit_mode <- match.arg(transit_mode, choices = c("bus","subway","train","tram","rail"))
  }

  ## transit_routing_preference only valid where mode == transit
  if(!is.null(transit_routing_preference) & mode != "transit"){
    warning("You have specified a transit_routing_preference, but are not using mode = 'transit'. Therefore this argument will be ignored")
    transit_routing_preference <- NULL
  }else if(!is.null(transit_routing_preference) & mode == "transit"){
    transit_routing_preference <- match.arg(transit_routing_preference, choices = c("less_walking","fewer_transfers"))
    transit_routing_preference <- paste0(transit_routing_preference, collapse = "|")
  }

  ## check avoid is valid
  if(!all(tolower(avoid) %in% c("tolls","highways","ferries","indoor")) & !is.null(avoid)){
    stop("avoid must be one of tolls, highways, ferries or indoor")
  }else{
    if(length(avoid) > 1){
      avoid <- paste0(tolower(avoid), collapse = "+")
    }else{
      avoid <- tolower(avoid)
    }
  }

  ## check departure time is valid
  if(!is.null(departure_time) & !inherits(departure_time, "POSIXct"))
    stop("departure_time must be a POSIXct object")

  if(!is.null(departure_time)){
    if(departure_time < Sys.time()){
      stop("departure_time must not be in the past")
    }
  }

  ## check arrival time is valid
  if(!is.null(arrival_time) & !inherits(arrival_time, "POSIXct"))
    stop("arrival_time must be a POSIXct object")

  if(!is.null(arrival_time) & !is.null(departure_time)){
    warning("you have supplied both an arrival_time and a departure_time - only one is allowed. The arrival_time will be ignored")
    arrival_time <- NULL
  }

  ## check alternatives is valid
  if(!is.logical(alternatives))
    stop("alternatives must be logical - TRUE or FALSE")

  ## check traffic model is valid
  if(!is.null(traffic_model) & is.null(departure_time))
    stop("traffic_model is only accepted with a valid departure_time")

  ## check origin/destinations are valid
  origin_code <- switch(information_type,
                        "directions" = "origin=",
                        "distance" = "origins=")

  destination_code <- switch(information_type,
                             "directions" = "destination=",
                             "distance" = "destinations=")

  if(information_type == "directions"){
    origin <- fun_check_location(origin, "Origin")
    destination <- fun_check_location(destination, "Destination")
  }else if(information_type == "distance"){
    origin <- fun_check_multiple_locations(origin, "Origins elements")
    destination <- fun_check_multiple_locations(destination, "Destinations elements")
  }

  ## check departure time is valid
  departure_time <- ifelse(is.null(departure_time), as.integer(Sys.time()), as.integer(departure_time))
  arrival_time <- as.integer(arrival_time)

  ## check waypoints are valid
  if(!is.null(waypoints) & !mode %in% c("driving", "walking","bicycling"))
    stop("waypoints are only valid for driving, walking or bicycling modes")

  if(!is.null(waypoints) & class(waypoints) != "list")
    stop("waypoints must be a list")

  if(!is.null(waypoints) & !all(names(waypoints) %in% c("", "via")))
    stop("'via' is the only valid name for a waypoint element")

  if(!is.null(waypoints)){
    ## construct waypoint string
    # waypoints <- paste0(lapply(waypoints, function(x) fun_check_waypoints(x)), collapse = "|")

    waypoints <- sapply(1:length(waypoints), function(x) {
      if(length(names(waypoints)) > 0){
        if(names(waypoints)[x] == "via"){
          paste0("via:", fun_check_location(waypoints[[x]]))
        }else{
          fun_check_location(waypoints[[x]])
        }
      }else{
        fun_check_location(waypoints[[x]])
      }
    })
    waypoints <- paste0(waypoints, collapse = "|")
  }

  ## language check
  if(!is.null(language) & (class(language) != "character" | length(language) > 1))
    stop("language must be a single character vector or string")

  ## region check
  if(!is.null(region) & (class(region) != "character" | length(region) > 1))
    stop("region must be a two-character string")

  ## construct url
  map_url <- paste0(base_url,
                    origin_code, origin,
                    "&", destination_code, destination,
                    "&waypoints=", waypoints,
                    "&departure_time=", departure_time,
                    "&arrival_time=", arrival_time,
                    "&alternatives=", tolower(alternatives),
                    "&avoid=", avoid,
                    "&units=", tolower(units),
                    "&mode=", tolower(mode),
                    "&transit_mode=", transit_mode,
                    "&transit_routing_preference=", transit_routing_preference,
                    "&language=", tolower(language),
                    "&region=", tolower(region),
                    "&key=", key)

  if(length(map_url) > 1)
    stop("invalid map_url")

  return(fun_download_data(map_url, simplify))

}


fun_download_data <- function(map_url, simplify){

  if(simplify == TRUE){
    out <- jsonlite::fromJSON(map_url)
  }else{
    # out <- readLines(curl::curl(map_url))
    con <- curl::curl(map_url)
    out <- readLines(con)
    close(con)   ## readLines closes a connection, but does not destroy it
  }
  return(out)
}


fun_check_multiple_locations <- function(loc, type){
  loc <- sapply(1:length(loc), function(x) {
    fun_check_location(loc[[x]], type)
  })
  loc <- paste0(loc, collapse = "|")
}


fun_check_location <- function(loc, type){
  if(is.numeric(loc) & length(loc) == 2){
    loc <- paste0(loc, collapse = ",")
  }else if(is.character(loc) & length(loc) == 1){
    loc <- gsub(" ", "+", loc)
  }else{
    stop(paste0(type, " must be either a numeric vector of lat/lon coordinates, or an address string"))
  }
  return(loc)
}

fun_check_address <- function(address){
  if(is.character(address) & length(address) == 1){
    address <- gsub(" ", "+", address)
  }else{
    stop("address must be a string of length 1")
  }
  return(address)
}



