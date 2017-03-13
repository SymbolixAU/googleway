#' Add markers
#'
#' Add markers to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param id string specifying the column containing an identifier for a marker
#' @param colour string specifying the column containing the 'colour' to use for the markers. One of 'red', 'blue', 'green' or 'lavender'.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @param title string specifying the column of \code{data} containing the 'title' of the markers. The title is displayed when you hover over a marker. If blank, no title will be displayed for the markers.
#' @param draggable string specifying the column of \code{data} defining if the marker is 'draggable' (either TRUE or FALSE)
#' @param opacity string specifying the column of \code{data} defining the 'opacity' of the maker. Values must be between 0 and 1 (inclusive).
#' @param label string specifying the column of \code{data} defining the character to appear in the centre of the marker. Values will be coerced to strings, and only the first character will be used.
#' @param cluster logical indicating if co-located markers should be clustered when the map zoomed out
#' @param info_window string specifying the column of data to display in an info window when a polygon is clicked
#' @param mouse_over string specifying the column of data to display when the mouse rolls over the polygon
#' @param mouse_over_group string specifying the column of data specifying which groups of circles to highlight on mouseover
#' @param layer_id single value specifying an id for the layer.
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
                        id = NULL,
                        colour = NULL,
                        lat = NULL,
                        lon = NULL,
                        title = NULL,
                        draggable = NULL,
                        opacity = NULL,
                        label = NULL,
                        cluster = FALSE,
                        info_window = NULL,
                        mouse_over = NULL,
                        mouse_over_group = NULL,
                        layer_id = NULL)
{

  ## TODO:
  ## - popups/info window
  ## - if a feature column (draggable/opacity, etc) is specified, but the
  ## data is null/incorrect
  ## - check for NAs - if any, issue warning

  data <- as.data.frame(data)

  if(is.null(lat)){
    data <- latitude_column(data, lat, 'add_markers')
    lat <- "lat"
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'add_markers')
    lon <- "lng"
  }

  if(!is.null(colour)){
    ## all colours must be either 'red', 'blue' or 'green'
    if(!all((tolower(data[, colour])) %in% c("red","blue","green","lavender")))
      stop("colours must be either red, blue or green")
  }

  markers <- data.frame(lat = data[, lat],
                        lng = data[, lon])

  layer_id <- LayerId(layer_id)

  # markers[, "mouse_over_group"] <- SetDefault(mouse_over_group, "NA", data)
  markers[, "opacity"] <- SetDefault(opacity, 1, data)
  markers[, "colour"] <- SetDefault(colour, "red" , data)

  if(!is.logical(cluster))
    stop("cluster must be logical")

  if(!is.null(id))
    markers[, "id"] <- as.character(data[, id])

  if(!is.null(title))
    markers[, "title"] <- as.character(data[, title])

  if(!is.null(draggable))
    markers[, 'draggable'] <- as.logical(data[, draggable])

  # if(!is.null(opacity))
  #   markers[, 'opacity'] <- as.numeric(data[, opacity])

  if(!is.null(label))
    markers[, 'label'] <- as.character(data[, label])

  if(!is.null(info_window))
    markers[, "info_window"] <- as.character(data[, info_window])

  if(!is.null(mouse_over))
    markers[, "mouse_over"] <- as.character(data[, mouse_over])

  if(!is.null(mouse_over_group))
    markers[, "mouse_over_group"] <- as.character(data[, mouse_over_group])

  # if(sum(is.na(markers)) > 0)
  #   warning("There are some NAs in your data. These may affect the markers that have been plotted.")

  ## colours last as they re-order the data with the merge
  df_colours <- data.frame(colour = c('red', 'blue', 'green', 'lavender'),
                           url = c("http://mt.googleapis.com/vt/icon/name=icons/spotlight/spotlight-poi.png&scale=1",
                                   "https://mts.googleapis.com/vt/icon/name=icons/spotlight/spotlight-waypoint-blue.png&psize=16&font=fonts/Roboto-Regular.ttf&color=ff333333&ax=44&ay=48&scale=1",
                                   "http://mt.google.com/vt/icon?psize=30&font=fonts/arialuni_t.ttf&color=ff304C13&name=icons/spotlight/spotlight-waypoint-a.png&ax=43&ay=48&text=%E2%80%A2",
                                   "http://mt.google.com/vt/icon/name=icons/spotlight/spotlight-ad.png"))

  markers <- merge(markers, df_colours, by.x = "colour", by.y = "colour", all.x = TRUE)



  markers <- jsonlite::toJSON(markers)

  invoke_method(map, data, 'add_markers', markers, cluster, layer_id)
}

#' clear map elements
#'
#' clears elements from a map
#'
#' @note These operations are intended for use in conjunction with \link{google_map_update} in an interactive shiny environment
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param layer_id id value of the layer to be removed from the map
#'
#' @name clear
#' @export
clear_markers <- function(map, layer_id = NULL){

  layer_id <- LayerId(layer_id)

  invoke_method(map, data = NULL, 'clear_markers', layer_id)
}

#' Clear search
#'
#' clears the markers placed on the map after using the search box
#' @param map a googleway map object created from \code{google_map()}
#'
#' @export
clear_search <- function(map){
  invoke_method(map, data = NULL, 'clear_search')
}

#' Update style
#'
#' Updates the map with the given styles
#'
#' @note This function is intended for use with \link{google_map_update} in an interactive shiny environment. You can set the styles of the original map using the \code{styles} argument of \link{google_map}
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param styles JSON string representation of a valid Google Maps styles Array. See the Google documentation for details \url{https://developers.google.com/maps/documentation/javascript/styling}
#' @examples
#' \dontrun{
#'
#'#' style <- '[{"featureType":"all","elementType":"all","stylers":[{"invert_lightness":true},
#' {"saturation":10},{"lightness":30},{"gamma":0.5},{"hue":"#435158"}]},
#' {"featureType":"road.arterial","elementType":"all","stylers":[{"visibility":"simplified"}]},
#' {"featureType":"transit.station","elementType":"labels.text","stylers":[{"visibility":"off"}]}]'
#'
#' google_map(key = "your_api_key") %>%
#'  update_style(styles = style)
#'
#' }
#' @export
update_style <- function(map, styles = NULL){

  if(!is.null(styles))
    jsonlite::validate(styles)

  invoke_method(map, data = NULL, 'update_style', styles)

}


#' Add circle
#'
#' Add circles to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param id string specifying the column containing an identifier for a circle
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @param radius either a string specifying the column of \code{data} containing the radius of each circle, OR a numeric value specifying the radius of all the circles (radius is expressed in metres)
#' @param draggable string specifying the column of \code{data} defining if the circle is 'draggable' (either TRUE or FALSE)
#' @param stroke_colour either a string specifying the column of \code{data} containing the stroke colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing the stroke opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing the stroke weight of each circle, or a number indicating the width of pixels in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data} containing the fill colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing the fill opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param info_window string specifying the column of data to display in an info window when a polygon is clicked
#' @param mouse_over string specifying the column of data to display when the mouse rolls over the polygon
#' @param mouse_over_group string specifying the column of data specifying which groups of circles to highlight on mouseover
#' @param layer_id single value specifying an id for the layer.
#'  layer.
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
#'  add_circles()
#'
#'  }
#' @export
add_circles <- function(map,
                        data = get_map_data(map),
                        id = NULL,
                        lat = NULL,
                        lon = NULL,
                        radius = NULL,
                        draggable = NULL,
                        stroke_colour = NULL,
                        stroke_opacity = NULL,
                        stroke_weight = NULL,
                        fill_colour = NULL,
                        fill_opacity = NULL,
                        mouse_over = NULL,
                        mouse_over_group = NULL,
                        info_window = NULL,
                        layer_id = NULL){

  if(is.null(lat)){
    data <- latitude_column(data, lat, 'add_circles')
    lat <- "lat"
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'add_circles')
    lon <- "lng"
  }

  layer_id <- LayerId(layer_id)

  Circles <- data.frame(lat = data[, lat],
                        lng = data[, lon])


  Circles[, "stroke_colour"] <- SetDefault(stroke_colour, "#FF0000", data)
  Circles[, "stroke_weight"] <- SetDefault(stroke_weight, 1, data)
  Circles[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.8, data)
  Circles[, "radius"] <- SetDefault(radius, 50, data)
  Circles[, "fill_colour"] <- SetDefault(fill_colour, "#FF0000", data)
  Circles[, "fill_opacity"] <- SetDefault(fill_opacity, 0.35, data)
  # Circles[, "mouse_over_group"] <- SetDefault(mouse_over_group, "NA", data)

  ## options
  if(!is.null(id))
    Circles[, "id"] <- as.character(data[, id])

  if(!is.null(draggable))
    Circles[, 'draggable'] <- as.logical(data[, draggable])

  if(!is.null(info_window))
    Circles[, "info_window"] <- as.character(data[, info_window])

  if(!is.null(mouse_over))
    Circles[, "mouse_over"] <- as.character(data[, mouse_over])

  if(!is.null(mouse_over_group))
    Circles[, "mouse_over_group"] <- as.character(data[, mouse_over_group])

  # if(sum(is.na(Circles)) > 0)
  #   warning("There are some NAs in your data. These may affect the circles that have been plotted.")

  Circles <- jsonlite::toJSON(Circles)

  invoke_method(map, data, 'add_circles', Circles, layer_id)
}

#' @rdname clear
#' @export
clear_circles <- function(map, layer_id = NULL){

  layer_id <- LayerId(layer_id)

  invoke_method(map, data = NULL, 'clear_circles', layer_id)
}



#' Update circles
#'
#' Updates specific colours and opacities of specified circles Designed to be used in a shiny application.
#'
#' @note Any circles (as specified by the \code{id} argument) that do not exist in the \code{data} passed into \code{add_circles()} will not be added to the map. This function will only update the circles that currently exist on the map when the function is called.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data.frame containing the new values for the circles
#' @param id string representing the column of \code{data} containing the id values for the circles. The id values must be present in the data supplied to \code{add_circles} in order for the polygons to be udpated
#' @param radius either a string specifying the column of \code{data} containing the radius of each circle, OR a numeric value specifying the radius of all the circles (radius is expressed in metres)
#' @param draggable string specifying the column of \code{data} defining if the circle is 'draggable' (either TRUE or FALSE)
#' @param stroke_colour either a string specifying the column of \code{data} containing the stroke colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing the stroke opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing the stroke weight of each circle, or a number indicating the width of pixels in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data} containing the fill colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing the fill opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param layer_id single value specifying an id for the layer.
#'
#' @export
update_circles <- function(map, data, id,
                           radius = NULL,
                           draggable = NULL,
                           stroke_colour = NULL,
                           stroke_weight = NULL,
                           stroke_opacity = NULL,
                           fill_colour = NULL,
                           fill_opacity = NULL,
                           layer_id = NULL){

  ## TODO: is 'info_window' required, if it was included in the original add_polygons?
  layer_id <- LayerId(layer_id)

  circleUpdate <- data.frame(id = as.character(data[, id]))

  circleUpdate[, "stroke_colour"] <- SetDefault(stroke_colour, "#FF0000", data)
  circleUpdate[, "stroke_weight"] <- SetDefault(stroke_weight, 1, data)
  circleUpdate[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.8, data)
  circleUpdate[, "radius"] <- SetDefault(radius, 50, data)
  circleUpdate[, "fill_colour"] <- SetDefault(fill_colour, "#FF0000", data)
  circleUpdate[, "fill_opacity"] <- SetDefault(fill_opacity, 0.35, data)

  if(!is.null(draggable))
    circleUpdate[, 'draggable'] <- as.logical(data[, draggable])

  circleUpdate <- jsonlite::toJSON(circleUpdate)

  invoke_method(map, data = NULL, 'update_circles', circleUpdate, layer_id)


}

# #' Add Rectangle
# #'
# #' Add rectangle to a google map
# #'
# #' @param map a googleway map object created from \code{google_map()}
# #' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
# #' @param id string specifying the column containing an identifier for a rectangle
# #' @param top_left string specifying the colum containing the top-left point of the rectangle
# #' @param bottom_left string specifying the colum containing the bottom-left point of the rectangle
# #' @param top_right string specifying the colum containing the top-rigth point of the rectangle
# #' @param bottom_right string specifying the colum containing the bottom-right point of the rectangle
# #' @param draggable string specifying the column of \code{data} defining if the rectangle is 'draggable' (either TRUE or FALSE)
# #' @param stroke_colour either a string specifying the column of \code{data} containing the stroke colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the circles
# #' @param stroke_opacity either a string specifying the column of \code{data} containing the stroke opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
# #' @param stroke_weight either a string specifying the column of \code{data} containing the stroke weight of each circle, or a number indicating the width of pixels in the line to be applied to all the circles
# #' @param fill_colour either a string specifying the column of \code{data} containing the fill colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the cirlces
# #' @param fill_opacity either a string specifying the column of \code{data} containing the fill opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
# #' @param info_window string specifying the column of data to display in an info window when a polygon is clicked
# #' @param mouse_over string specifying the column of data to display when the mouse rolls over the polygon
# #' @param mouse_over_group string specifying the column of data specifying which groups of circles to highlight on mouseover
# #' @param layer_id single value specifying an id for the layer.
# google_rectangle <- function(map,
#                              data = get_map_data(map),
#                              id = NULL,
#                              top_left,
#                              bottom_left,
#                              top_right,
#                              bottom_right,
#                              draggable = NULL,
#                              stroke_colour = NULL,
#                              stroke_opacity = NULL,
#                              stroke_weight = NULL,
#                              fill_colour = NULL,
#                              fill_opacity = NULL,
#                              mouse_over = NULL,
#                              mouse_over_group = NULL,
#                              info_window = NULL,
#                              layer_id = NULL){
#
#
#
# }
#
# clear_rectangles <- function(map, layer_id = NULL){
#
#   layer_id <- LayerId(layer_id)
#
#   invoke_method(map, data = NULL, 'clear_rectangles', layer_id)
# }


#' Add heatmap
#'
#' Adds a heatmap to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @param option_gradient vector of colours to use as the gradient colours. All CSS3 named colours are supported (\url{https://www.w3.org/TR/css3-color/#html4}), except for extended named colours (\url{https://www.w3.org/TR/css3-color/#svg-color})
#' @param weight string specifying the column of \code{data} containing the 'weight' associated with each point. If NULL, each point will get a weight of 1.
#' @param option_dissipating logical Specifies whether heatmaps dissipate on zoom. When dissipating is false the radius of influence increases with zoom level to ensure that the color intensity is preserved at any given geographic location. Defaults to false.
#' @param option_radius numeric The radius of influence for each data point, in pixels.
#' @param option_opacity The opacity of the heatmap, expressed as a number between 0 and 1. Defaults to 0.6.
#' @param layer_id single value specifying an id for the layer.
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
#'  add_heatmap(lat = "lat", lon = "lon", weight = "weight")
#'
#'  }
#' @export
add_heatmap <- function(map,
                        data = get_map_data(map),
                        lat = NULL,
                        lon = NULL,
                        weight = NULL,
                        option_gradient = NULL,
                        option_dissipating = FALSE,
                        option_radius = 0.01,
                        option_opacity = 0.6,
                        layer_id = NULL
                        ){


  ## TODO
  ## - gradient
  ## - max intensity
  ## - allow columns to be used for other options
  ## -- e.g., allow a column called 'opacity' to be used as a 'title'
  ## -- rather than 'correct' it

#  data <- as.data.frame(data)

  ## rename the cols so the javascript functions will see them
  if(is.null(lat)){
    data <- latitude_column(data, lat, 'add_heatmap')
    lat <- "lat"
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'add_heatmap')
    lon <- "lng"
  }

  Heatmap <- data.frame(lat = data[, lat],
                        lng = data[, lon])

  layer_id <- LayerId(layer_id)

  Heatmap[, "weight"] <- SetDefault(weight, 1, data)


  ## Heatmap Options
  if(!is.null(option_opacity))
    if(!is.numeric(option_opacity) | (option_opacity < 0 | option_opacity > 1))
      stop("option_opacity must be a numeric between 0 and 1")

  if(!is.null(option_radius))
    if(!is.numeric(option_radius))
      stop("option_radus must be numeric")

  if(!is.null(option_dissipating))
    if(!is.logical(option_dissipating))
      stop("option_dissipating must be logical")

  heatmap_options <- data.frame(dissipating = option_dissipating,
                                radius = option_radius,
                                opacity = option_opacity)

  if(!is.null(option_gradient)){

    heatmap_options$gradient <- list(c('rgba(0, 255, 255, 0)', option_gradient))
  }

  Heatmap <- jsonlite::toJSON(Heatmap)
  heatmap_options <- jsonlite::toJSON(heatmap_options)

  invoke_method(map, data, 'add_heatmap', Heatmap, heatmap_options, layer_id)
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
#' @param layer_id single value specifying an id for the layer.
#' @export
update_heatmap <- function(map,
                           data = get_map_data(map),
                           lat = NULL,
                           lon = NULL,
                           weight = 0.6,
                           layer_id = NULL){

  ## rename the cols so the javascript functions will see them
  if(is.null(lat)){
    data <- latitude_column(data, lat, 'update_heatmap')
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'update_heatmap')
  }

  layer_id <- LayerId(layer_id)

  Heatmap <- data.frame(lat = data[, "lat"],
                        lng = data[, "lng"])

  Heatmap[, "weight"] <- SetDefault(weight, 1, data)

  Heatmap <- jsonlite::toJSON(Heatmap)

  invoke_method(map, data, 'update_heatmap', Heatmap)

}


#' @rdname clear
#' @export
clear_heatmap <- function(map, layer_id = NULL){

  layer_id <- LayerId(layer_id)

  invoke_method(map, data = NULL, 'clear_heatmap', layer_id)
}

#' Add Traffic
#'
#' Adds live traffic information to a googleway map object
#'
#' @param map a googleway map object created from \code{google_map()}
#' @examples
#' \dontrun{
#' library(magrittr)
#'
#' google_map(key = "your_api_key") %>%
#'   add_traffic()
#'
#' }
#' @export
add_traffic <- function(map){
  invoke_method(map, data = NULL, 'add_traffic')
}


#' @rdname clear
#' @export
clear_traffic <- function(map){
  invoke_method(map, data = NULL, 'clear_traffic')
}

#' Add transit
#'
#' Adds public transport information to a googleway map object
#'
#' @param map a googleway map object created from \code{google_map()}
#' @examples
#' \dontrun{
#' library(magrittr)
#'
#' google_map(key = "your_api_key") %>%
#'   add_transit()
#'
#' }
#' @export
add_transit <- function(map){
  invoke_method(map, data = NULL, 'add_transit')
}

#' @rdname clear
#' @export
clear_transit <- function(map){
  invoke_method(map, data = NULL, 'clear_transit')
}


#' Add bicycling
#'
#' Adds bicycle route information to a googleway map object
#'
#' @param map a googleway map object created from \code{google_map()}
#' @examples
#' \dontrun{
#' library(magrittr)
#'
#' google_map(key = "your_api_key") %>%
#'   add_bicycling()
#'
#' }
#' @export
add_bicycling <- function(map){
  invoke_method(map, data = NULL, 'add_bicycling')
}

#' @rdname clear
#' @export
clear_bicycling <- function(map){
  invoke_method(map, data = NULL, 'clear_bicycling')
}


#' Add polyline
#'
#' Add a polyline to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least a \code{polyline} column, or a \code{lat} and a \code{lon} column. If Null, the data passed into \code{google_map()} will be used.
#' @param polyline string specifying the column of \code{data} containing the encoded 'polyline'.
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. Coordinates must be in the order that defines the path.
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. Coordinates must be in the order that defines the path.
#' @param id string specifying the column containing an identifier for a polyline
#' @param geodesic logical
#' @param stroke_colour either a string specifying the column of \code{data} containing the stroke colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing the stroke opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing the stroke weight of each circle, or a number indicating the width of pixels in the line to be applied to all the circles
#' @param info_window string specifying the column of data to display in an info window when a polygon is clicked
#' @param mouse_over string specifying the column of data to display when the mouse rolls over the polygon
#' @param mouse_over_group string specifying the column of data specifying which groups of polylines to highlight on mouseover
#' @param update_map_view logical specifying if the map should re-centre according to the polyline.
#' @param layer_id single value specifying an id for the layer.
#'
#' @note The lines can be generated by either using an encoded polyline, or by a set of lat/lon coordinates.
#' You sould specify either the column containing an encoded polyline, OR the lat / lon colulmns.
#'
#' Using \code{update_map_view = TRUE} for multiple polylines may be slow, so it may be more appropriate to set the view of the map using the location argument of \code{google_map()}
#'
#' @examples
#' \dontrun{
#'
#' ## using lat/lon coordinates
#'
#' map_key <- "your_api_key"
#'
#' google_map(data = tram_route, key = map_key) %>%
#'   add_polylines(lat = "shape_pt_lat", lon = "shape_pt_lon")
#'
#'
#' ## using encoded polyline and various colour / fill options
#' flights <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv')
#' flights$id <- seq_len(nrow(flights))
#'
#'
#' ## encode the routes as polylines
#' lst <- lapply(unique(flights$id), function(x){
#'   lat = c(flights[flights["id"] == x, c("start_lat")], flights[flights["id"] == x, c("end_lat")])
#'   lon = c(flights[flights["id"] == x, c("start_lon")], flights[flights["id"] == x, c("end_lon")])
#'   data.frame(id = x, polyline = gepaf::encodePolyline(data.frame(lat = lat, lon = lon)))
#' })
#'
#' flights <- merge(flights, do.call(rbind, lst), by = "id")
#'
#' ## style is taken from https://snazzymaps.com/style/6617/dark-greys
#'
#' map_key <- "your_api_key"
#' google_map(key = map_key, style = style) %>%
#'   add_polylines(data = flights, polyline = "polyline", mouse_over_group = "airport1",
#'                stroke_weight = 1, stroke_opacity = 0.3, stroke_colour = "#ccffff")
#'
#'
#' }
#' @export
add_polylines <- function(map,
                          data = get_map_data(map),
                          polyline = NULL,
                          lat = NULL,
                          lon = NULL,
                          id = NULL,
                          geodesic = NULL,
                          stroke_colour = NULL,
                          stroke_weight = NULL,
                          stroke_opacity = NULL,
                          info_window = NULL,
                          mouse_over = NULL,
                          mouse_over_group = NULL,
                          update_map_view = TRUE,
                          layer_id = NULL){

  # data <- createJSON(data)
  #
  # print(data)

  ## The JSON that gets sent to the JS contains EITHER
  ## 1. an encoded polyline, where each row of a data.frame is a path
  ## 2. a data.frame of coordinates, plus a data.frame of attributes




  # ## TODO:
  # ## polylines can be a list of data.frames with lat/lon columns
  # ## or a shape file
  # ## or also an encoded polyline
  # ## - other options - colours
  # ## rename the cols so the javascript functions will see them

  ## checks on group_options
  ## - each 'group' id has a corresponding option
  ## -- if not, use a 'default' colour
  ##
  if(is.null(polyline) & (is.null(lat) | is.null(lon)))
    stop("please supply the either the column containing the polylines, or the lat/lon coordinate columns")

  if(!is.null(polyline) & (!is.null(lat) | !is.null(lon)))
    stop("please use either a polyline colulmn, or lat/lon coordinate columns, not both")

  if(!is.logical(update_map_view))
    stop("update_map_view must be TRUE or FALSE")


  # if("SpatialLinesDataFrame" %in% class(data)){
  #   ## extract all the stuff?
  #   print("spatial object")
  #   usePolyline <- FALSE
  #
  # }

  if(inherits(data, "data.frame")){
    if(!is.null(polyline)){
      ## polyline specified
      polyline <- data[, polyline, drop = FALSE]
      polyline <- stats::setNames(polyline, "polyline")
      usePolyline <- TRUE

    }else{

      usePolyline <- FALSE
      dataLatLng <- data

      if(is.null(lat)){
        dataLatLng <- latitude_column(dataLatLng, lat, 'add_polylines')
        lat <- "lat"
      }

      if(is.null(lon)){
        dataLatLng <- longitude_column(dataLatLng, lon, 'add_polylines')
        lon <- "lng"
      }

      data <- unique(dataLatLng[, !names(dataLatLng) %in% c(lat, lon), drop = FALSE])
      polyline <- data
    }
  }


  ### IF using POLYLINES, there should be one row per line
  ### IF using COORDINATES, there will be many rows per line,
  ### - which means thee attributes may be repeated, and there could be values such
  ### - as 'point sequence', that need to be accounted for.

  ## so, need to construct the 'attributes' differently for different types of lines
  ## the COORDINATES need to take all the attributes and 'unique' them, but these
  ## will only be the attributes available in the function arguments list, and they must be unique
  ## per line id.

  layer_id <- LayerId(layer_id)


  ## if an id has been supplied, we need to aggregate the lat / lon by the id
  if(!is.null(id))
    polyline[, "id"] <- as.character(data[, id])


  ## using polyline ==> using one row per line (continue with 'polyline')
  ## using lat/lon ==> using many rows per line
  ## use a list to store the coordinates
  if(usePolyline == FALSE){

    ## if no id field has been specified, treat all the coordinates as one line
    if(is.null(id)){
      message("No 'id' value defined, assuming one continuous line")
      dataLatLng[, 'id'] <- "1"
      polyline[, 'id'] <- "1"
    }

    lst_polyline <- lapply(unique(dataLatLng[, 'id']), function(x) {
      list(id = x,
           coords = data.frame(lat = dataLatLng[dataLatLng['id'] == x, lat],
                               lng = dataLatLng[dataLatLng['id'] == x, lon])
      )
    })

    js_polyline <- jsonlite::toJSON(lst_polyline)
  }else{
    js_polyline <- ""
  }

  ## the defaults are required
  polyline[, "geodesic"] <- SetDefault(geodesic, TRUE, data)
  polyline[, "stroke_colour"] <- SetDefault(stroke_colour, "#0000FF", data)
  polyline[, "stroke_weight"] <- SetDefault(stroke_weight, 2, data)
  polyline[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.6, data)

  ## options
  if(!is.null(mouse_over))
    polyline[, "mouse_over"] <- as.character(data[, mouse_over])

  if(!is.null(mouse_over_group))
    polyline[, "mouse_over_group"] <- as.character(data[, mouse_over_group])

  if(!is.null(info_window))
    polyline[, "info_window"] <- as.character(data[, info_window])

  # if(sum(is.na(polyline)) > 0)
  #   warning("There are some NAs in your data. These may affect the polylines that have been plotted.")

  ## strip any unnecessary columns
  if(usePolyline == FALSE){
    ## using coordinates
    polyline <- unique(stripColumns(polyline))

    ## do a check for more rows than ids
    if(nrow(polyline) != length(unique(polyline[, 'id'])))
      warning("There are more distinct attributes than there are lines. This may cause issues with your plot
              It is likely you have different colour/fill/opacity values for the same line,
              or you haven't specified an id value for the different lines")

  }

  polyline <- jsonlite::toJSON(polyline)

  invoke_method(map, data, 'add_polylines', polyline, update_map_view, layer_id, usePolyline, js_polyline)
}






#' @rdname clear
#' @export
clear_polylines <- function(map, layer_id = NULL){

  layer_id <- LayerId(layer_id)

  invoke_method(map, data = NULL, 'clear_polylines', layer_id)
}

#' Add polygon
#'
#' Add a polygon to a google map.
#'
#' @note A polygon represents an area enclosed by a closed path. Polygon objects are similar to polylines in that htey consist of a series of coordinates in an ordered sequence.
#' Polygon objects can describe complex shapes, including
#'
#' * Multiple non-contiguous areas defined by a single polygon
#'
#' * Areas wwith holes in them
#'
#' * Intersections of one or more areas
#'
#' To define a complex shape, you use a polygon with multiple paths.
#'
#' To create a hole in a polygon, you need to create two paths, one inside the other.
#' To create the hole, the coordinates of the inner path must be in the opposite
#' order to those defining the outer path. For example, if the coordinates of
#' the outer path are in clockwise order, then the inner path must be anit-clockwise.
#'
#' To represent a complex polygon the data.frame column containing the polylines should be a list,
#' where each polyline that is used to create the polygon is in the same row of the data.frame
#' See examples.
#'
#' @examples
#' \dontrun{
#'
#' ##polygon with a hole - Bermuda triangle
#' ## to encode the polylines I'm currenlty using `library(gepaf)`
#' pl_outer <- gepaf::encodePolyline(data.frame(lat = c(25.774, 18.466,32.321),
#'       lng = c(-80.190, -66.118, -64.757)))
#'
#'pl_inner <- gepaf::encodePolyline(data.frame(lat = c(28.745, 29.570, 27.339),
#'        lng = c(-70.579, -67.514, -66.668)))
#'
#' df <- data.frame(id = c(1,1),
#'        polyline = c(pl_outer, pl_inner),
#'        stringsAsFactors = FALSE)
#'
#' df <- aggregate(polyline ~ id, data = df, list)
#'
#' google_map(key = map_key, height = 800, location = c(25.774, -80.190), zoom = 3) %>%
#'     add_polygons(data = df, polyline = "polyline", mouse_over = "polyline")
#'
#'
#' }
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param polyline string specifying the column containing the polyline
#' @param id string specifying the column containing an identifier for a polygon. Used when calling \code{update_polygons} so that specific polygons can be updated
#' @param stroke_colour either a string specifying the column of \code{data} containing the stroke colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing the stroke opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing the stroke weight of each circle, or a number indicating the width of pixels in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data} containing the fill colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing the fill opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param info_window string specifying the column of data to display in an info window when a polygon is clicked
#' @param mouse_over string specifying the column of data to display when the mouse rolls over the polygon
#' @param mouse_over_group string specifying the column of data specifying which groups of polygons to highlight on mouseover
#' @param update_map_view logical specifying if the map should re-centre according to the polyline.
#' @param layer_id single value specifying an id for the layer.
#' @export
add_polygons <- function(map,
                        data = get_map_data(map),
                        polyline,
                        id = NULL,
                        stroke_colour = NULL,
                        stroke_weight = NULL,
                        stroke_opacity = NULL,
                        fill_colour = NULL,
                        fill_opacity = NULL,
                        info_window = NULL,
                        mouse_over = NULL,
                        mouse_over_group = NULL,
                        update_map_view = TRUE,
                        layer_id = NULL
                        ){

  ## TODO
  ## - other data foramts
  ## -- e.g. geoJSON
  ## -- allow addition of other attributes (however, how will the user access them?)
  ## checks for missing column names
  if(is.null(polyline))
    stop("please supply the column containing the polylines")

  if(!is.logical(update_map_view))
    stop("update_map_view must be TRUE or FALSE")

  if(!is.list(data[, polyline])){
    polygon <- data.frame(polyline = I(as.list(as.character(data[, polyline]))))
  }else{
    polygon <- data[, polyline, drop = FALSE]
  }
#
#   if(sum(sapply(polygon[, polyline], is.null)) > 0){
#     warning("There are some NULL polyline values. These polygons are removed from the map")
#     print(str(polygon))
#     polygon <- polygon[!sapply(polygon[, polyline], is.null)]
#   }

  layer_id <- LayerId(layer_id)

  polygon <- stats::setNames(polygon, "polyline")

  ## the defaults are required
  polygon[, "stroke_colour"] <- SetDefault(stroke_colour, "#0000FF", data)
  polygon[, "stroke_weight"] <- SetDefault(stroke_weight, 1, data)
  polygon[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.6, data)
  polygon[, "fill_colour"] <- SetDefault(fill_colour, "#FF0000", data)
  polygon[, "fill_opacity"] <- SetDefault(fill_opacity, 0.35, data)
  # polygon[, "mouse_over_group"] <- SetDefault(mouse_over_group, "NA", data)

  ## options
  if(!is.null(id))
    polygon[, "id"] <- as.character(data[, id])

  if(!is.null(info_window))
    polygon[, "info_window"] <- as.character(data[, info_window])

  if(!is.null(mouse_over))
    polygon[, "mouse_over"] <- as.character(data[, mouse_over])

  if(!is.null(mouse_over_group))
    polygon[, "mouse_over_group"] <- as.character(data[, mouse_over_group])

  # if(sum(is.na(polygon)) > 0)
  #   warning("There are some NAs in your data. These may affect the polygons that have been plotted.")

  polygon <- jsonlite::toJSON(polygon)

  invoke_method(map, data, 'add_polygons', polygon, update_map_view, layer_id)
}


#' Update polygons
#'
#' Updates specific colours and opacities of specified polygons. Designed to be used in a shiny application.
#'
#' @note Any polygons (as specified by the \code{id} argument) that do not exist in the \code{data} passed into \code{add_polygons()} will not be added to the map. This function will only update the polygons that currently exist on the map when the function is called.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data.frame containing the new values for the polygons
#' @param id string representing the column of \code{data} containing the id values for the polygons. The id values must be present in the data supplied to \code{add_polygons} in order for the polygons to be udpated
#' @param polyline string specifying the column containing the polyline. Only used if \code{add_extra} is TRUE
#' @param stroke_colour either a string specifying the column of \code{data} containing the stroke colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing the stroke opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing the stroke weight of each circle, or a number indicating the width of pixels in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data} containing the fill colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing the fill opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param layer_id single value specifying an id for the layer.
#'
#' @export
update_polygons <- function(map, data, id,
                            polyline = NULL,
                            stroke_colour = NULL,
                            stroke_weight = NULL,
                            stroke_opacity = NULL,
                            fill_colour = NULL,
                            fill_opacity = NULL,
                            layer_id = NULL
                            ){

  ## TODO: is 'info_window' required, if it was included in the original add_polygons?

  if(!is.null(polyline)){
    if(!is.list(data[, polyline])){
      polygonUpdate <- data.frame(polyline = I(as.list(as.character(data[, polyline]))))
    }else{
      polygonUpdate <- data[, polyline, drop = FALSE]
    }
  }

  layer_id <- LayerId(layer_id)

  polygonUpdate[, "id"] <- as.character(data[, id])

  polygonUpdate[, "stroke_colour"] <- SetDefault(stroke_colour, "#0000FF", data)
  polygonUpdate[, "stroke_weight"] <- SetDefault(stroke_weight, 1, data)
  polygonUpdate[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.6, data)
  polygonUpdate[, "fill_colour"] <- SetDefault(fill_colour, "#FF0000", data)
  polygonUpdate[, "fill_opacity"] <- SetDefault(fill_opacity, 0.35, data)
  # polygonUpdate[, "mouse_over_group"] <- SetDefault(mouse_over_group, "NA", data)

  # if(!is.null(info_window))
  #   polygonUpdate[, "info_window"] <- as.character(data[, info_window])
  #
  # if(!is.null(mouse_over))
  #   polygonUpdate[, "mouse_over"] <- as.character(data[, mouse_over])
  #
  # if(!is.null(mouse_over_group))
  #   polygonUpdate[, "mouse_over_group"] <- as.character(data[, mouse_over_group])

  polygonUpdate <- jsonlite::toJSON(polygonUpdate)

  invoke_method(map, data = NULL, 'update_polygons', polygonUpdate, layer_id)

}

#' @rdname clear
#' @export
clear_polygons <- function(map, layer_id = NULL){

  layer_id <- LayerId(layer_id)

  invoke_method(map, data = NULL, 'clear_polygons', layer_id)
}



#' Add KML
#'
#' Adds a kml layer to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param kml_data kml data layer
#' @param layer_id single value specifying an id for the layer.
#'
#' @export
add_kml <- function(map,
                    kml_data,
                    layer_id = NULL){

  kmlData <- kml_data

  layer_id <- LayerId(layer_id)

  invoke_method(map, data = NULL, 'add_kml', kmlData, layer_id)

}

#' Clear kml
#'
#' Clears a kml layer from the map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param layer_id single value specifying an id for the layer
#' @export
clear_kml <- function(map, layer_id = NULL){

  layer_id <- LayerId(layer_id)

  invoke_method(map, data = NULL, 'clear_kml', layer_id)
}


