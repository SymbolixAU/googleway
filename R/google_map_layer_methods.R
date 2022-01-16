
stopMessage <- function(obj) stop(paste0("I don't know how to deal with objects of type ", class(obj)))


### validate GeoJSON -----------

# Validate GeoJSON
#
# Validates if the GeoJSON is a URL, character string that validates to JSON,
# or simply GeoJSON itself
validateGeojson <- function(js) UseMethod("validateGeojson")

#' @export
validateGeojson.character <- function(js){

  ## could be a link to geoJSON
  if(isUrl(js)) return( constructGeojsonSource(js, "url") )

  if(!jsonlite::validate(js)) stop("invalid JSON")
  ## https://github.com/jeroen/jsonlite/issues/77
  class(js) <- "json"
  return(
    constructGeojsonSource(js, "local")
    )
}


#' @export
validateGeojson.json <- function(js){
  if(!jsonlite::validate(js)) stop("invalid JSON")
  return(
    constructGeojsonSource(js, "local")
    )
}

#' @export
validateGeojson.default <- function(js){
  stopMessage(js)
}

constructGeojsonSource <- function(geojson, source) {
  return(list(geojson = geojson, source = source))
}


### validate Style -----------

validateStyleUpdate <- function(style) UseMethod("validateStyleUpdate")

#' @export
validateStyleUpdate.character <- function(style){
  if(!jsonlite::validate(style)) stop("invalid JSON")
  class(style) <- 'json'
  return(style)
}

#' @export
validateStyleUpdate.list <- function(style){
  jsonlite::toJSON(style, auto_unbox = T)
}

#' @export
validateStyleUpdate.default <- function(style){
  stopMessage(style)
}


validateStyle <- function(style) UseMethod("validateStyle")

#' @export
validateStyle.character <- function(style){
  if(!jsonlite::validate(style)) stop("invalid JSON")
  class(style) <- 'json'
  validateStyle(style)
}

#' @export
validateStyle.json <- function(style){
  return(
    constructStyleType(style, "all")
  )
}

#' @export
validateStyle.list <- function(style){

  ## named list, where each name is the style property, and each value
  ## is the geoJSON property that corresponds to the style
  return(
    constructStyleType(
      jsonlite::toJSON(style, auto_unbox = T),
      "individual"
      )
  )
}

#' @export
validateStyle.default <- function(style){
  stopMessage(style)
}

constructStyleType <- function(style, type) return(list(style = style, type = type))

stripBrackets <- function(js) gsub("\\[|\\]", "", js)


