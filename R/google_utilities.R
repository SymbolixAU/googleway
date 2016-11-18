#' Google map update
#'
#' Update a map in a shiny app. Use this function whenever the map needs to respond to reactive content.
#'
#' @param map_id string The output ID of the map in a shiny application
#' @param session the Shiny session object to which the map belongs; usually the default value will suffice
#' @param data data frame containing at least two columns, one specifying the latitude coordinates, and the other specifying the longitude.
#' @param deferUntilFlush indicates whether actions performed against this instance should be carried out right away, or whether they should be held until after the next time all of the outputs are updated; defaults to TRUE
#' @export
google_map_update <- function(map_id,
                              session = shiny::getDefaultReactiveDomain(),
                              data = NULL,
                              deferUntilFlush = TRUE) {

  if (is.null(session)) {
    stop("google_map_update must be called from the server function of a Shiny app")
  }

  structure(
    list(
      session = session,
      id = map_id,
      x = structure(
        list(),
        google_map_data = data
      ),
      deferUntilFlush = deferUntilFlush,
      dependencies = NULL
    ),
    class = "google_map_update"
  )
}


# These functions will be very similar to Leaflet

#' Google dispatch
#'
#' Extension points for plugins
#'
#' @param map a map object, as returned from \code{\link{google_map}}
#' @param funcName the name of the function that the user called that caused
#'   this \code{google_dispatch} call; for error message purposes
#' @param google_map an action to be performed if the map is from
#'   \code{\link{google_map}}
#' @param google_map_update an action to be performed if the map is from
#'   \code{\link{google_map_update}}
#'
#' @return \code{google_dispatch} returns the value of \code{google_map} or
#' or an error. \code{invokeMethod} returns the
#' \code{map} object that was passed in, possibly modified.
#'
#' @export
google_dispatch = function(map,
                           funcName,
                           google_map = stop(paste(funcName, "requires a map update object")),
                           google_map_update = stop(paste(funcName, "does not support map udpate objects"))
) {
  if (inherits(map, "google_map"))
    return(google_map)
  else if (inherits(map, "google_map_update"))
    return(google_map_update)
  else
    stop("Invalid map parameter")
}


#' @param data a data object that will be used when evaluating formulas in
#'   \code{...}
#' @param method the name of the JavaScript method to invoke
#' @param ... unnamed arguments to be passed to the JavaScript method
#' @rdname google_dispatch
#' @export
invoke_method = function(map, data, method, ...) {
  args = evalFormula(list(...), data)

  google_dispatch(map,
                  method,
                  google_map = {
                    x = map$x$calls
                    if (is.null(x)) x = list()
                    n = length(x)
                    x[[n + 1]] = list(functions = method, args = args)
                    map$x$calls = x
                    map
                  },
                  google_map_update = {
                    invoke_remote(map, method, args)
                  }
  )
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





invoke_remote = function(map, method, args = list()) {
  if (!inherits(map, "google_map_update"))
    stop("Invalid map parameter; googlemap_update object was expected")

  msg <- list(
    id = map$id,
    calls = list(
      list(
        dependencies = lapply(map$dependencies, shiny::createWebDependency),
        method = method,
        args = args
      )
    )
  )

  sess <- map$session
  if (map$deferUntilFlush) {

    sess$onFlushed(function() {
      sess$sendCustomMessage("googlemap-calls", msg)
    }, once = TRUE)

  } else {
    sess$sendCustomMessage("googlemap-calls", msg)
  }
  map
}


### ----------
## taken from Rstudio::leaflet package

# Evaluate list members that are formulae, using the map data as the environment
# (if provided, otherwise the formula environment)
evalFormula = function(list, data) {
  evalAll = function(x) {
    if (is.list(x)) {
      structure(lapply(x, evalAll), class = class(x))
    } else resolveFormula(x, data)
  }
  evalAll(list)
}



resolveFormula = function(f, data) {
  if (!inherits(f, 'formula')) return(f)
  if (length(f) != 2L) stop("Unexpected two-sided formula: ", deparse(f))

  doResolveFormula(data, f)
}

doResolveFormula = function(data, f) {
  UseMethod("doResolveFormula")
}


doResolveFormula.data.frame = function(data, f) {
  eval(f[[2]], data, environment(f))
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

# correct_columns <- function(df, cols, col_names, allowed_nulls = c()){
#
#   ## cols : the column names supplied by the user
#   ## col_names : the column names required in the javascript function
#   ## allowed_nulls : allowed null columns
#
#   for(i in 1:length(col_names)){
#
#     if(is.null(cols[[i]]) & !col_names[[i]] %in% allowed_nulls){
#       stop(paste0(col_names[i], " can not be NULL"))
#
#     }else if(is.null(cols[[i]]) & col_names[[i]] %in% allowed_nulls ){
#
#       ## don't overwrite column if it's used for a different option
#       if(!col_names[[i]] %in% cols){
#
#         ## create an NA column for the allowed null
#         df[, col_names[[i]]] <- NA
#         cols[[i]] <- col_names[[i]]
#       }
#
#     }else if(is.na(cols[[i]])){
#       stop(paste0(col_names[i], " can not be NA"))
#     }
#   }
#
#   for(i in 1:length(col_names)){
#     if(!is.null(cols[[i]])){
#       if(!cols[[i]] %in% names(df)){
#         ## the column doesn't exist
#         ## the actual column name should be col_names[i]
#         df[, col_names[[i]] ] <- cols[[i]]
#         cols[[i]] <- col_names[[i]]
#       }else{
#         ## else the column exists
#         ## make sure the name is correct
#
#       }
#     }
#   }
#
#   ## all correct columns have been created
#   cols <- stats::setNames(cols, col_names)
#
#   return(list(df = df, cols = cols))
# }



# default_group <- function(data, group){
#
#   group_options <- data.frame("geodesic" = TRUE,
#                               "strokeColour" = "#0000FF",
#                               "strokeOpacity" = 0.6,
#                               "strokeWeight" = 2,
#                               "fillColour" = "#FF0000",
#                               "fillOpacity" = 0.35,
#                               "information" = NA)
#   group_options <- cbind(group_options, "group" = unique(data[,group]))
#
#   return(group_options)
# }

# construct_poly <- function(data, group, group_options,
#                            lineSource, polyline){
#
#   poly <- split(data, data[group])
#   poly <- lapply(poly, function(x){
#     if(lineSource == "coords"){
#       pl <- gepaf::encodePolyline(x[, c("lat","lng")])
#     }else{
#       pl <- x[, polyline]
#     }
#     i <- unique(x[, group])
#     list("poly" = pl,
#          "group" = i,
#          "geodesic" = tolower(group_options[group_options$group == i, "geodesic"]),
#          "strokeColour" = group_options[group_options$group == i, "strokeColour"],
#          "strokeOpacity" = group_options[group_options$group == i, "strokeOpacity"],
#          "strokeWeight" = group_options[group_options$group == i, "strokeWeight"],
#          "fillColour" = group_options[group_options$group == i, "fillColour"],
#          "fillOpacity" = group_options[group_options$group == i, "fillOpacity"],
#          "information" = group_options[group_options$group == i, "information"]
#     )
#   })
# }

#' Set Defaults
#'
#' @param col column to check / add to the data
#' @param val default value for the column
#' @param df data to be checked/ added to
SetDefault <- function(col, val, df){
  if(is.null(col)){
    ## use the default value
    return(rep(val, nrow(df)))
  }else{
    ## if a column has been supplied, use that,
    ## otherwise, use the default value supplied
    if(col %in% names(df)){
      return(df[, col])
    }else{
      ## assume the value supplied is the default value
      return(rep(col, nrow(df)))
    }
  }
}

