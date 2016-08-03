#' Google map update
#'
#' Update a map in a shiny app. Use this function whenever the map needs to respond to reactive content.
#'
#' @param map_id string The output ID of the map in a shiny application
#' @param session the Shiny session object to which the map belongs; usually the default value will suffice
#' @param data
#' @param deferUntilFlush
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


# This will be very similar to Leaflet for now, while I figure out what's going on.


#' Extension points for plugins
#'
#' @param map a map object, as returned from \code{\link{google_map}}
#' @param funcName the name of the function that the user called that caused
#'   this \code{google_dispatch} call; for error message purposes
#' @param google_map an action to be performed if the map is from
#'   \code{\link{google_map}}
#'
#' @return \code{google_dispatch} returns the value of \code{google_map} or
#' or an error. \code{invokeMethod} returns the
#' \code{map} object that was passed in, possibly modified.
#'
#' @export
google_dispatch = function(map,
                    funcName,
                    googlemap = stop(paste(funcName, "requires a map update object")),
                    googlemap_update = stop(paste(funcName, "does not support map udpate objects"))
) {
  if (inherits(map, "google_map"))
    return(googlemap)
  else if (inherits(map, "google_map_update"))
    return(googlemap_update)
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
           googlemap = {
             x = map$x$calls
             if (is.null(x)) x = list()
             n = length(x)
             x[[n + 1]] = list(functions = method, args = args)
             map$x$calls = x
             map
           },
           googlemap_update = {
             invoke_remote(map, method, args)
           }
  )
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

check_for_columns <- function(df, cols){

  ## check to see if the specified columns exist
  if(!all(cols %in% names(df)))
    stop(paste0("Could not find columns: "
                , paste0(cols[!cols %in% names(df)], collapse = ", ")
                , " in the data"))
}

correct_columns <- function(df, cols){
  ## set any null columns to NA, so Google Maps uses the default
  df[, setdiff(cols, names(df))] <- NA
  return(df)
}
