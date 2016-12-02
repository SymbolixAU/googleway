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
#' @param info_window string specifying the column of data to display in an info window when a polygon is clicked
#' @param mouse_over string specifying the column of data to display when the mouse rolls over the polygon
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
                        info_window = NULL,
                        mouse_over = NULL)
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

  markers <- data.frame(lat = data[, lat],
                        lng = data[, lon])

  if(!is.logical(cluster))
    stop("cluster must be logical")

  if(!is.null(title))
    markers[, "title"] <- as.character(data[, title])

  if(!is.null(draggable))
    markers[, 'draggable'] <- as.logical(data[, draggable])

  if(!is.null(opacity))
    markers[, 'opacity'] <- as.numeric(data[, opacity])

  if(!is.null(label))
    markers[, 'label'] <- as.character(data[, label])

  if(!is.null(info_window))
    markers[, "info_window"] <- as.character(data[, info_window])

  if(!is.null(mouse_over))
    markers[, "mouse_over"] <- as.character(data[, mouse_over])

  markers <- jsonlite::toJSON(markers)

  invoke_method(map, data, 'add_markers', markers, cluster)
}

#' clear map elements
#'
#' clears elements from a map
#'
#' @note These operations are intended for use in conjunction with \link{google_map_update} in an interactive shiny environment
#'
#' @param map a googleway map object created from \code{google_map()}
#'
#' @name clear
#' @export
clear_markers <- function(map){
  invoke_method(map, data = NULL, 'clear_markers')
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
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
#' @param radius either a string specifying the column of \code{data} containing the 'radius' of each circle, OR a numeric value specifying the radius of all the circles
#' @param stroke_colour either a string specifying the column of \code{data} containing the stroke colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing the stroke opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing the stroke weight of each circle, or a number indicating the width of pixels in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data} containing the fill colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing the fill opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param info_window string specifying the column of data to display in an info window when a polygon is clicked
#' @param mouse_over string specifying the column of data to display when the mouse rolls over the polygon
#' @param mouse_over_group string specifying the column of data specifying which groups of circles to highlight on mouseover
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
                        lat = NULL,
                        lon = NULL,
                        radius = NULL,
                        stroke_colour = NULL,
                        stroke_opacity = NULL,
                        stroke_weight = NULL,
                        fill_colour = NULL,
                        fill_opacity = NULL,
                        mouse_over = NULL,
                        mouse_over_group = NULL,
                        info_window = NULL){

  # data <- as.data.frame(data)

  if(is.null(lat)){
    data <- latitude_column(data, lat, 'add_circles')
    lat <- "lat"
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'add_circles')
    lon <- "lng"
  }

  Circles <- data.frame(lat = data[, lat],
                        lng = data[, lon])


  Circles[, "stroke_colour"] <- SetDefault(stroke_colour, "#FF0000", data)
  Circles[, "stroke_weight"] <- SetDefault(stroke_weight, 2, data)
  Circles[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.8, data)
  Circles[, "radius"] <- SetDefault(radius, 100, data)
  Circles[, "fill_colour"] <- SetDefault(fill_colour, "#FF0000", data)
  Circles[, "fill_opacity"] <- SetDefault(fill_opacity, 0.35, data)
  Circles[, "mouse_over_group"] <- SetDefault(mouse_over_group, "NA", data)

  ## options
  if(!is.null(info_window))
    Circles[, "info_window"] <- as.character(data[, info_window])

  if(!is.null(mouse_over))
    Circles[, "mouse_over"] <- as.character(data[, mouse_over])

  Circles <- jsonlite::toJSON(Circles)

  invoke_method(map, data, 'add_circles', Circles)
}

#' @rdname clear
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
                        weight = NULL,
                        data = get_map_data(map),
                        option_dissipating = FALSE,
                        option_radius = 1,
                        option_opacity = 0.6
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

  Heatmap <- jsonlite::toJSON(Heatmap)

  invoke_method(map, data, 'add_heatmap', Heatmap, heatmap_options)
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
  if(is.null(lat)){
    data <- latitude_column(data, lat, 'update_heatmap')
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'update_heatmap')
  }

  Heatmap <- data.frame(lat = data[, "lat"],
                        lng = data[, "lng"])

  Heatmap[, "weight"] <- SetDefault(weight, 1, data)

  Heatmap <- jsonlite::toJSON(Heatmap)

  invoke_method(map, data, 'update_heatmap', Heatmap)

}


#' @rdname clear
#' @export
clear_heatmap <- function(map){
  invoke_method(map, data = NULL, 'clear_heatmap')
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
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param polyline string specifying the column of \code{data} containing the encoded 'polyline'
#' @param geodesic logical
#' @param stroke_colour either a string specifying the column of \code{data} containing the stroke colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing the stroke opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing the stroke weight of each circle, or a number indicating the width of pixels in the line to be applied to all the circles
#' @param info_window string specifying the column of data to display in an info window when a polygon is clicked
#' @param mouse_over string specifying the column of data to display when the mouse rolls over the polygon
#' @param mouse_over_group string specifying the column of data specifying which groups of polylines to highlight on mouseover
#' @examples
#' \dontrun{
#'
#' library(magrittr)
#' pl <- "pizeF_{~sZjLhAdAJLwBJkBv@wN~Bgd@x@sNjAeUR_FTkEAqBGiAQuAw@{E_C}NGwA?sANaELkDDu@LgAfAiF?g@EI?EIo@EMMKe@UQGaAM}IaA_Fg@_JaAsEc@_"
#' df <- data.frame(polyline = pl)
#' google_map(key = map_key) %>%
#'   add_polylines(data = df, polyline = "polyline")
#'
#'
#' }
#' @export
add_polylines <- function(map,
                         data = get_map_data(map),
                         polyline,
                         geodesic = NULL,
                         stroke_colour = NULL,
                         stroke_weight = NULL,
                         stroke_opacity = NULL,
                         info_window = NULL,
                         mouse_over = NULL,
                         mouse_over_group = NULL
#                          lineSource = c("coords","polyline"),
#                          group = NULL,
#                          group_options = NULL,
#                          lat = NULL,
#                          lon = NULL,
                                      ){
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
  ## set 'default' colous
  if(is.null(polyline))
    stop("please supply the column containing the polylines")


  polyline <- data[, polyline, drop = FALSE]
  polyline <- stats::setNames(polyline, "polyline")

  ## the defaults are required
  polyline[, "geodesic"] <- SetDefault(geodesic, TRUE, data)
  polyline[, "stroke_colour"] <- SetDefault(stroke_colour, "#0000FF", data)
  polyline[, "stroke_weight"] <- SetDefault(stroke_weight, 2, data)
  polyline[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.6, data)
  polyline[, "mouse_over_group"] <- SetDefault(mouse_over_group, "NA", data)

  ## options
  if(!is.null(mouse_over))
    polyline[, "mouse_over"] <- as.character(data[, mouse_over])

  if(!is.null(info_window))
    polyline[, "info_window"] <- as.character(data[, info_window])


  polyline <- jsonlite::toJSON(polyline)

  invoke_method(map, data, 'add_polylines', polyline)
}

#' @rdname clear
#' @export
clear_polylines <- function(map){
  invoke_method(map, data = NULL, 'clear_polylines')
}

#' Add polygon
#'
#' Add a polygon to a google map.
#' @examples
#' \dontrun{
#'
#' ## polygon with a hole - Bermuda triangle
#' pl_outer <- gepaf::encodePolyline(data.frame(lat = c(25.774, 18.466,32.321),
#'                                             lng = c(-80.190, -66.118, -64.757)))
#'
#' pl_inner <- gepaf::encodePolyline(data.frame(lat = c(28.745, 29.570, 27.339),
#'                                              lng = c(-70.579, -67.514, -66.668)))
#'
#'
#' l <- list(c(pl_outer, pl_inner))
#'
#' df <- data.frame(polyline = rep(NA, length(l)))
#'
#' df$polyline <- l
#'
#' google_map(key = map_key, height = 800, location = c(25.774, -80.190), zoom = 3) %>%
#'   add_polygons(data = df, polyline = "polyline", mouse_over = "polyline")
#'
#'
#' }
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param polyline string specifying the column containing the polyline
#' @param stroke_colour either a string specifying the column of \code{data} containing the stroke colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing the stroke opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing the stroke weight of each circle, or a number indicating the width of pixels in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data} containing the fill colour of each circle, or a valid hexadecimal numeric HTML style to be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing the fill opacity of each circle, or a value between 0 and 1 that will be aplied to all the circles
#' @param info_window string specifying the column of data to display in an info window when a polygon is clicked
#' @param mouse_over string specifying the column of data to display when the mouse rolls over the polygon
#' @param mouse_over_group string specifying the column of data specifying which groups of polygons to highlight on mouseover
#' @export
add_polygons <- function(map,
                        data = get_map_data(map),
                        polyline,
                        stroke_colour = NULL,
                        stroke_weight = NULL,
                        stroke_opacity = NULL,
                        fill_colour = NULL,
                        fill_opacity = NULL,
                        info_window = NULL,
                        mouse_over = NULL,
                        mouse_over_group = NULL
                        ){

  ## TODO
  ## - other data foramts
  ## -- e.g. geoJSON
  ## -- allow addition of other attributes (however, how will the user access them?)
  ## checks for missing column names
  if(is.null(polyline))
    stop("please supply the column containing the polylines")

  if(!is.list(data[, polyline])){
    polygon <- data.frame(polyline = I(as.list(as.character(data[, polyline]))))
  }else{
    polygon <- data[, polyline, drop = FALSE]
  }

  polygon <- stats::setNames(polygon, "polyline")

  ## the defaults are required
  polygon[, "stroke_colour"] <- SetDefault(stroke_colour, "#0000FF", data)
  polygon[, "stroke_weight"] <- SetDefault(stroke_weight, 2, data)
  polygon[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.6, data)
  polygon[, "fill_colour"] <- SetDefault(fill_colour, "#FF0000", data)
  polygon[, "fill_opacity"] <- SetDefault(fill_opacity, 0.35, data)
  polygon[, "mouse_over_group"] <- SetDefault(mouse_over_group, "NA", data)

  ## options
  if(!is.null(info_window))
    polygon[, "info_window"] <- as.character(data[, info_window])

  if(!is.null(mouse_over))
    polygon[, "mouse_over"] <- as.character(data[, mouse_over])

  polygon <- jsonlite::toJSON(polygon)

  invoke_method(map, data, 'add_polygons', polygon)
}

#' @rdname clear
#' @export
clear_polygons <- function(map){
  invoke_method(map, data = NULL, 'clear_polygons')
}


