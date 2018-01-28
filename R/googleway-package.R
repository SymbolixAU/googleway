
## TODO:
## - plot bbox as rectangle (if requested?)

#' @useDynLib googleway
#' @importFrom Rcpp sourceCpp
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

  if(is.null(key))
    stop("A Valid Google Developers API key is required")

  mode <- match.arg(mode)
  units <- match.arg(units)

  logicalCheck(simplify)
  avoid <- validateAvoid(avoid)

  transit_mode <- validateTransitMode(transit_mode, mode)
  transit_routing_preference <- validateTransitRoutingPreference(transit_routing_preference, mode)

  departure_time <- validateDepartureTime(departure_time)

  arrival_time <- validateArrivalTime(arrival_time)
  arrival_time <- validateArrivalDepartureTimes(arrival_time, departure_time)

  alternatives <- validateAlternatives(alternatives)

  if(!is.null(traffic_model) & is.null(departure_time))
    departure_time <- Sys.time()

  traffic_model <- validateTrafficModel(traffic_model)

  ## check origin/destinations are valid
  if(information_type == "directions"){
    origin <- check_location(origin, "Origin")
    destination <- check_location(destination, "Destination")
  }else if(information_type == "distance"){
    origin <- check_multiple_locations(origin, "Origins elements")
    destination <- check_multiple_locations(destination, "Destinations elements")
  }

  ## times as integers
  departure_time <- ifelse(is.null(departure_time), as.integer(Sys.time()), as.integer(departure_time))
  arrival_time <- as.integer(arrival_time)

  waypoints <- validateWaypoints(waypoints, optimise_waypoints, mode)
  language <- validateLanguage(language)
  region <- validateRegion(region)

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
            "traffic_model" = traffic_model,
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

