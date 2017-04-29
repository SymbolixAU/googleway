
# library(shinydashboard)
# library(shiny)
# library(magrittr)
# library(leaflet)
# library(googleway)
# library(data.table)
#
#
#
#


# google_map(key = map_key, data = df) %>%
#   add_heatmap(lat = "lat", lon = "lon", weight = "weight", option_radius = 0.01, option_dissipating = F)
#
#
# library(shiny)
#
# ui <- fluidPage(
#   sliderInput(inputId = "weight", label = "weight", min = 0, max = 1, step = 0.01, value = 1),
#   google_mapOutput(outputId = "map")
# )
#
# server <- function(input, output){
#
#   pl <- "~s|dF}{~rZnNoExBq@|@SfAIjA@~Et@fBBp@Iv@QxCoArNqGfA_@dB]`KgAfVkC|Gu@rAYf@Q|@i@p@m@n@{@^u@`@kAR_ALiADuACiAIeAOy@_@qA{@uB{@sB]gAUmAOaB?oCTkKr@kZZiN?s@Cq@EQDOLILFn@A\\CpI_A|AQjB[BGPOX@LHz@CpAKT?v@KpHu@vD]LGt@Ix@I\\QBGLOVCPJd@Dj@GnFq@`PaBp@KfBQzA[zAq@nAaAx@aA~ByDp@yAXe@VSVO@EVWPCRDJLBF@Hd@TrDj@rK`ADEJGJ@JFBFrSxBJOPCNHHPdBLnCb@bBb@lAf@zA~@lAbApAzAt@nAxA|C~BhHrAxD~AtEb@|@xAtBpBlBzCbB`AZhIhBrFpA|AZl@HRDLENGXORe@DKJSf@wD`@cDt@}INq@ZuEt@mHfBsN~BkS`CmR\\eDnAiKzAcM`CePNmAhAsGXmArAgFtDsM|DaOh@sC^kCf@kDb@uDl@kI\\sHn@yM?gDEoAOsA[}BUiBUsC@qCNuBViBrCcPp@oGHW|@oPBuDI_DKqAy@wD{Ja^}@oFY_CWoDIqBGqEBsENqE`C{^JuA\\aDj@oDn@cDxAcFz@yBtC{Fp@eAn@_An@s@t@}@j@g@bCaBtCsA`GiAzBm@`C}@jBmA~CiC~DcDjCwAfAa@bBe@nBa@pCYlCArDBlCHhCGnC_@~A]vBk@hAa@lF_CnMaGbDeArD}@vB[zEe@jFS`GFfBFxBJzO\\zZfAfCJdEPbDNvDRnEHvD?tEE~BQhC[zAYnCu@bA]dBm@bIkDtBy@bAYhB[rDYxJ[nB@vAHfBLbCf@|C~@vAp@nCdB|A`A`CzApAr@|Al@rBl@bBZbUbCZBzBDvBEtAMnF_AvB[vBOlCAlBFnBXbDr@~Bv@z@`@bBfAdD~BtB`Bv@f@nAn@x@ZZJ~A\\dBTdADtBEbAGnEg@dFi@`DYdDQdF?|DNfCV`BTlCl@dNvD`HnBdLvClAZn@DzB^hCRd@?fA?|@Ih@O`@Ud@a@h@w@\\u@Pm@Lw@HoBq@qK]eLUcIE{DC{AD}Fn@eSLeCJs@RwFRkDf@sCj@aE`AsFhAuGh@gDt@wEp@}En@_FPeBRkDByBCgBEgAS}B{@oEsA}Dy@eCi@yBGq@?s@Ds@V}@Rg@r@u@ZOj@Ml@Az@PrA^fBb@j@HV@f@e@`B}AbB_B]Ie@KeASiO}CmH_B{L}Bk@QTqBTgCAm@g@kCSaAs@V{CdAmDrAuAh@{@Ra@H{@D{Af@wBt@gAb@]ReBl@"
#   df <- decode_pl(pl)
#   df$weight <- 1
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
# #  map_key <- 'your_api_key'
#
#   output$map <- renderGoogle_map({
#     google_map(key = map_key) %>%
#       add_heatmap(data = df, weight = "weight")
#   })
#
#   observeEvent(input$weight,{
#
#     print(input$weight)
#     df$weight <- input$weight
#
#     google_map_update(map_id = "map") %>%
#       update_heatmap(data = df, weight = 'weight')
#
#   })
#
# }
#
# shinyApp(ui, server)



### polygon update
# library(googleway)
#
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# ## polygon with a hole - Bermuda triangle
# pl_outer <- encode_pl(lat = c(25.774, 18.466,32.321),lon = c(-80.190, -66.118, -64.757))
# pl_inner <- encode_pl(lat = c(28.745, 29.570, 27.339), lon = c(-70.579, -67.514, -66.668))
#
#
# l <- list(c(pl_outer, pl_inner))
#
# df <- data.frame(polyline = rep(NA, length(l)))
#
# df$polyline <- l
# df$id <- 7
#
#
# df_update <- data.frame(id = 7,
#                         fill_colour = "#FFFFFF")
#
# google_map(key = map_key, height = 800) %>%
#   add_polygons(data = df, polyline = "polyline", id = 'id') %>%
#   googleway::update_polygons(data = df_update, id = "id", fill_colour = "fill_colour")
#
# m <- google_map(key = map_key, height = 800) %>%
#   add_polygons(data = df, polyline = "polyline")
#
# m <- googleway::update_polygons(map = m, data = df_update, id = "id", fill_colour = "fill_colour")
# m

# library(shiny)
# library(googleway)
# library(magrittr)
#
# ui <- fluidPage(google_mapOutput('map'),
#                 actionButton("btn1", label = "remove layer 1"),
#                 actionButton("btn2", label = "remove layer 2")
#                 )
#
# server <- function(input, output){
#
#    pl <- "~s|dF}{~rZnNoExBq@|@SfAIjA@~Et@fBBp@Iv@QxCoArNqGfA_@dB]`KgAfVkC|Gu@rAYf@Q|@i@p@m@n@{@^u@`@kAR_ALiADuACiAIeAOy@_@qA{@uB{@sB]gAUmAOaB?oCTkKr@kZZiN?s@Cq@EQDOLILFn@A\\CpI_A|AQjB[BGPOX@LHz@CpAKT?v@KpHu@vD]LGt@Ix@I\\QBGLOVCPJd@Dj@GnFq@`PaBp@KfBQzA[zAq@nAaAx@aA~ByDp@yAXe@VSVO@EVWPCRDJLBF@Hd@TrDj@rK`ADEJGJ@JFBFrSxBJOPCNHHPdBLnCb@bBb@lAf@zA~@lAbApAzAt@nAxA|C~BhHrAxD~AtEb@|@xAtBpBlBzCbB`AZhIhBrFpA|AZl@HRDLENGXORe@DKJSf@wD`@cDt@}INq@ZuEt@mHfBsN~BkS`CmR\\eDnAiKzAcM`CePNmAhAsGXmArAgFtDsM|DaOh@sC^kCf@kDb@uDl@kI\\sHn@yM?gDEoAOsA[}BUiBUsC@qCNuBViBrCcPp@oGHW|@oPBuDI_DKqAy@wD{Ja^}@oFY_CWoDIqBGqEBsENqE`C{^JuA\\aDj@oDn@cDxAcFz@yBtC{Fp@eAn@_An@s@t@}@j@g@bCaBtCsA`GiAzBm@`C}@jBmA~CiC~DcDjCwAfAa@bBe@nBa@pCYlCArDBlCHhCGnC_@~A]vBk@hAa@lF_CnMaGbDeArD}@vB[zEe@jFS`GFfBFxBJzO\\zZfAfCJdEPbDNvDRnEHvD?tEE~BQhC[zAYnCu@bA]dBm@bIkDtBy@bAYhB[rDYxJ[nB@vAHfBLbCf@|C~@vAp@nCdB|A`A`CzApAr@|Al@rBl@bBZbUbCZBzBDvBEtAMnF_AvB[vBOlCAlBFnBXbDr@~Bv@z@`@bBfAdD~BtB`Bv@f@nAn@x@ZZJ~A\\dBTdADtBEbAGnEg@dFi@`DYdDQdF?|DNfCV`BTlCl@dNvD`HnBdLvClAZn@DzB^hCRd@?fA?|@Ih@O`@Ud@a@h@w@\\u@Pm@Lw@HoBq@qK]eLUcIE{DC{AD}Fn@eSLeCJs@RwFRkDf@sCj@aE`AsFhAuGh@gDt@wEp@}En@_FPeBRkDByBCgBEgAS}B{@oEsA}Dy@eCi@yBGq@?s@Ds@V}@Rg@r@u@ZOj@Ml@Az@PrA^fBb@j@HV@f@e@`B}AbB_B]Ie@KeASiO}CmH_B{L}Bk@QTqBTgCAm@g@kCSaAs@V{CdAmDrAuAh@{@Ra@H{@D{Af@wBt@gAb@]ReBl@"
#    pl2 <- "vibfFix{sZzAaUz@sLhAgP\\}Ex@oMfBmYdAqPpBw[fCga@pByZz@kNhA_QnBo[dAqPtBk]FsAEk@EQIOfFyFsAyBhJwJnB_Ct@u@`AkA|@qAj@kAj@}AXkAXaBT}BL}CZ}EZ_CRcACo@Ck@Qq@?eAJiAdAwPjBqZvBs]pBu\\dAyPd@cJCWEMGWRQ`A}@r@}@tAcCp@mBd@{BV_CHaC?wAa@yIEg@_@gCaA}GuBqNuAyI_@}Bc@}Ci@uCaB}KGqAAoA@o@F{@Ba@VyA\\oA\\_Ab@{@rAiBhFyGLg@b@s@xAgCTk@dCLrBRpANVDLEb@IZMt@k@d@]N[hAmCz@cChAoEd@_Cn@yDn@uF^sDHeATi@z@uJnBqVhBcUb@gFr@yFn@{Dp@yCnAaFjAeDdAmCzBuEdEuIl@qAjBqFfBeId@gCl@iFZsEh@_Kh@wJpAqVvA}ZhBc]r@gLPkBb@uCbAeFhAkDt@kB`A}BdAkBpAsBfA}A~AgBpCgCpJ}H?KN[tBmBzCuClCoCp@eAVi@Zy@`@oBXgCVyBFSb@yHf@mIXgFLuBBo@CYCOAOIYGKEEcBUyEq@iEq@kIcAkNgB{c@{DwGg@qBW_RmBiAOB_@fAL"
#    pl3 <- "pizeF_{~sZjLhAdAJLwBJkBv@wN~Bgd@x@sNjAeUR_FTkEAqBGiAQuAw@{E_C}NGwA?sANaELkDDu@LgAfAiF?g@EI?EIo@EMMKe@UQGaAM}IaA_Fg@_JaAsEc@_[iDiI_AeT}BgI{@mBSJ{AHwANgCn@}JdAaPiZgD"
#
#    df <- data.frame(polyline = c(pl, pl2, pl3),
#                     id = c(1,2,7),
#                     fill_colour = c("#FF00FF","#FFFF00","#00FFFF"))
#
#
#     # # df <- data.frame(polyline = pl2)
#     #
#     # df_update <- data.frame(id = c(1,1,2),
#     #                       fill_colour = c("#FFFFFF", "#000000", "#0000FF"),
#     #                       fill_opacity = c(0.3, 0.6, 0.9),
#     #                       polyline = c(pl3, pl, pl2))
#     #
#     # df1 <- decode_pl(pl)
#     # df1$id <- sample(c(1,2,3,4), size = nrow(df1), replace = T)
#     # df2 <- decode_pl(pl2)
#     # df2$info <- sample(letters, size = nrow(df2), replace = T)
#
#     map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#     output$map <- renderGoogle_map({
#       google_map(key = map_key, height = 800) %>%
#        add_polygons(data = df, polyline = "polyline", info_window = "id")
#
#     #  df0 <- data.frame(lat = 0, lng = 0)
#     #
#     # google_map(key = map_key, height = 800) %>%
#     #   add_polygons(data = df, polyline = "polyline", layer_id = "df", info_window = "id", mouse_over = "id") %>%
#     #   add_polygons(data = df_update, polyline = "polyline", layer_id = "df_update", mouse_over_group = "id")
#     #       add_circles(data = df1,  layer_id = "markers1", mouse_over_group = "id") %>%
#     #     #   add_markers(data = df2, layer_id = "markers2", info_window = "info", mouse_over = "info")
#     #     #  # add_markers(data = df0, layer_id = "markers3") %>%
#     #     #  add_polylines(data = df, polyline = "polyline", layer_id = "polyline1", update_map_view = T) %>%
#     #     #  # add_markers(data = data.frame(lat = 20, lng = 20), layer_id = "markers4")
#     #     #  add_polylines(data = df_update, polyline = "polyline", layer_id = "df_update", update_map_view = F)
#     #     # # add_heatmap(df1, layer_id = "df1") %>%
#     #     # # add_heatmap(df2, layer_id = "df2")
#     #     # # add_heatmap(df1, layer_id = "df3")
#
#     })
#
#     # observeEvent({
#     #   input$btn1
#     # },{
#     #     print("layer1")
#     #     google_map_update("map") %>%
#     #     googleway::clear_polyline(layer_id = "df")
#     #
#     #   if(input$btn %% 2 == 0){
#     #     google_map_update("map") %>%
#     #       googleway:::update_polygons(data = df_update, id = "id",
#     #                                   fill_colour = "fill_colour",
#     #                                   fill_opacity = "fill_opacity",
#     #                                   polyline = "polyline")
#     #   }else{
#     #     google_map_update("map") %>%
#     #       googleway:::update_polygons(data = df, id = "id",
#     #                                   fill_colour = "fill_colour",
#     #                                   fill_opacity = "fill_opacity",
#     #                                   polyline = "polyline")
#     #   }
#     # })
#     #
#     #
#     # observeEvent({
#     #   input$btn2
#     # },{
#     #   print("layer2")
#     #   google_map_update("map") %>%
#     #     googleway::clear_polyline(layer_id = "df_update")
#     # })
#
#   }
# shinyApp(ui , server)


# Click info
# library(shiny)
# library(googleway)
# library(magrittr)
#
# ui <- fluidPage(google_mapOutput('map')
#                 #actionButton("btn1", label = "remove layer 1"),
#               #  actionButton("btn2", label = "remove layer 2")
#                 )
#
# server <- function(input, output){
#
  # df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
  #                              -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
  # ), lon = c(144.968612670898, 144.968414306641, 144.868139648438,
  #            144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
  #                                                                              97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
  #                                                                              77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
  #                                                                                                                                                        "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
  #
  #
  #
  # df$id <- 1:nrow(df)
  #
  # map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
  #
  # output$map <- renderGoogle_map({
  #
  #   google_map(key = map_key, height = 800) %>% add_markers(data = df, lat = "lat", lon = "lon", id = "id", symbol = "symbol")
#
#   })
#
#   # observeEvent(input$map_marker_click, {
#   #   print("marker clicked")
#   #   print(str(input$map_marker_click))
#   # })
#   #
#   observeEvent(input$map_map_click, {
#     print("map clicked")
#     print(str(input$map_map_click))
#   })
#
#   # observeEvent(input$map_bounds_changed, {
#   #   print("bounds changed")
#   #   print(str(input$map_bounds_changed))
#   # })
# }
# shinyApp(ui , server)


# devtools::install_github("SymbolixAU/googleway")
# library(shiny)
# library(googleway)
#
# ui <- fluidPage(
#   google_mapOutput("myMap")
# )
#
# server <- function(input, output){
#
#   #map_key <- "your_api_key"
#
#   output$myMap <- renderGoogle_map({
#     google_map(key = "")
#   })
#
#   observeEvent(input$myMap_map_click, {
#     print(str(input$myMap_map_click))
#   })
#
# }
#
# shinyApp(ui, server)


# library(shiny)
# library(googleway)
#
# ui <- fluidPage(
#   # tags$img(outputId = "myPlot")
#   uiOutput(outputId = "myStreetview")
# )
#
# server <- function(input, output){
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#   output$myStreetview <- renderUI({
#     tags$img(src = google_streetview(location = c(-37.817714, 144.96726),
#                                      size = c(400,400), output = "html",
#                                      key = map_key),  width = "400px", height = "400px")
#   })
# }
#
# shinyApp(ui, server)
#
#
# google_streetview(location = c(-37.8, 144.967),
#                   size = c(400,400),
#                   panorama_id = NULL,
#                   output = "plot",
#                   heading = 90,
#                   fov = 90,
#                   pitch = 0,
#                   response_check = FALSE,
#                   key = key)
#
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# google_map(key = map_key) %>%
#   add_kml('http://googlemaps.github.io/js-v2-samples/ggeoxml/cta.kml')


# library(shiny)
# library(magrittr)
# library(googleway)
#
# ui <- fluidPage(
#   google_mapOutput("myMap")
# )
#
# server <- function(input, output){
#
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#   output$myMap <- renderGoogle_map({
#     google_map(key = map_key) %>%
#       add_kml('http://googlemaps.github.io/js-v2-samples/ggeoxml/cta.kml', layer_id = "kml_layer")
#   })
#
#   observeEvent(input$myMap_map_click, {
#     print(str(input$myMap_map_click))
#
#     google_map_update(map_id = "myMap") %>%
#       clear_kml(layer_id = "kml_layer")
#   })
#
# }
#
# shinyApp(ui, server)




# df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
#  -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
#  ), lon = c(144.968612670898, 144.968414306641, 144.968139648438,
#  144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
#  97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
#  77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
#  "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
#
# library(magrittr)

# google_map(key = map_key, data = df) %>%
#   add_heatmap(lat = "lat", lon = "lon", weight = "weight")


### clearing search box
# library(shiny)
# library(magrittr)
# library(googleway)
#
# ui <- fluidPage(
#   google_mapOutput("myMap")
#   #actionButton("clear", "clear search")
# )
#
# server <- function(input, output){
#
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#   output$myMap <- renderGoogle_map({
#     google_map(key = map_key, search_box = T) %>%
#       add_markers(data = df)
#   })
#
#   # observeEvent(input$clear, {
#   #
#   #   google_map_update(map_id = "myMap") %>%
#   #     clear_search()
#   #
#   # })
#
# }
#
# shinyApp(ui, server)
#
#





### Spatial polylines using simple features!
# library(sf)
# library(data.table)
# library(spatial.data.table)
# # library(rgdal)
# #
# # shp <- readOGR(dsn = "../../SVNStuff/Clients/HT0_HydroTasmania/MRBU_MRWF_BUS_surveys/Data/Received_BUSData/GIS",
# #                layer = "Roads_line")
# #
# # sf <- sf::read_sf("~/Documents/SVNStuff/Clients/HT0_HydroTasmania/MRBU_MRWF_BUS_surveys/Data/Received_BUSData/GIS/Roads_line.shp")
# #
# # map_key <- symbolix.utils::mapKey()
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# google_map(key = map_key) %>%
#   add_polylines(data = shp)
#
#
# filename <- system.file("gpkg/nc.gpkg", package="sf")
# nc <- st_read(filename, "nc.gpkg", crs = 4267)
#
#
# dt_nc <- spToDT(nc)
#
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# google_map(key = map_key) %>%
#   add_polylines(data = dt_nc[id == 4], lat = "lat", lon = "lon", id = "lineId")
#
# dt_nc <- dt_nc[, .(polyline = encode_pl(lat, lon)), by = setdiff(names(dt_nc), c("lat", "lon"))]
#
# google_map(key = map_key) %>%
#   add_polygons(data = dt_nc, polyline = "polyline")
#
#
# dt_line <- dt_nc[id == 4]
#
# google_map(key = map_key) %>%
#   add_polylines(data = dt_line, lat = "lat", lon = "lon")
#
# dt_poly <- dt_nc[id == 4, .(polyline = encode_pl(lat, lon)), by = lineId]
#
# google_map(key = map_key) %>%
#   add_polylines(data = dt_poly, polyline = "polyline")
#
#
# df_nc <- nc[3:4, ]
#
# class(df_nc)
#
# geomCol <- which(unlist(lapply(df_nc, function(x) "sfc" %in% class(x))))
#
# class(df_nc[, geomCol][[1]])
#
# # unlist(df_nc[, geomCol][[1]])
#
# geom <- df_nc[, geomCol][[1]]
#
# lst <- lapply(geom, function(x){
#
#
#   lapply(1:length(x), function(y){
#
#     data.frame(
#       lineId = y,
#       # polyline = encode_pl(x[[y]][[1]][,2], x[[y]][[1]][,1]),
#       lat = x[[y]][[1]][,2],
#       lon = x[[y]][[1]][,1],
#       hole = (y > 1)[c(T, F)]
#     )
#   })
#
# })
#




### Coordinate polylines
# library(googleway)
#
# df <- tram_route
# df$id <- c(rep(1, 27), rep(2, 28))
#
# df$stroke_weight <- c(rep(3, 27), rep(6, 28))
# df$lat <- df$shape_pt_lat
# df$lng <- df$shape_pt_lon
#
#
# map_key <- symbolix.utils::mapKey()
#
#
# google_map(key = map_key) %>%
#   add_polylines(data = df, lat = 'shape_pt_lat', lon = 'shape_pt_lon',
#                 stroke_weight = "stroke_weight", id = 'id')


## polyline/gon coordinates, where the JSON is not formed using arrays
# obj <- data.frame(id = c(1,1,1,2,2),
#                   stroke_weight = c(3,3,3,6,6),
#                   lat = c(1,1,1, 2,2),
#                   lng = c(1,1,1, 2,2))
#
# lst <- googleway:::objPolylineCoords(obj, unique(obj$id), c('stroke_weight'))
#
# jsonlite::toJSON(lst, auto_unbox = T)
#
#
# library(jsonlite)
#
# df <- data.frame(id = c(1,2,3))
# toJSON(df)
#
# id <- c(1,2,3)
# toJSON(id)
#
# id <- list(1, 2, 3)
# toJSON(id)
#
# id <- c(id = 1, id = 2, id = 3)
# toJSON(id)
#
# id <- list(id = 1, id = 2, id = 3)






# library(googleway)
# library(jsonlite)
#
# pl_outer <- encode_pl(lat = c(25.774, 18.466,32.321),
#      lon = c(-80.190, -66.118, -64.757))
#
# pl_inner <- encode_pl(lat = c(28.745, 29.570, 27.339),
#       lon = c(-70.579, -67.514, -66.668))
#
# pl_other <- encode_pl(c(21,23,22), c(-50, -49, -51))
#
# df <- data.frame(id = c('1', '1', '2'),
#                  colour = c("#00FF00", "#00FF00", "#FFFF00"),
#                  polyline = c(pl_outer, pl_inner, pl_other),
#                  stringsAsFactors = FALSE)
#
# google_map(key = map_key) %>%
#   add_polygons(data = df, polyline = 'polyline', id = 'id', fill_colour = 'colour')
#
# df_update <- df[, c("id", "colour")]
# df_update$colour <- c("#FFFFFF", "#FFFFFF", "000000")
#
# google_map(key = map_key) %>%
#   add_polygons(data = df, polyline = 'polyline', id = 'id', fill_colour = 'colour') %>%
#   update_polygons(data = df_update, id = 'id', fill_colour = 'colour')

#
# df <- data.frame(id = c(1,1,1,1,1,1,2,2,2),
#       pathId = c(1,1,1,2,2,2,1,1,1),
#       lat = c(26.774, 18.466, 32.321, 28.745, 29.570, 27.339, 22, 23, 22),
#       lng = c(-80.190, -66.118, -64.757, -70.579, -67.514, -66.668, -50, -49, -51),
#       fill_colour = c("#00FF00"),
#       stringsAsFactors = FALSE)
#
# polygon <- df
#



## Z_index
# google_map(key = map_key) %>%
#   add_circles(data = tram_stops, lat = "stop_lat", lon = "stop_lon",
#               fill_colour = "#00FFFF", fill_opacity = 1, z_index = 3) %>%
#   add_polygons(data = tram_route, lat = 'shape_pt_lat', lon = 'shape_pt_lon',
#                fill_opacity = 1, z_index = 2) %>%
#   add_polylines(data = tram_route, lat = "shape_pt_lat", lon = "shape_pt_lon",
#                 stroke_opacity = 1, stroke_colour = "#FFFFFF", stroke_weight = 10,
#                 z_index = 2)



## TEST: map_click numeric values
# library(shiny)
# library(googleway)
#
# ui <- fluidPage(
#   verbatimTextOutput("results"),
#   google_mapOutput("myMap")
# )
#
# server <- function(input, output){
#
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#   pl_outer <- encode_pl(lat = c(25.774, 18.466,32.321),
#                         lon = c(-80.190, -66.118, -64.757))
#
#   pl_inner <- encode_pl(lat = c(28.745, 29.570, 27.339),
#                         lon = c(-70.579, -67.514, -66.668))
#
#   df <- data.frame(id = c(1, 1),
#                    polyline = c(pl_outer, pl_inner),
#                    stringsAsFactors = FALSE)
#
#   # df <- aggregate(polyline ~ id, data = df, list)
#
#   output$myMap <- renderGoogle_map({
#     google_map(key = map_key) %>%
#       add_polygons(data = df, polyline = 'polyline')
# #      add_polylines(data = df, polyline = 'polyline')
#   })
#
#   observeEvent(input$myMap_polygon_click, {
#     print(str(input$myMap_polygon_click))
#   })
#
#   observeEvent(input$myMap_polyline_click, {
#     print(str(input$myMap_polyline_click))
#   })
#
#
#   observeEvent(input$myMap_map_click, {
#     print(input$myData)
#     print(str(input$myMap_map_click))
#   })
#
#   output$results = renderPrint({
#     input$myMapData
#   })
#
# }
#
# shinyApp(ui, server)


# ui2 <- shinyUI( bootstrapPage(
#
#   # a div named mydiv
#   tags$div(id="mydiv", style="width: 50px; height :50px;
#            left: 100px; top: 100px;
#            background-color: gray; position: absolute"),
#
#   # a shiny element to display unformatted text
#   verbatimTextOutput("results"),
#
#   # javascript code to send data to shiny server
#   tags$script('
#               document.getElementById("mydiv").onclick = function() {
#                   let myInfo = {
#                       randomNumber: Math.random(),
#                       anotherNumber: 23.3355345,
#                   }
#                   // var number = Math.random();
#                   Shiny.onInputChange("mydata", myInfo);
#               };
#               ')
#
#   ))
#
# server2 <- shinyServer(function(input, output, session) {
#
#   output$results = renderPrint({
#     input$mydata
#   })
#
# })
#
# shinyApp(ui = ui2, server = server2)


# library(shiny)
#
# ui <- fluidPage(
#   sliderInput(inputId = "weight", label = "weight", min = 0, max = 1,
#               step = 0.01, value = 1),
#   google_mapOutput(outputId = "map")
# )
#
# server <- function(input, output){
#
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#   set.seed(20170417)
#   df <- tram_route
#   df$weight <- abs(rnorm(nrow(df), mean = 0, sd = 1))
#
#   output$map <- renderGoogle_map({
#     google_map(key = map_key) %>%
#       add_heatmap(data = df, lat = "shape_pt_lat", lon = "shape_pt_lon",
#                   weight = "weight", option_radius = 0.001)
#   })
#
#   observeEvent(input$weight,{
#
#     df$weight <- df$weight * input$weight
#
#     google_map_update(map_id = "map") %>%
#        update_heatmap(data = df, lat = "shape_pt_lat", lon = "shape_pt_lon",
#                       weight = "weight")
#   })
# }
#
# shinyApp(ui, server)


## Polygon
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# google_map(key = map_key) %>%
#   add_polygons(data = melbourne, polyline = "polyline", info_window = "SA2_NAME")
#
# google_map(key = map_key) %>%
#   add_polygons(data = melbourne, polyline = "polyline", info_window = "SA2_NAME",
#                mouse_over_group = "SA3_NAME")


## Shiny update polygons


# library(shiny)
#
#
# ui <- fluidPage(
#   sliderInput(inputId = "opacity", label = "opacity", min = 0, max = 1,
#               step = 0.01, value = 1),
#   google_mapOutput(outputId = "map")
# )
#
# server <- function(input, output){
#
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#   output$map <- renderGoogle_map({
#
#     google_map(key = map_key) %>%
#       add_polygons(data = melbourne, id = "polygonId", pathId = "pathId",
#                    polyline = "polyline", fill_opacity = 1)
#   })
#
#   observeEvent(input$opacity, {
#
#     melbourne$opacity <- input$opacity
#
#     google_map_update(map_id = "map") %>%
#       update_polygons(data = melbourne, fill_opacity = "opacity", id = "polygonId")
#   })
#
# }
#
# shinyApp(ui, server)



## update heatmap
# ui <- fluidPage(
#   sliderInput(inputId = "sample", label = "sample", min = 1, max = 10,
#               step = 1, value = 10),
#   google_mapOutput(outputId = "map")
# )
#
# server <- function(input, output){
#
#   #map_key <- 'your_api_key'
#
#   set.seed(20170417)
#   df <- tram_route[sample(1:nrow(tram_route), size = 10 * 100, replace = T), ]
#
#   output$map <- renderGoogle_map({
#     google_map(key = map_key) %>%
#       add_heatmap(data = df, lat = "shape_pt_lat", lon = "shape_pt_lon",
#                   option_radius = 0.001)
#   })
#
#   observeEvent(input$sample,{
#
#     df <- tram_route[sample(1:nrow(tram_route), size = input$sample * 100, replace = T), ]
#
#     google_map_update(map_id = "map") %>%
#       update_heatmap(data = df, lat = "shape_pt_lat", lon = "shape_pt_lon")
#   })
# }
#
# shinyApp(ui, server)





