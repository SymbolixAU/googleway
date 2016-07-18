#' Google map
#'
#' Generates a google map object. Will only work with a valid key (see \link{map_key})
#'
#' @import htmlwidgets
#' @import htmltools
#' @examples
#' \dontrun{
#'
#' map <- google_map()
#' map$dependencies <- map_key(key)
#'
#' }
#'
#' @export
google_map <- function(width = NULL, height = NULL, padding = 0) {

  # key <- read.dcf("~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))

  # forward options using x
  x = list(
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'google_map',
    x,
    package = 'googleway',
    width = width,
    height = height,

    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = '100%',
      defaultHeight = 400,
      padding = padding,
      browser.fill = TRUE
    )
  )
}

#' Map key
#'
#' Adds the Google Maps API key to a map object
#'
#' @param key \code{string} a valid Google Maps API key
#' @examples
#' \dontrun{
#'
#' map <- google_map()
#' map$dependencies <- map_key(key)
#'
#' }
#' @export
map_key <- function(key){
  list(
    htmltools::htmlDependency(
      name = "googleway",
      version = "9999",
      src=".",
      head = paste0('<script src="https://maps.googleapis.com/maps/api/js?key=', key, '"></script>'),
      all_files = FALSE
    )
  )
}


google_key_dependency <- function(key) {

  list(
    htmltools::htmlDependency(
      name = "googleway",
      version = "9999",
      src=".",
      head = paste0('<script src="https://maps.googleapis.com/maps/api/js?key=', key, '"></script>'),
      all_files = FALSE
    )
  )
}


google_map_html <- function(id = id, style = style, class = class,...){

  list(tags$div(id = id, style = style, class = class,
                tags$div(id = "map"),
                tags$script("initMap();")
                )
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

