#' Google Distance
#'
#' The Google Maps Distance Matrix API is a service that provides travel distance
#' and time for a matrix of origins and destinations, based on the recommended
#' route between start and end points.
#'
#'
#' @param origins Origin locations as either a one or two column data.frame, a
#' list of unnamed elements, each element is either a numeric vector of lat/lon
#' coordinates, an address string or a place_id, or a vector of a pair of lat / lon coordinates
#' @param destinations destination locations as either a one or two column data.frame, a
#' list of unnamed elements, each element is either a numeric vector of lat/lon
#' coordinates, an address string or place_id, or a vector of a pair of lat / lon coordinates
#' @param mode \code{string} One of 'driving', 'walking', 'bicycling' or 'transit'.
#' @inheritParams google_directions
#' @param transit_routing_preference \code{vector} strings - one of 'less_walking' and
#' 'fewer_transfers'. specifies preferences for transit routes. Only valid for
#' transit directions.
#' @return Either list or JSON string of the distance between origins and destinations
#'
#' @inheritSection google_geocode API use and limits
#'
#' @examples
#' \dontrun{
#'
#' set_key("YOUR_GOOGLE_API_KEY")
#' google_distance(origins = list(c("Melbourne Airport, Australia"),
#'                              c("MCG, Melbourne, Australia"),
#'                              c(-37.81659, 144.9841)),
#'                              destinations = c("Portsea, Melbourne, Australia"),
#'                              simplify = FALSE)
#'
#' google_distance(origins = c(-37.816, 144.9841),
#'     destinations = c("Melbourne Airport, Australia", "Flinders Street Station, Melbourne"))
#'
#' google_distance(origins = tram_stops[1:5, c("stop_lat", "stop_lon")],
#'      destinations = tram_stops[10:12, c("stop_lat", "stop_lon")],)
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



