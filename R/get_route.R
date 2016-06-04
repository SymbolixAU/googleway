#' GetRoute
#'
#' This function is deprecated. Please use \link{google_directions}
#'
#' @param origin numeric Vector of lat/lon coordinates, or an address string
#' @param destination numeric Vector of lat/lon coordinates, or an address string
#' @param mode string. One of 'driving', 'walking', 'bicycling' or 'transit'.
#' @param departure_time POSIXct. Specifies the desired time of departure. Must be in the future (i.e. greater than \code{sys.time()}). If no value is specified it defaults to \code{Sys.time()}
#' @param arrival_time POSIXct. Specifies teh desired time of arrival. Note you can only specify one of \code{arrival_time} or \code{departure_time}, not both. If both are supplied, \code{departure_time} will be used.
#' @param waypoints list of waypoints, expressed as either a \code{vector} of lat/lon coordinates, or a \code{string} address to be geocoded. Only available for transit, walking or bicycling modes. Name the list element 'via' to avoid including a stopover for a waypoint. See \url{https://developers.google.com/maps/documentation/directions/intro#Waypoints} for details
#' @param alternatives logical If set to true, specifies that the Directions service may provide more than one route alternative in the response
#' @param avoid character Vector stating which features should be avoided. One of 'tolls', 'highways', 'ferries' or 'indoor'
#' @param units string metric or imperial. Note: Only affects the text displayed within the distance field. The values are always in metric
#' @param traffic_model string One of 'best_guess', 'pessimistic' or 'optimistic'. Only valid with a departure time
#' @param transit_mode vector of strings, either 'bus', 'subway', 'train', 'tram' or 'rail'. Only vaid where \code{mode = 'transit'}. Note that 'rail' is equivalent to \code{transit_mode=c("train", "tram", "subway")}
#' @param transit_routing_preference vector strings one of 'less_walking' and 'fewer_transfers'. specifies preferences for transit routes. Only valid for transit directions.
#' @param language string specifies the language in which to return the results. See the list of supported languages: \url{https://developers.google.com/maps/faq#using-google-maps-apis} If no langauge is supplied, the service will attempt to use the language of the domain from which the request was sent
#' @param region string Specifies the region code, specified as a ccTLD ("top-level domain"). See region basing for details \url{https://developers.google.com/maps/documentation/directions/intro#RegionBiasing}
#' @param key string A valid Google Developers Directions API key
#' @param output_format string Either 'data.frame' or 'JSON'
#' @return Either data.frame or JSON string of the route between origin and destination
#' @export
get_route <- function(origin,
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
                     key = NULL,
                     output_format = c('data.frame', 'JSON')){

  warning("get_route() is deprecated. Use google_directions() instead.")

  construct_url(base_url = "https://maps.googleapis.com/maps/api/directions/json?",
                information_type = "directions",
                origin,
                destination,
                mode,
                departure_time,
                arrival_time,
                waypoints,
                alternatives,
                avoid,
                units,
                traffic_model,
                transit_mode,
                transit_routing_preference,
                language,
                region,
                key,
                output_format)
}
#   ## parameter check
#   if(is.null(key))
#     stop("A Valid Google Developers API key is required")
#
#   mode <- match.arg(mode)
#   output_format <- match.arg(output_format)
#   units <- match.arg(units)
#   traffic_model <- match.arg(traffic_model)
#
#   ## transit_mode is only valid where mode = transit
#   if(!is.null(transit_mode) & mode != "transit"){
#     warning("You have specified a transit_mode, but are not using mode = 'transit'. Therefore this argument will be ignored")
#     transit_mode <- NULL
#   }else if(!is.null(transit_mode) & mode == "transit"){
#     transit_mode <- match.arg(transit_mode, choices = c("bus","subway","train","tram","rail"))
#   }
#
#   ## transit_routing_preference only valid where mode == transit
#   if(!is.null(transit_routing_preference) & mode != "transit"){
#     warning("You have specified a transit_routing_preference, but are not using mode = 'transit'. Therefore this argument will be ignored")
#     transit_routing_preference <- NULL
#   }else if(!is.null(transit_routing_preference) & mode == "transit"){
#     transit_routing_preference <- match.arg(transit_routing_preference, choices = c("less_walking","fewer_transfers"))
#     transit_routing_preference <- paste0(transit_routing_preference, collapse = "|")
#   }
#
#   ## check avoid is valid
#   if(!all(tolower(avoid) %in% c("tolls","highways","ferries","indoor")) & !is.null(avoid)){
#     stop("avoid must be one of tolls, highways, ferries or indoor")
#   }else{
#     if(length(avoid) > 1){
#       avoid <- paste0(tolower(avoid), collapse = "+")
#     }else{
#       avoid <- tolower(avoid)
#       }
#   }
#
#   ## check departure time is valid
#   if(!is.null(departure_time) & !inherits(departure_time, "POSIXct"))
#     stop("departure_time must be a POSIXct object")
#
#   if(!is.null(departure_time)){
#     if(departure_time < Sys.time()){
#       stop("departure_time must not be in the past")
#     }
#   }
#
#   ## check arrival time is valid
#   if(!is.null(arrival_time) & !inherits(arrival_time, "POSIXct"))
#      stop("arrival_time must be a POSIXct object")
#
#   if(!is.null(arrival_time) & !is.null(departure_time)){
#     warning("you have supplied both an arrival_time and a departure_time - only one is allowed. The arrival_time will be ignored")
#     arrival_time <- NULL
#   }
#
#   ## check alternatives is valid
#   if(!is.logical(alternatives))
#     stop("alternatives must be logical - TRUE or FALSE")
#
#   ## check traffic model is valid
#   if(!is.null(traffic_model) & is.null(departure_time))
#     stop("traffic_model is only accepted with a valid departure_time")
#
#   ## check origin/destinations are valid
#   origin <- fun_check_location(origin, "Origin")
#   destination <- fun_check_location(destination, "Destination")
#
#   ## check departure time is valid
#   departure_time <- ifelse(is.null(departure_time), as.integer(Sys.time()), as.integer(departure_time))
#   arrival_time <- as.integer(arrival_time)
#
#   ## check waypoints are valid
#   if(!is.null(waypoints) & !mode %in% c("driving", "walking","bicycling"))
#     stop("waypoints are only valid for driving, walking or bicycling modes")
#
#   if(!is.null(waypoints) & class(waypoints) != "list")
#     stop("waypoints must be a list")
#
#   if(!is.null(waypoints) & !all(names(waypoints) %in% c("", "via")))
#     stop("'via' is the only valid name for a waypoint element")
#
#   if(!is.null(waypoints)){
#     ## construct waypoint string
#     # waypoints <- paste0(lapply(waypoints, function(x) fun_check_waypoints(x)), collapse = "|")
#
#     waypoints <- sapply(1:length(waypoints), function(x) {
#       if(length(names(waypoints)) > 0){
#         if(names(waypoints)[x] == "via"){
#           paste0("via:", fun_check_location(waypoints[[x]]))
#         }else{
#           fun_check_location(waypoints[[x]])
#         }
#       }else{
#         fun_check_location(waypoints[[x]])
#       }
#     })
#     waypoints <- paste0(waypoints, collapse = "|")
#   }
#
#   ## language check
#   if(!is.null(language) & (class(language) != "character" | length(language) > 1))
#     stop("language must be a single character vector or string")
#
#   ## region check
#   if(!is.null(region) & (class(region) != "character" | length(region) > 1))
#      stop("region must be a two-character string")
#
#   ## construct url
#   map_url <- paste0("https://maps.googleapis.com/maps/api/directions/json?",
#                     "origin=", origin,
#                     "&destination=", destination,
#                     "&waypoints=", waypoints,
#                     "&departure_time=", departure_time,
#                     "&arrival_time=", arrival_time,
#                     "&alternatives=", tolower(alternatives),
#                     "&avoid=", avoid,
#                     "&units=", tolower(units),
#                     "&mode=", tolower(mode),
#                     "&transit_mode=", transit_mode,
#                     "&transit_routing_preference=", transit_routing_preference,
#                     "&language=", tolower(language),
#                     "&region=", tolower(region),
#                     "&key=", key)
#
#   if(length(map_url) > 1)
#     stop("invalid map_url")
#
#   if(output_format == "data.frame"){
#     out <- jsonlite::fromJSON(map_url)
#   }else if(output_format == "JSON"){
#     # out <- readLines(curl::curl(map_url))
#     con <- curl::curl(map_url)
#     out <- readLines(con)
#     close(con)   ## readLines closes a connection, but does not destroy it
#   }
#   return(out)
# }
#
# fun_check_location <- function(loc, type){
#   if(is.numeric(loc) & length(loc) == 2){
#     loc <- paste0(loc, collapse = ",")
#   }else if(is.character(loc) & length(loc) == 1){
#     loc <- gsub(" ", "+", loc)
#   }else{
#     stop(paste0(type, " must be either a numeric vector of lat/lon coordinates, or an address string"))
#   }
#   return(loc)
# }


