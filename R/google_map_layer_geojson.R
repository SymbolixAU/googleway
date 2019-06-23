googleGeojsonDependency <- function() {
  list(
    createHtmlDependency(
      name = "geojson",
      version = "1.0.0",
      src = system.file("htmlwidgets/lib/geojson", package = "googleway"),
      script = c("geojson.js"),
      all_files = FALSE
    )
  )
}

#' Drag Drop Geojson
#'
#' A function that enables you to drag data and drop it onto a map. Currently
#' only supports GeoJSON files / text
#'
#' @param map a googleway map object created from \code{google_map()}
#'
#' @export
add_dragdrop <- function(map){

  map <- addDependency(map, googleGeojsonDependency())

  invoke_method(map, "drag_drop_geojson")
}


#' Add GeoJson
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data A character string or geoJSON literal of correctly formatted geoJSON
#' @param layer_id single value specifying an id for the layer.
#' @param style Style options for the geoJSON. See details
#' @param mouse_over logical indicating if a feature should be highlighted when
#' the mouse passess over
#' @param update_map_view logical specifying if the map should re-centre according
#' to the geoJSON
#'
#' @examples
#' \dontrun{
#'
#'
#' ## use the properties inside the geoJSON to style each feature
#' google_map(key = map_key) %>%
#'   add_geojson(data = geo_melbourne)
#'
#' ## use a JSON string to style all features
#' style <- '{ "fillColor" : "green" , "strokeColor" : "black", "strokeWeight" : 0.5}'
#' google_map(key = map_key) %>%
#'   add_geojson(data = geo_melbourne, style = style)
#'
#'
#' ## use a named list to style all features
#' style <- list(fillColor = "red" , strokeColor = "blue", strokeWeight = 0.5)
#' google_map(key = map_key) %>%
#'   add_geojson(data = geo_melbourne, style = style)
#'
#' ## GeoJSON from a URL
#' url <- 'https://storage.googleapis.com/mapsdevsite/json/google.json'
#' google_map(key = map_key) %>%
#'   add_geojson(data = url, mouse_over = T)
#'
#' }
#'
#' @details
#' The style of the geoJSON features can be defined inside the geoJSON itself,
#' or specified as a JSON string or R list that's used to style all the features the same
#'
#' To use the properties in the geoJSON to define the styles, set the \code{style}
#' argument to a JSON string or a named list, where each name is one of
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
#' To style all the features the same, supply a JSON string or R list that
#' defines a value for each of the style options (listed above)
#'
#' See examples.
#'
#' @export
add_geojson <- function(map,
                        data = get_map_data(map),
                        layer_id = NULL,
                        style = NULL,
                        mouse_over = FALSE,
                        update_map_view = TRUE){

  ## TODO:
  ## - replicate blog: https://maps-apis.googleblog.com/2014/04/build-map-infographic-with-google-maps.html

  ## DataLayer events https://developers.google.com/maps/documentation/javascript/datalayer#add_event_handlers
  ## - addFeature
  ## - click
  ## - dblclick
  ## - mousedown
  ## - mouseout
  ## - mouseover
  ## - mouseup
  ## - removefeature
  ## - removeproperty
  ## - rightclick
  ## - setgeometry
  ## - setproperty

  layer_id <- layerId(layer_id)
  logicalCheck(mouse_over)
  geojson <- validateGeojson(data)

  if(!is.null(style))
    style <- validateStyle(style)

  map <- addDependency(map, googleGeojsonDependency())

  invoke_method(map, 'add_geojson', geojson[['geojson']], geojson[['source']],
                style[['style']], update_map_view, mouse_over,
                layer_id)
}


#' @rdname clear
#' @export
clear_geojson <- function(map, layer_id = NULL){

  layer_id <- layerId(layer_id)

  invoke_method(map, "clear_geojson", layer_id)
}



#' update geojson
#'
#' Updates a geojson layer by a specified style. Designed to work within an interactive
#' environment (e.g. shiny)
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param layer_id single value specifying an id for the layer.
#' @param style Style options for the geoJSON. See details
#'
#' @details
#' The style object can either be a valid JSON string, or a named list.
#' The style object will contain the following fields
#'
#' \itemize{
#' \item{property : the property of the geoJSON that contains the \code{value}}
#' \item{value : the value of the geoJSON that identifies the feature to be updated}
#' \item{features : a list (or JSON object) of features to be updated}
#' }
#'
#' see \link{add_geojson} for valid features
#'
#' @examples
#' \dontrun{
#'
#' style <- paste0('{
#'     "property" : "AREASQKM",
#'     "value" : 5,
#'     "operator" : ">=",
#'     "features" : {
#'       "fillColor" : "red",
#'       "strokeColor" : "red"
#'     }
#'   }')
#'
#' google_map(key = map_key) %>%
#'     add_geojson(data = geo_melbourne) %>%
#'     update_geojson(style = style)
#'
#' lst_style <- list(property = "AREASQKM", operator = "<=", value = 5,
#'    features = list(fillColor = "red",
#'    strokeColor = "red"))
#'
#' google_map(key = map_key) %>%
#'     add_geojson(data = geo_melbourne) %>%
#'     update_geojson(style = lst_style)
#'
#' ## Styling a specific feature
#' style <- '{"property" : "SA2_NAME", "value" : "Abbotsford", "features" : { "fillColor" : "red" } }'
#' google_map(key = map_key) %>%
#'   add_geojson(data = geo_melbourne) %>%
#'   update_geojson(style = style)
#'
#' }
#'
#' @export
update_geojson <- function(map, layer_id = NULL, style){

  layer_id <- layerId(layer_id)
  style <- validateStyleUpdate(style)

  invoke_method(map, "update_geojson", style, layer_id)
}




