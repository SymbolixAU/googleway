
# Replace Variable Colours
#
# Replaces the columns in shape object with the colours they have been mapped to
#
# @param shape object to be plotted on map
# @param colours list of colours that will replace the data in shape
replaceVariableColours <- function(shape, colours){

  eachColour <- do.call(cbind, colours)
  colourNames <- colnames(eachColour)

  ## need to strip off attributes so rstudio and browsers can plot the colours
  ## (there is an issue with one or the other not recognisign an array ["#FF00FF"])
  shape[, c(unname(colourNames))] <- as.data.frame(eachColour, stringsAsFactors = F)
  return(shape)

}

# Add Defaults
#
# adds the default object parameters to a shape
#
# @param shape object to be plotted on a map
# @param requiredDefaults required columns of default data
# @param shapeType the type of shape
addDefaults <- function(shape, requiredDefaults, shapeType){

  n <- nrow(shape)
  defaults <- switch(shapeType,
                     "marker" = markerDefaults(n),
                     "circle" = circleDefaults(n),
                     "polygon" = polygonDefaults(n),
                     "polyline" = polylineDefaults(n),
                     "rectangle" = rectangleDefaults(n))

  shape <- cbind(shape, defaults[, requiredDefaults])
  return(shape)
}

lineAttributes <- function(stroke_colour){
  c("stroke_colour" = stroke_colour)
}

shapeAttributes <- function(fill_colour, stroke_colour){
  c("stroke_colour" = stroke_colour,
    "fill_colour" = fill_colour)
}

requiredLineColumns <- function(){
  c("geodesic","stroke_colour","stroke_weight","stroke_opacity","z_index")
}

requiredShapeColumns <- function(){
  c("stroke_colour", "stroke_weight", "stroke_opacity",
    "fill_opacity", "fill_colour", "z_index")
}

requiredCircleColumns <- function(){
  c(requiredShapeColumns(), "radius")
}

requiredMarkerColumns <- function(){
  c("opacity", "colour")
}

## MARKERS ---------------------------------------------------------------------
markerColumns <- function(){
  c('id', 'colour', 'lat', 'lng', 'title', 'draggable', 'opacity', 'label',
    'info_window', 'mouse_over', 'mouse_over_group', 'url')
}

df_markerColours <- function(){
  data.frame(colour = c('red', 'blue', 'green', 'lavender'),
             url = c("http://mt.googleapis.com/vt/icon/name=icons/spotlight/spotlight-poi.png&scale=1",
                     "https://mts.googleapis.com/vt/icon/name=icons/spotlight/spotlight-waypoint-blue.png&psize=16&font=fonts/Roboto-Regular.ttf&color=ff333333&ax=44&ay=48&scale=1",
                     "http://mt.google.com/vt/icon?psize=30&font=fonts/arialuni_t.ttf&color=ff304C13&name=icons/spotlight/spotlight-waypoint-a.png&ax=43&ay=48&text=%E2%80%A2",
                     "http://mt.google.com/vt/icon/name=icons/spotlight/spotlight-ad.png"))
}

markerDefaults <- function(n){
  data.frame("opacity" = rep(1, n),
             "colour" = rep("red", n),
             stringsAsFactors = F)
}

## polyline ---------------------------------------------------------------------
polylineColumns <- function(){
  c('polyline', 'id', 'lat', 'lng', 'stroke_colour', 'stroke_opacity',
    'stroke_weight', 'mouse_over', 'mouse_over_group', 'info_window')
}

polylineDefaults <- function(n){
  data.frame(
    "geodesic" = rep(TRUE, n),
    "stroke_colour" = rep("#0000FF", n),
    "stroke_weight" = rep(2, n),
    "stroke_opacity" = rep(0.6, n),
    "z_index" = rep(3, n)
  )
}

## polygon ---------------------------------------------------------------------
polygonColumns <- function(){
  c('polyline', 'id', 'lat', 'lng', 'pathId', 'draggable','stroke_colour',
    'stroke_opacity', 'stroke_weight', 'fill_colour', 'fill_opacity',
    'mouse_over', 'mouse_over_group', 'info_window')
}

polygonDefaults <- function(n){
  data.frame("stroke_colour" = rep("#0000FF",n),
             "stroke_weight" = rep(1,n),
             "stroke_opacity" = rep(0.6,n),
             "fill_colour" = rep("#FF0000",n),
             "fill_opacity" = rep(0.35,n),
             "z_index" = rep(1,n),
             stringsAsFactors = FALSE)
}


## circle ---------------------------------------------------------------------
circleColumns <- function(){
  c('id', 'lat', 'lng', 'radius', 'draggable', 'stroke_colour',
    'stroke_opacity', 'stroke_weight', 'fill_colour', 'fill_opacity',
    'mouse_over', 'mouse_over_group', 'info_window')
}

circleDefaults <- function(n){
  data.frame("stroke_colour" = rep("#FF0000",n),
             "stroke_weight" = rep(1,n),
             "stroke_opacity" = rep(0.8,n),
             "radius" = rep(50,n),
             "fill_colour" = rep("#FF0000",n),
             "fill_opacity" = rep(0.35,n),
             "z_index" = rep(4,n),
             "radius" = rep(50, n),
             stringsAsFactors = FALSE)
}

## rectangle ---------------------------------------------------------------------
rectangleColumns <- function(){
  c("north", "east", "south", "west", 'id', 'lat', 'lng', "editable",
    'draggable', 'stroke_colour', 'stroke_opacity', 'stroke_weight',
    'fill_colour', 'fill_opacity', 'mouse_over', 'mouse_over_group',
    'info_window')
}

rectangleDefaults <- function(n){
  data.frame("stroke_colour" = rep("#FF0000", n),
             "stroke_weight" = rep(1, n),
             "stroke_opacity" = rep(0.8, n),
             "fill_colour" = rep("#FF0000", n),
             "fill_opacity" = rep(0.35, n),
             "z_index" = rep(2, n),
             stringsAsFactors = FALSE)
}
