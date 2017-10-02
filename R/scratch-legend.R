
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
#





# # I need colour_palettes to create the legend
# which(sapply(colour_palettes, function(x){ names(x$variables) }) == "fill_colour")
#
# legendIdx <- which(names(colourColumns) == 'fill_colour')
# legend <- colour_palettes[[legendIdx]]$palette
# variable <- colour_palettes[[legendIdx]]$variables
#
# # getLegendType <- function(colourColumn) UseMethod("getLegendType")
# # getLegendType.numeric <- function() "gradient"
# # getLegendType.default <- function() "category"
#
# legendType <- googleway:::getLegendType(legend$variable)
#
# jsonlite::toJSON(legend)
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
#
#
## create gradient legend for 1,2,3,+ values
## need the fisrt & last, and equi-spaced rows of the data
# n <- 33
# df <- data.frame(variable = 1:n, colour = viridisLite::viridis(n))
# df <- df[with(df, order(variable)), ]
#
# rows <- 1:n
# rowRange <- range(1:nrow(df))
# rw <- pretty(rows, n = 7)
# rw <- rw[rw >= rowRange[1] & rw <= rowRange[2]]
#
# ## the extremities give the min & max colours
# if(rw[1] != 1) rw <- c(1, rw)
# if(rw[length(rw)] != nrow(df)) rw <- c(rw, nrow(df))
#
# rw
# diff(rw)
#
# df[rw,]
#
#
# rw <- c(seq(1, nrow(df), by = round(nrow(df) / 7)), nrow(df))
#
# diff(rw)
#
#
# #cuts <- pretty(df[2:(n-1), 'variable'])
# cuts <- pretty(1:nrow(df), n = pmin(nrow(df), 7))
# rowRange <- range(1:nrow(df))
# rw <- unique(c(1, cuts[cuts >= rowRange[1] & cuts <= rowRange[2]]))
#
# diff(rw)
#
#
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



# library(shiny)
# ui <- fluidRow(
#   google_mapOutput(outputId = "map"),
#   sliderInput(inputId = "slider", label = "rows", min = 1, max = 20, value = 20)
# )
# server <- function(input, output){
#
#   mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#   df <- tram_stops
#
#   legendOptions <- list(
#     fill_colour = list(
#       position = "LEFT_BOTTOM"
#     ),
#     stroke_colour = list(
#       position = "TOP_RIGHT"
#     )
#   )
#
#   output$map <- renderGoogle_map({
#
#     google_map(key = mapKey) %>%
#       add_circles(data = df, id = "stop_id", lat = "stop_lat", lon = "stop_lon",
#                   stroke_colour = "stop_name", fill_colour = "stop_lat", legend = T,
#                   legend_options = legendOptions) %>%
#       add_polylines(data = tram_route, lat = "shape_pt_lat", lon = "shape_pt_lon")
#   })
#
#   observeEvent(input$slider, {
#
#     df <- tram_stops[1:input$slider, ]
#
#     google_map_update(map_id = "map") %>%
#       update_circles(data = df, id = "stop_id", fill_colour = "stop_lat",
#                      stroke_colour = "stop_name", legend = T)
#
#   })
#
# }
# shinyApp(ui, server)

#
# library(shiny)
#
# ui <- fluidPage(
#   google_mapOutput(outputId = "map"),
#   actionButton(inputId = "btn", label = "button")
# )
# server <- function(input, output){
#
#   mapKey <- symbolix.utils::mapKey()
#
#   output$map <- renderGoogle_map({
#
#     google_map(key = mapKey)
#
#   })
#
#
#   observeEvent(input$btn, {
#
#     if(input$btn %% 2 == 0){
#       google_map_update(map_id = "map") %>%
#         add_circles(data = tram_stops, lat = "stop_lat", lon = "stop_lon",
#                     fill_colour = "stop_name", legend = T)
#     }else{
#       google_map_update(map_id = "map") %>%
#         clear_circles()
#     }
#
#   })
#
# }
# shinyApp(ui, server)


