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
#' @examples
#' \dontrun{
#'
#' library(magrittr)  ## for the %>% pipes
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
#' library(magrittr)
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
                       search_box = FALSE) {

  ## TODO:
  ## centre map according to data/user location?
  ## other default location than Melbourne?
  ## pass data into google_map, and use in the other map_layer() functions

  # key <- read.dcf("~/Documents/.googleAPI", fields = c("GOOGLE_MAP_KEY"))
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
    search_box = search_box
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

  # if(search_box == TRUE){
    header <- paste0('<script src="https://maps.googleapis.com/maps/api/js?key=',
                     key, '&libraries=visualization,geometry,places"></script>')
  # }else{
  #   header <- paste0('<script src="https://maps.googleapis.com/maps/api/js?key=',
  #                    key, '&libraries=visualization,geometry"></script>')
  # }

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

get_map_data = function(map){
  attr(map$x, "google_map_data", exact = TRUE)
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
#' library(magrittr)
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


# google_map_html <- function(id, style, class, ...){
#   list(
#       tags$div(id = id, class = class, style = style,
#                tags$div(id = "search-container", class = "inner-addon right-addon",
#                         tags$input(id = "pac-input", class = "controls", type = "text"),
#                         tags$span(id = "search-clear", class="glyphicon glyphicon-remove-cirlce")))
#       )
# }


