#' Google map update
#'
#' Update a Google map in a shiny app. Use this function whenever the map needs
#' to respond to reactive content.
#'
#' @param map_id string containing the output ID of the map in a shiny application.
#' @param session the Shiny session object to which the map belongs; usually the
#' default value will suffice.
#' @param data data to be used in the map. See the details section for \code{\link{google_map}}.
#' @param deferUntilFlush indicates whether actions performed against this
#' instance should be carried out right away, or whether they should be held until
#' after the next time all of the outputs are updated; defaults to TRUE.
#' @examples
#' \dontrun{
#'
#' library(shiny)
#' library(googleway)
#'
#' ui <- pageWithSidebar(
#'   headerPanel("Toggle markers"),
#'   sidebarPanel(
#'     actionButton(inputId = "markers", label = "toggle markers")
#'   ),
#'   mainPanel(
#'     google_mapOutput("map")
#'   )
#' )
#'
#' server <- function(input, output, session){
#'
#'   # api_key <- "your_api_key"
#'
#'   df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
#'   -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
#'   ), lon = c(144.968612670898, 144.968414306641, 144.968139648438,
#'  144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
#'  97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
#'  77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
#'  "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
#'
#'
#'   output$map <- renderGoogle_map({
#'     google_map(key = api_key)
#'   })
#'
#'   observeEvent(input$markers,{
#'
#'     if(input$markers %% 2 == 1){
#'       google_map_update(map_id = "map") %>%
#'         add_markers(data = df)
#'     }else{
#'       google_map_update(map_id = "map") %>%
#'         clear_markers()
#'     }
#'   })
#'  }
#' shinyApp(ui, server)
#' }
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


#' @param method the name of the JavaScript method to invoke
#' @param ... unnamed arguments to be passed to the JavaScript method
#' @rdname google_dispatch
#' @export
invoke_method = function(map, method, ...) {
  args = evalFormula(list(...))

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


# Construct url
#
# Constructs the relevant API url, given the arguments
# @param map_url string map url
# @param urlArgs other arguments to append to the URL string
constructURL <- function(map_url, urlArgs){

  return(
    utils::URLencode(
      paste0(map_url,
             paste0("&",
             paste0(names(urlArgs)),
             "=",
             paste0(urlArgs), collapse = "")
             )
      , reserved = F
      )
    )
}

# Construct Waypoints
#
# constructs valid waypoint parameters for directions API
# @param waypoints list of waypoints
# @param optimise_waypoints logical indicating if they should be optimised
constructWaypoints <- function(waypoints, optimise_waypoints){

  waypoints <- sapply(1:length(waypoints), function(x) {
    if(length(names(waypoints)) > 0){
      if(names(waypoints)[x] == "via"){
        paste0("via:", check_location(waypoints[[x]]))
      }else{
        ## 'stop' is the default in google, and the 'stop' identifier is not needed
        check_location(waypoints[[x]])
      }
    }else{
      check_location(waypoints[[x]])
    }
  })

  if(optimise_waypoints == TRUE){
    waypoints <- paste0("optimize:true|", paste0(waypoints, collapse = "|"))
  }else{
    waypoints <- paste0(waypoints, collapse = "|")
  }
  return(waypoints)
}



















