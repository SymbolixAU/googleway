## TODO:
## re-define how the data is used inside each map layer function,
## so that colours can be merged on.
## i.e., don't rely on keeping the order of the data in the SetDefault function


generatePalette <- function(colData, colName, googleAttr, ...) UseMethod("generatePalette")

#' @export
generatePalette.factor <- function(colData, colName, googleAttr){

  facLvls <- levels(colData)
  palFunc <- viridisLite::viridis
  colours <- do.call(palFunc, list(nlevels(colData)))

  constructPalette(facLvls, colours, colName, googleAttr)
}

#' @export
generatePalette.character <- function(colData, colName, googleAttr ){

  charLvls <- unique(colData)
  palFunc <- viridisLite::magma
  colours <- do.call(palFunc, list(length(charLvls)))

  constructPalette(charLvls, colours, colName, googleAttr)
}

#' @export
generatePalette.default <- function(col) stop("I can't determine the colour for ", class(col), " columns.")


constructPalette <- function( lvls, colours, colName, googleAttr ){
  setNames(
    data.frame(colName = lvls, colour = colours, stringsAsFactors = F),
    c(colName, googleAttr)
  )
}




#
# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# df <- tram_stops
#
# df$group <- factor(sample(letters[1:5], size = nrow(df), replace = T))
#
#
# google_map(key = mapKey) %>%
#   add_circles(data = df, lat = "stop_lat", lon = "stop_lon",
#               fill_colour = "group", stroke_weight = 0, fill_opacity = 0.8)
#
# google_map(key = mapKey) %>%
#   add_circles(data = df, lat = "stop_lat", lon = "stop_lon",
#               fill_colour = "stop_name", stroke_weight = 0, fill_opacity = 0.8)
