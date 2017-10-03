
# Obj Polyline Coords
#
# Creates a list object that can be converted into the required JSON for plotting
# coordinates as polylines
#
# @param obj \code{data.frame} consisting of columns 'lat' and 'lng'
# @param ids vector of ids for each path/line
# @param otherColumns vector of attribute columns (e.g. stroke_fill, stroke_weight)
# that are to be kept in the output
objPolylineCoords <- function(obj, ids, otherColumns){

  if(length(otherColumns) > 0){

    lst_polyline <- lapply(ids, function(x){
      thisRow <- unique(obj[ obj[, 'id'] == x, otherColumns, drop = FALSE])
      coords <- list(obj[obj[, 'id'] == x, c('lat', 'lng')])
      c(c(coords = unname(coords)), thisRow, id = x)
    })

  }else{

    lst_polyline <- lapply(ids, function(x){
      coords <- list(obj[obj[, 'id'] == x, c('lat', 'lng')])
      c(c(coords = unname(coords), id = x))
    })
  }

  return(lst_polyline)
}


# Obj Polygon Coords
#
# Creates a list object that can be converted into the required JSON for plotting
# coordinates as polygons
#
# @param obj \code{data.frame} consisting of columns 'lat' and 'lng'
# @param ids vector of ids for each path/line
# @param otherColumns vector of attribute columns (e.g. stroke_fill, stroke_weight)
# that are to be kept in the output
objPolygonCoords <- function(obj, ids, otherColumns){

  if(length(otherColumns) > 0){

    lst_polygon <- lapply(ids, function(x){
      pathIds <- unique(obj[ obj[, 'id'] == x, 'pathId'])
      thisRow <- unique(obj[ obj[, 'id'] == x, otherColumns, drop = FALSE] )
      coords <- sapply(pathIds, function(y){
        list(obj[obj[, 'id'] == x & obj[, 'pathId'] == y, c('lat', 'lng')])
      })
      c(list(coords = unname(coords)), thisRow, id = x)
    })

  }else{

    lst_polygon <- lapply(ids, function(x){
      pathIds <- unique(obj[ obj[, 'id'] == x, 'pathId'])
      coords <- sapply(pathIds, function(y){
        list(obj[obj[, 'id'] == x & obj[, 'pathId'] == y, c('lat', 'lng')])
      })
      c(list(coords = unname(coords)), id = x)
    })
  }

  return(lst_polygon)
}

# Object Columns
#
# Defines the columns used by the Maps API so only those required
# are kept
#
# @param obj string specifying the type of object
# @return vector of column names
objectColumns <- function(obj = c("polylinePolyline",
                                  "polylineCoords",
                                  "polygonPolyline",
                                  "polygonCoords")){

  return(
    switch(obj,
           "polylineCoords" = c("id", "lat","lng", "geodesic", "editable","draggable",
                                "stroke_colour",
                                "stroke_weight","stroke_opacity","mouse_over",
                                "mouse_over_group", "info_window", "z_index"),

           "polylinePolyline" = c("id", "polyline", "geodesic","stroke_colour",
                                  "editable","draggable",
                                  "stroke_weight","stroke_opacity","mouse_over",
                                  "mouse_over_group", "info_window", "z_index"),

           "polygonCoords" = c("id","pathId","lat","lng","stroke_colour",
                               "editable","draggable",
                               "stroke_weight","stroke_opacity","fill_colour",
                               "fill_opacity", "info_window","mouse_over",
                               "mouse_over_group", "z_index"))
  )
}

