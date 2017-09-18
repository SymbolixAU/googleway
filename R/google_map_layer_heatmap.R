#' Add heatmap
#'
#' Adds a heatmap to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the
#' latitude coordinates, and the other specifying the longitude. If Null, the
#' data passed into \code{google_map()} will be used.
#' @param lat string specifying the column of \code{data} containing the 'latitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param option_gradient vector of colours to use as the gradient colours. see Details
#' @param weight string specifying the column of \code{data} containing the 'weight'
#' associated with each point. If NULL, each point will get a weight of 1.
#' @param option_dissipating logical Specifies whether heatmaps dissipate on zoom.
#' When dissipating is FALSE the radius of influence increases with zoom level to
#' ensure that the color intensity is preserved at any given geographic location.
#' Defaults to FALSE
#' @param option_radius numeric. The radius of influence for each data point, in pixels.
#' @param option_opacity The opacity of the heatmap, expressed as a number between
#' 0 and 1. Defaults to 0.6.
#' @param update_map_view logical specifying if the map should re-centre according to
#' the circles
#' @param layer_id single value specifying an id for the layer.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#'
#' @details
#' \code{option_gradient} colours can be two of the R colour specifications;
#' either a colour name (as listed by \code{colors()}, or a hexadecimal string of the
#' form \code{"#rrggbb"}).
#' The first colour in the vector will be used as the colour that fades to transparent,
#' while the last colour in the vector will be use in the centre of the 'heat'.
#'
#' @examples
#' \dontrun{
#'
#' map_key <- 'your_api_key'
#'
#' set.seed(20170417)
#' df <- tram_route
#' df$weight <- sample(1:10, size = nrow(df), replace = T)
#'
#' google_map(key = map_key, data = df) %>%
#'  add_heatmap(lat = "shape_pt_lat", lon = "shape_pt_lon", weight = "weight",
#'               option_radius = 0.001)
#'
#' ## specifying different colour gradient
#' option_gradient <- c('orange', 'blue', 'mediumpurple4', 'snow4', 'thistle1')
#'
#' google_map(key = map_key, data = df) %>%
#'  add_heatmap(lat = "shape_pt_lat", lon = "shape_pt_lon", weight = "weight",
#'               option_radius = 0.001, option_gradient = option_gradient)
#'
#'  }
#' @export
add_heatmap <- function(map,
                        data = get_map_data(map),
                        lat = NULL,
                        lon = NULL,
                        weight = NULL,
                        option_gradient = NULL,
                        option_dissipating = FALSE,
                        option_radius = 0.01,
                        option_opacity = 0.6,
                        layer_id = NULL,
                        update_map_view = TRUE,
                        digits = 4
){


  ## TODO:
  ## - max intensity
  ## - allow columns to be used for other options
  ## -- e.g., allow a column called 'opacity' to be used as a 'title'
  ## -- rather than 'correct' it

  objArgs <- match.call(expand.dots = F)

  ## PARAMETER CHECKS
  dataCheck(data)
  layer_id <- layerId(layer_id)

  objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_heatmap")
  logicalCheck(update_map_view)
  numericCheck(digits)
  ## END PARAMETER CHECKS

  allCols <- heatmapColumns()
  requiredCols <- requiredHeatmapColumns()

  shape <- createMapObject(data, allCols, objArgs)

  requiredDefaults <- setdiff(requiredCols, names(shape))
  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "circle")
  }

  shape <- jsonlite::toJSON(shape, digits = digits)

  ## Heatmap Options
  if(!is.null(option_opacity))
    if(!is.numeric(option_opacity) | (option_opacity < 0 | option_opacity > 1))
      stop("option_opacity must be a numeric between 0 and 1")

  if(!is.null(option_radius))
    if(!is.numeric(option_radius))
      stop("option_radius must be numeric")

  if(!is.null(option_dissipating))
    if(!is.logical(option_dissipating))
      stop("option_dissipating must be logical")

  heatmap_options <- data.frame(dissipating = option_dissipating,
                                radius = option_radius,
                                opacity = option_opacity)

  if(!is.null(option_gradient)){

    if(length(option_gradient) == 1)
      stop("please provide at least two gradient colours")

    ## first entry is used to fade into the background
    g <- sapply(seq_along(option_gradient), function(x){
      if(x == 1){
        paste0('rgba(', paste0(c(as.numeric(grDevices::col2rgb(option_gradient[x])), 0), collapse = ","), ')')
      }else{
        paste0('rgba(', paste0(c(as.numeric(grDevices::col2rgb(option_gradient[x])), 1), collapse = ","), ')')
      }
    })

    heatmap_options$gradient <- list(g)
  }

  # Heatmap <- jsonlite::toJSON(Heatmap, digits = digits)
  heatmap_options <- jsonlite::toJSON(heatmap_options)

  invoke_method(map, 'add_heatmap', shape, heatmap_options, update_map_view, layer_id)
}



#' update heatmap
#'
#' updates a heatmap layer
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data data frame containing at least two columns, one specifying the
#' latitude coordinates, and the other specifying the longitude. If Null,
#' the data passed into \code{google_map()} will be used.
#' @param lat string specifying the column of \code{data} containing the 'latitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude'
#' coordinates. If left NULL, a best-guess will be made
#' @param weight string specifying the column of \code{data} containing the 'weight'
#' associated with each point. If NULL, each point will get a weight of 1.
#' @param layer_id single value specifying an id for the layer.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#'
#' @export
update_heatmap <- function(map,
                           data,
                           lat = NULL,
                           lon = NULL,
                           weight = NULL,
                           layer_id = NULL,
                           digits = 4){

  ## TODO: update_map_view options

  objArgs <- match.call(expand.dots = F)
  dataCheck(data)
  layer_id <- layerId(layer_id)
  objArgs <- latLonCheck(objArgs, lat, lon, names(data), "update_heatmap")
  numericCheck(digits)

  allCols <- heatmapColumns()
  requiredCols <- requiredHeatmapColumns()
  shape <- createMapObject(data, allCols, objArgs)

  requiredDefaults <- setdiff(requiredCols, names(shape))
  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "circle")
  }

  shape <- jsonlite::toJSON(shape, digits = digits)

  invoke_method(map, 'update_heatmap', shape, layer_id)
}


#' @rdname clear
#' @export
clear_heatmap <- function(map, layer_id = NULL){
  layer_id <- layerId(layer_id)
  invoke_method(map, 'clear_heatmap', layer_id)
}
