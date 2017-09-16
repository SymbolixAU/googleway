#' Add GeoJson
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param geojson A character string or JSON/geoJSON literal of correctly formatted geoJSON
#' @param layer_id single value specifying an id for the layer.
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
#'          "fillColor" : "green",
#'          "strokeColor" : "blue",
#'          "id" : "green_rectangle",
#'          "location" : "melbourne",
#'          "value" : 100
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
#'          "fillColor" : "red",
#'          "id" : "red_rectangle",
#'          "location" : "melbourne",
#'          "value" : 200
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
#'          "title" : "a point",
#'          "location" : "melbourne",
#'          "value" : 100
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
add_geojson <- function(map, geojson, layer_id = NULL, style = NULL, update_map_view = TRUE){

  ## TODO:
  ## - better handler geojson source (url or local) and style (list or json)
  ## -- the current appraoch is limiting
  ## - update bounds (https://stackoverflow.com/questions/28507044/zoom-to-geojson-polygons-bounds-in-google-maps-api-v3)
  ## - drag & drop geojson - https://developers.google.com/maps/documentation/javascript/examples/layer-data-dragndrop
  ## - replicate blog: https://maps-apis.googleblog.com/2014/04/build-map-infographic-with-google-maps.html

  ## the GeoJSON can be supplied as geojson string, or a URL pointing to valid GeoJSON
  ## the style can either be defined in the geoJSON, or defined manually
  ## geoJSON defined:
  ## -- we need to know the mapping between the geoJSON and the style elements
  ## -- e.g, which object is the fill_colour / stroke_colour, etc.
  ## -- JSON / list / data.frame that provides the mapping?
  ## -- or if the geoJSON contains 'stroke_colour', 'fill_colour' properties, it auto-detects

  ## auto detect - Google seems to be able to do this, given keys are
  ## - properties.fillColour, etc

  ## manually defined:
  ## -- JSON literal
  ## -- list (that can convert to JSON)
  ## -- data.frame (that can convert to JSON)

  ## if styles are NULL, set defaults
  ## if they are defined by the user, rename them to match what google expects?
  ## or set a separate 'style' object?

  ## 'style' argument will be a list/json/data.frame, where the names must be 'fillColor', 'strokeColor' etc.
  ## - if provided, this will set the style for all features (google auto-detects the properties)
  ## - if not provided, the function will look for those within the geoJSON, and use if availabl.e
  ##

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

  layer_id <- layerId(layer_id)

  geojson <- validateGeojson(geojson)

  if(!is.null(style))
    style <- validateStyle(style)

  invoke_method(map,
                data = NULL,
                'add_geojson',
                geojson[['geojson']],
                geojson[['source']],
                style[['style']],
                "auto",
                FALSE,
                layer_id
                #                style[['type']]
  )
}



clear_geojson <- function(map, layer_id = NULL){

  layer_id <- layerId(layer_id)

  invoke_method(map, data = NULL, "clear_geojson", layer_id)
}



#' update geojson
#'
#' Updates a geojson layer by a specified style
#'
#' @param map
#' @param layer_id
#' @param style
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
#' style <- '{
#'     "property" : "value",
#'     "value" : 100,
#'     "operator" : ">=",
#'     "features" : {
#'       "fillColor" : "white",
#'       "strokeColor" : "white",
#'       "icon" : "https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png"
#'     }
#'   }'
#'
#' google_map(key = mapKey) %>%
#'     add_geojson(geojson = geojson_txt) %>%
#'     update_geojson(style = lst_style)
#'
#' lst_style <- list(property = "value", operator = ">=", value = 100,
#'                   features = list(fillColor = "white",
#'                                   strokeColor = "white",
#'                                   icon = "https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png"))
#'
#' }
#'
#' google_map(key = mapKey) %>%
#'     add_geojson(geojson = geojson_txt) %>%
#'     update_geojson(style = lst_style)
#'
#' @export
update_geojson <- function(map, layer_id = NULL, style){

  layer_id <- layerId(layer_id)
  style <- validateStyleUpdate(style)

  invoke_method(map, data = NULL, "update_geojson", style, layer_id)
}
