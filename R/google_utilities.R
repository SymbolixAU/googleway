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
#' library(magrittr)
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

#' Construct url
#'
#' Constructs the relevant API url, given the arguments
#' @param map_url string map url
#' @param urlArgs other arguments to append to the URL string
constructURL <- function(map_url, urlArgs){

  return(paste0(map_url,
                paste0("&",
                       paste0(names(urlArgs)),
                       "=",
                       paste0(urlArgs), collapse = "")
                )
         )
}


#' Map Styles
#'
#' Various styles for a \code{google_map()} map.
#'
#' @examples
#' \dontrun{
#' map_key <- "your_map_key"
#' google_map(key = map_key, style = map_styles()$silver)
#'
#' }
#'
#' @note you can generate your own map styles at \url{https://mapstyle.withgoogle.com/}
#'
#' @return list of styles
#' @export
map_styles <- function(){

  standard <- '[]'
  silver <- '[{"elementType": "geometry","stylers": [{"color": "#f5f5f5"}]},{"elementType": "labels.icon","stylers": [{"visibility": "off"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#616161"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#f5f5f5"}]},{"featureType": "administrative.land_parcel","elementType": "labels.text.fill","stylers": [{"color": "#bdbdbd"}]},{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#eeeeee"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#757575"}]},{"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#e5e5e5"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#9e9e9e"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#ffffff"}]},{"featureType": "road.arterial","elementType": "labels.text.fill","stylers": [{"color": "#757575"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#dadada"}]},{"featureType": "road.highway","elementType": "labels.text.fill","stylers": [{"color": "#616161"}]},{"featureType": "road.local","elementType": "labels.text.fill","stylers": [{"color": "#9e9e9e"}]},{"featureType": "transit.line","elementType": "geometry","stylers": [{"color": "#e5e5e5"}]},{"featureType": "transit.station","elementType": "geometry","stylers": [{"color": "#eeeeee"}]},{"featureType": "water","elementType": "geometry","stylers": [{"color": "#c9c9c9"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#9e9e9e"}]}]'
  retro <- '[{"elementType": "geometry","stylers": [{"color": "#ebe3cd"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#523735"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#f5f1e6"}]},{"featureType": "administrative","elementType": "geometry.stroke","stylers": [{"color": "#c9b2a6"}]},{"featureType": "administrative.land_parcel","elementType": "geometry.stroke","stylers": [{"color": "#dcd2be"}]},{"featureType": "administrative.land_parcel","elementType": "labels.text.fill","stylers": [{"color": "#ae9e90"}]},{"featureType": "landscape.natural","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#93817c"}]},{"featureType": "poi.park","elementType": "geometry.fill","stylers": [{"color": "#a5b076"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#447530"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#f5f1e6"}]},{"featureType": "road.arterial","elementType": "geometry","stylers": [{"color": "#fdfcf8"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#f8c967"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#e9bc62"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry","stylers": [{"color": "#e98d58"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry.stroke","stylers": [{"color": "#db8555"}]},{"featureType": "road.local","elementType": "labels.text.fill","stylers": [{"color": "#806b63"}]},{"featureType": "transit.line","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "transit.line","elementType": "labels.text.fill","stylers": [{"color": "#8f7d77"}]},{"featureType": "transit.line","elementType": "labels.text.stroke","stylers": [{"color": "#ebe3cd"}]},{"featureType": "transit.station","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "water","elementType": "geometry.fill","stylers": [{"color": "#b9d3c2"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#92998d"}]}]'
  dark <- '[{"elementType": "geometry","stylers": [{"color": "#212121"}]},{"elementType": "labels.icon","stylers": [{"visibility": "off"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#757575"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#212121"}]},{"featureType": "administrative","elementType": "geometry","stylers": [{"color": "#757575"}]},{"featureType": "administrative.country","elementType": "labels.text.fill","stylers": [{"color": "#9e9e9e"}]},{"featureType": "administrative.land_parcel","stylers": [{"visibility": "off"}]},{"featureType": "administrative.locality","elementType": "labels.text.fill","stylers": [{"color": "#bdbdbd"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#757575"}]},{"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#181818"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#616161"}]},{"featureType": "poi.park","elementType": "labels.text.stroke","stylers": [{"color": "#1b1b1b"}]},{"featureType": "road","elementType": "geometry.fill","stylers": [{"color": "#2c2c2c"}]},{"featureType": "road","elementType": "labels.text.fill","stylers": [{"color": "#8a8a8a"}]},{"featureType": "road.arterial","elementType": "geometry","stylers": [{"color": "#373737"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#3c3c3c"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry","stylers": [{"color": "#4e4e4e"}]},{"featureType": "road.local","elementType": "labels.text.fill","stylers": [{"color": "#616161"}]},{"featureType": "transit","elementType": "labels.text.fill","stylers": [{"color": "#757575"}]},{"featureType": "water","elementType": "geometry","stylers": [{"color": "#000000"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#3d3d3d"}]}]'
  night <- '[{"elementType": "geometry","stylers": [{"color": "#242f3e"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#746855"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#242f3e"}]},{"featureType": "administrative.locality","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#263c3f"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#6b9a76"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#38414e"}]},{"featureType": "road","elementType": "geometry.stroke","stylers": [{"color": "#212a37"}]},{"featureType": "road","elementType": "labels.text.fill","stylers": [{"color": "#9ca5b3"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#746855"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#1f2835"}]},{"featureType": "road.highway","elementType": "labels.text.fill","stylers": [{"color": "#f3d19c"}]},{"featureType": "transit","elementType": "geometry","stylers": [{"color": "#2f3948"}]},{"featureType": "transit.station","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "water","elementType": "geometry","stylers": [{"color": "#17263c"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#515c6d"}]},{"featureType": "water","elementType": "labels.text.stroke","stylers": [{"color": "#17263c"}]}]'
  aubergine <- '[{"elementType": "geometry","stylers": [{"color": "#1d2c4d"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#8ec3b9"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#1a3646"}]},{"featureType": "administrative.country","elementType": "geometry.stroke","stylers": [{"color": "#4b6878"}]},{"featureType": "administrative.land_parcel","elementType": "labels.text.fill","stylers": [{"color": "#64779e"}]},{"featureType": "administrative.province","elementType": "geometry.stroke","stylers": [{"color": "#4b6878"}]},{"featureType": "landscape.man_made","elementType": "geometry.stroke","stylers": [{"color": "#334e87"}]},{"featureType": "landscape.natural","elementType": "geometry","stylers": [{"color": "#023e58"}]},{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#283d6a"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#6f9ba5"}]},{"featureType": "poi","elementType": "labels.text.stroke","stylers": [{"color": "#1d2c4d"}]},{"featureType": "poi.park","elementType": "geometry.fill","stylers": [{"color": "#023e58"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#3C7680"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#304a7d"}]},{"featureType": "road","elementType": "labels.text.fill","stylers": [{"color": "#98a5be"}]},{"featureType": "road","elementType": "labels.text.stroke","stylers": [{"color": "#1d2c4d"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#2c6675"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#255763"}]},{"featureType": "road.highway","elementType": "labels.text.fill","stylers": [{"color": "#b0d5ce"}]},{"featureType": "road.highway","elementType": "labels.text.stroke","stylers": [{"color": "#023e58"}]},{"featureType": "transit","elementType": "labels.text.fill","stylers": [{"color": "#98a5be"}]},{"featureType": "transit","elementType": "labels.text.stroke","stylers": [{"color": "#1d2c4d"}]},{"featureType": "transit.line","elementType": "geometry.fill","stylers": [{"color": "#283d6a"}]},{"featureType": "transit.station","elementType": "geometry","stylers": [{"color": "#3a4762"}]},{"featureType": "water","elementType": "geometry","stylers": [{"color": "#0e1626"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#4e6d70"}]}]'

  return(list(standard = standard,
              silver = silver,
              retro = retro,
              dark = dark,
              night = night,
              aubergine = aubergine))
}

LayerId <- function(layer_id){
  if(!is.null(layer_id) & length(layer_id) != 1)
    stop("please provide a single value for 'layer_id'")

  if(is.null(layer_id)){
    return("defaultLayerId")
  }else{
    return(layer_id)
  }
}

#' Object Columns
#'
#' Defines the columns used by the Maps API so only those required
#' are kept
#'
#' @param obj string specifying the type of object
#' @return vector of column names
objectColumns <- function(obj = c("polylinePolyline",
                                  "polylineCoords",
                                  "polygonPolyline",
                                  "polygonCoords")){

  return(
    switch(obj,
           "polylineCoords" = c("id", "lat","lng", "geodesic","stroke_colour",
                                "stroke_weight","stroke_opacity","mouse_over",
                                "mouse_over_group", "info_window", "z_index"),
           "polylinePolyline" = c("id", "polyline", "geodesic","stroke_colour",
                                "stroke_weight","stroke_opacity","mouse_over",
                                "mouse_over_group", "info_window", "z_index"),
           "polygonCoords" = c("id","pathId","lat","lng","stroke_colour",
                               "stroke_weight","stroke_opacity","fill_colour",
                               "fill_opacity", "info_window","mouse_over",
                               "mouse_over_group", "z_index"))
  )
}



# polyCheck.sf <- function(data, polyline, lat, lon){
#   ## sf objects will use the 'sfc_ geometry' column
#   ## return data, and the de-constructed geometry column
#
#   ## geom column
#   geomCol <- which(unlist(lapply(data, function(x) "sfc" %in% class(x))))
#
#
#
# }
#
#
# polyCheck.default <- function(data, polyline, lat, lon){
#   ## nothing to do
#   return(list(data = data, polyline = polyline, lat = lat, lon = lon))
# }
#
#
# sfData <- function(geom) UseMethod("sfData")
#
# sfData.sfc_LINESTRING <- function(geom){
#
# }
#
#
# sfData.sfc_MULTIPOLYGON <- function(geom){
#
#
#     lapply(geom, function(x){
#
#          lapply(1:length(x), function(y){
#
#           data.frame(
#             lineId = y,
#             lat = x[[y]][[1]][,2],
#             lon = x[[y]][[1]][,1],
#             hole = (y > 1)[c(T, F)]
#           )
#         })
#     })
#
#
# }
#
#
# createJSON.default <- function(geom){
#
# }

# createJSON <- function(obj){
#   UseMethod("dataType", obj)
# }
#
# #' @export
# dataType.default <- function(data) stop(paste0("I don't yet know how to work with objects of class ", class(data)))
#
# #' @export
# dataType.data.frame <- function(data) print("data.frame")
#
# #' @export
# dataType.data.table <- function(data) print("data.table")
#
# #' @export
# dataType.SpatialLinesDataFrame <- function(shp, id = NULL) {
#   print("spatial lines data frame")
#   ## extract polyline stuff
#   # sp::SpatialLines(data@lines[1])
#
#   ## need to extract a data.frame of attributes (slot(shp, "data")), AND
#   ## a data.frame of each list of coordinates in lat/lon
#
#   ## in the spatialpolylinesdataframe, each 'line' corresponds to a row of the data
#   ## if no id has been specified, create one based on rowname
#   data <- shp@data
#
#   if(!is.null(id))
#     data[, 'id'] <- as.character(data[, id])
# }
















