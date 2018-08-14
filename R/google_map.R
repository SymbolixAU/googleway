#' Google map
#'
#' Generates a google map object
#'
#' @import htmlwidgets
#' @import htmltools
#' @import shiny
#'
#' @aliases googleway
#' @param key A valid Google Maps API key.
#' @param data data to be used on the map. Either a data.frame, or an \code{sf} object. See details
#' @param location \code{numeric} vector of latitude/longitude (in that order)
#' coordinates for the initial starting position of the map.
#' The map will automatically set the location and zoom if data is added through one
#' of the various \code{add_} functions. If null, the map will default to Melbourne, Australia.
#' @param zoom \code{integer} representing the zoom level of the map (0 is fully zoomed out)
#' @param width the width of the map
#' @param height the height of the map
#' @param padding the padding of the map
#' @param styles JSON string representation of a valid Google Maps styles Array.
#' See the Google documentation for details \url{https://developers.google.com/maps/documentation/javascript/styling}
#' @param search_box \code{boolean} indicating if a search box should be placed on the map
#' @param update_map_view logical indicating if the map should center on the searched location
#' @param zoom_control logical indicating if the zoom control should be displayed
#' @param map_type_control logical indicating if the map type control should be displayed
#' @param scale_control logical indicating if the scale control should be displayed
#' @param street_view_control logical indicating if the street view control should be displayed
#' @param rotate_control logical indicating if the rotate control should be displayed
#' @param fullscreen_control logical indicating if the full screen control should be displayed
#' @param libraries vector containgin the libraries you want to load. See details
#' @param split_view string giving the name of a UI output element in which to place
#' a streetview representation of the map. Will only work in an interactive environment (shiny).
#' @param split_view_options list of options to pass to the split street view.
#' valid list elements are \code{heading} and \code{pitch}
#' see \link{google_mapOutput}
#' @param event_return_type the type of data to return to R from an interactive environment (shiny),
#' either an R list, or raw json string.
#' @param geolocation logical indicating if you want geolocation enabled
#'
#' @details
#'
#' In order to use Google Maps you need a valid Google Maps Web JavaScript API key.
#' See the Google Maps API documentation \url{https://developers.google.com/maps/}
#'
#' The data argument is only needed if you call other functions to add layers to the map,
#' such as \code{add_markers()} or \code{add_polylines}. However, the data argument
#' can also be passed into those functions as well.
#'
#' The data can either be a data.frame containing longitude and latitude columns
#' or an encoded polyline for plotting polylines and polygons, or an \code{sf} object.
#'
#' The supported \code{sf} object types are
#'
#' \itemize{
#'   \item{POINT}
#'   \item{MULTIPOINT}
#'   \item{LINESTRING}
#'   \item{MULTILINESTRING}
#'   \item{POLYGON}
#'   \item{MULTIPOLYGON}
#'   \item{GEOMETRY}
#' }
#'
#'
#' The libraries argument can be used to turn-off certain libraries from being called.
#' By default the map will load
#' \itemize{
#'  \item{visualization - includes the HeatmapLayer for visualising heatmaps
#'  \url{https://developers.google.com/maps/documentation/javascript/visualization}}
#'  \item{geometry - utility functions for computation of geometric data on the surface of
#'  the earth, including plotting encoded polylines.
#'  \url{https://developers.google.com/maps/documentation/javascript/geometry}}
#'  \item{places - enables searching for places.
#'  \url{https://developers.google.com/maps/documentation/javascript/places}}
#'  \item{drawing - provides a graphical interface for users to draw polygons, rectangles,
#'  circles and markers on the map. \url{https://developers.google.com/maps/documentation/javascript/drawinglayer}}
#' }
#'
#' @examples
#' \dontrun{
#'
#' map_key <- "your_api_key"
#'
#' google_map(key = map_key, data = tram_stops) %>%
#'  add_markers() %>%
#'  add_traffic()
#'
#' ## style map using 'cobalt simplified' style
#' style <- '[{"featureType":"all","elementType":"all","stylers":[{"invert_lightness":true},
#' {"saturation":10},{"lightness":30},{"gamma":0.5},{"hue":"#435158"}]},
#' {"featureType":"road.arterial","elementType":"all","stylers":[{"visibility":"simplified"}]},
#' {"featureType":"transit.station","elementType":"labels.text","stylers":[{"visibility":"off"}]}]'
#'
#' google_map(key = map_key, styles = style)
#'
#' }
#'
#' @seealso \link{google_mapOutput}
#'
#' @export
google_map <- function(key = get_api_key("map"),
                       data = NULL,
                       location = NULL,
                       zoom = NULL,
                       width = NULL,
                       height = NULL,
                       padding = 0,
                       styles = NULL,
                       search_box = FALSE,
                       update_map_view = TRUE,
                       zoom_control = TRUE,
                       map_type_control = TRUE,
                       scale_control = FALSE,
                       street_view_control = TRUE,
                       rotate_control = TRUE,
                       fullscreen_control = TRUE,
                       libraries = NULL,
                       split_view = NULL,
                       split_view_options = NULL,
                       geolocation = FALSE,
                       event_return_type = c("list", "json")) {

  logicalCheck(zoom_control)
  logicalCheck(map_type_control)
  logicalCheck(scale_control)
  logicalCheck(street_view_control)
  logicalCheck(rotate_control)
  logicalCheck(fullscreen_control)
  logicalCheck(update_map_view)
  logicalCheck(geolocation)
  event_return_type <- match.arg(event_return_type)

  # split_view_options = list(heading = 34,
  #                            pitch = 10)
  split_view_options <- splitViewOptions(split_view_options)

  if(is.null(libraries))
    libraries <- c("visualization", "geometry", "places", "drawing")

  if(is.null(location))
    location <- c(-37.9, 144.5)  ## Melbourne, Australia

  if(is.null(zoom))
    zoom <- 8

  # forward options using x
  x = list(
    lat = location[1],
    lng = location[2],
    zoom = zoom,
    styles = styles,
    search_box = search_box,
    update_map_view = update_map_view,
    zoomControl = zoom_control,
    mapTypeControl = map_type_control,
    scaleControl = scale_control,
    streetViewControl = street_view_control,
    rotateControl = rotate_control,
    fullscreenControl = fullscreen_control,
    event_return_type = event_return_type,
    split_view = split_view,
    split_view_options = split_view_options,
    geolocation = geolocation
  )

  data <- normaliseData(data)

  # create widget
  googlemap <- htmlwidgets::createWidget(
    name = 'google_map',
    x = structure(
      x,
      google_map_data = data
    ),
    package = 'googleway',
    width = width,
    height = height,

    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = '100%',
      defaultHeight = 800,
      padding = padding,
      browser.fill = FALSE
    )
  )

  ## CHARTS2
  header <- paste0('<script src="https://maps.googleapis.com/maps/api/js?key=',
                  key, '&libraries=', paste0(libraries, collapse = ","), '"></script>',
                  '<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>')

  googlemap$dependencies <- c(
    googlemap$dependencies,
    list(
      htmltools::htmlDependency(
        name = "googleway",
        version = "9999",
        src=".",
        head = header,
        all_files = FALSE
        )
      )
    )

  return(googlemap)
}

splitViewOptions <- function(split_view_options) {
  ## add default values for spitViewOptions
  ## heading: 34
  ## pitch: 10
  if(is.null(split_view_options)) split_view_options <- list()
  split_view_options <- splitViewDefault(split_view_options, 'heading', 34)
  split_view_options <- splitViewDefault(split_view_options, 'pitch', 10)
  return(split_view_options)
}

splitViewDefault <- function(lst, key, default) {
  v <- lst[[key]]
  lst[[key]] <- ifelse(is.null(v), default, v)
  return(lst)
}


normaliseData <- function(data) UseMethod("normaliseData")

#' @export
normaliseData.sf <- function(data) googlePolylines::encode(data)

#' @export
normaliseData.default <- function(data) data

#' Clear search
#'
#' clears the markers placed on the map after using the search box
#' @param map a googleway map object created from \code{google_map()}
#'
#' @export
clear_search <- function(map){
  invoke_method(map, 'clear_search')
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

  invoke_method(map, 'update_style', styles)
}

#' Shiny bindings for google_map
#'
#' Output and render functions for using google_map within Shiny applications and interactive Rmd documents.
#'
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a google_map
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#' @name google_map-shiny
#' @examples
#' \dontrun{
#' library(shiny)
#' library(googleway)
#'
#' ui <- fluidPage(google_mapOutput("map"))
#'
#' server <- function(input, output, session){
#'
#'   api_key <- "your_api_key"
#'
#'   output$map <- renderGoogle_map({
#'     google_map(key = api_key)
#'   })
#' }
#'
#' shinyApp(ui, server)
#'
#' ## using split view
#'
#' library(shinydashboard)
#' library(googleway)
#'
#' ui <- dashboardPage(
#'
#'   dashboardHeader(),
#'   dashboardSidebar(),
#'   dashboardBody(
#'     box(width = 6,
#'         google_mapOutput(outputId = "map")
#'     ),
#'     box(width = 6,
#'         google_mapOutput(outputId = "pano")
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   set_key("your_api_key")
#'
#'   output$map <- renderGoogle_map({
#'     google_map(location = c(-37.817386, 144.967463),
#'                 zoom = 10,
#'                 split_view = "pano")
#'   })
#' }
#'
#' shinyApp(ui, server)
#'
#' }
#'
#' @export
google_mapOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId,
                                 'google_map',
                                 width,
                                 height,
                                 package = 'googleway')
}

#' @rdname google_map-shiny
#' @export
renderGoogle_map <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, google_mapOutput, env, quoted = TRUE)
}

# Get Map Data
#
# extracts teh data attribute from the map
#
# @param map a google_map object
#
get_map_data = function(map){
  attr(map$x, "google_map_data", exact = TRUE)
}


#' Map Styles
#'
#' Various styles for a \code{google_map()} map.
#'
#' @examples
#' \dontrun{
#' map_key <- "your_map_key"
#' google_map(key = map_key, style = map_styles()$silver)
#'
#' }
#'
#' @note you can generate your own map styles at \url{https://mapstyle.withgoogle.com/}
#'
#' @return list of styles
#' @export
map_styles <- function(){

  standard <- '[]'
  silver <- '[{"elementType": "geometry","stylers": [{"color": "#f5f5f5"}]},{"elementType": "labels.icon","stylers": [{"visibility": "off"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#616161"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#f5f5f5"}]},{"featureType": "administrative.land_parcel","elementType": "labels.text.fill","stylers": [{"color": "#bdbdbd"}]},{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#eeeeee"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#757575"}]},{"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#e5e5e5"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#9e9e9e"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#ffffff"}]},{"featureType": "road.arterial","elementType": "labels.text.fill","stylers": [{"color": "#757575"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#dadada"}]},{"featureType": "road.highway","elementType": "labels.text.fill","stylers": [{"color": "#616161"}]},{"featureType": "road.local","elementType": "labels.text.fill","stylers": [{"color": "#9e9e9e"}]},{"featureType": "transit.line","elementType": "geometry","stylers": [{"color": "#e5e5e5"}]},{"featureType": "transit.station","elementType": "geometry","stylers": [{"color": "#eeeeee"}]},{"featureType": "water","elementType": "geometry","stylers": [{"color": "#c9c9c9"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#9e9e9e"}]}]'
  retro <- '[{"elementType": "geometry","stylers": [{"color": "#ebe3cd"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#523735"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#f5f1e6"}]},{"featureType": "administrative","elementType": "geometry.stroke","stylers": [{"color": "#c9b2a6"}]},{"featureType": "administrative.land_parcel","elementType": "geometry.stroke","stylers": [{"color": "#dcd2be"}]},{"featureType": "administrative.land_parcel","elementType": "labels.text.fill","stylers": [{"color": "#ae9e90"}]},{"featureType": "landscape.natural","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#93817c"}]},{"featureType": "poi.park","elementType": "geometry.fill","stylers": [{"color": "#a5b076"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#447530"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#f5f1e6"}]},{"featureType": "road.arterial","elementType": "geometry","stylers": [{"color": "#fdfcf8"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#f8c967"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#e9bc62"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry","stylers": [{"color": "#e98d58"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry.stroke","stylers": [{"color": "#db8555"}]},{"featureType": "road.local","elementType": "labels.text.fill","stylers": [{"color": "#806b63"}]},{"featureType": "transit.line","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "transit.line","elementType": "labels.text.fill","stylers": [{"color": "#8f7d77"}]},{"featureType": "transit.line","elementType": "labels.text.stroke","stylers": [{"color": "#ebe3cd"}]},{"featureType": "transit.station","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "water","elementType": "geometry.fill","stylers": [{"color": "#b9d3c2"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#92998d"}]}]'
  dark <- '[{"elementType": "geometry","stylers": [{"color": "#212121"}]},{"elementType": "labels.icon","stylers": [{"visibility": "off"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#757575"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#212121"}]},{"featureType": "administrative","elementType": "geometry","stylers": [{"color": "#757575"}]},{"featureType": "administrative.country","elementType": "labels.text.fill","stylers": [{"color": "#9e9e9e"}]},{"featureType": "administrative.land_parcel","stylers": [{"visibility": "off"}]},{"featureType": "administrative.locality","elementType": "labels.text.fill","stylers": [{"color": "#bdbdbd"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#757575"}]},{"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#181818"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#616161"}]},{"featureType": "poi.park","elementType": "labels.text.stroke","stylers": [{"color": "#1b1b1b"}]},{"featureType": "road","elementType": "geometry.fill","stylers": [{"color": "#2c2c2c"}]},{"featureType": "road","elementType": "labels.text.fill","stylers": [{"color": "#8a8a8a"}]},{"featureType": "road.arterial","elementType": "geometry","stylers": [{"color": "#373737"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#3c3c3c"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry","stylers": [{"color": "#4e4e4e"}]},{"featureType": "road.local","elementType": "labels.text.fill","stylers": [{"color": "#616161"}]},{"featureType": "transit","elementType": "labels.text.fill","stylers": [{"color": "#757575"}]},{"featureType": "water","elementType": "geometry","stylers": [{"color": "#000000"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#3d3d3d"}]}]'
  night <- '[{"elementType": "geometry","stylers": [{"color": "#242f3e"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#746855"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#242f3e"}]},{"featureType": "administrative.locality","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#263c3f"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#6b9a76"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#38414e"}]},{"featureType": "road","elementType": "geometry.stroke","stylers": [{"color": "#212a37"}]},{"featureType": "road","elementType": "labels.text.fill","stylers": [{"color": "#9ca5b3"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#746855"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#1f2835"}]},{"featureType": "road.highway","elementType": "labels.text.fill","stylers": [{"color": "#f3d19c"}]},{"featureType": "transit","elementType": "geometry","stylers": [{"color": "#2f3948"}]},{"featureType": "transit.station","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "water","elementType": "geometry","stylers": [{"color": "#17263c"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#515c6d"}]},{"featureType": "water","elementType": "labels.text.stroke","stylers": [{"color": "#17263c"}]}]'
  aubergine <- '[{"elementType": "geometry","stylers": [{"color": "#1d2c4d"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#8ec3b9"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#1a3646"}]},{"featureType": "administrative.country","elementType": "geometry.stroke","stylers": [{"color": "#4b6878"}]},{"featureType": "administrative.land_parcel","elementType": "labels.text.fill","stylers": [{"color": "#64779e"}]},{"featureType": "administrative.province","elementType": "geometry.stroke","stylers": [{"color": "#4b6878"}]},{"featureType": "landscape.man_made","elementType": "geometry.stroke","stylers": [{"color": "#334e87"}]},{"featureType": "landscape.natural","elementType": "geometry","stylers": [{"color": "#023e58"}]},{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#283d6a"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#6f9ba5"}]},{"featureType": "poi","elementType": "labels.text.stroke","stylers": [{"color": "#1d2c4d"}]},{"featureType": "poi.park","elementType": "geometry.fill","stylers": [{"color": "#023e58"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#3C7680"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#304a7d"}]},{"featureType": "road","elementType": "labels.text.fill","stylers": [{"color": "#98a5be"}]},{"featureType": "road","elementType": "labels.text.stroke","stylers": [{"color": "#1d2c4d"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#2c6675"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#255763"}]},{"featureType": "road.highway","elementType": "labels.text.fill","stylers": [{"color": "#b0d5ce"}]},{"featureType": "road.highway","elementType": "labels.text.stroke","stylers": [{"color": "#023e58"}]},{"featureType": "transit","elementType": "labels.text.fill","stylers": [{"color": "#98a5be"}]},{"featureType": "transit","elementType": "labels.text.stroke","stylers": [{"color": "#1d2c4d"}]},{"featureType": "transit.line","elementType": "geometry.fill","stylers": [{"color": "#283d6a"}]},{"featureType": "transit.station","elementType": "geometry","stylers": [{"color": "#3a4762"}]},{"featureType": "water","elementType": "geometry","stylers": [{"color": "#0e1626"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#4e6d70"}]}]'

  return(list(standard = standard,
              silver = silver,
              retro = retro,
              dark = dark,
              night = night,
              aubergine = aubergine))
}
