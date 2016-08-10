#' Add polyline dev
#'
#' Add a polyline to a google map
#'
#' @param map a googleway map object created from \code{google_map()}
#' @param data ordered data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude. If Null, the data passed into \code{google_map()} will be used.
#' @param data_options data frame  -- including, ID, (must match an 'id' field in the \code{data}), and geodesic, strokeColor, strokeOpacity, strokeWeight
#' @param lat string specifying the column of \code{data} containing the 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{data} containing the 'longitude' coordinates. If left NULL, a best-guess will be made
add_polyline_dev <- function(map,
                             data = get_map_data(map),
                             data_options = NULL,
                             lat = NULL,
                             lon = NULL){

  # geodesic: true,
  # strokeColor: '#0088FF',
  # strokeOpacity: 0.6,
  # strokeWeight: 4,

  # ## TODO:
  # ## polylines can be a list of data.frames with lat/lon columns
  # ## or a shape file
  # ## or a data frame with an id column

  ## accept:
  ## single data.table/data.frame
  ## list of data.tables/data.frames
  ## sp - SpatialLines, SpatialLinesDataFrame, Lines, Line

  ## check the values in id match those in data


  ## single data.frame:
  ## users specifies an 'id' column to specify a 'group' for each line

  ## if a list of data.frames, assign each one an 'id',
  ## and send it in to javascript to add lines according to the id

  data <- as.data.frame(data)

  if(is.null(lat)){
    data <- latitude_column(data, lat, 'add_polyline')
    lat <- "lat"
  }

  if(is.null(lon)){
    data <- longitude_column(data, lon, 'add_polyline')
    lon <- "lng"
  }

  ## check columns
  cols <- list(id)
  col_names <- list("id")
  allowed_nulls <- c()
  lst <- correct_columns(data, cols, col_names, allowed_nulls)

  data <- lst$df
  cols <- lst$cols

  invoke_method(map, data, 'add_polyline',
                data[, lat],
                data[, lon],
                data[, id]
                )

}
