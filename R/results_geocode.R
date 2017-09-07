
#' @describeIn access_result the coordinates from a geocode or reverse geocode query
#' @export
geocode_coordinates <- function(res) .access_result(resultType(res), "coordinates")

#' @describeIn access_result the formatted address from a geocode or reverse geocode query
#' @export
geocode_address <- function(res) .access_result(resultType(res), "address")

#' @describeIn access_result the address components from a geocode or reverse geocode query
#' @export
geocode_address_components <- function(res) .access_result(resultType(res), "address_components")

#' @describeIn access_result the place id from a geocode or reverse geocode query
#' @export
geocode_place <- function(res) .access_result(resultType(res), "geo_place_id")

#' @describeIn access_result the geocoded place types from a geocode or reverse geocode query
#' @export
geocode_type <- function(res) .access_result(resultType(res), "geo_type")



## TODO:
## - sepecific address types
 # c("street_address", "route", "intersection", "political", "country", "administrative_area_level_1",
 #  "administrative_area_level_2", "administrative_area_level_3", "administrative_area_level_4",
 #  "administrative_area_level_5", "colloquial_area", "locality", "ward", "sublocality",
 #  "sublocality_level_1", "sublocality_level_2", "sublocality_level_3", "sublocality_level_4",
 #  "sublocality_level_5", "neighbourhood", "premise", "subpremise", "postal_code",
 #  "natural_feature", "airport", "park", "point_of_interest")
