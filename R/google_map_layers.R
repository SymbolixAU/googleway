

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
#' containing the stroke colour of each polyline, or a valid hexadecimal numeric
#' HTML style to be applied to all the polylines
#' @param stroke_opacity either a string specifying the column of \code{data}
#' containing the stroke opacity of each polyline, or a value between 0 and 1
#' that will be applied to all the polyline
#' @param stroke_weight either a string specifying the column of \code{data}
#' containing the stroke weight of each polyline, or a number indicating the width
#' of pixels in the line to be applied to all the polyline
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
#' containing the stroke colour of each polygon, or a valid hexadecimal numeric
#' HTML style to be applied to all the polygons
#' @param stroke_opacity either a string specifying the column of \code{data}
#' containing the stroke opacity of each polygon, or a value between 0 and 1 that
#' will be applied to all the polygons
#' @param stroke_weight either a string specifying the column of \code{data}
#' containing the stroke weight of each polygon, or a number indicating the width of
#' pixels in the line to be applied to all the polygons
#' @param fill_colour either a string specifying the column of \code{data}
#' containing the fill colour of each polygon, or a valid hexadecimal numeric
#' HTML style to be applied to all the polygons
#' @param fill_opacity either a string specifying the column of \code{data}
#' containing the fill opacity of each polygon, or a value between 0 and 1 that
#' will be applied to all the polygons
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
#'   add_overlay(north = 40.773941, south = 40.712216, east = -74.12544, west = -74.22655,
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


  urlCheck(overlay_url)

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

  urlCheck(kml_url)

  layer_id <- LayerId(layer_id)

  kml <- jsonlite::toJSON(data.frame(url = kml_url))

  invoke_method(map, data = NULL, 'add_kml', kml, layer_id)
}


#' Add GeoJson
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param geojson A character string or JSON/geoJSON literal of correctly formatted geoJSON
#' @param style Style options for the geoJSON. See details
#' @param update_map_view logical specifying if the map should re-centre according
#' to the geoJSON
#'
#' @examples
#' \dontrun{
#'
#' ## Rectangle polygons and a point over melbourne
#'  geojson_txt <- '{
#'    "type" : "FeatureCollection",
#'    "features" : [
#'      {
#'        "type" : "Feature",
#'        "properties" : {
#'          "color" : "green",
#'          "lineColor" : "blue"
#'        },
#'        "geometry" : {
#'          "type" : "Polygon", "coordinates" : [
#'            [
#'              [144.88, -37.85],
#'              [145.02, -37.85],
#'              [145.02, -37.80],
#'              [144.88, -37.80],
#'              [144.88, -37.85]
#'            ]
#'          ]
#'        }
#'      },
#'      {
#'        "type" : "Feature",
#'        "properties" : {
#'          "color" : "red"
#'        },
#'        "geometry" : {
#'          "type" : "Polygon", "coordinates" : [
#'            [
#'              [144.80, -37.85],
#'              [144.88, -37.85],
#'              [144.88, -37.80],
#'              [144.80, -37.80],
#'              [144.80, -37.85]
#'            ]
#'          ]
#'        }
#'      },
#'      {
#'        "type" : "Feature",
#'        "properties" : {
#'          "title" : "a point"
#'        },
#'        "geometry" : {
#'          "type" : "Point", "coordinates" : [145.00, -37.82]
#'        }
#'      }
#'    ]
#'  }'
#'
#' ## use the properties inside the geoJSON to style each feature
#' google_map(key = map_key) %>%
#'   add_geojson(geojson = geojson_txt,
#'     style = list(fillColor = "color", strokeColor = "lineColor", title = "title"))
#'
#' ## use a JSON style literal to style all features
#' style <- '{ "fillColor" : "green" , "strokeColor" : "black", "strokeWeight" : 0.5}'
#' google_map(key = map_key) %>%
#'   add_geojson(geojson = geojson_txt, style = style)
#'
#' ## GeoJSON from a URL
#' url <- 'https://storage.googleapis.com/mapsdevsite/json/google.json'
#' google_map(key = map_key) %>%
#'   add_geojson(geojson = url)
#'
#' }
#'
#' @details
#' The style of the geoJSON features can be defined inside the geoJSON itself,
#' or specified as a JSON literal that's used to style all the features the same
#'
#' To use the properties in the geoJSON to define the styles, set the \code{style}
#' argument to a named list, where each name is one of
#'
#' All Geometries
#'
#' \itemize{
#'   \item{clickable}
#'   \item{visible}
#'   \item{zIndex}
#' }
#'
#' Point Geometries
#'
#' \itemize{
#'   \item{cursor}
#'   \item{icon}
#'   \item{shape}
#'   \item{title}
#' }
#'
#' Line Geometries
#' \itemize{
#'   \item{strokeColor}
#'   \item{strokeOpacity}
#'   \item{strokeWeight}
#' }
#'
#' Polygon Geometries (Line Geometries, plus)
#' \itemize{
#'   \item{fillColor}
#'   \item{fillOpacity}
#' }
#'
#' and where the values are the the properties of the geoJSON that contain the relevant style
#' for those properties.
#'
#' To style all the features the same, supply a JSON literal that defines a value for each
#' of the style options (listed above)
#'
#' See examples.
#'
#' @export
add_geojson <- function(map, geojson, style = NULL, update_map_view = TRUE){

  ## TODO:
  ## - better handler geojson source (url or local) and style (list or json)
  ## -- the current appraoch is limiting
  ## - update bounds (https://stackoverflow.com/questions/28507044/zoom-to-geojson-polygons-bounds-in-google-maps-api-v3)

  ## DataLayer events https://developers.google.com/maps/documentation/javascript/datalayer#add_event_handlers
  ## - addFeature
  ## - click
  ## - dblclick
  ## - mosuedown
  ## - mouseout
  ## - mouseover
  ## - mouseup
  ## - removefeature
  ## - removeproperty
  ## - rightclick
  ## - setgeometry
  ## - setproperty

  geojson <- validateGeojson(geojson)

  if(!is.null(style))
    style <- validateStyle(style)

  invoke_method(map, data = NULL, 'add_geojson', geojson[['geojson']], geojson[['source']],
                style[['style']], style[['type']])
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
#' map_key <- 'your_api_key'
#'
#' qry <- data.frame(select = 'address',
#'     from = '1d7qpn60tAvG4LEg4jvClZbc1ggp8fIGGvpMGzA',
#'     where = 'ridership > 200')
#'
#' google_map(key = map_key, location = c(41.8, -87.7), zoom = 9) %>%
#'   add_fusion(query = qry)
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
#' google_map(key = map_key, location = c(-25.3, 133), zoom = 4) %>%
#'   add_fusion(query = qry, styles = styles)
#'
#' qry <- data.frame(select = 'location',
#'     from = '1xWyeuAhIFK_aED1ikkQEGmR8mINSCJO9Vq-BPQ')
#'
#' google_map(key = map_key, location = c(0, 0), zoom = 1) %>%
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
  ## - allow JSON style

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



#' Add Drawing
#'
#' Adds drawing tools to the map. Particularly useful when in an interactive (shiny) environment.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param drawing_modes string vector giving the drawing controls required.
#' One of one or more of marker, circle, polygon, polyline and rectangle
#' @param delete_on_change logical indicating if the currently drawn shapes
#' should be deleted when a new drawing mode is selected
#'
#' @examples
#' \dontrun{
#'
#' google_map(key = "your_api_key") %>%
#'   add_drawing()
#'
#' }
#' @export
add_drawing <- function(map,
                        drawing_modes = c('marker', 'circle', 'polygon', 'polyline', 'rectangle'),
                        delete_on_change = FALSE){

  logicalCheck(delete_on_change)

  drawing_modes <- jsonlite::toJSON(drawing_modes)

  ## set defaults:
  marker <- jsonlite::toJSON(markerDefaults())
  circle <- jsonlite::toJSON(circleDefaults())
  rectangle <- jsonlite::toJSON(rectangleDefaults())
  polyline <- jsonlite::toJSON(polylineDefaults())
  polygon <- jsonlite::toJSON(polygonDefaults())

  invoke_method(map, data = NULL, 'add_drawing', drawing_modes,
                marker, circle, rectangle, polyline, polygon, delete_on_change)
}

#' @rdname clear
#' @export
clear_drawing <- function(map){
  invoke_method(map, data = NULL, 'clear_drawing')
}

#' Remove drawing
#'
#' Removes the drawing controls from a map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @describeIn clear
#' @export
remove_drawing <- function(map){
  invoke_method(map, data = NULL, 'remove_drawing')
}

