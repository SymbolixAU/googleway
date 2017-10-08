
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


validateFusionStyle <- function(styles) UseMethod("validateFusionStyle")

#' @export
validateFusionStyle.list <- function(styles){

  ## The Google Maps API can't use values inside arrays, so we need
  ## to get rid of any arrays.
  ## - remove square brackets around value
  styles <- jsonlite::toJSON(styles)
  styles <- stripBrackets(substr(styles, 2, (nchar(styles) - 1)))
  styles <- paste0("[", styles, "]")
  return(styles)
}

#' @export
validateFusionStyle.character <- function(styles){
  if(!jsonlite::validate(styles)) stop("invalid JSON")
  return(styles)
}

#' @export
validateFusionStyle.json <- function(styles) as.character(styles)

#' @export
validateFusionStyle.default <- function(styles) stopMessage(styles)


## validate fusion query ------------------------------------------------------

validateFusionQuery <- function(query) UseMethod("validateFusionQuery")

#' @export
validateFusionQuery.list <- function(query) {
  query <- stripBrackets(jsonlite::toJSON(query))
  return(query)
}

#' @export
validateFusionQuery.data.frame <- function(query){
  if(nrow(query) > 1) stop("a fusion query specified by a data.frame can only be one row")

  names(query) <- tolower(names(query))
  if(!all(c("select","from") %in% names(query))){
    stop("the columns of a fusion query must contain 'select' and 'where'")
  }
  ## need to unbox
  ## The Google Maps API can't use values inside arrays, so we need
  ## to get rid of any arrays.
  ## - remove square brackets around value
  # gsub("\\[|\\]", "", jsonlite::toJSON(query))
  return(
    stripBrackets(jsonlite::toJSON(query))
  )
}

#' @export
validateFusionQuery.character <- function(query){
  if(!jsonlite::validate(query)) stop("invalid JSON")
  class(query) <- 'json'
  return(query)
}

#' @export
validateFusionQuery.default <- function(query) stopMessage(query)

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


