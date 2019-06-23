googleKmlDependency <- function() {
  list(
    createHtmlDependency(
      name = "kml",
      version = "1.0.0",
      src = system.file("htmlwidgets/lib/kml", package = "googleway"),
      script = c("kml.js"),
      all_files = FALSE
    )
  )
}

#' Add KML
#'
#' Adds a KML layer to a map.
#'
#' @inheritParams add_circles
#' @param kml_url URL string specifying the location of the kml layer
#'
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
add_kml <- function(map,
                    kml_url,
                    layer_id = NULL,
                    update_map_view = TRUE,
                    z_index = 5){
  urlCheck(kml_url)
  numericCheck(z_index)
  logicalCheck(update_map_view)

  layer_id <- layerId(layer_id)

  kml <- jsonlite::toJSON(data.frame(url = kml_url, z_index = z_index))

  map <- addDependency(map, googleKmlDependency())

  invoke_method(map, 'add_kml', kml, layer_id, !update_map_view)
}



#' @rdname clear
#' @export
clear_kml <- function(map, layer_id = NULL){
  layer_id <- layerId(layer_id)
  invoke_method(map, 'clear_kml', layer_id)
}


