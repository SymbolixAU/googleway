#' Add Fusion
#'
#' Adds a fusion table layer to a map.
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param query a fusion layer query. See details.
#' @param styles a \code{list} object or character string used to apply colour,
#' stroke weight and opacity to lines and polygons. See examples.
#' @param heatmap logical indicating whether to show a heatmap.
#' @param layer_id single value specifying an id for the layer.
#'
#' @details
#' The query must have a 'select' and a 'from' property, and optionally a 'where'.
#' This can be specified as a JSON string, a list, or a \code{data.frame} of 2 (or 3 columns),
#' and only 1 row. Two columns must be 'select' and 'from', and the third 'where'.
#'
#' The 'select' value is the column name (from the fusion table) containing the
#' location information, and the 'from' value is the encrypted table Id.
#' The 'where' value is a string specifying the 'where' condition on the data query.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' qry <- data.frame(select = 'address',
#'     from = '1d7qpn60tAvG4LEg4jvClZbc1ggp8fIGGvpMGzA',
#'     where = 'ridership > 200')
#'
#' google_map(key = map_key, location = c(41.8, -87.7), zoom = 9) %>%
#'   add_fusion(query = qry)
#'
#'
#' qry <- list(select = 'address',
#'     from = '1d7qpn60tAvG4LEg4jvClZbc1ggp8fIGGvpMGzA',
#'     where = 'ridership > 200')
#'
#' google_map(key = map_key, location = c(41.8, -87.7), zoom = 9) %>%
#'   add_fusion(query = qry)
#'
#' qry <- data.frame(select = 'geometry',
#'    from = '1ertEwm-1bMBhpEwHhtNYT47HQ9k2ki_6sRa-UQ')
#'
#' styles <- list(
#'   list(
#'     polygonOptions = list( fillColor = "#00FF00", fillOpacity = 0.3)
#'     ),
#'   list(
#'     where = "birds > 300",
#'     polygonOptions = list( fillColor = "#0000FF" )
#'     ),
#'   list(
#'     where = "population > 5",
#'     polygonOptions = list( fillOpacity = 1.0 )
#'  )
#' )
#'
#' google_map(key = map_key, location = c(-25.3, 133), zoom = 4) %>%
#'   add_fusion(query = qry, styles = styles)
#'
#' qry <- '{"select":"geometry","from":"1ertEwm-1bMBhpEwHhtNYT47HQ9k2ki_6sRa-UQ"}'
#'
#' styles <- '[
#'   {
#'     "polygonOptions":{
#'       "fillColor":"#FFFF00",
#'       "fillOpacity":0.3
#'       }
#'     },
#'     {
#'       "where":"birds > 300",
#'        "polygonOptions":{
#'          "fillColor":"#000000"
#'        }
#'      },
#'      {
#'        "where":"population > 5",
#'        "polygonOptions":{
#'          "fillOpacity":1
#'          }
#'      }
#'    ]'
#'
#' google_map(key = map_key, location = c(-25.3, 133), zoom = 4) %>%
#'   add_fusion(query = qry, styles = styles)
#'
#' ## using a JSON style
#' attr(styles, 'class') <- 'json'
#'
#' google_map(key = map_key, location = c(-25.3, 133), zoom = 4) %>%
#'   add_fusion(query = qry, styles = styles)
#'
#' qry <- data.frame(select = 'location',
#'     from = '1xWyeuAhIFK_aED1ikkQEGmR8mINSCJO9Vq-BPQ')
#'
#' google_map(key = map_key, location = c(0, 0), zoom = 1) %>%
#'   add_fusion(query = qry, heatmap = T)
#'
#' }
#'
#' @export
add_fusion <- function(map, query, styles = NULL, heatmap = FALSE, layer_id = NULL){

  ## TODO:
  ## - update bounds on layer
  ## - info window

  logicalCheck(heatmap)
  layer_id <- layerId(layer_id)

  query <- validateFusionQuery(query)

  if(!is.null(styles))
    styles <- validateFusionStyle(styles)

  invoke_method(map, 'add_fusion', query, styles, heatmap, layer_id)
}

#' @rdname clear
#' @export
clear_fusion <- function(map, layer_id = NULL){
  layer_id <- layerId(layer_id)
  invoke_method(map, 'clear_fusion', layer_id)
}
