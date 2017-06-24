#' @useDynLib googleway
#' @importFrom Rcpp evalCpp
#' @importFrom jsonlite fromJSON
#' @importFrom curl curl
#' @importFrom grDevices col2rgb
#' @importFrom stats setNames
NULL


#' Pipe
#'
#' Uses the pipe operator (\code{\%>\%}) to chain statements. Useful for adding
#' layers to a \code{google_map}
#'
#' @importFrom magrittr %>%
#' @name %>%
#' @rdname pipe
#' @export
#' @param lhs,rhs A google map and a layer to add to it
#' @examples
#' \dontrun{
#'
#' key <- "your_api_key"
#' google_map(key = key) %>%
#' add_traffic()
#'
#' }
NULL

## build notes
# --use-valgrind
directions_data <- function(base_url,
                            information_type = c("directions","distance"),
                            origin,
                            destination,
                            mode = c('driving','walking','bicycling','transit'),
                            departure_time = NULL,
                            arrival_time = NULL,
                            waypoints = NULL,
                            optimise_waypoints = FALSE,
                            alternatives = FALSE,
                            avoid = NULL,
                            units = c("metric", "imperial"),
                            traffic_model = NULL,
                            transit_mode = NULL,
                            transit_routing_preference = NULL,
                            language = NULL,
                            region = NULL,
                            key,
                            simplify = TRUE,
                            curl_proxy = NULL){

  ## parameter check
  if(is.null(key))
    stop("A Valid Google Developers API key is required")

  mode <- match.arg(mode)
  units <- match.arg(units)
  # traffic_model <- match.arg(traffic_model)

  LogicalCheck(simplify)

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
    stop("avoid can only include tolls, highways, ferries or indoor")
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
  LogicalCheck(alternatives)

  if(!is.null(alternatives))
    alternatives <- tolower(alternatives)

  ## check traffic model is valid
  if(!is.null(traffic_model) & is.null(departure_time))
    stop("traffic_model is only accepted with a valid departure_time")

  if(!is.null(traffic_model)){
    traffic_model <- match.arg(traffic_model, choices = c("best_guess", "pessimistic","optimistic"))
  }

  ## check origin/destinations are valid
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

  if(!is.null(waypoints) & !all(names(waypoints) %in% c("stop", "via")))
    stop("waypoint list elements must be named either 'via' or 'stop'")

  ## check if waypoints should be optimised, and thefore only use 'stop' as a valid waypoint
  if(optimise_waypoints == TRUE){
    if(any(names(waypoints) %in% c("via")))
      stop("waypoints can only be optimised for stopovers. Each waypoint in the list must be named as stop")
  }

  if(!is.null(waypoints)){
    ## construct waypoint string
    # waypoints <- paste0(lapply(waypoints, function(x) fun_check_waypoints(x)), collapse = "|")

    waypoints <- sapply(1:length(waypoints), function(x) {
      if(length(names(waypoints)) > 0){
        if(names(waypoints)[x] == "via"){
          paste0("via:", fun_check_location(waypoints[[x]]))
        }else{
          ## 'stop' is the default in google, and the 'stop' identifier is not needed
          fun_check_location(waypoints[[x]])
        }
      }else{
        fun_check_location(waypoints[[x]])
      }
    })

    if(optimise_waypoints == TRUE){
      waypoints <- paste0("optimize:true|", paste0(waypoints, collapse = "|"))
    }else{
      waypoints <- paste0(waypoints, collapse = "|")
    }
  }

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

  ## construct url
  if(information_type == "directions"){
    args <- c("origin" = origin, "destination" = destination)

  }else if(information_type == "distance"){
    args <- c("origins" = origin, "destinations" = destination)
  }

  args <- c(args, "waypoints" = waypoints,
            "departure_time" = departure_time,
            "arrival_time" = arrival_time,
            "alternatives" = alternatives,
            "avoid" = avoid,
            "units" = units,
            "mode" = mode,
            "transit_mode" = transit_mode,
            "transit_routing_preference" = transit_routing_preference,
            "language" = language,
            "region" = region,
            "key" = key)

  map_url <- constructURL(base_url, args)

  if(length(map_url) > 1)
    stop("invalid map_url")

  return(fun_download_data(map_url, simplify, curl_proxy))

}


fun_download_data <- function(map_url, simplify, curl_proxy = NULL){

  out <- NULL
  ## check map_url is valid
  if(length(map_url) > 1)
    stop("invalid map_url")

  ## check for a valid connection
  if(curl::has_internet() == FALSE)
    stop("Can not retrieve results. No valid internet connection (tested using curl::has_internet() )")

  ## if a proxy has been passed in, use it
  if(!is.null(curl_proxy)){
    con <- curl_proxy(map_url)
    out <- readLines(con)
    close(con)
    if(simplify == TRUE){
      out <- jsonlite::fromJSON(out)
    }
    return(out)
  }

  if(simplify == TRUE){
    out <- jsonlite::fromJSON(map_url)
  }else{
    # out <- readLines(curl::curl(map_url))
    con <- curl::curl(map_url)
    tryCatch({
      out <- readLines(con)
      close(con)
    },
    error = function(cond){
      close(con)
      warning("There was an error downloading results. Please manually check the following URL is valid by entering it into a browswer. If valid, please file a bug report citing this URL (note: your API key has been removed, so you will need to add that back in) \n\n", gsub("key=.*","",map_url), "key=", sep = "")
    })
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

