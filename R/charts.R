
## e.g.http://jsfiddle.net/doktormolle/S6vBK/

#' Google Charts
#'
#' Google Charts that can be displayed
#'
#' @section Pie Chart:
#'
#' A Pie chart requires a \code{data.frame} of two columns. The first column contains
#' the text that's used as the label, and the second contains the data used in
#' the pie.
#'
#' type: 'pie'
#'
#' options
#' \itemize{
#'   \item{title - string of text}
#'   \item{is3D - logical}
#' }
#'
#'
#' @section Area:
#'
#' \url{https://developers.google.com/chart/interactive/docs/gallery/areachart}
#'
#' Each row of data represents a data point at the same x-axis location
#'
#'
#' @name google_charts
NULL


InfoWindow <- function(info_window, mapObject, id) UseMethod("InfoWindow")


#' @export
InfoWindow.list <- function(info_window, mapObject, id){
  ## if a single columnname, use that
  ## else, it needs to be multiple column names, where
  ## the values will be the data components of a chart
  ## and needs to define the chart type
  ## e.g. list("pie", c("stop_lat", "stop_lon"))

  #id <- info_window[['id']]

  if(is.null(id))
    stop("To use a chart as an Info Window you need to provide an 'id' that links the two data sets together.
         Therefore, specify the 'id' parameter as the common column of data between the two.")

  if(!all(c("data", "type") %in% names(info_window)))
    stop("infow_window list requires a 'data' and 'type' element")

  infoData <- info_window[['data']]
  dataCols <- setdiff(names(infoData), id)

  mapObject[, 'chart_cols'] <- DataTableHeading(infoData, dataCols)

#  print(mapObject)

  infoData <- DataTableColumn(df = infoData, id = id, cols = dataCols)

  ## TODO:
  ## chart options
  chartOptions <- info_window[['options']]

  mapObject[, 'chart_type'] <- tolower(info_window[['type']])
  mapObject[, 'chart_options'] <- jsonlite::toJSON(chartOptions, auto_unbox = T)

  mapObject <- merge(mapObject, infoData, by.x = 'id', by.y = id, all.x = T)
  ## set the info_window property so it is seen in JS
  return(mapObject)
}

# InfoWindow.character <- function(info_window, mapObject, data, id){
#   mapObject[, "info_window"] <- as.character(data[, info_window])
#   return(mapObject)
# }

#' @export
InfoWindow.default <- function(info_window, mapObject, id){
  stop("info_window must either be a list containing data for a chart, or a string specifying the column of data to be used as the info window content")
}
