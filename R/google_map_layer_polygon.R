googlePolygonDependency <- function() {
  list(
    createHtmlDependency(
      name = "polygons",
      version = "1.0.0",
      src = system.file("htmlwidgets/lib/polygons", package = "googleway"),
      script = c("polygons.js"),
      all_files = FALSE
    )
  )
}

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
#' @inheritParams add_circles
#'
#' @param data data frame containing at least a \code{polyline} column,
#' or a \code{lat} and a \code{lon} column. If Null, the data passed into
#' \code{google_map()} will be used.
#' @param polyline string specifying the column of \code{data} containing
#' the encoded polyline
#' @param pathId string specifying the column containing an identifer for each
#' path that forms the complete polygon. Not required when using \code{polyline},
#' as each polyline is itself a path.
#'
#' @inheritSection add_circles palette
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
                         legend_options = NULL,
                         load_interval = 0,
                         focus_layer = FALSE
                         ){

  #objArgs <- match.call(expand.dots = F)
  objArgs <- list()
  objArgs[["polyline"]] <- force( polyline )
  objArgs[["lat"]] <- force( lat )
  objArgs[["lon"]] <- force( lon )
  objArgs[["id"]] <- force( id )
  objArgs[["pathId"]] <- force( pathId )
  objArgs[["stroke_colour"]] <- force( stroke_colour )
  objArgs[["stroke_weight"]] <- force( stroke_weight )
  objArgs[["stroke_opacity"]] <- force( stroke_opacity )
  objArgs[["fill_colour"]] <- force( fill_colour )
  objArgs[["fill_opacity"]] <- force( fill_opacity )
  objArgs[["info_window"]] <- force( info_window )
  objArgs[["mouse_over"]] <- force( mouse_over )
  objArgs[["mouse_over_group"]] <- force( mouse_over_group )
  objArgs[["draggable"]] <- force( draggable )
  objArgs[["editable"]] <- force( editable )
  objArgs[["update_map_view"]] <- force( update_map_view )
  objArgs[["layer_id"]] <- force( layer_id )
  objArgs[["z_index"]] <- force( z_index )
  objArgs[["digits"]] <- force( digits )
  objArgs[["palette"]] <- force( palette )
  objArgs[["legend"]] <- force( legend )
  objArgs[["legend_options"]] <- force( legend_options )
  objArgs[["load_interval"]] <- force( load_interval )
  objArgs[["focus_layer"]] <- force( focus_layer )

  data <- normaliseSfData(data, "POLYGON")
  polyline <- findEncodedColumn(data, polyline)

  ## - if sf object, and geometry column has not been supplied, it needs to be
  ## added to objArgs after the match.call() function
  if( !is.null(polyline) && !polyline %in% names(objArgs) ) {
    objArgs[['polyline']] <- polyline
  }


  ## PARAMETER CHECKS
  if(!dataCheck(data, "add_polygon")) data <- polygonDefaults(1)
  layer_id <- layerId(layer_id)
  latLonPolyCheck(lat, lon, polyline)

  usePolyline <- isUsingPolyline(polyline)

  if(!usePolyline){
    objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_polyline")
  }

  infoWindowChart <- NULL
  if (!is.null(info_window) && isInfoWindowChart(info_window)) {
    infoWindowChart <- info_window
    objArgs[['info_window']] <- NULL
  }

  logicalCheck(update_map_view)
  logicalCheck(focus_layer)
  numericCheck(digits)
  numericCheck(z_index)
  loadIntervalCheck(load_interval)
  palette <- paletteCheck(palette)

  lst <- polyIdCheck(data, id, usePolyline, objArgs)
  data <- lst$data
  objArgs <- lst$objArgs
  id <- lst$id

  lst <- pathIdCheck(data, pathId, usePolyline, objArgs)
  data <- lst$data
  objArgs <- lst$objArgs
  pathId <- lst$pathId

  objArgs <- zIndexCheck( objArgs, z_index )

  ## END PARAMETER CHECKS
  allCols <- polygonColumns()
  requiredCols <- requiredShapeColumns()
  colourColumns <- shapeAttributes(fill_colour = fill_colour, stroke_colour = stroke_colour)

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
    shape <- addDefaults(shape, requiredDefaults, "polygon")
  }

  if(usePolyline){
    shape <- createPolylineListColumn(shape)
    shape <- createInfoWindowChart(shape, infoWindowChart, id)
    shape <- jsonlite::toJSON(shape, digits = digits)
  }else{

    ids <- unique(shape[, 'id'])
    n <- names(shape)[names(shape) %in% objectColumns("polygonCoords")]
    keep <- setdiff(n, c("id", "pathId", "lat", "lng"))

    lst_polygon <- objPolygonCoords(shape, ids, keep)
    lst_polygon <- createInfoWindowChart(lst_polygon, infoWindowChart, id)

    shape <- jsonlite::toJSON(lst_polygon, digits = digits, auto_unbox = T)
  }

  map <- addDependency(map, googlePolygonDependency())

  invoke_method(map, 'add_polygons', shape, update_map_view, layer_id, usePolyline, legend, load_interval, focus_layer)
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
#' @inheritParams update_circles
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
                            info_window = NULL,
                            layer_id = NULL,
                            palette = NULL,
                            legend = F,
                            legend_options = NULL
                            ){

  #objArgs <- match.call(expand.dots = F)
  objArgs <- list()
  objArgs[["id"]] <- force( id )
  objArgs[["stroke_colour"]] <- force( stroke_colour )
  objArgs[["stroke_weight"]] <- force( stroke_weight )
  objArgs[["stroke_opacity"]] <- force( stroke_opacity )
  objArgs[["fill_colour"]] <- force( fill_colour )
  objArgs[["fill_opacity"]] <- force( fill_opacity )
  objArgs[["info_window"]] <- force( info_window )
  objArgs[["layer_id"]] <- force( layer_id )
  objArgs[["palette"]] <- force( palette )
  objArgs[["legend"]] <- force( legend )
  objArgs[["legend_options"]] <- force( legend_options )

  #  callingFunc <- as.character(objArgs[[1]])

  # data <- normaliseSfData(data, "POLYGON")
  # polyline <- findEncodedColumn(data, polyline)
  #
  # if( !is.null(polyline) && !polyline %in% names(objArgs) ) {
  #   objArgs[['polyline']] <- polyline
  # }

  if(!dataCheck(data, "update_polygon")) data <- polygonUpdateDefaults(1)
  layer_id <- layerId(layer_id)

  palette <- paletteCheck(palette)

  lst <- polyIdCheck(data, id, FALSE, objArgs)
  data <- lst$data
  objArgs <- lst$objArgs
  id <- lst$id

  infoWindowChart <- NULL
  if (!is.null(info_window) && isInfoWindowChart(info_window)) {
    infoWindowChart <- info_window
    objArgs[['info_window']] <- NULL
  }

  allCols <- polygonUpdateColumns()
  requiredCols <- requiredShapeUpdateColumns()
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
    shape <- addDefaults(shape, requiredDefaults, "polygonUpdate")
  }

  shape <- createInfoWindowChart(shape, infoWindowChart, id)
  shape <- jsonlite::toJSON(shape, auto_unbox = T)

  invoke_method(map, 'update_polygons', shape, layer_id, legend)
}



#' @rdname clear
#' @export
clear_polygons <- function(map, layer_id = NULL){
  layer_id <- layerId(layer_id)
  invoke_method(map, 'clear_polygons', layer_id)
}
