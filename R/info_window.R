createInfoWindowChart <- function(shape, infoWindowChart, id) UseMethod("createInfoWindowChart")

createInfoWindowChart.data.frame <- function(shape, infoWindowChart, id) {
  if (!is.null(infoWindowChart)) {
    shape <- InfoWindow(infoWindowChart, shape, id)
  }
  return(shape)
}

createInfoWindowChart.list <- function(shape, infoWindowChart, id) {

  myfun <- function(x, idcol) {
    thisId <- x[['id']]
    dat <- infoWindowChart[['data']][ with(infoWindowChart[['data']], id == thisId), ]
    thisList <- list(
      data = dat,
      type = infoWindowChart[['type']],
      options = infoWindowChart[['options']]
    )
    x <- InfoWindow(thisList, x, idcol)

    return(x)
  }

  if (!is.null(infoWindowChart)) {
    shape <- lapply(shape, myfun, idcol = id)
  }
  return(shape)
}


InfoWindow <- function(info_window, mapObject, id) UseMethod("InfoWindow")

#' @export
InfoWindow.list <- function(info_window, mapObject, id){

  if(is.null(id))
    stop("When using a chart as an info window you need to supply the 'id' which links the data to the chart")

  if(!all(c("data", "type") %in% names(info_window)))
    stop("infow_window list requires a 'data' and 'type' element")

  infoData <- info_window[['data']]
  dataCols <- setdiff(names(infoData), id)

  mapObject[['info_window']] <- DataTableArray(infoData, id, dataCols)
  mapObject[['chart_type']] <- tolower(info_window[['type']])
  mapObject[['chart_options']] <- jsonlite::toJSON(info_window[['options']], auto_unbox = T)

  return(mapObject)
}

#' @export
InfoWindow.default <- function(info_window, mapObject, id){
  stop("info_window must be a list, column name or single value")
}

isInfoWindowChart <- function(info_window) UseMethod("isInfoWindowChart")

isInfoWindowChart.list <- function(info_window) TRUE

isInfoWindowChart.default <- function(info_window) FALSE
