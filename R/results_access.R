
#' Access Result
#'
#' Methods for accessing specific elements of a Google API query.
#'
#' @param res result from a Google API query
#' @param result the specific field of the result you want to access
#'
#' @examples
#' \dontrun{
#'
#' apiKey <- "your_api_key"
#'
#' ## results returned as a list (simplify == TRUE)
#' lst <- google_directions(origin = c(-37.8179746, 144.9668636),
#'                         destination = c(-37.81659, 144.9841),
#'                         mode = "walking",
#'                         key = apiKey,
#'                         simplify = TRUE)
#'
#' ## results returned as raw JSON character vector
#' js <- google_directions(origin = c(-37.8179746, 144.9668636),
#'                          destination = c(-37.81659, 144.9841),
#'                         mode = "walking",
#'                          key = apiKey,
#'                          simplify = FALSE)
#'
#' access_result(js, "polyline")
#'
#' direction_polyline(js)
#'
#' }
#' @export
access_result <- function(res,
                          result = c("instructions", "routes", "legs", "steps",
                                     "points", "polyline", "coordinates", "address",
                                     "address_components", "geo_place_id", "dist_origins",
                                     "dist_destinations",
                                     "elevation", "elev_location", "place",
                                     "place_name", "next_page", "place_location",
                                     "place_type", "place_hours", "place_open")){
  result <- match.arg(result)
  func <- getFunc(result)

  do.call(func, list(res))
}


# Access Result
#
# @param res response from Google's API
# @param accessor the accessor function required
.access_result <- function(res, accessor) UseMethod(".access_result")

#' @export
.access_result.character <- function(js, accessor) resultJs(js, jsAccessor(accessor))

#' @export
.access_result.list <- function(lst, accessor) resultLst(lst, lstAccessor(accessor))

#' @export
.access_result.default <- function(res, accessor) stopMessage(res)


collapseResult <- function(res) paste0(res, collapse = "")


resultType <- function(res) UseMethod("resultType")

#' @export
resultType.character <- function(res) collapseResult(res)

#' @export
resultType.list <- function(res) return(res)

#' @export
resultType.default <- function(res) stopMessage(res)


resultJs <- function(js, jqr_string) jqr::jq(js, jqr_string)

resultLst <- function(lst, lst_string) eval(parse(text = paste0("lst", lst_string)))

getFunc <- function(res){
  switch(res,
         "routes"              =  "direction_routes",
         "legs"                =  "direction_legs",
         "steps"               =  "direction_steps",
         "points"              =  "direction_points",
         "instructions"        =  "direction_instructions",
         "polyline"            =  "direction_polyline",
         "coordinates"         =  "geocode_coordinates",
         "address"             =  "geocode_address",
         "address_components"  =  "geocode_address_components",
         "geo_place_id"        =  "geocode_place",
         "geo_type"            =  "geocode_type",
         "dist_origins"        =  "distance_origins",
         "dist_destinations"   =  "distance_destinations",
         "dist_elements"       =  "distance_elements",
         "elevation"           =  "elevation",
         "elev_location"       =  "elevation_location",
         "place"               =  "place",
         "place_name"          =  "place_name",
         "next_page"           =  "place_next_page",
         "place_location"      =  "place_location",
         "place_type"          =  "place_type",
         "place_hours"         =  "place_hours",
         "place_open"          =  "place_open",
         "nearest_road_coords" =  "nearest_roads_coordinates")
}


jsAccessor <- function(resType){
  switch(resType,
         "routes"              =  ".routes[]",
         "legs"                =  ".routes[].legs[]",
         "steps"               =  ".routes[].legs[].steps",
         "points"              =  ".routes[].legs[].steps[].polyline.points",
         "instructions"        =  ".routes[].legs[].steps[].html_instructions",
         "polyline"            =  ".routes[].overview_polyline.points",
         "coordinates"         =  ".results[].geometry.location",
         "address"             =  ".results[].formatted_address",
         "address_components"  =  ".results[].address_components[]",
         "geo_place_id"        =  ".results[].place_id",
         "geo_type"            =  ".results[].types[]",
         "dist_origins"        =  ".origin_addresses[]",
         "dist_destinations"   =  ".destination_addresses[]",
         "dist_elements"       =  ".rows[].elements[]",
         "elevation"           =  ".results[].elevation",
         "elev_location"       =  ".results[].location",
         "place"               =  ".results[].place_id",
         "place_name"          =  ".results[].name",
         "place_next_page"     =  ".next_page_token",
         "place_location"      =  ".results[].geometry.location",
         "place_type"          =  ".results[].types",
         "place_hours"         =  ".result[].opening_hours.periods",
         "place_open"          =  ".result[].opening_hours.open_now",
         "nearest_road_coords" =  ".snappedPoints[].location")
}

lstAccessor <- function(resType){
  switch(resType,
         "routes"              =  "[[c('routes')]]",
         "legs"                =  "[[c('routes','legs')]][[1]]",
         "steps"               =  "[[c('routes','legs')]][[1]][['steps']][[1]]",
         "points"              =  "[[c('routes','legs')]][[1]][['steps']]",
         "polyline"            =  "[[c('routes','overview_polyline','points')]]",
         "instructions"        =  "[[c('routes','legs')]][[1]][['steps']]",
         "coordinates"         =  "[[c('results','geometry','location')]]",
         "address"             =  "[[c('results','formatted_address')]]",
         "address_components"  =  "[[c('results','address_components')]][[1]]",
         "geo_place_id"        =  "[[c('results','place_id')]][[1]]",
         "geo_type"            =  "[[c('results','types')]]",
         "dist_origins"        =  "[['origin_addresses']]",
         "dist_destinations"   =  "[['destination_addresses']]",
         "dist_elements"       =  "[[c('rows', 'elements')]]",
         "elevation"           =  "[[c('results','elevation')]]",
         "elev_location"       =  "[[c('results', 'location')]]",
         "place"               =  "[[c('results','place_id')]]",
         "place_name"          =  "[[c('results', 'name')]]",
         "place_next_page"     =  "[['next_page_token']]",
         "place_location"      =  "[[c('results','geometry','location')]]",
         "place_type"          =  "[[c('results','types')]]",
         "place_hours"         =  "[[c('result','opening_hours','periods')]]",
         "place_open"          =  "[[c('result','opening_hours','open_now')]]",
         "nearest_road_coords" =  "[[c('snappedPoints', 'location')]]")
}
