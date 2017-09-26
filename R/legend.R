

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
    return(jsonlite::toJSON(legend))
  }else{
    ## create bins and stuff
    cuts <- base::pretty(legend$variable, n = 7)
    n <- length(cuts)
    r <- range(legend$variable)

    innerCuts <- cuts[cuts >= r[1] & cuts <= r[2]]
    n <- length(innerCuts)

    p <- (innerCuts - r[1]) / (r[2] - r[1])

    ## translate 'p' into 'row of palette'
    rw <- c(1, 1, round(p[p > 0] * nrow(legend)), nrow(legend))
    legend <- data.frame("variable" = cuts, "colour" = legend[rw, c("colour")])

    return(jsonlite::toJSON(legend))
  }

  return(NULL)
}

