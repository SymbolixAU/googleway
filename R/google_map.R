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
#' @examples
#' \dontrun{
#'
#' google_map(key = key, location = c(-37.9, 144.5), zoom = 12)
#' }
#'
#' @export
google_map <- function(key,
                       location = NULL,
                       zoom = NULL,
                       width = NULL,
                       height = NULL,
                       padding = 0) {

  ## TODO:
  ## centre map according to data/user location?
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
    zoom = zoom
  )

  # create widget
  googlemap <- htmlwidgets::createWidget(
    name = 'google_map',
    x,
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

  googlemap$dependencies <- c(googlemap$dependencies,
                              list(
                                htmltools::htmlDependency(
                                  name = "googleway",
                                  version = "9999",
                                  src=".",
                                  head = paste0('<script src="https://maps.googleapis.com/maps/api/js?key=', key, '&libraries=visualization"></script>'),
                                  all_files = FALSE
                                  )
                                )
                              )

  return(googlemap)
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
  htmlwidgets::shinyWidgetOutput(outputId, 'google_map', width, height, package = 'googleway')
}

#' @rdname google_map-shiny
#' @export
renderGoogle_map <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, google_mapOutput, env, quoted = TRUE)
}

