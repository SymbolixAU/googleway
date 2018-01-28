#' Add heatmap
#'
#' Adds a heatmap to a google map
#'
#' @inheritParams add_circles
#' @param weight string specifying the column of \code{data} containing the 'weight'
#' associated with each point. If NULL, each point will get a weight of 1.
#' @param option_gradient vector of colours to use as the gradient colours. see Details
#' @param option_dissipating logical Specifies whether heatmaps dissipate on zoom.
#' When dissipating is FALSE the radius of influence increases with zoom level to
#' ensure that the color intensity is preserved at any given geographic location.
#' When set to TRUE you will likely need a greater \code{option_radius} value.
#' Defaults to FALSE.
#' @param option_radius numeric. The radius of influence for each data point, in pixels.
#' Defaults to 0.01
#' @param option_opacity The opacity of the heatmap, expressed as a number between
#' 0 and 1. Defaults to 0.6.
#'
#' @details
#' The legend will only show if you supply a \code{weight} variable.
#'
#' \code{option_gradient} colours can be two of the R colour specifications;
#' either a colour name (as listed by \code{colors()}, or a hexadecimal string of the
#' form \code{"#rrggbb"}).
#'
#' The first colour in the vector will be used as the colour that fades to transparent,
#' and is not actually mapped to any data points (and therefore won't be included
#' in the legend).
#' The last colour in the vector will be use in the centre of the 'heat'.
#'
#' The \code{option_gradient}, \code{option_dissipating}, \code{option_radius} and
#' \code{option_opacity} values apply to all points in the data.8
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
#'               option_radius = 0.001, legend = T)
#'
#' ## specifying different colour gradient
#' option_gradient <- c('orange', 'blue', 'mediumpurple4', 'snow4', 'thistle1')
#'
#' google_map(key = map_key, data = df) %>%
#'  add_heatmap(lat = "shape_pt_lat", lon = "shape_pt_lon", weight = "weight",
#'               option_radius = 0.001, option_gradient = option_gradient, legend = T)
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
                        digits = 4,
                        legend = F,
                        legend_options = NULL
                        ){
  ## TODO:
  ## - max intensity

  objArgs <- match.call(expand.dots = F)


  ## PARAMETER CHECKS
  if(!dataCheck(data, "add_heatmap")) data <- heatmapDefaults(1)
  layer_id <- layerId(layer_id)

  objArgs <- latLonCheck(objArgs, lat, lon, names(data), "add_heatmap")
  objArgs <- heatWeightCheck(objArgs)

  fill_colour <- weight

  logicalCheck(update_map_view)
  numericCheck(digits)

  ## Heatmap Options
  optionOpacityCheck(option_opacity)
  optionRadiusCheck(option_radius)
  optionDissipatingCheck(option_dissipating)
  ## END PARAMETER CHECKS

  allCols <- heatmapColumns()
  requiredCols <- requiredHeatmapColumns()

  shape <- createMapObject(data, allCols, objArgs)

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

    rampColours <- option_gradient[2:length(option_gradient)]
    heatmap_options$gradient <- list(g)
  }else{
    rampColours <- c("green", "red")
  }

  requiredDefaults <- setdiff(requiredCols, names(shape))

  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "heatmap")
  }

  colourColumns <- shapeAttributes(fill_colour, NULL)
  pal <- createPalettes(shape, colourColumns)

  ## heatmap works differntly to other layers as the data/shape is not updated with
  ## colours, rather the colours are only used to construct a legend. Google
  ## takes care of creating the colour heatmap

  colour_palettes <- createColourPalettes(data, pal, colourColumns, grDevices::colorRampPalette(rampColours))

  ## HEATMAP legend
  ## The regular legends map the colour palette to the variables. Here we have
  ## either the default colour palette (red -> green assigned by google)
  ## or the rgb colours
  ##
  ## google constructs the gradient according to the 'weights'
  ## and the lowest is always 0
  ## so we just need the max intensity, and create a gradient colour palette
  ## using the rgb colours defined

  legend <- resolveLegend(legend, legend_options, colour_palettes)

  shape <- jsonlite::toJSON(shape, digits = digits)

  # Heatmap <- jsonlite::toJSON(Heatmap, digits = digits)
  heatmap_options <- jsonlite::toJSON(heatmap_options)

  invoke_method(map, 'add_heatmap', shape, heatmap_options, update_map_view, layer_id, legend)
}



#' update heatmap
#'
#' updates a heatmap layer
#'
#' @inheritParams add_heatmap
#'
#' @details
#' The \code{option_gradient} is only used to craete the legend, and not to change
#' the colours of the heat layer. If you are not displaying
#' a legend this argument is not needed. If you are displaying a legend, you should
#' provide the same gardient as in the \code{add_heatmap} call.
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
#' ## update by adding the same data again to double the number of points at each location
#' df_update <- df
#' google_map(key = map_key, data = df) %>%
#'  add_heatmap(lat = "shape_pt_lat", lon = "shape_pt_lon", weight = "weight",
#'               option_radius = 0.001) %>%
#'  update_heatmap(df_update, lat = "shape_pt_lat", lon = "shape_pt_lon")
#'
#' }
#'
#' @export
update_heatmap <- function(map,
                           data,
                           lat = NULL,
                           lon = NULL,
                           weight = NULL,
                           option_gradient = NULL,
                           option_dissipating = FALSE,
                           option_radius = 0.01,
                           option_opacity = 0.6,
                           layer_id = NULL,
                           update_map_view = TRUE,
                           digits = 4,
                           legend = F,
                           legend_options = NULL){

  objArgs <- match.call(expand.dots = F)
  if(!dataCheck(data, "update_heatmap")) data <- heatmapDefaults(1)
  layer_id <- layerId(layer_id)
  objArgs <- latLonCheck(objArgs, lat, lon, names(data), "update_heatmap")
  objArgs <- heatWeightCheck(objArgs)

  fill_colour <- weight
  logicalCheck(update_map_view)
  numericCheck(digits)

  ## Heatmap Options
  optionOpacityCheck(option_opacity)
  optionRadiusCheck(option_radius)
  optionDissipatingCheck(option_dissipating)
  ### END PARAMETER CHECKS

  allCols <- heatmapColumns()
  requiredCols <- requiredHeatmapUpdateColumns()

  shape <- createMapObject(data, allCols, objArgs)

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

    rampColours <- option_gradient[2:length(option_gradient)]
    heatmap_options$gradient <- list(g)

  }else{
    rampColours <- c("green", "red")
  }

  colourColumns <- shapeAttributes(fill_colour, NULL)
  pal <- createPalettes(shape, colourColumns)
  colour_palettes <- createColourPalettes(data, pal, colourColumns, grDevices::colorRampPalette(rampColours))

  requiredDefaults <- setdiff(requiredCols, names(shape))
  if(length(requiredDefaults) > 0){
    shape <- addDefaults(shape, requiredDefaults, "heatmapUpdate")
  }

  legend <- resolveLegend(legend, legend_options, colour_palettes)

  shape <- jsonlite::toJSON(shape, digits = digits)

  heatmap_options <- jsonlite::toJSON(heatmap_options)

  invoke_method(map, 'update_heatmap', shape, heatmap_options, layer_id, legend, update_map_view)
}


#' @rdname clear
#' @export
clear_heatmap <- function(map, layer_id = NULL){
  layer_id <- layerId(layer_id)
  invoke_method(map, 'clear_heatmap', layer_id)
}
