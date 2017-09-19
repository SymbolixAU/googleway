# Data Check
#
# checks the data is the correct type(s)
# @param data the data passed into the map layer funciton
dataCheck <- function(data){

  if(is.null(data))
    stop("No data supplied")

  if(!inherits(data, "data.frame"))
    stop("Currently only data.frames are supported")
}

# Latitude Check
#
# Checks that a value is between -90:90
latitudeCheck <- function(lat, arg){
  if(!is.numeric(lat) | lat < -90 | lat > 90)
    stop(paste0(arg, " must be a value between -90 and 90 (inclusive)"))
}

# Longitude Check
#
# Checks that a value is between -90:90
longitudeCheck <- function(lat, arg){
  if(!is.numeric(lat) | lat < -180 | lat > 180)
    stop(paste0(arg, " must be a value between -180 and 180 (inclusive)"))
}

# Is Using Polyline
#
# Checks if the polyline argument is null or not
# @param polyline
isUsingPolyline <- function(polyline){
  if(!is.null(polyline)) return(TRUE)

  return(FALSE)
}

# Lat Lon Check
#
# Attempts to find the lat and lon columns. Also corrects the 'lon'
# column to 'lng'
#
# @param objArgs arguments of calling funciton
# @param lat object specified by user
# @param lon object specified by user
# @param dataNames data names
# @param layer_call the map layer funciton calling this function
latLonCheck <- function(objArgs, lat, lon, dataNames, layer_call){

  ## change lon to lng
  names(objArgs)[which(names(objArgs) == "lon")] <- "lng"

  if(is.null(lat)){
    lat <- find_lat_column(dataNames, layer_call, TRUE)
    objArgs[['lat']] <- lat
  }

  if(is.null(lon)){
    lon <- find_lon_column(dataNames, layer_call, TRUE)
    objArgs[['lng']] <- lon
  }
  return(objArgs)
}

# Lat Lon Poly Check
#
# Check to ensure either the polyline or the lat & lon columns are specified
# @param lat latitude column
# @param lon longitude column
# @param polyline polyline column
latLonPolyCheck <- function(lat, lon, polyline){

  if(!is.null(polyline) & !is.null(lat) & !is.null(lon))
    stop('please use either a polyline colulmn, or lat/lon coordinate columns, not both')

  if(is.null(polyline) & (is.null(lat) | is.null(lon)))
    stop("please supply the either the column containing the polylines, or the lat/lon coordinate columns")
}

# Layer Id
#
# Checks the layer_id parameter, and provides a default one if NULL
# @param layer_id
layerId <- function(layer_id){
  if(!is.null(layer_id) & length(layer_id) != 1)
    stop("please provide a single value for 'layer_id'")

  if(is.null(layer_id)){
    return("defaultLayerId")
  }else{
    return(layer_id)
  }
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

# Marker Colour Icon Check
#
# Checks for only one of colour or marker_icon, and fixes the 'marker_icon'
# to be 'icon'
# @param data the data supplied to the map layer
# @param objArgs the arguments to the function
# @param colour the colour argument for a marker
# @param marker_icon the icon argument for a marker
markerColourIconCheck <- function(data, objArgs, colour, marker_icon){

  if(!is.null(colour) & !is.null(marker_icon))
    stop("only one of colour or icon can be used")

  if(!is.null(marker_icon)){
    objArgs[['url']] <- marker_icon
    objArgs[['marker_icon']] <- NULL
  }

  if(!is.null(colour)){
    if(!all((tolower(data[, colour])) %in% c("red","blue","green","lavender"))){
      stop("colours must be either red, blue, green or lavender")
    }
  }

  return(objArgs)
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

# Palette Check
#
# Checks if the palette is a function
# @param arg palette to test
paletteCheck <- function(arg){
  if(is.null(arg)) return(viridisLite::viridis)
  if(!is.function(arg)) stop("palette needs to be a function")

  return(arg)
}

# Path Id Check
#
# If a polygon is using coordinates a path Id is also required. If pathId is not
# supplied it is assumed each sequence of coordinates belong to the same path
# @param data
# @param pathId
# @param usePolyline
pathIdCheck <- function(data, pathId, usePolyline, objArgs){

  if(!usePolyline){
    if(is.null(pathId)){
      message("No 'pathId' value defined, assuming one continuous line per polygon")
      pathId <- 'pathId'
      objArgs[['pathId']] <- pathId
      data[, pathId] <- '1'
    }else{
      data[, pathId] <- as.character(data[, pathId])
    }
  }

  return(list(data = data, objArgs = objArgs, pathId = pathId))
}

# Poly Id Check
#
# Polygons and polylines require an id for specifying the shape being defined.
# @param data the data being passed into the shape function
# @param id the id from the data
# @param usePolyline logical indicating if an encoded polyline is being used
# @param objArgs the arguments to the function will be updated if a default ID value is required
# @details
# If coordinates are being used, and no id is specified, the coordinates are assumed
# to identify a single polyline
#
# If polylines are being used,
polyIdCheck <- function(data, id, usePolyline, objArgs){

  if(usePolyline){
    if(is.null(id)){
      id <- 'id'
      objArgs[['id']] <- id
      data[, id] <- 1:nrow(data)
    }else{
      data[, id] <- data[, id]
    }
  }else{
    if(is.null(id)){
      message("No 'id' value defined, assuming one continuous line of coordinates")
      id <- 'id'
      data[, id] <- 1
      objArgs[['id']] <- id
    }else{
      data[, id] <- data[, id]
    }
  }
  return(list(data = data, objArgs = objArgs, id = id))
}
