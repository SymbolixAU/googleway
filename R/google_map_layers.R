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
#' @param cluster logical indicating if co-located markers should be clustered when the map zoomed out
#' @param info_window string specifying the column of \code{data} containing the text to appear in a pop-up info window above a marker
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
#' google_map(key = map_key, data = df) %>%
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
                        label = NULL,
                        cluster = FALSE,
                        info_window = NULL)
{

  ## TODO:
  ## - popups/info window
  ## - if a feature column (draggable/opacity, etc) is specified, but the
  ## data is null/incorrect

  data <- as.data.frame(data)

  if(is.null(lat)){
    data <- latitude_column(data, lat, 'add_markers')
    lat <- "lat"
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'add_markers')
    lon <- "lng"
  }

  if(!is.logical(cluster))
    stop("cluster must be logical")

  ## TODO:
  ## - pass other arguments in as an object into javascript?
  ## that way, they can be NULL and ignored on the other side.
  ## - maker options - colour, etc

  ## check columns
  cols <- list(title, draggable, opacity, label, info_window)
  col_names <- list('title', 'draggable', 'opacity', 'label', 'info_window')
  allowed_nulls <- c('title', 'draggable', 'opacity', 'label', 'info_window')
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

  if(!is.null(info_window)){
    ## must be a string
    data[, info_window] <- as.character(data[, info_window])
  }

  check_opacities(data, cols = unique(c(cols$opacity)))

  invoke_method(map, data, 'add_markers', cluster,
                data[, lat],
                data[, lon],
                data[, cols$title],
                data[, cols$opacity],
                data[, cols$draggable],
                data[, cols$label],
                data[, cols$info_window])
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
#' @param stroke_colour either a string specifying the column of \code{data} containing the stroke colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing the stroke opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing the stroke weight of each circle, or a number indicating the width of pixels in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data} containing the fill colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing the fill opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
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

  data <- as.data.frame(data)

  if(is.null(lat)){
    data <- latitude_column(data, lat, 'add_circles')
    lat <- "lat"
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'add_circles')
    lon <- "lng"
  }

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
                data[, lat],
                data[, lon],
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
  ## - allow columns to be used for other options
  ## -- e.g., allow a column called 'opacity' to be used as a 'title'
  ## -- rather than 'correct' it

  data <- as.data.frame(data)

  ## rename the cols so the javascript functions will see them
  if(is.null(lat)){
    data <- latitude_column(data, lat, 'add_heatmap')
    lat <- "lat"
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'add_heatmap')
    lon <- "lng"
  }

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
                data[, lat],
                data[, lon],
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

  data <- as.data.frame(data)

  ## rename the cols so the javascript functions will see them
  if(is.null(lat)){
    data <- latitude_column(data, lat, 'update_heatmap')
    lat <- "lat"
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'update_heatmap')
    lon <- "lng"
  }

  ## check columns
  cols <- list(weight)
  col_names <- list("weight")
  allowed_nulls <- c()
  lst <- correct_columns(data, cols, col_names, allowed_nulls)

  data <- lst$df
  cols <- lst$cols

  invoke_method(map, data, 'update_heatmap',
                data[, lat],
                data[, lon],
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
#' @export
add_polyline <- function(map,
                         data,
                         group = NULL,
                         lat = NULL,
                         lon = NULL){
  # ## TODO:
  # ## polylines can be a list of data.frames with lat/lon columns
  # ## or a shape file
  # ## or also an encoded polyline
  # ## - other options - colours
  # ## rename the cols so the javascript functions will see them

  ## First instance: use a dataframe with a grouping variable
  data <- as.data.frame(data)

  if(is.null(lat)){
    data <- latitude_column(data, lat, 'add_polyline')
    lat <- "lat"
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'add_polyline')
    lon <- "lng"
  }

  ## check columns
  cols <- list(group)
  col_names <- list("group")
  allowed_nulls <- c('group')
  lst <- correct_columns(data, cols, col_names, allowed_nulls)

  data <- lst$df
  cols <- lst$cols

  ## put grouped data into a list
  if(!is.null(group)){
    data <- split(data, data[group])
  }else{
    data <- list(data)
  }

  invoke_method(map, data, 'add_polyline', data
               # data$lat,
               # data$lon
                )

}


