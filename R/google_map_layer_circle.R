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
#'  add_circles(lat = "stop_lat", lon = "stop_lon")
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
                        palette = NULL){

  ## TODO:
  ## parameter checks

  if(is.null(palette)){
    palette <- viridisLite::viridis
  }else{
    if(!is.function(palette)) stop("palette needs to be a function")
  }

  layer_id <- LayerId(layer_id)
  objArgs <- match.call(expand.dots = F)

  objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_circles")

  allCols <- circleColumns()
  requiredCols <- requiredShapeColumns()
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

  print(" -- invoking circles -- ")
  invoke_method(map, data, 'add_circles', shape, update_map_view, layer_id)
}
