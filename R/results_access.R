
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
                                     "points", "polyline", "coordinates", "address")){
  result <- match.arg(result)
  func <- getFunc(result)

  do.call(func, list(res))
}

.access_result <- function(res, accessor) UseMethod(".access_result")

#' @export
.access_result.character <- function(js, accessor) resultJs(js, jsAccessor(accessor))

#' @export
.access_result.list <- function(lst, accessor) resultLst(lst, lstAccessor(accessor))

#' @export
.access_result.default <- function(res, accessor) stopMessage(res)

getFunc <- function(res){
  switch(res,
         "instructions"   =  "direction_instructions",
         "routes"         =  "direction_routes",
         "legs"           =  "direction_legs",
         "steps"          =  "direction_steps",
         "points"         =  "direction_points",
         "polyline"       =  "direction_polyline",
         "coordinates"    =  "geocode_coordinates",
         "address"        =  "geocode_address")
}

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

jsAccessor <- function(resType){
  switch(resType,
         "routes"       =  ".routes[]",
         "legs"         =  ".routes[].legs[]",
         "steps"        =  ".routes[].legs[].steps",
         "points"       =  ".routes[].legs[].steps[].polyline.points",
         "polyline"     =  ".routes[].overview_polyline.points",
         "instructions" =  ".routes[].legs[].steps[].html_instructions",
         "coordinates"  =  ".results[].geometry.location",
         "address"      =  ".results[].formatted_address")
}

lstAccessor <- function(resType){
  switch(resType,
         "routes"       = "[['routes']]",
         "legs"         = "[['routes']][['legs']][[1]]",
         "steps"        = "[['routes']][['legs']][[1]][['steps']][[1]]",
         "polints"      = "[['routes']][['legs']][[1]][['steps']][[1]][['polyline']][['points']]",
         "polyline"     = "[['routes']][['overview_polyline']][['points']]",
         "instructions" = "[['routes']][['legs']][[1]][['steps']][[1]][['html_instructions']]",
         "coordinates"  = "[['results']][['geometry']][['location']]",
         "address"      = "[['results']][['formatted_address']]")
}
