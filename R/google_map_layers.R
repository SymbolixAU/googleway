#' Add markers
#'
#' Add markers to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the latitude
#' coordinates, and the other specifying the longitude. If Null, the data passed
#' into \code{google_map()} will be used.
#' @param id string specifying the column containing an identifier for a marker
#' @param colour string specifying the column containing the 'colour' to use for
#' the markers. One of 'red', 'blue', 'green' or 'lavender'.
#' @param lat string specifying the column of \code{data} containing the 'latitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param title string specifying the column of \code{data} containing the 'title'
#' of the markers. The title is displayed when you hover over a marker. If blank,
#' no title will be displayed for the markers.
#' @param draggable string specifying the column of \code{data} defining if the
#' marker is 'draggable' (either TRUE or FALSE)
#' @param opacity string specifying the column of \code{data} defining the 'opacity'
#' of the maker. Values must be between 0 and 1 (inclusive).
#' @param label string specifying the column of \code{data} defining the character
#' to appear in the centre of the marker. Values will be coerced to strings, and
#' only the first character will be used.
#' @param cluster logical indicating if co-located markers should be clustered
#' when the map zoomed out
#' @param info_window string specifying the column of data to display in an info
#' window when a marker is clicked
#' @param mouse_over string specifying the column of data to display when the
#' mouse rolls over the marker
#' @param mouse_over_group string specifying the column of data specifying which
#' groups of circles to highlight on mouseover
#' @param marker_icon string specifying the column of data containing a link/URL to
#' an image to use for a marker
#' @param layer_id single value specifying an id for the layer.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- "your api key"
#'
#' google_map(key = map_key, data = tram_stops) %>%
#'  add_markers(lat = "stop_lat", lon = "stop_lon", info_window = "stop_name")
#'
#'
#' ## using marker icons
#' iconUrl <- paste0("https://developers.google.com/maps/documentation/",
#' "javascript/examples/full/images/beachflag.png")
#'
#' tram_stops$icon <- iconUrl
#'
#' google_map(key = map_key, data = tram_stops) %>%
#'   add_markers(lat = "stop_lat", lon = "stop_lon", marker_icon = "icon")
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
                        marker_icon = NULL,
                        layer_id = NULL,
                        digits = 4)
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

  if(!is.null(colour) & !is.null(marker_icon))
    stop("only one of colour or icon can be used")

  if(!is.null(colour)){
    if(!all((tolower(data[, colour])) %in% c("red","blue","green","lavender")))
      stop("colours must be either red, blue, green or lavender")

    data[, colour] <- tolower(data[, colour])

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

  if(!is.null(marker_icon))
    markers[, "url"] <- as.character(data[, marker_icon])

  # if(sum(is.na(markers)) > 0)
  #   warning("There are some NAs in your data. These may affect the markers that have been plotted.")

  if(!is.null(colour)){
    ## colours last as they re-order the data with the merge
    df_colours <- data.frame(colour = c('red', 'blue', 'green', 'lavender'),
                             url = c("http://mt.googleapis.com/vt/icon/name=icons/spotlight/spotlight-poi.png&scale=1",
                                     "https://mts.googleapis.com/vt/icon/name=icons/spotlight/spotlight-waypoint-blue.png&psize=16&font=fonts/Roboto-Regular.ttf&color=ff333333&ax=44&ay=48&scale=1",
                                     "http://mt.google.com/vt/icon?psize=30&font=fonts/arialuni_t.ttf&color=ff304C13&name=icons/spotlight/spotlight-waypoint-a.png&ax=43&ay=48&text=%E2%80%A2",
                                     "http://mt.google.com/vt/icon/name=icons/spotlight/spotlight-ad.png"))

    markers <- merge(markers, df_colours, by.x = "colour", by.y = "colour", all.x = TRUE)
  }

  markers <- jsonlite::toJSON(markers, digits = digits)

  invoke_method(map, data, 'add_markers', markers, cluster, layer_id)
}

#' clear map elements
#'
#' clears elements from a map
#'
#' @note These operations are intended for use in conjunction with
#' \link{google_map_update} in an interactive shiny environment
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
#' @note This function is intended for use with \link{google_map_update} in an
#' interactive shiny environment. You can set the styles of the original map
#' using the \code{styles} argument of \link{google_map}
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param styles JSON string representation of a valid Google Maps styles Array.
#' See the Google documentation for details \url{https://developers.google.com/maps/documentation/javascript/styling}
#'
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
#' @param data data frame containing at least two columns, one specifying the
#' latitude coordinates, and the other specifying the longitude. If Null, the
#' data passed into \code{google_map()} will be used.
#' @param id string specifying the column containing an identifier for a circle
#' @param lat string specifying the column of \code{data} containing the 'latitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param radius either a string specifying the column of \code{data} containing the
#' radius of each circle, OR a numeric value specifying the radius of all the circles
#' (radius is expressed in metres)
#' @param draggable string specifying the column of \code{data} defining if the circle
#' is 'draggable' (either TRUE or FALSE)
#' @param stroke_colour either a string specifying the column of \code{data} containing
#' the stroke colour of each circle, or a valid hexadecimal numeric HTML style to
#' be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing
#' the stroke opacity of each circle, or a value between 0 and 1 that will be
#' applied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing
#' the stroke weight of each circle, or a number indicating the width of pixels
#' in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data} containing
#' the fill colour of each circle, or a valid hexadecimal numeric HTML style to
#' be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing
#' the fill opacity of each circle, or a value between 0 and 1 that will be applied to all the circles
#' @param info_window string specifying the column of data to display in an info
#' window when a circle is clicked
#' @param mouse_over string specifying the column of data to display when the
#' mouse rolls over the circle
#' @param mouse_over_group string specifying the column of data specifying which
#' groups of circles to highlight on mouseover
#' @param layer_id single value specifying an id for the layer.
#'  layer.
#' @param z_index single value specifying where the circles appear in the layering
#' of the map objects. Layers with a higher \code{z_index} appear on top of those with
#' a lower \code{z_index}. See details.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#'
#' @details
#' \code{z_index} values define the order in which objects appear on the map.
#' Those with a higher value appear on top of those with a lower value. The default
#' order of objects is (1 being underneath all other objects)
#'
#' \itemize{
#'   \item{1. Polygon}
#'   \item{2. Rectangle}
#'   \item{3. Polyline}
#'   \item{4. Circle}
#' }
#'
#' Markers are always the top layer
#'
#' @examples
#' \dontrun{
#'
#' google_map(key = map_key, data = tram_stops) %>%
#'  add_circles(lat = "stop_lat", lon = "stop_lon")
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
                        layer_id = NULL,
                        z_index = NULL,
                        digits = 4){

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
  Circles[, "z_index"] <- SetDefault(z_index, 4, data)
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

  Circles <- jsonlite::toJSON(Circles, digits = digits)

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
#' Updates specific colours and opacities of specified circles Designed to be
#' used in a shiny application.
#'
#' @note Any circles (as specified by the \code{id} argument) that do not exist
#' in the \code{data} passed into \code{add_circles()} will not be added to the map.
#' This function will only update the circles that currently exist on the map when
#' the function is called.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data.frame containing the new values for the circles
#' @param id string representing the column of \code{data} containing the id values
#' for the circles. The id values must be present in the data supplied to
#' \code{add_circles} in order for the polygons to be udpated
#' @param radius either a string specifying the column of \code{data} containing
#' the radius of each circle, OR a numeric value specifying the radius of all the
#' circles (radius is expressed in metres)
#' @param draggable string specifying the column of \code{data} defining if the
#' circle is 'draggable' (either TRUE or FALSE)
#' @param stroke_colour either a string specifying the column of \code{data} containing
#' the stroke colour of each circle, or a valid hexadecimal numeric HTML style
#' to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing
#' the stroke opacity of each circle, or a value between 0 and 1 that will be
#' applied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing
#' the stroke weight of each circle, or a number indicating the width of pixels
#' in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data} containing
#' the fill colour of each circle, or a valid hexadecimal numeric HTML style to
#' be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing
#' the fill opacity of each circle, or a value between 0 and 1 that will be applied
#' to all the circles
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

#' Add heatmap
#'
#' Adds a heatmap to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the
#' latitude coordinates, and the other specifying the longitude. If Null, the
#' data passed into \code{google_map()} will be used.
#' @param lat string specifying the column of \code{data} containing the 'latitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param option_gradient vector of colours to use as the gradient colours. see Details
#' @param weight string specifying the column of \code{data} containing the 'weight'
#' associated with each point. If NULL, each point will get a weight of 1.
#' @param option_dissipating logical Specifies whether heatmaps dissipate on zoom.
#' When dissipating is FALSE the radius of influence increases with zoom level to
#' ensure that the color intensity is preserved at any given geographic location.
#' Defaults to FALSE
#' @param option_radius numeric. The radius of influence for each data point, in pixels.
#' @param option_opacity The opacity of the heatmap, expressed as a number between
#' 0 and 1. Defaults to 0.6.
#' @param layer_id single value specifying an id for the layer.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#'
#' @details
#' \code{option_gradient} colours can be two of the R colour specifications;
#' either a colour name (as listed by \code{colors()}, or a hexadecimal string of the
#' form \code{"#rrggbb"}).
#' The first colour in the vector will be used as the colour that fades to transparent,
#' while the last colour in the vector will be use in the centre of the 'heat'.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' set.seed(20170417)
#' df <- tram_route
#' df$weight <- sample(1:10, size = nrow(df), replace = T)
#'
#' google_map(key = map_key, data = df) %>%
#'  add_heatmap(lat = "shape_pt_lat", lon = "shape_pt_lon", weight = "weight",
#'               option_radius = 0.001)
#'
#' ## specifying different colour gradient
#' option_gradient <- c('orange', 'blue', 'mediumpurple4', 'snow4', 'thistle1')
#'
#' google_map(key = map_key, data = df) %>%
#'  add_heatmap(lat = "shape_pt_lat", lon = "shape_pt_lon", weight = "weight",
#'               option_radius = 0.001, option_gradient = option_gradient)
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
                        layer_id = NULL,
                        digits = 4
                        ){


  ## TODO:
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
      stop("option_radius must be numeric")

  if(!is.null(option_dissipating))
    if(!is.logical(option_dissipating))
      stop("option_dissipating must be logical")

  heatmap_options <- data.frame(dissipating = option_dissipating,
                                radius = option_radius,
                                opacity = option_opacity)

  if(!is.null(option_gradient)){

    if(length(option_gradient) == 1)
      stop("please provide at least two gradient colours")

    ## first entry is used to fade into the background
    g <- sapply(seq_along(option_gradient), function(x){
      if(x == 1){
        paste0('rgba(', paste0(c(as.numeric(grDevices::col2rgb(option_gradient[x])), 0), collapse = ","), ')')
      }else{
        paste0('rgba(', paste0(c(as.numeric(grDevices::col2rgb(option_gradient[x])), 1), collapse = ","), ')')
      }
    })

    heatmap_options$gradient <- list(g)
  }

  Heatmap <- jsonlite::toJSON(Heatmap, digits = digits)
  heatmap_options <- jsonlite::toJSON(heatmap_options)

  invoke_method(map, data, 'add_heatmap', Heatmap, heatmap_options, layer_id)
}


#' update heatmap
#'
#' updates a heatmap layer
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the
#' latitude coordinates, and the other specifying the longitude. If Null,
#' the data passed into \code{google_map()} will be used.
#' @param lat string specifying the column of \code{data} containing the 'latitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param weight string specifying the column of \code{data} containing the 'weight'
#' associated with each point. If NULL, each point will get a weight of 1.
#' @param layer_id single value specifying an id for the layer.
#' @export
update_heatmap <- function(map,
                           data,
                           lat = NULL,
                           lon = NULL,
                           weight = NULL,
                           layer_id = NULL){

  ## rename the cols so the javascript functions will see them
  if(is.null(lat)){
    data <- latitude_column(data, lat, 'update_heatmap')
    lat <- 'lat'
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'update_heatmap')
    lon <- 'lng'
  }

  layer_id <- LayerId(layer_id)

  Heatmap <- data.frame(lat = data[, lat],
                        lng = data[, lon])

  Heatmap[, "weight"] <- SetDefault(weight, 0.6, data)

  Heatmap <- jsonlite::toJSON(Heatmap)

  invoke_method(map, data, 'update_heatmap', Heatmap, layer_id)

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
#' @param data data frame containing at least a \code{polyline} column, or a
#' \code{lat} and a \code{lon} column. If Null, the data passed into
#' \code{google_map()} will be used.
#' @param polyline string specifying the column of \code{data} containing the
#' encoded 'polyline'.
#' @param lat string specifying the column of \code{data} containing the 'latitude'
#' coordinates. Coordinates must be in the order that defines the path.
#' @param lon string specifying the column of \code{data} containing the 'longitude'
#' coordinates. Coordinates must be in the order that defines the path.
#' @param id string specifying the column containing an identifier for a polyline
#' @param geodesic logical
#' @param stroke_colour either a string specifying the column of \code{data}
#' containing the stroke colour of each circle, or a valid hexadecimal numeric
#' HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data}
#' containing the stroke opacity of each circle, or a value between 0 and 1 that
#' will be applied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data}
#' containing the stroke weight of each circle, or a number indicating the width
#' of pixels in the line to be applied to all the circles
#' @param info_window string specifying the column of data to display in an info
#' window when a polyline is clicked
#' @param mouse_over string specifying the column of data to display when the
#' mouse rolls over the polyline
#' @param mouse_over_group string specifying the column of data specifying which
#' groups of polylines to highlight on mouseover
#' @param update_map_view logical specifying if the map should re-centre according
#' to the polyline.
#' @param layer_id single value specifying an id for the layer.
#' @param z_index single value specifying where the polylines appear in the layering
#' of the map objects. Layers with a higher \code{z_index} appear on top of those with
#' a lower \code{z_index}. See details.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#'
#' @details
#' \code{z_index} values define the order in which objects appear on the map.
#' Those with a higher value appear on top of those with a lower value. The default
#' order of objects is (1 being underneath all other objects)
#'
#' \itemize{
#'   \item{1. Polygon}
#'   \item{2. Rectangle}
#'   \item{3. Polyline}
#'   \item{4. Circle}
#' }
#'
#' Markers are always the top layer
#'
#' @note The lines can be generated by either using an encoded polyline, or by a
#' set of lat/lon coordinates.
#' You sould specify either the column containing an encoded polyline, OR the
#' lat / lon colulmns.
#'
#' Using \code{update_map_view = TRUE} for multiple polylines may be slow, so it
#' may be more appropriate to set the view of the map using the location argument
#' of \code{google_map()}
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
#' url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
#' flights <- read.csv(url)
#' flights$id <- seq_len(nrow(flights))
#'
#'
#' ## encode the routes as polylines
#' lst <- lapply(unique(flights$id), function(x){
#'   lat = c(flights[flights["id"] == x, c("start_lat")], flights[flights["id"] == x, c("end_lat")])
#'   lon = c(flights[flights["id"] == x, c("start_lon")], flights[flights["id"] == x, c("end_lon")])
#'   data.frame(id = x, polyline = encode_pl(lat = lat, lon = lon))
#' })
#'
#' flights <- merge(flights, do.call(rbind, lst), by = "id")
#'
#' style <- map_styles()$night
#'
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
                          layer_id = NULL,
                          z_index = NULL,
                          digits = 4){

  ## TODO:
  ## - warning if there are non-unique attributes for cooridnate lines
  ## -- e.g., if the same line has different colours

  if(is.null(polyline) & (is.null(lat) | is.null(lon)))
    stop("please supply the either the column containing the polylines, or the lat/lon coordinate columns")

  if(!is.null(polyline) & (!is.null(lat) | !is.null(lon)))
    stop("please use either a polyline colulmn, or lat/lon coordinate columns, not both")

  LogicalCheck(update_map_view)

  if(!inherits(data, "data.frame"))
    stop("Currently only data.frames are supported")


  if(!is.null(polyline)){


    if(is.null(id)){
      id <- 'id'
      data[, id] <- as.character(1:nrow(data))
    }else{
      data[, id] <- as.character(data[, id])
    }

    ## polyline specified
    polyline <- data[, c(id, polyline)]
    polyline <- stats::setNames(polyline, c("id", "polyline"))

    # polyline <- "polyline"
    usePolyline <- TRUE
  }else{

    ## coordinates
    usePolyline <- FALSE

    if(is.null(id)){
      message("No 'id' value defined, assuming one continuous line of coordinates")
      id <- 'id'
      data[, id] <- '1'
    }else{
      data[, id] <- as.character(data[, id])
    }

    if(is.null(lat)){
      data <- latitude_column(data, lat, 'add_polylines')
      lat <- "lat"
    }

    if(is.null(lon)){
      data <- longitude_column(data, lon, 'add_polylines')
      lon <- "lng"
    }

    polyline <- data[, c(id, lat, lon)]
    polyline <- stats::setNames(polyline, c('id', 'lat', 'lng'))
  }


  layer_id <- LayerId(layer_id)


  ## the defaults are required
  polyline[, "geodesic"] <- SetDefault(geodesic, TRUE, data)
  polyline[, "stroke_colour"] <- SetDefault(stroke_colour, "#0000FF", data)
  polyline[, "stroke_weight"] <- SetDefault(stroke_weight, 2, data)
  polyline[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.6, data)
  polyline[, "z_index"] <- SetDefault(z_index, 3, data)

  ## options
  if(!is.null(mouse_over))
    polyline[, "mouse_over"] <- as.character(data[, mouse_over])

  if(!is.null(mouse_over_group))
    polyline[, "mouse_over_group"] <- as.character(data[, mouse_over_group])

  if(!is.null(info_window))
    polyline[, "info_window"] <- as.character(data[, info_window])

  # if(sum(is.na(polyline)) > 0)
  #   warning("There are some NAs in your data. These may affect the polylines that have been plotted.")

  if(!usePolyline){

    ## using coordinates
    ids <- unique(polyline[, 'id'])
    n <- names(polyline)[names(polyline) %in% objectColumns("polylineCoords")]
    keep <- setdiff(n, c('id', 'lat', 'lng'))

    lst_polyline <- objPolylineCoords(polyline, ids, keep)

    js_polyline <- jsonlite::toJSON(lst_polyline, digits = digits, auto_unbox = T)

  }else{

    n <- names(polyline)[names(polyline) %in% objectColumns("polylinePolyline")]
    polyline <- polyline[, n, drop = FALSE]

    js_polyline <- jsonlite::toJSON(polyline, auto_unbox = T)
  }

  invoke_method(map, data, 'add_polylines', js_polyline, update_map_view, layer_id, usePolyline)
}


#' Update polylines
#'
#' Updates specific attributes of polylines. Designed to be
#' used in a shiny application.
#'
#' @note Any polylines (as specified by the \code{id} argument) that do not exist
#' in the \code{data} passed into \code{add_polylines()} will not be added to the
#' map. This function will only update the polylines that currently exist on
#' the map when the function is called.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data.frame containing the new values for the polylines
#' @param id string representing the column of \code{data} containing the id
#' values for the polylines The id values must be present in the data supplied
#' to \code{add_polylines} in order for the polylines to be udpated
#' @param stroke_colour either a string specifying the column of \code{data}
#' containing the stroke colour of each circle, or a valid hexadecimal numeric
#' HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data}
#' containing the stroke opacity of each circle, or a value between 0 and 1
#' that will be applied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data}
#' containing the stroke weight of each circle, or a number indicating the width
#' of pixels in the line to be applied to all the circles
#' @param layer_id single value specifying an id for the layer.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' ## coordinate columns
#' ## plot polylines using default attributes
#' df <- tram_route
#' df$id <- c(rep(1, 27), rep(2, 28))
#'
#' df$colour <- c(rep("#00FFFF", 27), rep("#FF00FF", 28))
#'
#' google_map(key = map_key) %>%
#'   add_polylines(data = df, lat = 'shape_pt_lat', lon = 'shape_pt_lon',
#'                 stroke_colour = "colour", id = 'id')
#'
#' ## specify width and colour attributes to update
#' df_update <- data.frame(id = c(1,2),
#'                         width = c(3,10),
#'                         colour = c("#00FF00", "#DCAB00"))
#'
#' google_map(key = map_key) %>%
#'   add_polylines(data = df, lat = 'shape_pt_lat', lon = 'shape_pt_lon',
#'                 stroke_colour = "colour", id = 'id') %>%
#'   update_polylines(data = df_update, id = 'id', stroke_weight = "width",
#'                    stroke_colour = 'colour')
#'
#'
#' ## encoded polylines
#' pl <- sapply(unique(df$id), function(x){
#'   encode_pl(lat = df[ df$id == x , 'shape_pt_lat'], lon = df[ df$id == x, 'shape_pt_lon'])
#' })
#'
#' df <- data.frame(id = c(1, 2), polyline = pl)
#'
#' google_map(key = map_key) %>%
#'   add_polylines(data = df, polyline = 'polyline')
#'
#' google_map(key = map_key) %>%
#'   add_polylines(data = df, polyline = 'polyline') %>%
#'   update_polylines(data = df_update, id = 'id', stroke_weight = "width",
#'                    stroke_colour = 'colour')
#'
#' }
#'
#' @export
update_polylines <- function(map, data, id,
                             stroke_colour = NULL,
                             stroke_weight = NULL,
                             stroke_opacity = NULL,
                             layer_id = NULL){

  ## TODO: is 'info_window' required, if it was included in the original add_polygons?

  polylineUpdate <- data[, id, drop = FALSE]
  polylineUpdate[, "id"] <- as.character(data[, id])
  polylineUpdate <- stats::setNames(polylineUpdate, 'id')

  layer_id <- LayerId(layer_id)

  polylineUpdate[, "stroke_colour"] <- SetDefault(stroke_colour, "#0000FF", data)
  polylineUpdate[, "stroke_weight"] <- SetDefault(stroke_weight, 1, data)
  polylineUpdate[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.6, data)

  polylineUpdate <- jsonlite::toJSON(polylineUpdate, auto_unbox = T)

  invoke_method(map, data = NULL, 'update_polylines', polylineUpdate, layer_id)
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
#' @note A polygon represents an area enclosed by a closed path. Polygon objects
#' are similar to polylines in that they consist of a series of coordinates in an ordered sequence.
#' Polygon objects can describe complex shapes, including
#'
#' \itemize{
#'   \item{Multiple non-contiguous areas defined by a single polygon}
#'   \item{Areas with holes in them}
#'   \item{Intersections of one or more areas}
#' }
#'
#' To define a complex shape, you use a polygon with multiple paths.
#'
#' To create a hole in a polygon, you need to create two paths, one inside the other.
#' To create the hole, the coordinates of the inner path must be wound in the opposite
#' order to those defining the outer path. For example, if the coordinates of
#' the outer path are in clockwise order, then the inner path must be anti-clockwise.
#'
#' You can represent a polygon in one of three ways
#' \itemize{
#'   \item{as a series of coordinates defining a path (or paths) with both an
#'   \code{id} and \code{pathId} argument that make up the polygon}
#'   \item{as an encoded polyline using an \code{id} column to specify multiple
#'   polylines for a polygon}
#'   \item{as a list column in a data.frame, where each row of the data.frame
#'   contains the polylines that comprise the polygon}
#'
#' }
#'
#' See Examples
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' ## polygon with a hole - Bermuda triangle
#' ## using one row per polygon, and a list-column of encoded polylines
#' pl_outer <- encode_pl(lat = c(25.774, 18.466,32.321),
#'       lon = c(-80.190, -66.118, -64.757))
#'
#' pl_inner <- encode_pl(lat = c(28.745, 29.570, 27.339),
#'        lon = c(-70.579, -67.514, -66.668))
#'
#' df <- data.frame(id = c(1, 1),
#'        polyline = c(pl_outer, pl_inner),
#'        stringsAsFactors = FALSE)
#'
#' df <- aggregate(polyline ~ id, data = df, list)
#'
#' google_map(key = map_key, height = 800) %>%
#'     add_polygons(data = df, polyline = "polyline")
#'
#' ## the same polygon, but using an 'id' to specify the polygon
#' df <- data.frame(id = c(1,1),
#'        polyline = c(pl_outer, pl_inner),
#'        stringsAsFactors = FALSE)
#'
#' google_map(key = map_key, height = 800) %>%
#'     add_polygons(data = df, polyline = "polyline", id = "id")
#'
#' ## the same polygon, specified using coordinates, and with a second independent
#' ## polygon
#' df <- data.frame(myId = c(1,1,1,1,1,1,2,2,2),
#'       lineId = c(1,1,1,2,2,2,1,1,1),
#'       lat = c(26.774, 18.466, 32.321, 28.745, 29.570, 27.339, 22, 23, 22),
#'       lon = c(-80.190, -66.118, -64.757, -70.579, -67.514, -66.668, -50, -49, -51),
#'       colour = c(rep("#00FF0F", 6), rep("#FF00FF", 3)),
#'       stringsAsFactors = FALSE)
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, lat = 'lat', lon = 'lon', id = 'myId', pathId = 'lineId',
#'                fill_colour = 'colour')
#'
#'
#'
#' }
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least a \code{polyline} column,
#' or a \code{lat} and a \code{lon} column. If Null, the data passed into
#' \code{google_map()} will be used.
#' @param polyline string specifying the column of \code{data} containing
#' the encoded polyline
#' @param lat string specifying the column of \code{data} containing the
#' 'latitude' coordinates. Coordinates must be in the order that defines the path.
#' @param lon string specifying the column of \code{data} containing the
#' 'longitude' coordinates. Coordinates must be in the order that defines the path.
#' @param id string specifying the column containing an identifier for a polygon.
#' @param pathId string specifying the column containing an identifer for each
#' path that forms the complete polygon. Not required when using \code{polyline},
#' as each polyline is itself a path.
#' @param stroke_colour either a string specifying the column of \code{data}
#' containing the stroke colour of each polygon, or a valid hexadecimal numeric
#' HTML style to be applied to all the polygons
#' @param stroke_opacity either a string specifying the column of \code{data}
#' containing the stroke opacity of each polygon, or a value between 0 and 1
#' that will be applied to all the polygons
#' @param stroke_weight either a string specifying the column of \code{data}
#' containing the stroke weight of each polygon, or a number indicating the
#' width of pixels in the line to be applied to all the polygons
#' @param fill_colour either a string specifying the column of \code{data}
#' containing the fill colour of each polygon, or a valid hexadecimal numeric
#' HTML style to be applied to all the polygons
#' @param fill_opacity either a string specifying the column of \code{data}
#' containing the fill opacity of each polygon, or a value between 0 and 1 that
#' will be applied to all the polygons
#' @param info_window string specifying the column of data to display in an
#' info window when a polygon is clicked
#' @param mouse_over string specifying the column of data to display when the
#' mouse rolls over the polygon
#' @param mouse_over_group string specifying the column of data specifying
#' which groups of polygons to highlight on mouseover
#' @param draggable string specifying the column of \code{data} defining if
#' the polygon is 'draggable'. The column of data should be logical (either TRUE or FALSE)
#' @param editable string specifying the column of \code{data} defining if the polygon
#' is 'editable' (either TRUE or FALSE)
#' @param update_map_view logical specifying if the map should re-centre
#' according to the polyline.
#' @param layer_id single value specifying an id for the layer.
#' @param z_index single value specifying where the polygons appear in the layering
#' of the map objects. Layers with a higher \code{z_index} appear on top of those with
#' a lower \code{z_index}. See details.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#'
#' @details
#' \code{z_index} values define the order in which objects appear on the map.
#' Those with a higher value appear on top of those with a lower value. The default
#' order of objects is (1 being underneath all other objects)
#'
#' \itemize{
#'   \item{1. Polygon}
#'   \item{2. Rectangle}
#'   \item{3. Polyline}
#'   \item{4. Circle}
#' }
#'
#' Markers are always the top layer
#'
#'
#' @seealso \link{encode_pl}
#'
#' @export
add_polygons <- function(map,
                        data = get_map_data(map),
                        polyline = NULL,
                        lat = NULL,
                        lon = NULL,
                        id = NULL,
                        pathId = NULL,
                        stroke_colour = NULL,
                        stroke_weight = NULL,
                        stroke_opacity = NULL,
                        fill_colour = NULL,
                        fill_opacity = NULL,
                        info_window = NULL,
                        mouse_over = NULL,
                        mouse_over_group = NULL,
                        draggable = NULL,
                        editable = NULL,
                        update_map_view = TRUE,
                        layer_id = NULL,
                        z_index = NULL,
                        digits = 4
                        ){

  ## TODO
  ## - holes must be wound in the opposite direction

  if(is.null(polyline) & (is.null(lat) | is.null(lon)))
    stop("please supply the either the column containing the polylines, or the lat/lon coordinate columns")

  if(!is.null(polyline) & (!is.null(lat) | !is.null(lon)))
    stop("please use either a polyline colulmn, or lat/lon coordinate columns, not both")

  LogicalCheck(update_map_view)

  if(!inherits(data, "data.frame"))
    stop("Currently only data.frames are supported")

  if(!is.null(polyline)){

    if(is.null(id)){
      id <- 'id'
      data[, id] <- as.character(1:nrow(data))
    }else{
      data[, id] <- as.character(data[, id])
    }

   polygon <- data[, c(id, polyline)]
   polygon <- stats::setNames(polygon, c("id", "polyline"))

   polyline <- "polyline"
   usePolyline <- TRUE

  }else{

    usePolyline <- FALSE

    ## coordinates
    if(is.null(id)){
      message("No 'id' value defined, assuming one continuous line of coordinates")
      id <- 'id'
      data[, id] <- '1'
    }else{
      data[, id] <- as.character(data[, id])
    }

    ## check pathId
    if(is.null(pathId)){
      message("No 'pathId' value defined, assuming one continuous line per polygon")
      pathId <- 'pathId'
      data[, pathId] <- '1'
    }else{
      data[, pathId] <- as.character(data[, pathId])
    }

    if(is.null(lat)){
      data <- latitude_column(data, lat, 'add_polygons')
      lat <- "lat"
    }

    if(is.null(lon)){
      data <- longitude_column(data, lon, 'add_polygons')
      lon <- "lng"
    }

    polygon <- data[, c(id, pathId, lat, lon)]
    polygon <- stats::setNames(polygon, c('id', 'pathId', 'lat', 'lng'))

  }

  ## the defaults are required
  polygon[, "stroke_colour"] <- SetDefault(stroke_colour, "#0000FF", data)
  polygon[, "stroke_weight"] <- SetDefault(stroke_weight, 1, data)
  polygon[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.6, data)
  polygon[, "fill_colour"] <- SetDefault(fill_colour, "#FF0000", data)
  polygon[, "fill_opacity"] <- SetDefault(fill_opacity, 0.35, data)
  polygon[, "z_index"] <- SetDefault(z_index, 1, data)


  # polygon[, id] <- as.character(polygon[, id])
  # polygon[, pathId] <- as.character(polygon[, pathId])

  if(!is.null(info_window))
    polygon[, "info_window"] <- as.character(data[, info_window])

  if(!is.null(mouse_over))
    polygon[, "mouse_over"] <- as.character(data[, mouse_over])

  if(!is.null(mouse_over_group))
    polygon[, "mouse_over_group"] <- as.character(data[, mouse_over_group])

  if(!is.null(draggable))
    polygon[, "draggable"] <- as.logical(data[, draggable])

  if(!is.null(editable))
    polygon[, 'editable'] <- as.logical(data[, editable])

  ## using polyline ==> using one row per line (continue with 'polyline')
  ## using lat/lon ==> using many rows per line
  ## use a list to store the coordinates
  if(!usePolyline){

    ## each 'lineId' needs to be in the same array. Holes are wound in the opposite direction
    ## to the outer path.
    ## example of a single polygon looks like
    ## polygon = new google.maps.polygon({
    ##  paths : [ coords1, coords2, coords3, coords4]
    ## })
    ##
    ## where any of coords* can be holes.

    ## using coordinates
    ids <- unique(polygon[, 'id'])
    n <- names(polygon)[names(polygon) %in% objectColumns("polygonCoords")]
    keep <- setdiff(n, c('id', 'pathId', 'lat', 'lng'))

    lst_polygon <- objPolygonCoords(polygon, ids, keep)

    js_polygon <- jsonlite::toJSON(lst_polygon, digits = digits, auto_unbox = T)

  }else{

    if(!is.list(polygon[, polyline])){

      ## make our own list column
      f <- paste0(polyline, " ~ " , paste0(setdiff(names(polygon), polyline), collapse = "+") )
      polygon <- stats::aggregate(stats::formula(f), data = polygon, list)

      js_polygon <- jsonlite::toJSON(polygon)

    }else{

      js_polygon <- jsonlite::toJSON(polygon)

    }

  }

#   if(sum(sapply(polygon[, polyline], is.null)) > 0){
#     warning("There are some NULL polyline values. These polygons are removed from the map")
#     polygon <- polygon[!sapply(polygon[, polyline], is.null)]
#   }

  layer_id <- LayerId(layer_id)
  # if(sum(is.na(polygon)) > 0)
  #   warning("There are some NAs in your data. These may affect the polygons that have been plotted.")
  invoke_method(map, data, 'add_polygons', js_polygon, update_map_view, layer_id, usePolyline)
}


#' Update polygons
#'
#' Updates specific colours and opacities of specified polygons. Designed to be
#' used in a shiny application.
#'
#' @note Any polygons (as specified by the \code{id} argument) that do not exist
#' in the \code{data} passed into \code{add_polygons()} will not be added to the map.
#' This function will only update the polygons that currently exist on the map
#' when the function is called.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data.frame containing the new values for the polygons
#' @param id string representing the column of \code{data} containing the id
#' values for the polygons. The id values must be present in the data supplied
#' to \code{add_polygons} in order for the polygons to be udpated
#' @param stroke_colour either a string specifying the column of \code{data}
#' containing the stroke colour of each circle, or a valid hexadecimal numeric
#' HTML style to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data}
#' containing the stroke opacity of each circle, or a value between 0 and 1 that
#' will be applied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data}
#' containing the stroke weight of each circle, or a number indicating the width of
#' pixels in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data}
#' containing the fill colour of each circle, or a valid hexadecimal numeric
#' HTML style to be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data}
#' containing the fill opacity of each circle, or a value between 0 and 1 that
#' will be applied to all the circles
#' @param layer_id single value specifying an id for the layer.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' pl_outer <- encode_pl(lat = c(25.774, 18.466,32.321),
#'                       lon = c(-80.190, -66.118, -64.757))
#'
#' pl_inner <- encode_pl(lat = c(28.745, 29.570, 27.339),
#'                       lon = c(-70.579, -67.514, -66.668))
#'
#' pl_other <- encode_pl(c(21,23,22), c(-50, -49, -51))
#'
#' ## using encoded polylines
#' df <- data.frame(id = c(1,1,2),
#'                  colour = c("#00FF00", "#00FF00", "#FFFF00"),
#'                  polyline = c(pl_outer, pl_inner, pl_other),
#'                  stringsAsFactors = FALSE)
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', id = 'id', fill_colour = 'colour')
#'
#' df_update <- df[, c("id", "colour")]
#' df_update$colour <- c("#FFFFFF", "#FFFFFF", "000000")
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', id = 'id', fill_colour = 'colour') %>%
#'   update_polygons(data = df_update, id = 'id', fill_colour = 'colour')
#'
#'
#' df <- aggregate(polyline ~ id + colour, data = df, list)
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', fill_colour = 'colour')
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', id = 'id', fill_colour = 'colour') %>%
#'   update_polygons(data = df_update, id = 'id', fill_colour = 'colour')
#'
#'
#' ## using coordinates
#' df <- data.frame(id = c(rep(1, 6), rep(2, 3)),
#'                  lineId = c(rep(1, 3), rep(2, 3), rep(1, 3)),
#'                  lat = c(25.774, 18.466, 32.321, 28.745, 29.570, 27.339, 21, 23, 22),
#'                  lon = c(-80.190, -66.118, -64.757, -70.579, -67.514, -66.668, -50, -49, -51))
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, lat = 'lat', lon = 'lon', id = 'id', pathId = 'lineId')
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, lat = 'lat', lon = 'lon', id = 'id', pathId = 'lineId') %>%
#'   update_polygons(data = df_update, id = 'id', fill_colour = 'colour')
#'
#' }
#'
#' @export
update_polygons <- function(map, data, id,
                            stroke_colour = NULL,
                            stroke_weight = NULL,
                            stroke_opacity = NULL,
                            fill_colour = NULL,
                            fill_opacity = NULL,
                            layer_id = NULL
                            ){

  ## TODO: is 'info_window' required, if it was included in the original add_polygons?

  polygonUpdate <- data[, id, drop = FALSE]
  polygonUpdate[, id] <- as.character(polygonUpdate[, id])

  polygonUpdate <- stats::setNames(polygonUpdate, c('id'))

  layer_id <- LayerId(layer_id)

  # polygonUpdate[, id] <- as.character(data[, id])

  polygonUpdate[, "stroke_colour"] <- SetDefault(stroke_colour, "#0000FF", data)
  polygonUpdate[, "stroke_weight"] <- SetDefault(stroke_weight, 1, data)
  polygonUpdate[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.6, data)
  polygonUpdate[, "fill_colour"] <- SetDefault(fill_colour, "#FF0000", data)
  polygonUpdate[, "fill_opacity"] <- SetDefault(fill_opacity, 0.35, data)
  # polygonUpdate[, "mouse_over_group"] <- SetDefault(mouse_over_group, "NA", data)

  polygonUpdate <- jsonlite::toJSON(polygonUpdate, auto_unbox = T)

  invoke_method(map, data = NULL, 'update_polygons', polygonUpdate, layer_id)

}

#' @rdname clear
#' @export
clear_polygons <- function(map, layer_id = NULL){

  layer_id <- LayerId(layer_id)

  invoke_method(map, data = NULL, 'clear_polygons', layer_id)
}


#' Add Rectangles
#'
#' Adds a rectangle to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing the bounds for the rectangles
#' @param north String specifying the column of \code{data} that contains the
#' northern most latitude coordinate
#' @param east String specifying the column of \code{data} that contains the
#' eastern most longitude
#' @param south String specifying the column of \code{data} that contains the
#' southern most latitude coordinate
#' @param west String specifying the column of \code{data} that contains the
#' western most longitude
#' @param id string specifying the column containing an identifier for a rectangle
#' @param draggable string specifying the column of \code{data} defining if the rectangle
#' is 'draggable' (either TRUE or FALSE)
#' @param editable string specifying the column of \code{data} defining if the rectangle
#' is 'editable' (either TRUE or FALSE)
#' @param stroke_colour either a string specifying the column of \code{data} containing
#' the stroke colour of each rectangle, or a valid hexadecimal numeric HTML style to
#' be applied to all the rectangle
#' @param stroke_opacity either a string specifying the column of \code{data} containing
#' the stroke opacity of each rectangle, or a value between 0 and 1 that will be
#' applied to all the rectangle
#' @param stroke_weight either a string specifying the column of \code{data} containing
#' the stroke weight of each rectangle, or a number indicating the width of pixels
#' in the line to be applied to all the rectangle
#' @param fill_colour either a string specifying the column of \code{data} containing
#' the fill colour of each rectangle, or a valid hexadecimal numeric HTML style to
#' be applied to all the rectangle
#' @param fill_opacity either a string specifying the column of \code{data} containing
#' the fill opacity of each rectangle, or a value between 0 and 1 that will be applied to all the rectangles
#' @param info_window string specifying the column of data to display in an info
#' window when a rectangle is clicked
#' @param mouse_over string specifying the column of data to display when the
#' mouse rolls over the rectangle
#' @param mouse_over_group string specifying the column of data specifying which
#' groups of rectangle to highlight on mouseover
#' @param layer_id single value specifying an id for the layer.
#' @param z_index single value specifying where the rectangles appear in the layering
#' of the map objects. Layers with a higher \code{z_index} appear on top of those with
#' a lower \code{z_index}. See details.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#'
#' @details
#' \code{z_index} values define the order in which objects appear on the map.
#' Those with a higher value appear on top of those with a lower value. The default
#' order of objects is (1 being underneath all other objects)
#'
#' \itemize{
#'   \item{1. Polygon}
#'   \item{2. Rectangle}
#'   \item{3. Polyline}
#'   \item{4. Circle}
#' }
#'
#' Markers are always the top layer
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' df <- data.frame(north = 33.685, south = 33.671, east = -116.234, west = -116.251)
#'
#' google_map(key = map_key) %>%
#'   add_rectangles(data = df, north = 'north', south = 'south',
#'                  east = 'east', west = 'west')
#'
#' ## editable rectangle
#' df <- data.frame(north = -37.8459, south = -37.8508, east = 144.9378,
#'                   west = 144.9236, editable = T, draggable = T)
#'
#' google_map(key = map_key) %>%
#'   add_rectangles(data = df, north = 'north', south = 'south',
#'                  east = 'east', west = 'west',
#'                  editable = 'editable', draggable = 'draggable')
#'
#' }
#' @export
add_rectangles <- function(map,
                           data = get_map_data(map),
                           north,
                           east,
                           south,
                           west,
                           id = NULL,
                           draggable = NULL,
                           editable = NULL,
                           stroke_colour = NULL,
                           stroke_opacity = NULL,
                           stroke_weight = NULL,
                           fill_colour = NULL,
                           fill_opacity = NULL,
                           mouse_over = NULL,
                           mouse_over_group = NULL,
                           info_window = NULL,
                           layer_id = NULL,
                           z_index = NULL,
                           digits = 4){

  layer_id <- LayerId(layer_id)

  Rectangle <- data.frame(north = data[, north],
                        south = data[, south],
                        east = data[, east],
                        west = data[, west])

  Rectangle[, "stroke_colour"] <- SetDefault(stroke_colour, "#FF0000", data)
  Rectangle[, "stroke_weight"] <- SetDefault(stroke_weight, 1, data)
  Rectangle[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.8, data)
  Rectangle[, "fill_colour"] <- SetDefault(fill_colour, "#FF0000", data)
  Rectangle[, "fill_opacity"] <- SetDefault(fill_opacity, 0.35, data)
  Rectangle[, "z_index"] <- SetDefault(z_index, 2, data)
  # Circles[, "mouse_over_group"] <- SetDefault(mouse_over_group, "NA", data)

  ## options
  if(!is.null(id))
    Rectangle[, "id"] <- as.character(data[, id])

  if(!is.null(draggable))
    Rectangle[, 'draggable'] <- as.logical(data[, draggable])

  if(!is.null(editable))
    Rectangle[, 'editable'] <- as.logical(data[, editable])

  if(!is.null(info_window))
    Rectangle[, "info_window"] <- as.character(data[, info_window])

  if(!is.null(mouse_over))
    Rectangle[, "mouse_over"] <- as.character(data[, mouse_over])

  if(!is.null(mouse_over_group))
    Rectangle[, "mouse_over_group"] <- as.character(data[, mouse_over_group])

  # if(sum(is.na(Rectangle)) > 0)
  #   warning("There are some NAs in your data. These may affect the circles that have been plotted.")

  Rectangle <- jsonlite::toJSON(Rectangle, digits = digits)


  invoke_method(map, data, 'add_rectangles', Rectangle, layer_id)

}

#' @rdname clear
#' @export
clear_rectangles <- function(map, layer_id = NULL){

  layer_id <- LayerId(layer_id)

  invoke_method(map, data = NULL, 'clear_rectangles', layer_id)
}


#' Update rectangles
#'
#' Updates specific colours and opacities of specified rectangles Designed to be
#' used in a shiny application.
#'
#' @note Any rectangles (as specified by the \code{id} argument) that do not exist
#' in the \code{data} passed into \code{add_rectangles()} will not be added to the map.
#' This function will only update the rectangles that currently exist on the map when
#' the function is called.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data.frame containing the new values for the rectangles
#' @param id string representing the column of \code{data} containing the id values
#' for the rectangles The id values must be present in the data supplied to
#' \code{add_rectangles} in order for the polygons to be udpated
#' @param draggable string specifying the column of \code{data} defining if the
#' rectangle is 'draggable' (either TRUE or FALSE)
#' @param stroke_colour either a string specifying the column of \code{data} containing
#' the stroke colour of each rectangle, or a valid hexadecimal numeric HTML style
#' to be applied to all the rectangles
#' @param stroke_opacity either a string specifying the column of \code{data} containing
#' the stroke opacity of each rectangle, or a value between 0 and 1 that will be
#' applied to all the rectangles
#' @param stroke_weight either a string specifying the column of \code{data} containing
#' the stroke weight of each rectangle, or a number indicating the width of pixels
#' in the line to be applied to all the rectangles
#' @param fill_colour either a string specifying the column of \code{data} containing
#' the fill colour of each rectangle, or a valid hexadecimal numeric HTML style to
#' be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing
#' the fill opacity of each rectangle, or a value between 0 and 1 that will be applied
#' to all the rectangles
#' @param layer_id single value specifying an id for the layer.
#'
#' @export
update_rectangles <- function(map, data, id,
                           draggable = NULL,
                           stroke_colour = NULL,
                           stroke_weight = NULL,
                           stroke_opacity = NULL,
                           fill_colour = NULL,
                           fill_opacity = NULL,
                           layer_id = NULL){

  ## TODO: is 'info_window' required, if it was included in the original add_polygons?
  layer_id <- LayerId(layer_id)

  rectangleUpdate <- data.frame(id = as.character(data[, id]))

  rectangleUpdate[, "stroke_colour"] <- SetDefault(stroke_colour, "#FF0000", data)
  rectangleUpdate[, "stroke_weight"] <- SetDefault(stroke_weight, 1, data)
  rectangleUpdate[, "stroke_opacity"] <- SetDefault(stroke_opacity, 0.8, data)
  rectangleUpdate[, "fill_colour"] <- SetDefault(fill_colour, "#FF0000", data)
  rectangleUpdate[, "fill_opacity"] <- SetDefault(fill_opacity, 0.35, data)

  if(!is.null(draggable))
    rectangleUpdate[, 'draggable'] <- as.logical(data[, draggable])

  rectangleUpdate <- jsonlite::toJSON(rectangleUpdate)

  invoke_method(map, data = NULL, 'update_rectangles', rectangleUpdate, layer_id)

}

#' Add Overlay
#'
#' Adds a ground overlay to a map. The overlay can only be added from a URL
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param north northern-most latitude coordinate
#' @param east eastern-most longitude
#' @param south southern-most latitude coordinate
#' @param west western-most longitude
#' @param overlay_url URL string specifying the location of the overlay layer
#' @param layer_id single value specifying an id for the layer.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' google_map(key = map_key) %>%
#'   add_overlay(north = 40.773941,south = 40.712216, east = -74.12544, west = -74.22655,
#'                overlay_url = "https://www.lib.utexas.edu/maps/historical/newark_nj_1922.jpg")
#'
#'
#' }
#' @export
add_overlay <- function(map,
                        north,
                        east,
                        south,
                        west,
                        overlay_url,
                        layer_id = NULL,
                        digits = 4){

  URLCheck(overlay_url)
  LatitudeCheck(north, "north")
  LatitudeCheck(south, "south")
  LongitudeCheck(east, "east")
  LongitudeCheck(west, "west")

  layer_id <- LayerId(layer_id)

  overlay <- jsonlite::toJSON(data.frame(url = overlay_url,
                                       north = north,
                                       south = south,
                                       west = west,
                                       east = east),
                              digits = digits)

  invoke_method(map, data = NULL, 'add_overlay', overlay, layer_id)
}


#' Add KML
#'
#' Adds a KML layer to a map.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param kml_url URL string specifying the location of the kml layer
#' @param layer_id single value specifying an id for the layer.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' kmlUrl <- paste0('https://developers.google.com/maps/',
#' 'documentation/javascript/examples/kml/westcampus.kml')
#'
#' google_map(key = map_key) %>%
#'   add_kml(kml_url = kmlUrl)
#'
#' }
#' @export
add_kml <- function(map, kml_url, layer_id = NULL){

  URLCheck(kml_url)

  layer_id <- LayerId(layer_id)

  kml <- jsonlite::toJSON(data.frame(url = kml_url))

  invoke_method(map, data = NULL, 'add_kml', kml, layer_id)
}


#' Add Fusion
#'
#' Adds a fusion table layer to a map.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param query a \code{data.frame} of 2 or 3 columns, and only 1 row. Two columns
#' must be 'select' and 'from', and the third 'where'. The 'select' value is the column
#' name (from the fusion table) containing the location information, and the
#' 'from' value is the encrypted table Id. The 'where' value is a string specifying the
#' 'where' condition on the data query.
#' @param styles a \code{list} object used to apply colour, stroke weight and
#' opacity to lines and polygons. See examples to see how the list should be
#' constructed.
#' @param heatmap logical indicating whether to show a heatmap.
#' @param layer_id single value specifying an id for the layer.
#' @examples
#' \dontrun{
#'
#' mapKey <- 'your_api_key'
#'
#' qry <- data.frame(select = 'address',
#'     from = '1d7qpn60tAvG4LEg4jvClZbc1ggp8fIGGvpMGzA',
#'     where = 'ridership > 200')
#'
#' google_map(key = mapKey, location = c(41.8, -87.7), zoom = 9) %>%
#'   add_fusion(query = qry)
#'
#'
#'
#' qry <- data.frame(select = 'geometry',
#'    from = '1ertEwm-1bMBhpEwHhtNYT47HQ9k2ki_6sRa-UQ')
#'
#' styles <- list(
#'   list(
#'     polygonOptions = list( fillColor = "#00FF00", fillOpacity = 0.3)
#'     ),
#'   list(
#'     where = "birds > 300",
#'     polygonOptions = list( fillColor = "#0000FF" )
#'     ),
#'   list(
#'     where = "population > 5",
#'     polygonOptions = list( fillOpacity = 1.0 )
#'  )
#' )
#'
#' google_map(key = mapKey, location = c(-25.3, 133), zoom = 4) %>%
#'   add_fusion(query = qry, styles = styles)
#'
#' qry <- data.frame(select = 'location',
#'     from = '1xWyeuAhIFK_aED1ikkQEGmR8mINSCJO9Vq-BPQ')
#'
#' google_map(key = mapKey, location = c(0, 0), zoom = 1) %>%
#'   add_fusion(query = qry, heatmap = T)
#'
#' }
#'
#' @export
add_fusion <- function(map, query, styles = NULL, heatmap = FALSE, layer_id = NULL){

  ## TODO:
  ## - check each 'value' is a single value
  ## - update bounds on layer
  ## - info window

  ## The Google Maps API can't use values inside arrays, so we need
  ## to get rid of any arrays.
  ## - remove square brackets around value
  LogicalCheck(heatmap)

  query <- gsub("\\[|\\]", "", jsonlite::toJSON(query))

  style <- jsonlite::toJSON(styles)
  style <- gsub("\\[|\\]", "", substr(style, 2, (nchar(style) - 1)))
  style <- paste0("[", style, "]")

  layer_id <- LayerId(layer_id)

  invoke_method(map, data = NULL, 'add_fusion', query, style, heatmap, layer_id)
}

#' @rdname clear
#' @export
clear_fusion <- function(map, layer_id = NULL){

  layer_id <- LayerId(layer_id)

  invoke_method(map, data = NULL, 'clear_fusion', layer_id)
}

