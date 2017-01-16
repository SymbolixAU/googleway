#' Tram stops along tram route 35 in Melbourne
#'
#' A data set containing the latitude and longitude coordinates of tram stops along route 35 in Melbourne.
#'
#' The data is taken from the PTV GTFS data
#'
#' @format A data frame with 41 observations and 4 variables
#' \describe{
#'   \item{stop_id}{unique ID for each stop}
#'   \item{stop_name}{the name of each stop}
#'   \item{stop_lat}{the latitude of the stop}
#'   \item{stop_lon}{the longitude of the stop}
#' }
"tram_stops"

#' Tram Route
#'
#' The latitude and longitude coordinates specifying the path tram 35 follows in Melbourne.
#'
#' The data is taken from the PTV GTFS data
#'
#' @format A data frame with 55 observations and 3 variables
#' \describe{
#'   \item{shape_pt_lat}{the latitude of each point in the route}
#'   \item{shape_pt_lon}{the longitude of each point in the route}
#'   \item{shape_pt_sequence}{the position in the sequence of coordinates for each point}
#' }
"tram_route"
