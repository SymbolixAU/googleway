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

#' Melbourne
#'
#' Polygons for Melbourne and the surrounding area
#'
#' This data set is a subset of the Statistical Area Level 2 (SA2) ASGS
#' Edition 2016 data released by the Australian Bureau of Statistics
#' \url{ http://www.abs.gov.au }
#'
#' The data is realsed under a Creative Commons Attribution 2.5 Australia licence
#' \url{https://creativecommons.org/licenses/by/2.5/au/}
#'
#'
#' @format A data frame with 397 observations and 7 variables
#' \describe{
#'   \item{polygonId}{a unique identifier for each polygon}
#'   \item{pathId}{an identifier for each path that define a polygon}
#'   \item{SA2_NAME}{statistical area 2 name of the polygon}
#'   \item{SA3_NAME}{statistical area 3 name of the polygon}
#'   \item{SA4_NAME}{statistical area 4 name of the polygon}
#'   \item{AREASQKM}{area of the SA2 polygon}
#'   \item{polyline}{encoded polyline that defines each \code{pathId}}
#' }
"melbourne"

#' geo_melbourne
#'
#' GeoJSON data of Melbourne's Inner suburbs.
#'
#' This is a subset of the \code{melbourne} data.
"geo_melbourne"


