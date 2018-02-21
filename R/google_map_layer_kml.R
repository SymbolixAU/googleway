googleKmlDependency <- function() {
  list(
    htmltools::htmlDependency(
      "kml",
      "1.0.0",
      system.file("htmlwidgets/lib/kml", package = "googleway"),
      script = c("kml.js")
    )
  )
}

#' Add KML
#'
#' Adds a KML layer to a map.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param kml_url URL string specifying the location of the kml layer
#' @param layer_id single value specifying an id for the layer.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' kmlUrl <- "http://googlemaps.github.io/js-v2-samples/ggeoxml/cta.kml"
#'
#' google_map(key = map_key) %>%
#'   add_kml(kml_url = kmlUrl)
#'
#' kmlUrl <- paste0('https://developers.google.com/maps/',
#' 'documentation/javascript/examples/kml/westcampus.kml')
#'
#' google_map(key = map_key) %>%
#'   add_kml(kml_url = kmlUrl)
#'
#' }
#' @export
add_kml <- function(map, kml_url, layer_id = NULL){

  urlCheck(kml_url)

  layer_id <- layerId(layer_id)

  kml <- jsonlite::toJSON(data.frame(url = kml_url))

  map <- addDependency(map, googleKmlDependency())

  invoke_method(map, 'add_kml', kml, layer_id)
}



#' @rdname clear
#' @export
clear_kml <- function(map, layer_id = NULL){
  layer_id <- layerId(layer_id)
  invoke_method(map, 'clear_kml', layer_id)
}


