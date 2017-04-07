LogicalCheck <- function(param){
  if(!is.logical(param))
    stop(paste0(deparse(substitute(param))," must be logical - TRUE or FALSE"))

  if(length(param) != 1)
    stop(paste0(deparse(substitute(param))," must be either TRUE or FALSE"))
}

check_hex_colours <- function(df, cols){
  ## checks the columns of data that should be in HEX colours

  for(myCol in cols){
    if(!all(grepl("^#(?:[0-9a-fA-F]{3}){1,2}$", df[, myCol])))
      stop(paste0("Incorrect colour specified in ", myCol, ". Make sure the colours in the column are valid hexadecimal HTML colours"))
  }
}

check_opacities <- function(df, cols){

  for(myCol in cols){
    ## allow NAs through
    vals <- df[, myCol][!is.na(df[, myCol])]
    if(length(vals) > 0)
      if(any(vals < 0) | any(vals > 1))
        stop(paste0("opacity values for ", myCol, " must be between 0 and 1"))
  }
}

check_for_columns <- function(df, cols){

  ## check to see if the specified columns exist
  if(!all(cols %in% names(df)))
    stop(paste0("Could not find columns: "
                , paste0(cols[!cols %in% names(df)], collapse = ", ")
                , " in the data"))

}


latitude_column <- function(data, lat, calling_function){

  if(is.null(lat)){
    lat_col <- find_lat_column(names(data), calling_function)
    names(data)[names(data) == lat_col[1]] <- "lat"
  }else{
    ## check the supplied latitude column exists
    check_for_columns(data, lat)
    # names(data)[names(data) == lat] <- "lat"
  }
  return(data)
}

longitude_column <- function(data, lon, calling_function){
  if(is.null(lon)){
    lon_col <- find_lon_column(names(data), calling_function)
    names(data)[names(data) == lon_col[1]] <- "lng"
  }else{
    check_for_columns(data, lon)
    # names(data)[names(data) == lon] <- "lng"
  }
  return(data)
}

find_lat_column = function(names, calling_function, stopOnFailure = TRUE) {

  lats = names[grep("^(lat|lats|latitude|latitudes)$", names, ignore.case = TRUE)]

  if (length(lats) == 1) {
    # if (length(names) > 1) {
    #   message("Assuming '", lats, " is the latitude column")
    # }
    ## passes
    return(list(lat = lats))
  }

  if (stopOnFailure) {
    stop(paste0("Couldn't infer latitude column for ", calling_function))
  }

  list(lat = NA)
}


find_lon_column = function(names, calling_function, stopOnFailure = TRUE) {

  lons = names[grep("^(lon|lons|lng|lngs|long|longs|longitude|longitudes)$", names, ignore.case = TRUE)]

  if (length(lons) == 1) {
    # if (length(names) > 1) {
    #   message("Assuming '", lons, " is the longitude column")
    # }
    ## passes
    return(list(lon = lons))
  }

  if (stopOnFailure) {
    stop(paste0("Couldn't infer longitude columns for ", calling_function))
  }

  list(lon = NA)
}

