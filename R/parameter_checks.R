
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

loadIntervalCheck <- function(load_interval){
  numericCheck(load_interval)
  if(!is.null(load_interval))
    if(load_interval < 0)
      stop("load_interval needs to be a positive number")
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

#' @export
urlCheck.url <- function(url) url

#' @export
urlCheck.default <- function(url) stopMessage(url)




# hexType <- function(cols){
#   rgb <- "^#(?:[0-9a-fA-F]{3}){1,2}$"
#   rgba <- "^#(?:[0-9a-fA-F]{4}){1,2}$"
# }




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


validateAlternatives <- function(alternatives){
  if(is.null(alternatives)) return(NULL)

  logicalCheck(alternatives)

  return(tolower(alternatives))
}

validateArrivalTime <- function(arrival_time){

  if(is.null(arrival_time)) return( NULL )

  checkPosix(arrival_time)

  return(arrival_time)
}


validateArrivalDepartureTimes <- function(arrival_time, departure_time){

  if(!is.null(arrival_time) & !is.null(departure_time)){
    warning("you have supplied both an arrival_time and a departure_time - only one is allowed. The arrival_time will be ignored")
    return(NULL)
  }
  return(arrival_time)
}

validateAvoid <- function(avoid){
  if(is.null(avoid)) return(NULL)

  if(!all(tolower(avoid) %in% c("tolls","highways","ferries","indoor"))){
    stop("avoid can only include tolls, highways, ferries or indoor")
  }else{
    if(length(avoid) > 1){
      avoid <- paste0(tolower(avoid), collapse = "|")
    }else{
      avoid <- tolower(avoid)
    }
  }
  return(avoid)
}

validateBounds <- function(bounds){
  if(is.null(bounds)) return(NULL)

  if(!class(bounds) == "list" | !all(sapply(bounds, class) == "numeric") | length(bounds) != 2)
    stop("bounds must be a list of length 2, each item being a vector of lat/lon coordinate pairs")

  if(!all(sapply(bounds, length) == 2))
    stop("each element of bounds must be length 2 - a pair of lat/lon coordinates")

  bounds <- paste0(lapply(bounds, function(x) paste0(x, collapse = ",")), collapse = "|")
  return(bounds)
}

validateComponents <- function(components){
  if(is.null(components)) return(NULL)

  if(!inherits(components, "data.frame") | !sum(names(components) %in% c("component","value")) == 2)
    stop("components must be a data.frame with two columns named 'component' and 'value'")

  ## error on misspelled components
  if(!any(as.character(components$component) %in% c("route","locality","administrative_area","postal_code","country")))
    stop("valid components are 'route', 'locality', 'postal_code', 'administrative_area' and 'country'")

  components = paste0(apply(components, 1, function(x) paste0(x, collapse = ":")), collapse = "|")
  components <- tolower(components)
  return(components)
}

validateComponentsCountries <- function(components){
  if(is.null(components)) return(NULL)

  if(length(components) > 5){
    stop("components only supports up to 5 countries")
  }

  if(!all(nchar(components) == 2)){
    stop("components must be two characters and represent an ISO 3166-1 Alpha-2 country code")
  }

  if(!is.character(components)){
    stop("components must be two characters and represent an ISO 3166-1 Alpha-2 country code")
  }

  components <- paste0("country:", components, collapse = "|")
  return(components)
}

validateDepartureTime <- function(departure_time, mode){
  if(is.null(departure_time)) return(NULL)

  if (inherits(departure_time, "POSIXct")) {
    checkPosix( departure_time )

    if(mode == "driving" && ( departure_time + 60) < Sys.time() ){ ## allowing a buffer
      stop("departure_time for driving mode must not be in the past")
    }

    return( as.integer(departure_time ) )

  } else if ( inherits(departure_time, "character") ) {
    if( departure_time != "now") {
      stop("when using a string for departure_time you may only use 'now'")
    }
  }
  return( departure_time )
}

validateFindInput <- function( input, inputtype ) {
  ## if phonenumber , "+" needs to be encoded to %2B
  if( inputtype == "phonenumber") {
    input <- gsub("\\+","%2B",input)
  }
  return( input )
}

validateLocationPoint <- function( point ) {
  if(is.null(point)) return(NULL)
  point <- validateGeocodeLocation( point )
  return(
    paste0("point:",point)
  )
}

validateLocationCircle <- function( circle ) {
  if(is.null(circle)) return(NULL)
  if( is.null( circle[['radius']] ) || is.null( circle[['point']] ) ) {
    stop("circle list must include radius and point elements")
  }
  return(
    paste0("circle:", circle[['radius']],"@", paste0(circle[['point']], collapse = ",") )
  )
}

validateLocationRectangle <- function( rectangle ) {
  if(is.null(rectangle)) return(NULL)
  if( is.null( rectangle[['sw']] ) || is.null( rectangle[['ne']] ) ) {
    stop("rectangle list must include sw and ne elements")
  }

  sw <- paste0(rectangle[['sw']], collapse = ",")
  ne <- paste0(rectangle[['ne']], collapse = ",")
  return(
    paste0("rectangle:",sw, "|", ne)
  )
}


validateLocationBias <- function( point, circle, rectangle ) {
  if( !is.null(point) ) {
    return( point )
  }
  if (!is.null( circle )) {
    return( circle )
  }
  if (!is.null( rectangle )) {
    return ( rectangle )
  }
  return( NULL )
}

validateLanguage <- function(language){
  if(is.null(language)) return(NULL)

  if(class(language) != "character" | length(language) > 1){
    stop("language must be a single string")
  }
  return(tolower(language))
}

validateFov <- function(fov){

  if(length(fov) != 1)
    stop("fov must be a single value")

  if(!is.numeric(fov) | fov < 0 | fov > 120)
    stop("fov must be a numeric value between 0 and 120 (inclusive)")

  return(fov)
}

validateGeocodeLocation <- function(location){

  if(is.null(location)) return(NULL)
  ## checks the location is a numeric vector (of lat/lon coordinates)

  if(!is.numeric(location))
    stop("location must be a vector of a pair of latitude and longitude coordinates")

  if(!length(location) == 2)
    stop("location must be a vector of a pair of latitude and longitude coordinates")

  location <- paste0(location, collapse = ",")
  return(location)

}


validateHeading <- function(heading){
  if(is.null(heading)) return(NULL)

  if(length(heading) != 1)
    stop("heading must be a single value")

  if(!is.numeric(heading) | heading < 0 | heading > 360){
    stop("heading must be a numeric value between 0 and 360 (inclusive)")
  }

  return(heading)
}

validateLocationSearch <- function(location, search_string, radius, rankby, keyword, name, place_type){
  if(is.null(location)) return(NULL)

  ## if using rankby="distance"
  if(!is.null(rankby)) {
    if(rankby == "distance") {
      if(!is.null(radius)) {
        stop("If using rankby, radius must not be specified")
      }
    }
  }

  if(!is.null(radius) && !is.null(rankby)) {
    stop("rankby must not be included if radius is specified")
  }

  ## radius must be included if using a location search
  if(is.null(search_string) && is.null(radius) & is.null(rankby))
    stop("you must specify a radius if only using a 'location' search")

  ## if rankby == distance, then one of keyword, name or place_type must be specified
  if(!is.null(rankby)){
    if(rankby == "distance" &
       is.null(keyword) & is.null(name) & is.null(place_type))
      stop("you have specified rankby to be 'distance', so you must provide one of 'keyword','name' or 'place_type'")
  }

  return(location)
}

validateLocationType <- function(location_type){
  if(is.null(location_type)) return(NULL)

  if(length(setdiff(location_type, c("rooftop","range_interpolated", "geometric_center", "approximate"))) > 0)
    stop("invlalid values for location_type")

  if(length(location_type) > 1){
    location_type <- paste0(toupper(location_type), collapse = "|")
  }else{
    location_type <- toupper(location_type)
  }
  return(location_type)
}

validateName <- function(name, search_string){
  if(is.null(name)) return(NULL)

  ## warning if name used with search_string
  if(!is.null(search_string) & !is.null(name))
    warning("The 'name' argument is ignored when using a 'search_string'")

  if(length(name) > 1)
    name <- paste0(name, collapse = "|")

  return(name)
}

validatePageToken <- function(page_token){
  if(is.null(page_token)) return(NULL)

  ## page token is single string
  if(!is.character(page_token) | length(page_token) != 1)
    stop("page_token must be a string of length 1")

  return(page_token)
}


validatePitch <- function(pitch){

  if(length(pitch) != 1)
    stop("pitch must be a single value")

  if(!is.numeric(pitch) | pitch < -90 | pitch > 90){
    stop("pitch must be between -90 and 90 (inclusive)")
  }

  return(pitch)
}

# validatePlaceInput <- function( inputtype ) {
#   if ( !( intputtype == "textxquery" || inputtype == "phonenumber") ) {
#     stop("inputtype must be one of textquery or phonenumber")
#   }
#   return( inputtype )
# }

validatePlaceType <- function(place_type){
  if(is.null(place_type)) return(NULL)

  if(length(place_type) > 1 | !is.character(place_type))
    stop("place_type must be a string vector of length 1")

  return(place_type)
}


checkPosix <- function(time){
  if(!inherits(time, "POSIXct"))
    stop("times must be a POSIXct object")
}


validatePriceRange <- function(price_range){
  if(is.null(price_range)) return(NULL)

  ## price range is between 0 and 4
  if(!is.numeric(price_range) | (is.numeric(price_range) & length(price_range) != 2))
    stop("price_range must be a numeric vector of length 2")

  if(!price_range[1] %in% 0:4 | !price_range[2] %in% 0:4)
    stop("price_range must be between 0 and 4 inclusive")

  return(price_range)
}


validateRadar <- function(radar){
  ## if radar search, must provide location, key, radius
  ## if radar search, one of keyword, name or type
  # if(isTRUE(radar)){
  #   if(!is.null(search_string))
  #     warning("the search_string in a radar search will be ignored")
  #
  #   if(is.null(keyword) & is.null(name) & is.null(place_type))
  #     stop("when using a radar search, one of keyword, name or place_type must be provided")
  #
  #   if(is.null(location))
  #     stop("when using a radar search, location must be provided")
  #
  #   if(is.null(radius))
  #     stop("when using a radar search, radius must be provided")
  # }
  #
  # return(radar)
  message("The radar argument is now deprecated")
}

validateRadius <- function(radius){
  if(is.null(radius)) return(NULL)

  if(length(radius) != 1 | is.list(radius))
    stop("radius must be numeric vector of length 1")

  if(!is.numeric(radius))
    stop("radius must be numeric between 0 and 50000")

  if(radius > 50000 | radius < 0)
    stop("radius must be numeric between 0 and 50000")

  return(radius)
}

validateRadiusRankBy <- function(rankby, radius, location){

  ## radius must not be included if rankby=distance
  if(!is.null(rankby) & !is.null(location)){
    if(!is.null(radius) & rankby == "distance"){
      warning("radius is ignored when rankby == 'distance'")
      radius <- NULL
    }
  }
  return(radius)
}

validateRankBy <- function(rankby, location, search_string){
  if(is.null(rankby)) return(NULL)

  ## rankby has correct arguments
  if(!is.null(location))
    if(!rankby %in% c("prominence","distance"))
      stop("rankby must be one of either prominence or distance")

  ## warning if rankby used with search_string
  if(!is.null(search_string))
    warning("The 'rankby' argument is ignored when using a 'search_string'")

  return(rankby)
}

validateRegion <- function(region){
  if(is.null(region)) return(NULL)

  if(class(region) != "character" | length(region) > 1)
    stop("region must be a two-character string")

  return(tolower(region))
}

validateResultType <- function(result_type){
  if(is.null(result_type)) return(NULL)

  if(!class(result_type) == "character")
    stop("result_type must be a vector of strings")

  if(length(result_type) > 1){
    result_type <- paste0(tolower(result_type), collapse = "|")
  }else{
    result_type <- tolower(result_type)
  }

  return(result_type)
}


validateSize <- function(size){

  if(!is.numeric(size) | length(size) != 2)
    stop("size must be a numeric vector of length 2, giving the width and height (in pixles) of the image")

  size <- paste0(size, collapse = "x")
  return(size)

}

validateTrafficModel <- function(traffic_model){
  if(is.null(traffic_model)) return(NULL)

  ## allow an underscore to pass
  traffic_model <- match.arg(gsub("_", " ", traffic_model), choices = c("best guess", "pessimistic","optimistic"))
  traffic_model <- gsub(" ", "_", traffic_model)

}

## transit_mode is only valid where mode = transit
validateTransitMode <- function(transit_mode, mode) {

  if(!is.null(transit_mode) & mode != "transit") {

    warning("You have specified a transit_mode, but are not using mode = 'transit'. Therefore this argument will be ignored")
    return(NULL)
  }else if(!is.null(transit_mode) & mode == "transit"){
    transit_mode <- match.arg(transit_mode, choices = c("bus","subway","train","tram","rail"))
  }

  return(transit_mode)
}

## transit_routing_preference only valid where mode == transit
validateTransitRoutingPreference <- function(transit_routing_preference, mode) {
  if(!is.null(transit_routing_preference) & mode != "transit"){
    warning("You have specified a transit_routing_preference, but are not using mode = 'transit'. Therefore this argument will be ignored")
    return(NULL)
  }else if(!is.null(transit_routing_preference) & mode == "transit"){
    transit_routing_preference <- match.arg(transit_routing_preference, choices = c("less_walking","fewer_transfers"))
    transit_routing_preference <- paste0(transit_routing_preference, collapse = "|")
  }
  return(transit_routing_preference)
}

validateWaypoints <- function(waypoints, optimise_waypoints, mode){
  if(is.null(waypoints)) return(NULL)

  if(!mode %in% c("driving", "walking","bicycling"))
    stop("waypoints are only valid for driving, walking or bicycling modes")

  if(class(waypoints) != "list")
    stop("waypoints must be a list")

  if(!all(names(waypoints) %in% c("stop", "via")))
    stop("waypoint list elements must be named either 'via' or 'stop'")

  ## check if waypoints should be optimised, and thefore only use 'stop' as a valid waypoint
  if(optimise_waypoints == TRUE){
    if(any(names(waypoints) %in% c("via")))
      stop("waypoints can only be optimised for stopovers. Each waypoint in the list must be named as stop")
  }

  return(constructWaypoints(waypoints, optimise_waypoints))
}
