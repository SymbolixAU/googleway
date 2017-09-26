

# Get Legned Type
# determins the type of legend to plot given the data
# @param colourColum
getLegendType <- function(colourColumn) UseMethod("getLegendType")

#' @export
getLegendType.numeric <- function(colourColumn) "gradient"

#' @export
getLegendType.default <- function(colourColumn) "category"


constructLegend <- function(legend, type){

  if(type == "category"){
    #legendIdx <- which(names(colourColumns) == 'fill_colour')
    #legend <- colour_palettes[[legendIdx]]$palette
    return(jsonlite::toJSON(legend))
  }

  return(NULL)
}

