# This will be very similar to Leaflet for now, while I figure out what's going on.


#' Extension points for plugins
#'
#' @param map a map object, as returned from \code{\link{google_map}}
#' @param funcName the name of the function that the user called that caused
#'   this \code{dispatch} call; for error message purposes
#' @param google_map an action to be performed if the map is from
#'   \code{\link{google_map}}
#'
#' @return \code{dispatch} returns the value of \code{google_map} or
#' or an error. \code{invokeMethod} returns the
#' \code{map} object that was passed in, possibly modified.
#'
#' @export
dispatch = function(map,
                    funcName,
                    google_map = stop(paste(funcName, "requires a map proxy object"))
) {
  if (inherits(map, "google_map"))
    return(google_map)
  else
    stop("Invalid map parameter")
}


#' @param data a data object that will be used when evaluating formulas in
#'   \code{...}
#' @param method the name of the JavaScript method to invoke
#' @param ... unnamed arguments to be passed to the JavaScript method
#' @rdname dispatch
#' @export
invokeMethod = function(map, data, method, ...) {
  args = evalFormula(list(...), data)

  dispatch(map,
           method,
           google_map = {
             x = map$x$calls
             if (is.null(x)) x = list()
             n = length(x)
             x[[n + 1]] = list(method = method, args = args)
             map$x$calls = x
             map
           }
  )
}
