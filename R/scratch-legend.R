
## TODO:
## - numeric      (n-bins)
## - categorical
##
## the JS functions will only need a JSON object of the variable names and colour mapping

## for the gradient, the numbers need to be sorted


# df <- tram_stops
#
# df$rand <- rnorm(n = nrow(df), 0, 1)
#
# lstPalette <- list(fill_colour = viridisLite::viridis,
#                    stroke_colour = viridisLite::inferno
#                    )
#
# google_map(key = map_key) %>%
#   add_circles(data = df, legend = T, fill_colour = "stop_name")
#
#
#
# allCols <- c("stop_id", "stop_name", "stop_lat", "stop_lon", "stop_lat")
# objArgs <- quote(add_circles(id = "stop_id", stroke_colour = "rand", fill_colour = "stop_name"))
# shape <- googleway:::createMapObject(df, allCols, objArgs)
#
# colourColumns <- c("stroke_colour" = "rand", "fill_colour" = 'stop_name')
#
# ### These three steps are executed in 'setupColours'
# pal <- googleway:::createPalettes(shape, colourColumns)
# colour_palettes <- googleway:::createColourPalettes(df, pal, colourColumns, viridisLite::viridis)
# colours <- googleway:::createColours(shape, colour_palettes)
#
#
# ## generate a legend for each palette (categorical)
# legends <- lapply(colour_palettes, function(x){
#   list(
#     colourType = ifelse('fill_colour' %in% names(x$variables), 'fill_colour', 'stroke_colour'),
#     type = googleway:::getLegendType(x$palette[['variable']]),
#     title = unique(x$variable),
#     legend = x$palette
#   )
# })
#
# legends <-  jsonlite::toJSON(legends, auto_unbox = T)







