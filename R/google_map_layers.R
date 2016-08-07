#' Add markers
#'
#' Add markers to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @param title string specifying the column of \code{data} containing the 'title' of the markers. The title is displayed when you hover over a marker. If blank, no title will be displayed for the markers.
#' @param draggable string specifying the column of \code{data} defining if the marker is 'draggable' (either TRUE or FALSE)
#' @param opacity string specifying the column of \code{data} defining the 'opacity' of the maker. Values must be between 0 and 1 (inclusive).
#' @param label string specifying the column of \code{data} defining the character to appear in the centre of the marker. Values will be coerced to strings, and only the first character will be used.
#' @examples
#' \dontrun{
#'
#' df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
#' -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
#' ), lon = c(144.968612670898, 144.968414306641, 144.968139648438,
#' 144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
#' 97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
#' 77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
#' "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
#'
#' library(magrittr)
#' google_map(key = map_key, data = df_line) %>%
#'  add_markers(lat = "lat", lon = "lon")
#'
#' }
#' @export
add_markers <- function(map,
                        data = get_map_data(map),
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

  if(is.null(lat))
    data <- latitude_column(data, lat, 'add_markers')

  if(is.null(lon))
    data <- longitude_column(data, lon, 'add_markers')

  ## TODO:
  ## - pass other arguments in as an object into javascript?
  ## that way, they can be NULL and ignored on the other side.
  ## - maker options - colour, etc

  ## check columns
  cols <- list(title, draggable, opacity, label)
  col_names <- list('title', 'draggable', 'opacity', 'label')
  allowed_nulls <- c('title', 'draggable', 'opacity', 'label')
  lst <- correct_columns(data, cols, col_names, allowed_nulls)

  data <- lst$df
  cols <- lst$cols

  if(!is.null(title)){
    data[, title] <- as.character(data[, title])
  }

  if(!is.null(draggable)){
    if(!is.logical(data$draggable))
      stop("draggable values must be logical")
  }

  if(!is.null(label)){
    ## must be a string
    data[, label] <- as.character(data[, label])
  }

  check_opacities(data, cols = unique(c(cols$opacity)))

  invoke_method(map, data, 'add_markers',
                data$lat,
                data$lon,
                data[, cols$title],
                data[, cols$opacity],
                data[, cols$draggable],
                data[, cols$label])
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
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @param radius either a string specifying the column of \code{data} containing the 'radius' of each circle, OR a numeric value specifying the radius of all the circles
#' @param stroke_colour either a string specifying the column of \code{data} containing the stroke colour of each circle, Or a valid hexadecimal numeric HTML style to be applied to all the circles
#' @param stroke_opacity desc -- value between 0 and 1
#' @param stroke_weight desc -- width of pixels in line
#' @param fill_colour desc -- Colours should be indicated in hexadecimal numeric HTML style.
#' @param fill_opacity desc -- value between 0 and 1
#' @examples
#' \dontrun{
#'
#' #' df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
#' -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
#' ), lon = c(144.968612670898, 144.968414306641, 144.968139648438,
#' 144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
#' 97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
#' 77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
#' "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
#'
#' library(magrittr)
#' google_map(key = map_key, data = df_line) %>%
#'  add_circles()
#'
#'  }
#' @export
add_circles <- function(map,
                        data = get_map_data(map),
                        lat = NULL,
                        lon = NULL,
                        radius = 100,
                        stroke_colour = '#FF0000',
                        stroke_opacity = 0.8,
                        stroke_weight = 2,
                        fill_colour = '#FF0000',
                        fill_opacity = 0.35){

  if(is.null(lat))
    data <- latitude_column(data, lat, 'add_circles')

  if(is.null(lon))
    data <- longitude_column(data, lon, 'add_circles')

  ## check columns
  cols <- list(radius, stroke_colour, stroke_opacity, stroke_weight, fill_colour, fill_opacity)
  col_names <- list("radius", "stroke_colour", "stroke_opacity", "stroke_weight", "fill_colour", "fill_opacity")
  allowed_nulls <- c()
  lst <- correct_columns(data, cols, col_names, allowed_nulls)

  data <- lst$df
  cols <- lst$cols

  check_hex_colours(data, cols = unique(c(cols$stroke_colour, cols$fill_colour)))
  check_opacities(data, cols = unique(c(cols$stroke_opacity, cols$fill_opacity)))

  invoke_method(map, data, 'add_circles',
                data$lat,
                data$lon,
                data[, cols$radius],
                data[, cols$stroke_colour],
                data[, cols$stroke_opacity],
                data[, cols$stroke_weight],
                data[, cols$fill_colour],
                data[, cols$fill_opacity])
}

#' clear circles
#'
#' clears circles from map
#'
#' @param map googleway map object
#' @export
clear_circles <- function(map){
  invoke_method(map, data = NULL, 'clear_circles')
}


#' Add heatmap
#'
#' Adds a heatmap to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @param weight string specifying the column of \code{data} containing the 'weight' associated with each point. If NULL, each point will get a weight of 1.
#' @param option_dissipating logical Specifies whether heatmaps dissipate on zoom. By default, the radius of influence of a data point is specified by the radius option only. When dissipating is disabled, the radius option is interpreted as a radius at zoom level 0.
#' @param option_radius numeric The radius of influence for each data point, in pixels.
#' @param option_opacity The opacity of the heatmap, expressed as a number between 0 and 1. Defaults to 0.6.
#' @examples
#' \dontrun{
#'
#' #' df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
#' -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
#' ), lon = c(144.968612670898, 144.968414306641, 144.968139648438,
#' 144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
#' 97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
#' 77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
#' "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
#'
#' library(magrittr)
#' google_map(key = map_key, data = df_line) %>%
#'  add_heatmap(lat = "lat", lon = "lon", weight = "weight")
#'
#'  }
#' @export
add_heatmap <- function(map,
                        lat = NULL,
                        lon = NULL,
                        weight = 0.6,
                        data = get_map_data(map),
                        option_dissipating = FALSE,
                        option_radius = 10,
                        option_opacity = 0.6
){


  ## TODO
  ## - gradient
  ## - max intensity

  ## rename the cols so the javascript functions will see them
  if(is.null(lat))
    data <- latitude_column(data, lat, 'add_heatmap')

  if(is.null(lon))
    data <- longitude_column(data, lon, 'add_heatmap')

  ## Heatmap Options
  if(!is.null(option_opacity))
    if(!is.numeric(option_opacity) | (option_opacity < 0 | option_opacity > 1))
      stop("option_opacity must be a numeric between 0 and 1")

  if(!is.null(option_radius))
    if(!is.numeric(option_radius))
      stop("option_radus must be numeric")

  ## Defaults
  # https://developers.google.com/maps/documentation/javascript/reference#HeatmapLayerOptions


  ## check columns
  cols <- list(weight)
  col_names <- list("weight")
  allowed_nulls <- c()
  lst <- correct_columns(data, cols, col_names, allowed_nulls)

  data <- lst$df
  cols <- lst$cols

  heatmap_options <- data.frame(dissipating = option_dissipating,
                                radius = option_radius,
                                opacity = option_opacity)

  invoke_method(map, data, 'add_heatmap',
                data$lat,
                data$lon,
                data[, cols$weight],
                heatmap_options
                )
}


#' update heatmap
#'
#' updates a heatmap layer
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @param weight string specifying the column of \code{data} containing the 'weight' associated with each point. If NULL, each point will get a weight of 1.
#' @export
update_heatmap <- function(map,
                           data = get_map_data(map),
                           lat = NULL,
                           lon = NULL,
                           weight = 0.6){

  ## rename the cols so the javascript functions will see them
  if(is.null(lat))
    data <- latitude_column(data, lat, 'update_heatmap')

  if(is.null(lon))
    data <- longitude_column(data, lon, 'update_heatmap')

  ## check columns
  cols <- list(weight)
  col_names <- list("weight")
  allowed_nulls <- c()
  lst <- correct_columns(data, cols, col_names, allowed_nulls)

  data <- lst$df
  cols <- lst$cols

  invoke_method(map, data, 'update_heatmap',
                data$lat,
                data$lon,
                data[, cols$weight]
                )

}


#' clear heatmap
#'
#' Clears a heatmap layer from a map
#'
#' @param map googleway map object
#' @export
clear_heatmap <- function(map){
  invoke_method(map, data = NULL, 'clear_heatmap')
}

## TODO
## - handle multiple layer calls? bicycling AND transit?

#' Add Traffic
#'
#' Adds live traffic information to a googleway map object
#'
#' @param map a googleway map object created from \code{google_map()}
#' @export
add_traffic <- function(map){
  invoke_method(map, data = NULL, 'add_traffic')
}

#' Clear traffic
#'
#' Clears traffic layer from map
#' @param map a googleway map object created from \code{google_map()}
#' @export
clear_traffic <- function(map){
  invoke_method(map, data = NULL, 'clear_traffic')
}

#' Add transit
#'
#' Adds public transport information to a googleway map object
#'
#' @param map a googleway map object created from \code{google_map()}
#' @export
add_transit <- function(map){
  invoke_method(map, data = NULL, 'add_transit')
}

#' Clear transit
#'
#' Clears transit layer from map
#' @param map a googleway map object
#' @export
clear_transit <- function(map){
  invoke_method(map, data = NULL, 'clear_transit')
}


#' Add bicycling
#'
#' Adds bicycle route information to a googleway map object
#'
#' @param map a googleway map object created from \code{google_map()}
#' @export
add_bicycling <- function(map){
  invoke_method(map, data = NULL, 'add_bicycling')
}

#' Clear bicycling
#'
#' Clears bicycle route layer from map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @export
clear_bicycling <- function(map){
  invoke_method(map, data = NULL, 'clear_bicycling')
}




#' Add polyline
#'
#' Add a polyline to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
add_polyline <- function(map,
                         data,
                         lat = NULL,
                         lon = NULL){
  # ## TODO:
  # ## polylines can be a list of data.frames with lat/lon columns
  # ## or a shape file
  # ## - other options - colours
  # ## rename the cols so the javascript functions will see them
  # if(is.null(lat))
  #   data <- latitude_column(data, lat, 'add_polyline')
  #
  # if(is.null(lon))
  #   data <- longitude_column(data, lon, 'add_polyline')
  #
  # ## check columns
  # cols <- list()
  # col_names <- list()
  # allowed_nulls <- c()
  # lst <- correct_columns(data, cols, col_names, allowed_nulls)
  #
  # data <- lst$df
  # cols <- lst$cols
  #
  # invoke_method(map, data, 'add_polyline',
  #               data$lat,
  #               data$lon
  #               )

}


