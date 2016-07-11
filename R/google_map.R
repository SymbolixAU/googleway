#' Google map
#'
#' Generates a google map
#'
#' @import htmlwidgets
#' @import htmltools
#'
#' @export
google_map <- function(width = NULL, height = NULL, key) {

  # key <- read.dcf("~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  key <- sprintf('<script>
                 async defer src="https://maps.googleapis.com/maps/api/js?key=%s&callback=initMap">
                 </script>', key)

  # forward options using x
  x = list(
    key = key
  )


  # create widget
  htmlwidgets::createWidget(
    name = 'google_map',
    x,
    width = width,
    height = height,
    package = 'googleway'
  )
}

#' @export
google_map_html <- function(x = x, id = id, style = style, class = class,...){

  # key <- read.dcf("~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))
  key <- x$x$key

  list(tags$head(tags$style("#map { width: 100%; height: 400px; }")),
       tags$div(id = "map")
       # tags$script("function initMap() {
       #        var mapDiv = document.getElementById('map');
       #        var map = new google.maps.Map(mapDiv, {
       #        center: {lat: -37.8, lng: 145},
       #        zoom: 8
       #        });
       #        }"),
#         tags$body(HTML(sprintf('
# 									 <script async defer
#                          src="https://maps.googleapis.com/maps/api/js?key=%s&callback=initMap">
#                    </script>', key)))
  )
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

