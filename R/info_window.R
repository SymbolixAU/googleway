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

  #mapObject[, 'chart_cols'] <- DataTableHeading(infoData, dataCols)
  #infoData <- DataTableColumn(df = infoData, id = id, cols = dataCols)

  mapObject[, 'info_window'] <- DataTableArray(infoData, id, dataCols)
  mapObject[, 'chart_type'] <- tolower(info_window[['type']])
  mapObject[, 'chart_options'] <- jsonlite::toJSON(info_window[['options']], auto_unbox = T)

  #  mapObject <- merge(mapObject, infoData, by.x = 'id', by.y = id, all.x = T)

  #  print(mapObject)

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
