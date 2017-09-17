#' Google map
#'
#' Generates a google map object
#'
#' The data argument is only needed if you call other functions to add layers to the map, such as \code{add_markers()} or \code{add_polylines}. However, the data argument can also be passed into those functions as well.
#'
#' In order to use Google Maps you need a valid Google Maps Web JavaScript API key. See the Google Maps API documentation \url{https://developers.google.com/maps/}
#'
#' @import htmlwidgets
#' @import htmltools
#' @import shiny
#'
#' @aliases googleway
#' @param key A valid Google Maps API key. see Details
#' @param data data to be used on the map. This will likely contain two columns for latitude and longitude, and / or encoded polylines for plotting polylines and polygons
#' @param location \code{numeric} vector of latitude/longitude (in that order) coordinates for the initial starting position of the map. The map will automatically set the location and zoom if markers are supplied through \link{add_markers}. If null, the map will default to Melbourne, Australia.
#' @param zoom \code{integer} representing the zoom level of the map (0 is fully zoomed out)
#' @param width the width of the map
#' @param height the height of the map
#' @param padding the padding of the map
#' @param styles JSON string representation of a valid Google Maps styles Array. See the Google documentation for details \url{https://developers.google.com/maps/documentation/javascript/styling}
#' @param search_box \code{boolean} indicating if a search box should be placed on the map
#' @param zoom_control logical indicating if the zoom control should be displayed
#' @param map_type_control logical indicating if the map type control should be displayed
#' @param scale_control logical indicating if the scale control should be displayed
#' @param street_view_control logical indicating if the street view control should be displayed
#' @param rotate_control logical indicating if the rotate control should be displayed
#' @param fullscreen_control logical indicating if the full screen control should be displayed
#' @param libraries vector containgin the libraries you want to load. See details
#' @param event_return_type the type of data to return to R from an interactive environment (shiny),
#' either an R list, or raw JSON string.
#'
#' @details
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
#' df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
#' -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
#' ), lon = c(144.968612670898, 144.968414306641, 144.968139648438,
#' 144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
#' 97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
#' 77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
#' "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
#'
#' google_map(key = map_key, data = df_line) %>%
#'  add_markers() %>%
#'  add_heatmap() %>%
#'  add_traffic()
#'
#' ## style map using 'cobalt simplified' style
#' style <- '[{"featureType":"all","elementType":"all","stylers":[{"invert_lightness":true},
#' {"saturation":10},{"lightness":30},{"gamma":0.5},{"hue":"#435158"}]},
#' {"featureType":"road.arterial","elementType":"all","stylers":[{"visibility":"simplified"}]},
#' {"featureType":"transit.station","elementType":"labels.text","stylers":[{"visibility":"off"}]}]'
#' google_map(key = map_key, styles = style)
#'
#' }
#'
#'
#' @export
google_map <- function(key,
                       data = NULL,
                       location = NULL,
                       zoom = NULL,
                       width = NULL,
                       height = NULL,
                       padding = 0,
                       styles = NULL,
                       search_box = FALSE,
                       zoom_control = TRUE,
                       map_type_control = TRUE,
                       scale_control = FALSE,
                       street_view_control = TRUE,
                       rotate_control = TRUE,
                       fullscreen_control = TRUE,
                       libraries = NULL,
                       event_return_type = c("list", "JSON")) {

  logicalCheck(zoom_control)
  logicalCheck(map_type_control)
  logicalCheck(scale_control)
  logicalCheck(street_view_control)
  logicalCheck(rotate_control)
  logicalCheck(fullscreen_control)

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
    zoomControl = zoom_control,
    mapTypeControl = map_type_control,
    scaleControl = scale_control,
    streetViewControl = street_view_control,
    rotateControl = rotate_control,
    fullscreenControl = fullscreen_control,
    event_return_type = event_return_type
  )

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

  header <- paste0('<script src="https://maps.googleapis.com/maps/api/js?key=',
                  key, '&libraries=', paste0(libraries, collapse = ","), '"></script>')

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
#' api_key <- "your_api_key"
#'
#'   df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
#'   -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
#'   ), lon = c(144.968612670898, 144.968414306641, 144.968139648438,
#'   144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
#'   97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
#'   77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
#'   "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
#'
#'   output$map <- renderGoogle_map({
#'     google_map(key = api_key)
#'   })
#' }
#'
#' shinyApp(ui, server)
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

