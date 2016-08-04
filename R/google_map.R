#' Google map
#'
#' Generates a google map object. Will only work with a valid key
#'
#' @import jsonlite
#' @import htmlwidgets
#' @import htmltools
#'
#' @param key A valid Google Maps API key
#' @param location numeric vector of latitude/longitude (in that order) coordinates for the initial starting position of the map
#' @param zoom numeric integer representing the zoom level of the map (0 is fully zoomed out)
#' @param width desc
#' @param height desc
#' @param padding desc
#' @param styles JSON string representation of a valid Google Maps Style Array.
#' @param place_search desc
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
#'  add_markers() %>%
#'  add_heatmap() %>%
#'  add_traffic()
#'
#' ## style map using 'paper' style
#' style <- '[{"featureType":"administrative","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"landscape","elementType":"all","stylers":[{"visibility":"simplified"},{"hue":"#0066ff"},{"saturation":74},{"lightness":100}]},{"featureType":"poi","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"road","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"road.highway","elementType":"all","stylers":[{"visibility":"off"},{"weight":0.6},{"saturation":-85},{"lightness":61}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"visibility":"on"}]},{"featureType":"road.arterial","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"road.local","elementType":"all","stylers":[{"visibility":"on"}]},{"featureType":"transit","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"water","elementType":"all","stylers":[{"visibility":"simplified"},{"color":"#5f94ff"},{"lightness":26},{"gamma":5.86}]}]'
#'
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
                       place_search = FALSE) {

  ## TODO:
  ## centre map according to data/user location?
  ## other default location than Melbourne?
  ## map styles
  ## pass data into google_map, and use in the other map_layer() functions

  # key <- read.dcf("~/Documents/.googleAPI", fields = c("GOOGLE_MAP_KEY"))
  if(is.null(location))
    location <- c(-37.9, 144.5)

  if(is.null(zoom))
    zoom <- 8

  # forward options using x
  x = list(
    lat = location[1],
    lng = location[2],
    zoom = zoom,
    styles = styles,
    place_search = place_search
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
      defaultHeight = 400,
      padding = padding,
      browser.fill = FALSE
    )
  )

  if(place_search == TRUE){
    header <- paste0('<script src="https://maps.googleapis.com/maps/api/js?key=',
                     key, '&libraries=visualization,places"></script>')
  }else{
    header <- paste0('<script src="https://maps.googleapis.com/maps/api/js?key=',
                     key, '&libraries=visualization"></script>')
  }
  header_script <-
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
#' Output and render functions for using google_map within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a google_map
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name google_map-shiny
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

