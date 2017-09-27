#' Add circle
#'
#' Add circles to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the
#' latitude coordinates, and the other specifying the longitude. If Null, the
#' data passed into \code{google_map()} will be used.
#' @param id string specifying the column containing an identifier for a circle
#' @param lat string specifying the column of \code{data} containing the 'latitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param radius either a string specifying the column of \code{data} containing the
#' radius of each circle, OR a numeric value specifying the radius of all the circles
#' (radius is expressed in metres)
#' @param draggable string specifying the column of \code{data} defining if the circle
#' is 'draggable' (either TRUE or FALSE)
#' @param stroke_colour either a string specifying the column of \code{data} containing
#' the stroke colour of each circle, or a valid hexadecimal numeric HTML style to
#' be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing
#' the stroke opacity of each circle, or a value between 0 and 1 that will be
#' applied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing
#' the stroke weight of each circle, or a number indicating the width of pixels
#' in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data} containing
#' the fill colour of each circle, or a valid hexadecimal numeric HTML style to
#' be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing
#' the fill opacity of each circle, or a value between 0 and 1 that will be applied to all the circles
#' @param info_window string specifying the column of data to display in an info
#' window when a circle is clicked
#' @param mouse_over string specifying the column of data to display when the
#' mouse rolls over the circle
#' @param mouse_over_group string specifying the column of data specifying which
#' groups of circles to highlight on mouseover
#' @param layer_id single value specifying an id for the layer.
#'  layer.
#' @param update_map_view logical specifying if the map should re-centre according to
#' the circles
#' @param z_index single value specifying where the circles appear in the layering
#' of the map objects. Layers with a higher \code{z_index} appear on top of those with
#' a lower \code{z_index}. See details.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#' @param palette a function that generates hex RGB colours given a single number as an input.
#' Used when a variable of \code{data} is specified as a colour
#' @param legend logical indicating if a legend should be included on the map
#' @param legend_options
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
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' google_map(key = map_key, data = tram_stops) %>%
#'  add_circles(lat = "stop_lat", lon = "stop_lon", fill_colour = "stop_name",
#'  stroke_weight = 0.3, stroke_colour = "stop_name")
#'
#'  }
#' @export
add_circles <- function(map,
                        data = get_map_data(map),
                        id = NULL,
                        lat = NULL,
                        lon = NULL,
                        radius = NULL,
                        draggable = NULL,
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
                        legend_options = NULL){

  objArgs <- match.call(expand.dots = F)

  ## PARAMETER CHECKS
  if(!dataCheck(data, "add_circles")) data <- circleDefaults(1)
  layer_id <- layerId(layer_id)

  objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_circles")
  logicalCheck(update_map_view)
  numericCheck(digits)
  numericCheck(z_index)
  palette <- paletteCheck(palette)
  ## END PARAMETER CHECKS


  allCols <- circleColumns()
  requiredCols <- requiredCircleColumns()
  colourColumns <- shapeAttributes(fill_colour, stroke_colour)

  shape <- createMapObject(data, allCols, objArgs)
  pal <- createPalettes(shape, colourColumns)
  colour_palettes <- createColourPalettes(data, pal, colourColumns, viridisLite::viridis)
  colours <- createColours(shape, colour_palettes)

  # colours <- setupColours(data, shape, colourColumns, palette)
  if(length(colours) > 0){
    shape <- replaceVariableColours(shape, colours)
  }

  if(legend){
    ## TODO:
    ## - map all fills, stroke, weight, opacity to legend?
    ## - assign different palettes to different aesthetics (fill & stroke) ?

    legend <- lapply(colour_palettes, function(x){
      list(
        colourType = ifelse('fill_colour' %in% names(x$variables), 'fill_colour', 'stroke_colour'),
        type = getLegendType(x$palette[['variable']]),
        title = unique(x$variable),
        legend = x$palette
      )
    })
    # legendIdx <- which(names(colourColumns) == 'fill_colour')
    # legend <- colour_palettes[[legendIdx]]$palette
    # title <- colour_palettes[[legendIdx]]$variables
    # type <- getLegendType(legend$variable)
    # legend <- constructLegend(legend, type)
    #
    # ## legend options:
    # ## title
    # ## css
    # ## position
    # ## text format
    legend_options = list(#type = type,
                          #title = title,
                          #css = 'max-width : 120px; max-height : 160px; overflow : auto;',
                          position = "BOTTOM_LEFT")
    legend_options <- jsonlite::toJSON(legend_options, auto_unbox = T)
  }

  requiredDefaults <- setdiff(requiredCols, names(shape))
  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "circle")
  }

  shape <- jsonlite::toJSON(shape, digits = digits)

  invoke_method(map, 'add_circles', shape, update_map_view, layer_id, legend, legend_options)
}

#' @rdname clear
#' @export
clear_circles <- function(map, layer_id = NULL){
  layer_id <- layerId(layer_id)
  invoke_method(map, data = NULL, 'clear_circles', layer_id)
}


#' Update circles
#'
#' Updates specific colours and opacities of specified circles Designed to be
#' used in a shiny application.
#'
#' @note Any circles (as specified by the \code{id} argument) that do not exist
#' in the \code{data} passed into \code{add_circles()} will not be added to the map.
#' This function will only update the circles that currently exist on the map when
#' the function is called.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data.frame containing the new values for the circles
#' @param id string representing the column of \code{data} containing the id values
#' for the circles. The id values must be present in the data supplied to
#' \code{add_circles} in order for the polygons to be udpated
#' @param radius either a string specifying the column of \code{data} containing
#' the radius of each circle, OR a numeric value specifying the radius of all the
#' circles (radius is expressed in metres)
#' @param draggable string specifying the column of \code{data} defining if the
#' circle is 'draggable' (either TRUE or FALSE)
#' @param stroke_colour either a string specifying the column of \code{data} containing
#' the stroke colour of each circle, or a valid hexadecimal numeric HTML style
#' to be applied to all the circles
#' @param stroke_opacity either a string specifying the column of \code{data} containing
#' the stroke opacity of each circle, or a value between 0 and 1 that will be
#' applied to all the circles
#' @param stroke_weight either a string specifying the column of \code{data} containing
#' the stroke weight of each circle, or a number indicating the width of pixels
#' in the line to be applied to all the circles
#' @param fill_colour either a string specifying the column of \code{data} containing
#' the fill colour of each circle, or a valid hexadecimal numeric HTML style to
#' be applied to all the cirlces
#' @param fill_opacity either a string specifying the column of \code{data} containing
#' the fill opacity of each circle, or a value between 0 and 1 that will be applied
#' to all the circles
#' @param layer_id single value specifying an id for the layer.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#' @param palette a function that generates hex RGB colours given a single number as an input.
#' Used when a variable of \code{data} is specified as a colour
#'
#' @export
update_circles <- function(map, data, id,
                           radius = NULL,
                           draggable = NULL,
                           stroke_colour = NULL,
                           stroke_weight = NULL,
                           stroke_opacity = NULL,
                           fill_colour = NULL,
                           fill_opacity = NULL,
                           layer_id = NULL,
                           digits = 4,
                           palette = NULL){

  ## TODO: is 'info_window' required, if it was included in the original add_ call?

  objArgs <- match.call(expand.dots = F)

  layer_id <- layerId(layer_id)
  numericCheck(digits)
  palette <- paletteCheck(palette)

  allCols <- circleColumns()
  requiredCols <- requiredCircleColumns()
  colourColumns <- shapeAttributes(fill_colour, stroke_colour)

  shape <- createMapObject(data, allCols, objArgs)
  colours <- setupColours(data, shape, colourColumns, palette)

  if(length(colours) > 0){
    shape <- replaceVariableColours(shape, colours)
  }

  requiredDefaults <- setdiff(requiredCols, names(shape))
  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "circle")
  }

  shape <- jsonlite::toJSON(shape, digits = digits)

  invoke_method(map, 'update_circles', shape, layer_id)
}
