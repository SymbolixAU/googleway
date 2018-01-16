#' Google Distance
#'
#' The Google Maps Distance Matrix API is a service that provides travel distance
#' and time for a matrix of origins and destinations, based on the recommended
#' route between start and end points.
#'
#' @param origins Origin locations as either a one or two column data.frame, a
#' list of unnamed elements, each element is either a numeric vector of lat/lon
#' coordinates, an address string or a place_id, or a vector of a pair of lat / lon coordinates
#' @param destinations destination locations as either a one or two column data.frame, a
#' list of unnamed elements, each element is either a numeric vector of lat/lon
#' coordinates, an address string or place_id, or a vector of a pair of lat / lon coordinates
#' @param mode \code{string} One of 'driving', 'walking', 'bicycling' or 'transit'.
#' @param departure_time \code{POSIXct}. Specifies the desired time of departure. Must
#' be in the future (i.e. greater than \code{sys.time()}). If no value is specified
#' it defaults to \code{Sys.time()}
#' @param arrival_time \code{POSIXct}. Specifies teh desired time of arrival. Note you can
#' only specify one of \code{arrival_time} or \code{departure_time}, not both.
#' If both are supplied, \code{departure_time} will be used.
#' @param avoid \code{character} vector stating which features should be avoided.
#' One of 'tolls', 'highways', 'ferries' or 'indoor'
#' @param units \code{string} metric or imperial. Note: Only affects the text displayed
#' within the distance field. The values are always in metric
#' @param traffic_model \code{string}. One of 'best_guess', 'pessimistic' or 'optimistic'.
#' Only valid with a departure time
#' @param transit_mode \code{vector} of strings, either 'bus', 'subway', 'train', 'tram' or 'rail'.
#' Only vaid where \code{mode = 'transit'}. Note that 'rail' is equivalent to
#' \code{transit_mode=c("train", "tram", "subway")}
#' @param transit_routing_preference \code{vector} strings - one of 'less_walking' and
#' 'fewer_transfers'. specifies preferences for transit routes. Only valid for
#' transit directions.
#' @param language \code{string}. Specifies the language in which to return the results.
#' See the list of supported languages: \url{https://developers.google.com/maps/faq#using-google-maps-apis}
#' If no langauge is supplied, the service will attempt to use the language of
#' the domain from which the request was sent
#' @param key \code{string}. A valid Google Developers Distance API key
#' @param simplify \code{logical} - TRUE indicates the returned JSON will be coerced into a list. FALSE indicates the returend JSON will be returned as a string
#' @param curl_proxy a curl proxy object
#' @return Either list or JSON string of the distance between origins and destinations
#' @examples
#' \dontrun{
#'
#' api_key <- 'your_api_key'
#' google_distance(origins = list(c("Melbourne Airport, Australia"),
#'                              c("MCG, Melbourne, Australia"),
#'                              c(-37.81659, 144.9841)),
#'                              destinations = c("Portsea, Melbourne, Australia"),
#'                              key = api_key,
#'                              simplify = FALSE)
#'
#' google_distance(origins = c(-37.816, 144.9841),
#'     destinations = c("Melbourne Airport, Australia", "Flinders Street Station, Melbourne"),
#'     key = api_key)
#'
#' google_distance(origins = tram_stops[1:5, c("stop_lat", "stop_lon")],
#'      destinations = tram_stops[10:12, c("stop_lat", "stop_lon")],
#'      key = api_key)
#'
#' }
#' @export
google_distance <- function(origins,
                            destinations,
                            mode = c('driving','walking','bicycling','transit'),
                            departure_time = NULL,
                            arrival_time = NULL,
                            avoid = NULL,
                            units = c("metric", "imperial"),
                            traffic_model = NULL,
                            transit_mode = NULL,
                            transit_routing_preference = NULL,
                            language = NULL,
                            key = get_api_key("distance"),
                            simplify = TRUE,
                            curl_proxy = NULL){

  origins <- validateLocations(origins)
  destinations <- validateLocations(destinations)

  directions_data(base_url = "https://maps.googleapis.com/maps/api/distancematrix/json?",
                information_type = "distance",
                origin = origins,
                destination = destinations,
                mode,
                departure_time,
                arrival_time,
                waypoints = NULL,
                optimise_waypoints = FALSE,
                alternatives = FALSE,
                avoid,
                units,
                traffic_model,
                transit_mode,
                transit_routing_preference,
                language,
                region = NULL,
                key,
                simplify,
                curl_proxy)

}

validateLocations <- function(locations) UseMethod("validateLocations")

# validateLocations.list <- function(locations) locations
#
#' @export
validateLocations.character <- function(locations) locations


#' @export
validateLocations.numeric <- function(locations) {
  ## a vector has to be put into a list
  if(length(locations) > 2) stop("A vector can have a maximum of two elements")
  list(locations)
}

#' @export
validateLocations.data.frame <- function(locations){

  ## A dataframe can be used, and can be one column or two
  ##
  if(ncol(locations) > 2) stop("A data.frame can have a maximum of two columns")

  ## two-columns indicate lat/lons
  if(ncol(locations) == 2){
    locations <- lapply(1:nrow(locations), function(x) as.numeric(locations[x, ]))
    return(locations)
  }else{
    locations <- lapply(1:nrow(locations), function(x) as.character(locations[x,]))
    return(locations)
  }
}

#' @export
validateLocations.default <- function(locations) locations



