

## TODO:
## - plot sf objects


#' Add sf
#'
#' Adds an \code{sf} object to a google map
#'
#'
#' @inheritParams add_circles
#' @export
add_sf <- function(map,
                   data = get_map_data(map)
                   ) {

  ## TODO:
  ## - determine the geometries to plot
  ## - plot each geometry separtely
  ##
  ## - add_markers, add_circles, add_polylines, add_polygons to accept list-polyline columns,
  ## and in Javascript

  ## requires an sf or sfencoded object
  data <- normalise_sf(data)

  print(head(data))
  ## POINT > add_markers
  ## LINESTRING > add_polylines
  ## POLYGON > add_polygons

  points <- googlePolylines::geometryRow(data, "POINT")
  lines <- googlePolylines::geometryRow(data, "LINESTRING")
  polygons <- googlePolylines::geometryRow(data, "POLYGON")

#   print(polygons)
#   print(data[polygons, ])
  print("lines") ; print(lines)
  print("polygons"); print(polygons)


  if(length(polygons) > 1) {
    print("adding polygons")
    add_polygons(map = map, data = data[polygons, names(data), drop = FALSE ], polyline = "geometry")
  }

  if(length(lines) > 1 ) {
    print("adding polylines")
    add_polylines(map = map, data = data[lines, names(data), drop = FALSE], polyline = "geometry")
  }
  #return(data)

}


findEncodedColumn <- function(data, polyline) UseMethod("findEncodedColumn")

#' @export
findEncodedColumn.sfencoded <- function(data, polyline) {
  if(is.null(polyline)) polyline <- attr(data, "encoded_column")
  return(polyline)
}

#' @export
findEncodedColumn.default <- function(data, polyline) polyline


normaliseSfData <- function(data, geom) UseMethod("normaliseSfData")

#' @export
normaliseSfData.sf <- function(data, geom) {
  enc <- googlePolylines::encode(data)
  data <- normaliseSfData(enc, geom)
  return(data)
}

#' @export
normaliseSfData.sfencoded <- function(data, geom) {
  idx <- googlePolylines::geometryRow(data, geom)
  return(data[idx, names(data), drop = F])
}

#' @export
normaliseSfData.default <- function(data, geom) data



normalise_sf <- function(sf) UseMethod("normalise_sf")

#' @export
normalise_sf.sf <- function(sf) googlePolylines::encode(sf)

#' @export
normalise_sf.sfencoded <- function(sf) sf

#' @export
normalise_sf.default <- function(sf) stop("Expecting an sf or sfencoded object to add_sf")
