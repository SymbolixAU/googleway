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
#' @param label string specifying the column of \code{data} defining the character to appear in the centre of the marker. Values will be coerced to strings, and only the first character will be used.
#' @export
add_markers <- function(map,
                        data,
                        lat = NULL,
                        lon = NULL,
                        title = NULL,
                        draggable = NULL,
                        opacity = NULL,
                        label = NULL)
  {

  ## TODO:
  ## - popups/info window
  ## - if a feature column (draggable/opacity, etc) is specified, but the
  ## data is null/incorrect

  ## rename the cols so the javascript functions will see them
  data <- latitude_column(data, lat, 'add_markers')
  data <- longitude_column(data, lon, 'add_markers')

  ## check columns
  check_for_columns(data, c(title, draggable, opacity))

  if(!is.null(title)){
  #   names(data)[names(data) == title] <- "title"
    ## must be character
    data[, title] <- as.character(data[, title])
  }

  if(!is.null(opacity)){
    # names(data)[names(data) == opacity] <- "opacity"
    if(any(data$opacity < 0) | any(data$opacity > 1))
      stop("opacity values must be between 0 and 1")
  }

  if(!is.null(draggable)){
    #names(data)[names(data) == draggable] <- "draggable"
    if(!is.logical(data$draggable))
      stop("draggable values must be logical")
  }

  if(!is.null(label)){
    #names(data)[names(data) == label] <- "label"
    ## must be a string
    data[, label] <- as.character(data[, label])
  }

  data <- correct_columns(data, c(title, opacity, draggable, label))
  print(head(data))

  ## TODO:
  ## pass other arguments in as an object into javascript?
  ## that way, they can be NULL and ignored on the other side.
  invoke_method(map, data, 'add_markers', data$lat, data$lng, data[, title],
                data[, opacity], data[, draggable], data[, label])
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
#' @param radius string specifying the column of \code{data} containing the 'radius' of each circle
#' @export
add_circles <- function(map,
                        data,
                        lat = NULL,
                        lon = NULL,
                        radius = NULL
                        ){

  ## TODO:
  ## circle options - radius, storke, opacity, etc.

  data <- latitude_column(data, lat, 'add_circles')
  data <- longitude_column(data, lon, 'add_circles')

  ## check columns
  check_for_columns(data, c(radius))

  if(!is.null(radius)){
    if(!is.numeric(data[, radius]))
      stop("radius must be numeric")
  }

  correct_columns(data, c(radius))

  invoke_method(map, data, 'add_circles', data$lat, data$lng, data[, radius])

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
                        option_radius = 10
                        # option_opacity = 0.6
                        ){


  ## rename the cols so the javascript functions will see them
  data <- latitude_column(data, lat, 'add_heatmap')
  data <- longitude_column(data, lon, 'add_heatmap')

  ## check columns
  check_for_columns(data, c(weight))

  ## if no heat provided, assume all == 1
  if(is.null(weight))
    data$weight <- 1

  correct_columns(data, c(weight))

  heatmap_options <- data.frame(dissipating = option_dissipating,
                                radius = option_radius)

  invoke_method(map, data, 'add_heatmap', data$lat, data$lng, data[, weight],
                heatmap_options)
}

#' update heatmap
#'
#' updates a heatmap layer
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude.
#' @export
update_heatmap <- function(map, data, lat = NULL, lon = NULL){

  ## rename the cols so the javascript functions will see them
  data <- latitude_column(data, lat, 'update_heatmap')
  data <- longitude_column(data, lon, 'update_heatmap')

  invoke_method(map, data, 'update_heatmap', data$lat, data$lng)

}


#' clear heatmap
#'
#' clears heatmap layer from map
#'
#' @param map googleway map object
#' @export
clear_heatmap <- function(map){
  invoke_method(map, data = NULL, 'clear_heatmap')
}

#' Add Traffic
#'
#' Adds traffic information to a map
#' @param map a googleway map object created from \code{google_map()}
#' @export
add_traffic <- function(map){
  invoke_method(map, data = NULL, 'add_traffic')
}

#' Clear traffic
#'
#' Clears traffic layer from map
#' @param map a googleway map object
#' @export
clear_traffic <- function(map){
  invoke_method(map, data = NULL, 'clear_traffic')
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


latitude_column <- function(data, lat, calling_function){
  if(is.null(lat)){
    lat_col <- find_lat_column(names(data), calling_function)
    names(data)[names(data) == lat_col[1]] <- "lat"
  }else{
    names(data)[names(data) == lat] <- "lat"
  }
  return(data)
}

longitude_column <- function(data, lon, calling_function){
  if(is.null(lon)){
    lon_col <- find_lon_column(names(data), calling_function)
    names(data)[names(data) == lon_col[1]] <- "lng"
  }else{
    names(data)[names(data) == lon] <- "lng"
  }
  return(data)
}


find_lat_column = function(names, calling_function, stopOnFailure = TRUE) {

  lats = names[grep("^(lat|lats|latitude|latitudes)$", names, ignore.case = TRUE)]

  if (length(lats) == 1) {
    # if (length(names) > 1) {
    #   message("Assuming '", lats, " is the latitude column")
    # }
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
    # if (length(names) > 1) {
    #   message("Assuming '", lons, " is the longitude column")
    # }
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
