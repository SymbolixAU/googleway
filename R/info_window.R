createInfoWindowChart <- function(shape, infoWindowChart, id) UseMethod("createInfoWindowChart")

createInfoWindowChart.data.frame <- function(shape, infoWindowChart, id) {
  if (!is.null(infoWindowChart)) {
    shape <- InfoWindow(infoWindowChart, shape, id)
  }
  return(shape)
}

createInfoWindowChart.list <- function(shape, infoWindowChart, id) {

  print("createInfoWindowChart.list")
  print("--shape--")
  print(shape)
  print("--infoWindowChart--")
  print(infoWindowChart)

  ## TODO: add the infowindow stuff to the list.

  myfun <- function(x, idcol) {
    thisId <- x[['id']]
    dat <- infoWindowChart[['data']][ with(infoWindowChart[['data']], id == thisId), ]
    thisList <- list(
      data = dat,
      type = infoWindowChart[['type']],
      options = infoWindowChart[['options']]
    )
    print("--this list--")
    print(thisList)
    # x[['info_window']] <- InfoWindow(thisList, x, thisId)
    # x[['chart_type']] <- infoWindowChart[['type']]
    # x[['chart_options']] <- infoWindowChart[['options']]
    x <- InfoWindow(thisList, x, idcol)
    print("--- x ---")
    print(x)
    return(x)
  }

  if (!is.null(infoWindowChart)) {

    shape <- lapply(shape, myfun, idcol = id)

    print("--shape--")
    print(shape)
    # shape <- InfoWindow(infoWindowChart, shape, id)
    # shape[['info_window']] <- elements[['info_window']]
    # shape[['chart_type']] <- elements[['chart_type']]
    # shape[['chart_options']] <- elements[['chart_options']]

  }
  return(shape)
}


InfoWindow <- function(info_window, mapObject, id) UseMethod("InfoWindow")

#' @export
InfoWindow.list <- function(info_window, mapObject, id){

  if(is.null(id))
    stop("To use a chart as an Info Window you need to provide an 'id' that links the two data sets together.
         Therefore, specify the 'id' parameter as the common column of data between the two.")

  if(!all(c("data", "type") %in% names(info_window)))
    stop("infow_window list requires a 'data' and 'type' element")

  infoData <- info_window[['data']]
  dataCols <- setdiff(names(infoData), id)

  print("-- infoDAta -- ")
  print(infoData)
  print(dataCols)

  mapObject[['info_window']] <- DataTableArray(infoData, id, dataCols)
  mapObject[['chart_type']] <- tolower(info_window[['type']])
  mapObject[['chart_options']] <- jsonlite::toJSON(info_window[['options']], auto_unbox = T)

  #print(mapObject)

  return(mapObject)
}

#' @export
InfoWindow.default <- function(info_window, mapObject, id){
  stop("info_window must either be a list containing data for a chart,
       or a string specifying the column of data to be used as the info window content")
}

isInfoWindowChart <- function(info_window) UseMethod("isInfoWindowChart")

isInfoWindowChart.list <- function(info_window) TRUE

isInfoWindowChart.default <- function(info_window) FALSE
