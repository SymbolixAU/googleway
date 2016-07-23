#' This is taken directly from Rstudio/leaflet. I would like to make use of some of the functions
#'
#'
#' #' Add Markers
#' #'
#' #' Add Markers to a Google Map objet
#' #'
#' add_markers <- function(map, data, lat = NULL, lon = NULL){
#'
#'   pts = derivePoints(data, lat, lon, missing(lat), missing(lon), "add_markers")
#'
#'   invokeMethod(
#'     map, data, 'add_markers', pts$lat, pts$lon
#'   )
#' }
#'
#'
#'
#' derivePoints = function(data, lat, lon, missingLat, missingLon, funcName) {
#'   if (missingLat || missingLon) {
#'     if (is.null(data)) {
#'       stop("Point data not found; please provide ", funcName,
#'            " with data and/or lat/lon arguments")
#'     }
#'
#'     pts = pointData(data)
#'     ## pases
#'     if (is.null(lon)) lon = pts$lon
#'     if (is.null(lat)) lat = pts$lat
#'   }
#'
#'   lat = resolveFormula(lat, data)
#'   lon = resolveFormula(lon, data)
#'
#'   if (is.null(lon) && is.null(lat)) {
#'     stop(funcName, " requires non-NULL longitude/latitude values")
#'   } else if (is.null(lon)) {
#'     stop(funcName, " requires non-NULL longitude values")
#'   } else if (is.null(lat)) {
#'     stop(funcName, " requires non-NULL latitude values")
#'   }
#'
#'   data.frame(lat = lat, lon = lon)
#' }
#'
#' pointData = function(obj) {
#'   UseMethod("pointData")
#' }
#'
#' #' @export
#' pointData.data.frame = function(obj) {
#'   cols = guessLatLongCols(names(obj))
#'   ## passes
#'   data.frame(
#'     lat = obj[[cols$lat]],
#'     lon = obj[[cols$lon]]
#'   )
#' }
#'
#' guessLatLongCols = function(names, stopOnFailure = TRUE) {
#'
#'   lats = names[grep("^(lat|latitude)$", names, ignore.case = TRUE)]
#'   lons = names[grep("^(lon|lng|long|longitude)$", names, ignore.case = TRUE)]
#'
#'   if (length(lats) == 1 && length(lons) == 1) {
#'     if (length(names) > 2) {
#'       message("Assuming '", lons, "' and '", lats,
#'               "' are latitude and longitude, respectively")
#'     }
#'     ## passes
#'     return(list(lat = lats, lon = lons))
#'   }
#'
#'   if (stopOnFailure) {
#'     stop("Couldn't infer latitude/longitude columns")
#'   }
#'
#'   list(lat = NA, lon = NA)
#' }
#'
#'
#' resolveFormula = function(f, data) {
#'   if (!inherits(f, 'formula')) return(f)
#'   if (length(f) != 2L) stop("Unexpected two-sided formula: ", deparse(f))
#'   print(data)
#'   print(f)
#'   doResolveFormula(data, f)
#' }
#'
#' doResolveFormula = function(data, f) {
#'   UseMethod("doResolveFormula")
#' }
#'
#' doResolveFormula.data.frame = function(data, f) {
#'   eval(f[[2]], data, environment(f))
#' }
#'
#'
#' evalFormula = function(list, data) {
#'   evalAll = function(x) {
#'     if (is.list(x)) {
#'       structure(lapply(x, evalAll), class = class(x))
#'     } else resolveFormula(x, data)
#'   }
#'   evalAll(list)
#' }
#'
