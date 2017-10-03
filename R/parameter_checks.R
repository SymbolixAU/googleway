
# Check hex colours
#
# Checks for valid hexadecimal value
#
# @param df \code{data.frame}
# @param cols string of columns to check
check_hex_colours <- function(df, cols){
  for(myCol in cols){
    if(!all(grepl("^#(?:[0-9a-fA-F]{3}){1,2}$", df[, myCol])))
      stop(paste0("Incorrect colour specified in ", myCol, ". Make sure the colours in the column are valid hexadecimal HTML colours"))
  }
}

# Check opacities
#
# Checks for valid opacity values
#
# @param df \code{data.frame}
# @param cols string of columns to check
check_opacities <- function(df, cols){

  for(myCol in cols){
    ## allow NAs through
    vals <- df[, myCol][!is.na(df[, myCol])]
    if(length(vals) > 0)
      if(any(vals < 0) | any(vals > 1))
        stop(paste0("opacity values for ", myCol, " must be between 0 and 1"))
  }
}


isHexColour <- function(cols){
  hexPattern <- "^#(?:[0-9a-fA-F]{3}){1,2}$|^#(?:[0-9a-fA-F]{4}){1,2}$"
  all(grepl(hexPattern, cols))
}

isRgba <- function(cols){
  all(grepl("^#(?:[0-9a-fA-F]{4}){1,2}$", cols))
}

# Logical Check
#
# Checks the argument is length 1 logical
# @param arg
logicalCheck <- function(arg){
  if(!is.null(arg)){
    if(!is.logical(arg) | length(arg) != 1)
      stop(paste0(deparse(substitute(arg))," must be logical - TRUE or FALSE"))
  }
}

# Numeric Check
#
# Checks the argument is lenght 1 numeric
# @param arg
numericCheck <- function(arg){
  if(!is.null(arg)){
    if(!is.numeric(arg) | length(arg) != 1)
      stop(paste0(deparse(substitute(arg)), " must be a single numeric value"))
  }
}

### url check ------------------
urlCheck <- function(url) UseMethod("urlCheck")

#' @export
urlCheck.character <- function(url) {
  if(!isUrl(url)) stop("invalid url")
}

urlCheck.url <- function(url) url

#' @export
urlCheck.default <- function(url) stopMessage(url)




hexType <- function(cols){
  rgb <- "^#(?:[0-9a-fA-F]{3}){1,2}$"
  rgba <- "^#(?:[0-9a-fA-F]{4}){1,2}$"
}




# Check for columns
#
# Checks for valid columns
#
# @param df \code{data.frame}
# @param cols string of columns
check_for_columns <- function(df, cols){

  ## check to see if the specified columns exist
  if(!all(cols %in% names(df)))
    stop(paste0("Could not find columns: "
                , paste0(cols[!cols %in% names(df)], collapse = ", ")
                , " in the data"))

}

check_address <- function(address){
  if(is.character(address) & length(address) == 1){
    address <- gsub(" ", "+", address)
  }else{
    stop("address must be a string of length 1")
  }
  return(address)
}

check_location <- function(loc, type){
  if(is.numeric(loc) & length(loc) == 2){
    loc <- paste0(loc, collapse = ",")
  }else if(is.character(loc) & length(loc) == 1){
    loc <- gsub(" ", "+", loc)
  }else{
    stop(paste0(type, " must be either a numeric vector of lat/lon coordinates, or an address string"))
  }
  return(loc)
}

check_multiple_locations <- function(loc, type){
  loc <- sapply(1:length(loc), function(x) {
    check_location(loc[[x]], type)
  })
  loc <- paste0(loc, collapse = "|")
}

# Latitude column
#
# calls the correct function to check for latitude column
# @param data \code{data.frame}
# @param lat string identifying the latitude column
# @param calling_function the function that called this function
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

# Longitude column
#
# calls the correct function to check for longitude column
# @param data \code{data.frame}
# @param lon string identifying the longitude column
# @param calling_function the function that called this function
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

# Find Lat Column
#
# Tries to identify the latitude column
# @param names string of column names
# @param calling_function the function that called this function
# @param stopOnFailure logical
find_lat_column = function(names, calling_function, stopOnFailure = TRUE) {

  lats = names[grep("^(lat|lats|latitude|latitudes|stop_lat|shape_pt_lon)$", names, ignore.case = TRUE)]

  if (length(lats) == 1) {
    # return(list(lat = lats))
    return(lats)
  }

  if (stopOnFailure) {
    stop(paste0("Couldn't infer latitude column for ", calling_function))
  }

  return(NA)
  # list(lat = NA)
}

# Find Lon Column
#
# Tries to identify the longitude column
# @param names string of column names
# @param calling_function the function that called this function
# @param stopOnFailure logical
find_lon_column = function(names, calling_function, stopOnFailure = TRUE) {

  lons = names[grep("^(lon|lons|lng|lngs|long|longs|longitude|longitudes|stop_lon|shape_pt_lon)$", names, ignore.case = TRUE)]

  if (length(lons) == 1) {
    # return(list(lon = lons))
    return(lons)
  }

  if (stopOnFailure) {
    stop(paste0("Couldn't infer longitude columns for ", calling_function))
  }

  #list(lon = NA)
  return(NA)
}

