#' Add markers
#'
#' Add markers to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @param title string specifying the column of \code{data} containing the 'title' of the markers
#' @param draggable string specifying the column of \code{data} defining if the marker is 'draggable' (either TRUE or FALSE)
#' @param opacity string specifying the column of \code{data} defining the 'opacity' of the maker. Values must be between 0 and 1 (inclusive)
#' @export
add_markers <- function(map,
                        data,
                        lat = NULL,
                        lon = NULL,
                        title = NULL,
                        draggable = NULL,
                        opacity = NULL)
  {

  ## TODO:
  ## - popups/info window

  ## rename the cols so the javascript functions will see them
  data <- latitude_column(data, lat)
  data <- longitude_column(data, lon)

  if(!is.null(title))
    names(data)[names(data) == title] <- "title"

  if(!is.null(opacity)){
    names(data)[names(data) == opacity] <- "opacity"
    if(any(data$opacity < 0) | any(data$opacity > 1))
      stop("opacity values must be between 0 and 1")
  }
  if(!is.null(draggable)){
    names(data)[names(data) == draggable] <- "draggable"
    if(!is.logical(data$draggable))
      stop("draggable values must be logical")
  }

  invoke_method(map, data, 'add_markers', data$lat, data$lng)
  # ## if markers already exist, add to them, don't overwrite
  # if(!is.null(map$x$markers)){
  #   ## they already exist
  #   map$x$markers <- rbind(map$x$markers, data)
  # }else{
  #   ## they don't exist
  #   map$x$markers <- data
  # }
  # return(map)
}


#' clear markers
#'
#' clears markers from map
#'
#' @param map googleway map object
#' @export
clear_markers <- function(map){
  invoke_method(map, data = NULL, 'clear_markers')
}


#' Add circle
#'
#' Add circles to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @export
add_circles <- function(map,
                        data,
                        lat = NULL,
                        lon = NULL
                        ){

  ## TODO:
  ## circle options - radius, storke, opacity, etc.

  data <- latitude_column(data, lat)
  data <- longitude_column(data, lon)

  ## if circles already exist, add to them, don't overwrite
  if(!is.null(map$x$circles)){
    ## they already exist
    map$x$circles <- rbind(map$x$circles, data)
  }else{
    ## they don't exist
    map$x$circles <- data
  }
  return(map)
}

#' Add heatmap
#'
#' Adds a heatmap to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @param weight string specifying the column of \code{data} containing the 'weight' associated with each point. If NULL, each point will get a weight of 1.
#' @param option_dissipating logical Specifies whether heatmaps dissipate on zoom. By default, the radius of influence of a data point is specified by the radius option only. When dissipating is disabled, the radius option is interpreted as a radius at zoom level 0.
#' @param option_radius numeric The radius of influence for each data point, in pixels.
#' @param option_opacity The opacity of the heatmap, expressed as a number between 0 and 1. Defaults to 0.6.
#' @export
add_heatmap <- function(map,
                        data,
                        lat = NULL,
                        lon = NULL,
                        weight = NULL,
                        option_dissipating = FALSE,
                        # gradient = NULL,
                        # maxIntensity = NULL,
                        option_radius = 10,
                        option_opacity = 0.6
                        ){


  ## rename the cols so the javascript functions will see them
  data <- latitude_column(data, lat)
  data <- longitude_column(data, lon)

  ## if no heat provided, assume all == 1
  if(is.null(weight)){
    data$weight <- 1
  }else{
    names(data)[names(data) == weight] <- "weight"
  }

  ## if heatmap already exist, add to them, don't overwrite
  if(!is.null(map$x$heatmap)){
    ## they already exist
    map$x$heatmap <- rbind(map$x$heatmap, data)
  }else{
    ## they don't exist
    map$x$heatmap <- data
  }

  ## sort out options
  map$x$heatmap_options <- data.frame(radius = option_radius,
                                      opacity = option_opacity,
                                      dissapating = option_dissipating)
  return(map)

}


#' Add polyline
#'
#' Add a polyline to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @export
add_polyline <- function(map,
                         data,
                         lat = NULL,
                         lon = NULL){

  ## TODO:
  ## - handle mis-specified lat/lon column names
  ## - other options - colours  ## rename the cols so the javascript functions will see them
  data <- latitude_column(data, lat)
  data <- longitude_column(data, lon)

  ## if polyline already exists, add to it, don't overwrite
  if(!is.null(map$x$polyline)){
    ## already exist
    map$x$polyline <- list(map$x$polyline, data)
  }else{
    map$x$polyline <- data
  }
  return(map)
}


latitude_column <- function(data, lat){
  if(is.null(lat)){
    lat_col <- find_lat_column(names(data), "add_polyline")
    names(data)[names(data) == lat_col[1]] <- "lat"
  }else{
    names(data)[names(data) == lat] <- "lat"
  }
  return(data)
}

longitude_column <- function(data, lon){
  if(is.null(lon)){
    lon_col <- find_lon_column(names(data), "add_polyline")
    names(data)[names(data) == lon_col[1]] <- "lng"
  }else{
    names(data)[names(data) == lon] <- "lng"
  }
  return(data)
}


find_lat_column = function(names, calling_function, stopOnFailure = TRUE) {

  lats = names[grep("^(lat|lats|latitude|latitudes)$", names, ignore.case = TRUE)]

  if (length(lats) == 1) {
    if (length(names) > 1) {
      message("Assuming '", lats, " is the latitude column")
    }
    ## passes
    return(list(lat = lats))
  }

  if (stopOnFailure) {
    stop(paste0("Couldn't infer latitude column for ", calling_function))
  }

  list(lat = NA)
}


find_lon_column = function(names, calling_function, stopOnFailure = TRUE) {

  lons = names[grep("^(lon|lons|lng|lngs|long|longs|longitude|latitudes)$", names, ignore.case = TRUE)]

  if (length(lons) == 1) {
    if (length(names) > 1) {
      message("Assuming '", lons, " is the longitude column")
    }
    ## passes
    return(list(lon = lons))
  }

  if (stopOnFailure) {
    stop(paste0("Couldn't infer latitude/longitude columns for ", calling_function))
  }

  list(lon = NA)
}


# This is taken directly from Rstudio/leaflet. I would like to make use of some of the functions
#
#
#
# add_markers <- function(map, data, lat = NULL, lon = NULL){
#
#   pts = derivePoints(data, lat, lon, missing(lat), missing(lon), "add_markers")
#
#   invokeMethod(
#     map, data, 'add_markers', pts$lat, pts$lon
#   )
# }
#
#
#
# derivePoints = function(data, lat, lon, missingLat, missingLon, funcName) {
#   if (missingLat || missingLon) {
#     if (is.null(data)) {
#       stop("Point data not found; please provide ", funcName,
#            " with data and/or lat/lon arguments")
#     }
#
#     pts = pointData(data)
#     ## pases
#     if (is.null(lon)) lon = pts$lon
#     if (is.null(lat)) lat = pts$lat
#   }
#
#   lat = resolveFormula(lat, data)
#   lon = resolveFormula(lon, data)
#
#   if (is.null(lon) && is.null(lat)) {
#     stop(funcName, " requires non-NULL longitude/latitude values")
#   } else if (is.null(lon)) {
#     stop(funcName, " requires non-NULL longitude values")
#   } else if (is.null(lat)) {
#     stop(funcName, " requires non-NULL latitude values")
#   }
#
#   data.frame(lat = lat, lon = lon)
# }
#
# pointData = function(obj) {
#   UseMethod("pointData")
# }
#
#
# pointData.data.frame = function(obj) {
#   cols = guessLatLongCols(names(obj))
#   ## passes
#   data.frame(
#     lat = obj[[cols$lat]],
#     lon = obj[[cols$lon]]
#   )
# }
#
#
#
# resolveFormula = function(f, data) {
#   if (!inherits(f, 'formula')) return(f)
#   if (length(f) != 2L) stop("Unexpected two-sided formula: ", deparse(f))
#   doResolveFormula(data, f)
# }
#
# doResolveFormula = function(data, f) {
#   UseMethod("doResolveFormula")
# }
#
# doResolveFormula.data.frame = function(data, f) {
#   eval(f[[2]], data, environment(f))
# }
#
#
# evalFormula = function(list, data) {
#   evalAll = function(x) {
#     if (is.list(x)) {
#       structure(lapply(x, evalAll), class = class(x))
#     } else resolveFormula(x, data)
#   }
#   evalAll(list)
# }
#
