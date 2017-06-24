#' Google Distance
#'
#' The Google Maps Distance Matrix API is a service that provides travel distance
#' and time for a matrix of origins and destinations, based on the recommended
#' route between start and end points.
#'
#' @param origins list of unnamed elements, each element is either a numeric
#' vector of lat/lon coordinates, or an address string
#' @param destinations list of unnamed elements, each element is either a vector
#' of lat/lon coordinates, or an address string
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
#' google_distance(origins = list(c("Melbourne Airport, Australia"),
#'                              c("MCG, Melbourne, Australia"),
#'                              c(-37.81659, 144.9841)),
#'                              destinations = c("Portsea, Melbourne, Australia"),
#'                              key = "<your valid api key>",
#'                              simplify = FALSE)
#'
#'
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
                            key,
                            simplify = TRUE,
                            curl_proxy = NULL){

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
