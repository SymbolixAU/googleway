#
# ## TODO:
# ## - numeric      (n-bins)
# ## - categorical
# ##
# ## the JS functions will only need a JSON object of the variable names and colour mapping
#
# ## for the gradient, the numbers need to be sorted
#
#
# df <- tram_stops
#
# df$rand <- rnorm(n = nrow(df), 0, 1)
#
# allCols <- c("stop_id", "stop_name", "stop_lat", "stop_lon", "stop_lat")
# objArgs <- quote(add_circles(id = "stop_id", fill_colour = "stop_lat"))
# shape <- googleway:::createMapObject(df, allCols, objArgs)
#
# colourColumns <- c("stroke_colour" = NULL, "fill_colour" = 'stop_lat')
#
# ### These three steps are executed in 'setupColours'
# pal <- googleway:::createPalettes(shape, colourColumns)
# colour_palettes <- googleway:::createColourPalettes(df, pal, colourColumns, viridisLite::viridis)
# colours <- googleway:::createColours(shape, colour_palettes)
#
# # I need colour_palettes to create the legend
# which(sapply(colour_palettes, function(x){ names(x$variables) }) == "fill_colour")
#
# legendIdx <- which(names(colourColumns) == 'fill_colour')
# legend <- colour_palettes[[legendIdx]]$palette
#
# # getLegendType <- function(colourColumn) UseMethod("getLegendType")
# # getLegendType.numeric <- function() "gradient"
# # getLegendType.default <- function() "category"
#
# legendType <- googleway:::getLegendType(legend$variable)
#
# # jsonlite::toJSON(legend)
#
#
# ## given a colour palette, take the 'fill_colour' palettes and create the legend
# ## the colour_palette is returend in the correct order for mapping onto the data
# ## need to take a copy and convert it into a legend
# ##
#
# ## find the palettes that are 'fill_color'
# names(colour_palettes[[1]]$variables)
#
# myPalette <- colour_palettes[[1]]$palette
#
# ## sort by variable
# myPalette <- myPalette[with(myPalette, order(variable)), ]
#
# # cut(x = myPalette$variable, breaks = 7)
#
# # ## the tick legend points
# # base::pretty(myPalette$variable, n = 7)
# # ## this funciton may generate values outside the range of 'variable'
# #
# #
# # ## colours at equally spaced points in the palette
# # ## and need the min & max
# # nrow(myPalette)
# #
# # range(myPalette$variable)
#
# cuts <- base::pretty(myPalette$variable, n = 7)
# n <- length(cuts)
# r <- range(myPalette$variable)
#
# innerCuts <- cuts[cuts >= r[1] & cuts <= r[2]]
# n <- length(innerCuts)
#
# p <- (innerCuts - r[1]) / (r[2] - r[1])
#
# ## translate 'p' into 'row of palette'
# rw <- c(1, round(p[p > 0] * nrow(myPalette)), nrow(myPalette))
# legend <- data.frame("value" = cuts, "colour" = myPalette[rw, c("colour")])
#
# diff(rw)
#
# jsonlite::toJSON(legend)
#
#
#
#
#
# google_map(key = mapKey) %>%
#   add_circles(data = tram_stops[1:10, ], lat = "stop_lat", lon = "stop_lon",
#               fill_colour = "stop_name", stroke_weight = 0,  legend = T)
#
#
# ## categorical legend
# ## just JSONify the colour_palette for 'fill_colour'
#
#


## create gradient legend for 1,2,3,+ values

# n <- 1
# df <- data.frame(variable = 1:n, colour = viridisLite::viridis(n))
#
#
# cuts <- if(nrow(df) < 3) nrow(df) else base::pretty(df$variable, n = 7)
# n <- length(cuts)
# r <- range(df$variable)
#
# innerCuts <- cuts[cuts >= r[1] & cuts <= r[2]]
# n <- length(innerCuts)
#
# p <- (innerCuts - r[1]) / (r[2] - r[1])
#
# ## translate 'p' into 'row of palette'
# rw <- c(1, round(p[p > 0] * nrow(myPalette)), nrow(myPalette))
# legend <- data.frame("value" = cuts, "colour" = myPalette[rw, c("colour")])





