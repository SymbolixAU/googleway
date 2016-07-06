#' Google map
#'
#' Generates a google map
#'
#' @import htmlwidgets
#' @import htmltools
#'
#' @export
google_map <- function(message, width = NULL, height = NULL) {

  # forward options using x
  x = list(
    message = message
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
google_map_html <- function(id, style, class, key, ...){
  key <- read.dcf("~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))
  src_url <- paste0("https://maps.googleapis.com/maps/api/js?key=", key, "&callback=initMap")
  list(tags$script(src=src_url),
       tags$link(rel="stylesheet", href="./inst/htmlwidgets/lib/map_style.css")
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

