
#' Add polygon
#'
#' Add a polygon to a google map.
#'
#' @note A polygon represents an area enclosed by a closed path. Polygon objects
#' are similar to polylines in that they consist of a series of coordinates in an ordered sequence.
#' Polygon objects can describe complex shapes, including
#'
#' \itemize{
#'   \item{Multiple non-contiguous areas defined by a single polygon}
#'   \item{Areas with holes in them}
#'   \item{Intersections of one or more areas}
#' }
#'
#' To define a complex shape, you use a polygon with multiple paths.
#'
#' To create a hole in a polygon, you need to create two paths, one inside the other.
#' To create the hole, the coordinates of the inner path must be wound in the opposite
#' order to those defining the outer path. For example, if the coordinates of
#' the outer path are in clockwise order, then the inner path must be anti-clockwise.
#'
#' You can represent a polygon in one of three ways
#' \itemize{
#'   \item{as a series of coordinates defining a path (or paths) with both an
#'   \code{id} and \code{pathId} argument that make up the polygon}
#'   \item{as an encoded polyline using an \code{id} column to specify multiple
#'   polylines for a polygon}
#'   \item{as a list column in a data.frame, where each row of the data.frame
#'   contains the polylines that comprise the polygon}
#'
#' }
#'
#' See Examples
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' ## polygon with a hole - Bermuda triangle
#' ## using one row per polygon, and a list-column of encoded polylines
#' pl_outer <- encode_pl(lat = c(25.774, 18.466,32.321),
#'       lon = c(-80.190, -66.118, -64.757))
#'
#' pl_inner <- encode_pl(lat = c(28.745, 29.570, 27.339),
#'        lon = c(-70.579, -67.514, -66.668))
#'
#' df <- data.frame(id = c(1, 1),
#'        polyline = c(pl_outer, pl_inner),
#'        stringsAsFactors = FALSE)
#'
#' df <- aggregate(polyline ~ id, data = df, list)
#'
#' google_map(key = map_key, height = 800) %>%
#'     add_polygons(data = df, polyline = "polyline")
#'
#' ## the same polygon, but using an 'id' to specify the polygon
#' df <- data.frame(id = c(1,1),
#'        polyline = c(pl_outer, pl_inner),
#'        stringsAsFactors = FALSE)
#'
#' google_map(key = map_key, height = 800) %>%
#'     add_polygons(data = df, polyline = "polyline", id = "id")
#'
#' ## the same polygon, specified using coordinates, and with a second independent
#' ## polygon
#' df <- data.frame(myId = c(1,1,1,1,1,1,2,2,2),
#'       lineId = c(1,1,1,2,2,2,1,1,1),
#'       lat = c(26.774, 18.466, 32.321, 28.745, 29.570, 27.339, 22, 23, 22),
#'       lon = c(-80.190, -66.118, -64.757, -70.579, -67.514, -66.668, -50, -49, -51),
#'       colour = c(rep("#00FF0F", 6), rep("#FF00FF", 3)),
#'       stringsAsFactors = FALSE)
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, lat = 'lat', lon = 'lon', id = 'myId', pathId = 'lineId',
#'                fill_colour = 'colour')
#'
#'
#'
#' }
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least a \code{polyline} column,
#' or a \code{lat} and a \code{lon} column. If Null, the data passed into
#' \code{google_map()} will be used.
#' @param polyline string specifying the column of \code{data} containing
#' the encoded polyline
#' @param lat string specifying the column of \code{data} containing the
#' 'latitude' coordinates. Coordinates must be in the order that defines the path.
#' @param lon string specifying the column of \code{data} containing the
#' 'longitude' coordinates. Coordinates must be in the order that defines the path.
#' @param id string specifying the column containing an identifier for a polygon.
#' @param pathId string specifying the column containing an identifer for each
#' path that forms the complete polygon. Not required when using \code{polyline},
#' as each polyline is itself a path.
#' @param stroke_colour either a string specifying the column of \code{data}
#' containing the stroke colour of each polygon, or a valid hexadecimal numeric
#' HTML style to be applied to all the polygons
#' @param stroke_opacity either a string specifying the column of \code{data}
#' containing the stroke opacity of each polygon, or a value between 0 and 1
#' that will be applied to all the polygons
#' @param stroke_weight either a string specifying the column of \code{data}
#' containing the stroke weight of each polygon, or a number indicating the
#' width of pixels in the line to be applied to all the polygons
#' @param fill_colour either a string specifying the column of \code{data}
#' containing the fill colour of each polygon, or a valid hexadecimal numeric
#' HTML style to be applied to all the polygons
#' @param fill_opacity either a string specifying the column of \code{data}
#' containing the fill opacity of each polygon, or a value between 0 and 1 that
#' will be applied to all the polygons
#' @param info_window string specifying the column of data to display in an
#' info window when a polygon is clicked
#' @param mouse_over string specifying the column of data to display when the
#' mouse rolls over the polygon
#' @param mouse_over_group string specifying the column of data specifying
#' which groups of polygons to highlight on mouseover
#' @param draggable string specifying the column of \code{data} defining if
#' the polygon is 'draggable'. The column of data should be logical (either TRUE or FALSE)
#' @param editable string specifying the column of \code{data} defining if the polygon
#' is 'editable' (either TRUE or FALSE)
#' @param update_map_view logical specifying if the map should re-centre
#' according to the polyline.
#' @param layer_id single value specifying an id for the layer.
#' @param z_index single value specifying where the polygons appear in the layering
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
#'
#' @seealso \link{encode_pl}
#'
#' @export
add_polygons <- function(map,
                         data = get_map_data(map),
                         polyline = NULL,
                         lat = NULL,
                         lon = NULL,
                         id = NULL,
                         pathId = NULL,
                         stroke_colour = NULL,
                         stroke_weight = NULL,
                         stroke_opacity = NULL,
                         fill_colour = NULL,
                         fill_opacity = NULL,
                         info_window = NULL,
                         mouse_over = NULL,
                         mouse_over_group = NULL,
                         draggable = NULL,
                         editable = NULL,
                         update_map_view = TRUE,
                         layer_id = NULL,
                         z_index = NULL,
                         digits = 4,
                         palette = NULL,
                         legend = F,
                         legend_options = NULL){

  ## TODO:
  ## - holes must be wound in the opposite direction

  objArgs <- match.call(expand.dots = F)

  ## PARAMETER CHECKS
  if(!dataCheck(data, "add_polygon")) data <- polygonDefaults(1)
  layer_id <- layerId(layer_id)
  latLonPolyCheck(lat, lon, polyline)

  usePolyline <- isUsingPolyline(polyline)

  if(!usePolyline){
    objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_polyline")
  }

  logicalCheck(update_map_view)
  numericCheck(digits)
  numericCheck(z_index)
  palette <- paletteCheck(palette)

  lst <- polyIdCheck(data, id, usePolyline, objArgs)
  data <- lst$data
  objArgs <- lst$objArgs
  id <- lst$id

  lst <- pathIdCheck(data, pathId, usePolyline, objArgs)
  data <- lst$data
  objArgs <- lst$objArgs
  pathId <- lst$pathId
  ## END PARAMETER CHECKS


  allCols <- polygonColumns()
  requiredCols <- requiredShapeColumns()
  colourColumns <- shapeAttributes(fill_colour, stroke_colour)

  shape <- createMapObject(data, allCols, objArgs)
  pal <- createPalettes(shape, colourColumns)
  colour_palettes <- createColourPalettes(data, pal, colourColumns, viridisLite::viridis)
  colours <- createColours(shape, colour_palettes)

  if(length(colours) > 0){
    shape <- replaceVariableColours(shape, colours)
  }

  # if(legend){
  #   ## TODO:
  #   ## - map all fills, stroke, weight, opacity to legend?
  #
  #   legendIdx <- which(names(colourColumns) == 'fill_colour')
  #   print(colourColumns)
  #   print(legend)
  #   print(legendIdx)
  #   legend <- colour_palettes[[1]]$palette
  #   title <- colour_palettes[[1]]$variables
  #   type <- getLegendType(legend$variable)
  #   legend <- constructLegend(legend, type)
  #
  #   ## legend options:
  #   ## title
  #   ## css
  #   ## position
  #   ## text format
  #   legend_options = list(type = type,
  #                         title = "SA4 Name",
  #                         #                       css = 'max-width : 120px; max-height : 160px; overflow : auto;',
  #                         position = "RIGHT_BOTTOM")
  #   legend_options <- jsonlite::toJSON(legend_options, auto_unbox = T)
  # }

  requiredDefaults <- setdiff(requiredCols, names(shape))

  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "polygon")
  }

  if(usePolyline){

    if(!is.list(shape[, polyline])){
      f <- paste0(polyline, " ~ " , paste0(setdiff(names(shape), polyline), collapse = "+") )
      shape <- stats::aggregate(stats::formula(f), data = shape, list)
    }

    shape <- jsonlite::toJSON(shape, digits = digits)

  }else{

    ids <- unique(shape[, 'id'])
    n <- names(shape)[names(shape) %in% objectColumns("polygonCoords")]
    keep <- setdiff(n, c("id", "pathId", "lat", "lng"))

    lst_polygon <- objPolygonCoords(shape, ids, keep)

    shape <- jsonlite::toJSON(lst_polygon, digits = digits, auto_unbox = T)
  }

  invoke_method(map, 'add_polygons', shape, update_map_view, layer_id, usePolyline, legend, legend_options)
}



#' Update polygons
#'
#' Updates specific colours and opacities of specified polygons. Designed to be
#' used in a shiny application.
#'
#' @note Any polygons (as specified by the \code{id} argument) that do not exist
#' in the \code{data} passed into \code{add_polygons()} will not be added to the map.
#' This function will only update the polygons that currently exist on the map
#' when the function is called.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data.frame containing the new values for the polygons
#' @param id string representing the column of \code{data} containing the id
#' values for the polygons. The id values must be present in the data supplied
#' to \code{add_polygons} in order for the polygons to be udpated
#' @param stroke_colour either a string specifying the column of \code{data}
#' containing the stroke colour of each polygon, or a valid hexadecimal numeric
#' HTML style to be applied to all the polygons
#' @param stroke_opacity either a string specifying the column of \code{data}
#' containing the stroke opacity of each polygon, or a value between 0 and 1 that
#' will be applied to all the polygons
#' @param stroke_weight either a string specifying the column of \code{data}
#' containing the stroke weight of each polygon, or a number indicating the width of
#' pixels in the line to be applied to all the polygons
#' @param fill_colour either a string specifying the column of \code{data}
#' containing the fill colour of each polygon, or a valid hexadecimal numeric
#' HTML style to be applied to all the polygons
#' @param fill_opacity either a string specifying the column of \code{data}
#' containing the fill opacity of each polygon, or a value between 0 and 1 that
#' will be applied to all the polygons
#' @param layer_id single value specifying an id for the layer.
#' @param palette a function that generates hex RGB colours given a single number as an input.
#' Used when a variable of \code{data} is specified as a colour
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' pl_outer <- encode_pl(lat = c(25.774, 18.466,32.321),
#'                       lon = c(-80.190, -66.118, -64.757))
#'
#' pl_inner <- encode_pl(lat = c(28.745, 29.570, 27.339),
#'                       lon = c(-70.579, -67.514, -66.668))
#'
#' pl_other <- encode_pl(c(21,23,22), c(-50, -49, -51))
#'
#' ## using encoded polylines
#' df <- data.frame(id = c(1,1,2),
#'                  colour = c("#00FF00", "#00FF00", "#FFFF00"),
#'                  polyline = c(pl_outer, pl_inner, pl_other),
#'                  stringsAsFactors = FALSE)
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', id = 'id', fill_colour = 'colour')
#'
#' df_update <- df[, c("id", "colour")]
#' df_update$colour <- c("#FFFFFF", "#FFFFFF", "#000000")
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', id = 'id', fill_colour = 'colour') %>%
#'   update_polygons(data = df_update, id = 'id', fill_colour = 'colour')
#'
#'
#' df <- aggregate(polyline ~ id + colour, data = df, list)
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', fill_colour = 'colour')
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, polyline = 'polyline', id = 'id', fill_colour = 'colour') %>%
#'   update_polygons(data = df_update, id = 'id', fill_colour = 'colour')
#'
#'
#' ## using coordinates
#' df <- data.frame(id = c(rep(1, 6), rep(2, 3)),
#'                  lineId = c(rep(1, 3), rep(2, 3), rep(1, 3)),
#'                  lat = c(25.774, 18.466, 32.321, 28.745, 29.570, 27.339, 21, 23, 22),
#'                  lon = c(-80.190, -66.118, -64.757, -70.579, -67.514, -66.668, -50, -49, -51))
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, lat = 'lat', lon = 'lon', id = 'id', pathId = 'lineId')
#'
#' google_map(key = map_key) %>%
#'   add_polygons(data = df, lat = 'lat', lon = 'lon', id = 'id', pathId = 'lineId') %>%
#'   update_polygons(data = df_update, id = 'id', fill_colour = 'colour')
#'
#' }
#'
#' @export
update_polygons <- function(map, data, id,
                            stroke_colour = NULL,
                            stroke_weight = NULL,
                            stroke_opacity = NULL,
                            fill_colour = NULL,
                            fill_opacity = NULL,
                            layer_id = NULL,
                            palette = NULL
){

  ## TODO: is 'info_window' required, if it was included in the original add_polygons?

  objArgs <- match.call(expand.dots = F)
  if(!dataCheck(data, "update_polygon")) data <- polygonUpdateDefaults(1)
  layer_id <- layerId(layer_id)

  palette <- paletteCheck(palette)

  lst <- polyIdCheck(data, id, FALSE, objArgs)
  data <- lst$data
  objArgs <- lst$objArgs
  id <- lst$id


  allCols <- polygonUpdateColumns()
  requiredCols <- requiredShapeUpdateColumns()
  colourColumns <- shapeAttributes(fill_colour, stroke_colour)

  shape <- createMapObject(data, allCols, objArgs)
  colours <- setupColours(data, shape, colourColumns, palette)

  if(length(colours) > 0){
    shape <- replaceVariableColours(shape, colours)
  }

  requiredDefaults <- setdiff(requiredCols, names(shape))

  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "polygonUpdate")
  }

  shape <- jsonlite::toJSON(shape, auto_unbox = T)

  invoke_method(map, 'update_polygons', shape, layer_id)
}



#' @rdname clear
#' @export
clear_polygons <- function(map, layer_id = NULL){
  layer_id <- layerId(layer_id)
  invoke_method(map, 'clear_polygons', layer_id)
}
