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

  logicalCheck(simplify)

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
      avoid <- paste0(tolower(avoid), collapse = "|")
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
  logicalCheck(alternatives)

  if(!is.null(alternatives))
    alternatives <- tolower(alternatives)

  ## check traffic model is valid
  if(!is.null(traffic_model) & is.null(departure_time))
    departure_time <- Sys.time()

#    stop("traffic_model is only accepted with a valid departure_time")

  if(!is.null(traffic_model)){
    ## allow an underscore to pass
    traffic_model <- match.arg(gsub("_", " ", traffic_model), choices = c("best guess", "pessimistic","optimistic"))
    traffic_model <- gsub(" ", "_", traffic_model)
  }

  ## check origin/destinations are valid
  if(information_type == "directions"){
    origin <- check_location(origin, "Origin")
    destination <- check_location(destination, "Destination")
  }else if(information_type == "distance"){
    origin <- check_multiple_locations(origin, "Origins elements")
    destination <- check_multiple_locations(destination, "Destinations elements")
  }

  ## check departure time is valid
  departure_time <- ifelse(is.null(departure_time), as.integer(Sys.time()), as.integer(departure_time))
  arrival_time <- as.integer(arrival_time)

  ## check waypoints are valid
  waypoints <- validateWaypoints(waypoints, optimise_waypoints, mode)

  ## language check
  if(!is.null(language)){
    if(class(language) != "character" | length(language) > 1){
      stop("language must be a single string")
      }
    }

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

  return(downloadData(map_url, simplify, curl_proxy))

}


downloadData <- function(map_url, simplify, curl_proxy = NULL){

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

