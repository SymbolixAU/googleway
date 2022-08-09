googleImageMapTypeDependency <- function() {
  list(
    createHtmlDependency(
      name = "imageMapType",
      version = "1.0.0",
      src = system.file("htmlwidgets/lib/imageMap", package = "googleway"),
      script = c("imageMapType.js"),
      all_files = FALSE
    )
  )
}

#' Add Image Map
#'
#' @export
add_image_map <- function(map) {

  map <- addDependency(map, googleImageMapTypeDependency())

  invoke_method(map, "add_image_map_type")
}
