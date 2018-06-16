
# Find WKT Column
#
# This function is called early in each add_layer function to see if the
# object contains WKT
#
# @param data the data object
# @param wkt the 'wkt' parameter set by the user in the add_ funciton call
findWktColumn <- function(data, wkt) UseMethod("findWktColumn")

#' @export
findWktColumn.sfencoded <- function(data, wkt) {
  if(is.null(wkt)) wkt <- attr(data, "wkt_column")
  return(wkt)
}

#' @export
findWktColumn.default <- function(data, wkt) wkt

