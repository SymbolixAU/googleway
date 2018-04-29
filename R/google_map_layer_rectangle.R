googleRectangleDependency <- function() {
  list(
    htmltools::htmlDependency(
      "rectangles",
      "1.0.0",
      system.file("htmlwidgets/lib/rectangles", package = "googleway"),
      script = c("rectangles.js")
    )
  )
}

#' Add Rectangles
#'
#' Adds a rectangle to a google map
#'
#' @inheritParams add_circles
#' @param data data frame containing the bounds for the rectangles
#' @param north String specifying the column of \code{data} that contains the
#' northern most latitude coordinate
#' @param east String specifying the column of \code{data} that contains the
#' eastern most longitude
#' @param south String specifying the column of \code{data} that contains the
#' southern most latitude coordinate
#' @param west String specifying the column of \code{data} that contains the
#' western most longitude
#' @param editable String specifying the column of \code{data} that indicates if the
#' rectangle is editable. The value in the column should be logical
#'
#' @details
#' \code{z_index} values define the order in which objects appear on the map.
#' Those with a higher value appear on top of those with a lower value. The default
#' order of objects is (1 being underneath all other objects)
#'
#' \itemize{
#'   \item{1. Polygon}
#'   \item{2. Rectangle}
#'   \item{3. Polyline}
#'   \item{4. Circle}
#' }
#'
#' Markers are always the top layer
#'
#' @inheritSection add_circles palette
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' df <- data.frame(north = 33.685, south = 33.671, east = -116.234, west = -116.251)
#'
#' google_map(key = map_key) %>%
#'   add_rectangles(data = df, north = 'north', south = 'south',
#'                  east = 'east', west = 'west')
#'
#' ## editable rectangle
#' df <- data.frame(north = -37.8459, south = -37.8508, east = 144.9378,
#'                   west = 144.9236, editable = T, draggable = T)
#'
#' google_map(key = map_key) %>%
#'   add_rectangles(data = df, north = 'north', south = 'south',
#'                  east = 'east', west = 'west',
#'                  editable = 'editable', draggable = 'draggable')
#'
#' }
#' @export
add_rectangles <- function(map,
                           data = get_map_data(map),
                           north,
                           east,
                           south,
                           west,
                           id = NULL,
                           draggable = NULL,
                           editable = NULL,
                           stroke_colour = NULL,
                           stroke_opacity = NULL,
                           stroke_weight = NULL,
                           fill_colour = NULL,
                           fill_opacity = NULL,
                           mouse_over = NULL,
                           mouse_over_group = NULL,
                           info_window = NULL,
                           layer_id = NULL,
                           update_map_view = TRUE,
                           z_index = NULL,
                           digits = 4,
                           palette = NULL,
                           legend = F,
                           legend_options = NULL,
                           load_interval = 0,
                           focus_layer = FALSE
                           ){

  objArgs <- match.call(expand.dots = F)

  ## PARAMETER CHECKS
  if(!dataCheck(data, "add_rectangles")) data <- rectangleDefaults(1)
  layer_id <- layerId(layer_id)

  logicalCheck(update_map_view)
  logicalCheck(focus_layer)
  numericCheck(digits)
  numericCheck(z_index)
  loadIntervalCheck(load_interval)
  palette <- paletteCheck(palette)

  infoWindowChart <- NULL
  if (!is.null(info_window) && isInfoWindowChart(info_window)) {
    infoWindowChart <- info_window
    objArgs[['info_window']] <- NULL
  }

  ## END PARAMETER CHECKS

  allCols <- rectangleColumns()
  requiredCols <- requiredShapeColumns()
  colourColumns <- shapeAttributes(fill_colour, stroke_colour)

  shape <- createMapObject(data, allCols, objArgs)
  pal <- createPalettes(shape, colourColumns)
  colour_palettes <- createColourPalettes(data, pal, colourColumns, palette)
  colours <- createColours(shape, colour_palettes)

  if(length(colours) > 0){
    shape <- replaceVariableColours(shape, colours)
  }

  ## LEGEND
  legend <- resolveLegend(legend, legend_options, colour_palettes)

  requiredDefaults <- setdiff(requiredCols, names(shape))
  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "rectangle")
  }

  shape <- createInfoWindowChart(shape, infoWindowChart, id)
  shape <- jsonlite::toJSON(shape, digits = digits)

  map <- addDependency(map, googleRectangleDependency())

  invoke_method(map, 'add_rectangles', shape, update_map_view, layer_id, legend, load_interval, focus_layer)
}


#' @rdname clear
#' @export
clear_rectangles <- function(map, layer_id = NULL){
  layer_id <- layerId(layer_id)
  invoke_method(map, 'clear_rectangles', layer_id)
}



#' Update rectangles
#'
#' Updates specific colours and opacities of specified rectangles Designed to be
#' used in a shiny application.
#'
#' @note Any rectangles (as specified by the \code{id} argument) that do not exist
#' in the \code{data} passed into \code{add_rectangles()} will not be added to the map.
#' This function will only update the rectangles that currently exist on the map when
#' the function is called.
#'
#' @inheritParams update_circles
#'
#' @export
update_rectangles <- function(map, data, id,
                              draggable = NULL,
                              stroke_colour = NULL,
                              stroke_weight = NULL,
                              stroke_opacity = NULL,
                              fill_colour = NULL,
                              fill_opacity = NULL,
                              info_window = NULL,
                              layer_id = NULL,
                              digits = 4,
                              palette = NULL,
                              legend = F,
                              legend_options = NULL){

  objArgs <- match.call(expand.dots = F)

  layer_id <- layerId(layer_id)
  numericCheck(digits)
  palette <- paletteCheck(palette)

  infoWindowChart <- NULL
  if (!is.null(info_window) && isInfoWindowChart(info_window)) {
    infoWindowChart <- info_window
    objArgs[['info_window']] <- NULL
  }

  allCols <- rectangleColumns()
  requiredCols <- requiredShapeColumns()
  colourColumns <- shapeAttributes(fill_colour, stroke_colour)

  shape <- createMapObject(data, allCols, objArgs)
  pal <- createPalettes(shape, colourColumns)
  colour_palettes <- createColourPalettes(data, pal, colourColumns, palette)
  colours <- createColours(shape, colour_palettes)

  if(length(colours) > 0){
    shape <- replaceVariableColours(shape, colours)
  }

  legend <- resolveLegend(legend, legend_options, colour_palettes)

  requiredDefaults <- setdiff(requiredCols, names(shape))
  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "rectangle")
  }

  shape <- createInfoWindowChart(shape, infoWindowChart, id)
  shape <- jsonlite::toJSON(shape, digits = digits)

  invoke_method(map, 'update_rectangles', shape, layer_id, legend)
}

