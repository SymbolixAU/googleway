# library(shinydashboard)
# library(shiny)
# library(magrittr)
# library(leaflet)
# library(googleway)
# library(data.table)
#
#
#
## testing circle bounds
#
# df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
#                              -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
# ), lon = c(144.968612670898, 144.968414306641, 144.968139648438,
#            144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
#                                                                              97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
#                                                                              77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
#                                                                                                                                                        "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
# library(magrittr)
# google_map(key = map_key, data = df) %>%
#   add_markers(lat = "lat", lon = "lon")
#
#
#
# df$weight <- runif(nrow(df)) * 10
# google_map(key = map_key, data = df) %>%
#   add_heatmap(lat = "lat", lon = "lon", weight = "weight")
#
# pl <- "~s|dF}{~rZnNoExBq@|@SfAIjA@~Et@fBBp@Iv@QxCoArNqGfA_@dB]`KgAfVkC|Gu@rAYf@Q|@i@p@m@n@{@^u@`@kAR_ALiADuACiAIeAOy@_@qA{@uB{@sB]gAUmAOaB?oCTkKr@kZZiN?s@Cq@EQDOLILFn@A\\CpI_A|AQjB[BGPOX@LHz@CpAKT?v@KpHu@vD]LGt@Ix@I\\QBGLOVCPJd@Dj@GnFq@`PaBp@KfBQzA[zAq@nAaAx@aA~ByDp@yAXe@VSVO@EVWPCRDJLBF@Hd@TrDj@rK`ADEJGJ@JFBFrSxBJOPCNHHPdBLnCb@bBb@lAf@zA~@lAbApAzAt@nAxA|C~BhHrAxD~AtEb@|@xAtBpBlBzCbB`AZhIhBrFpA|AZl@HRDLENGXORe@DKJSf@wD`@cDt@}INq@ZuEt@mHfBsN~BkS`CmR\\eDnAiKzAcM`CePNmAhAsGXmArAgFtDsM|DaOh@sC^kCf@kDb@uDl@kI\\sHn@yM?gDEoAOsA[}BUiBUsC@qCNuBViBrCcPp@oGHW|@oPBuDI_DKqAy@wD{Ja^}@oFY_CWoDIqBGqEBsENqE`C{^JuA\\aDj@oDn@cDxAcFz@yBtC{Fp@eAn@_An@s@t@}@j@g@bCaBtCsA`GiAzBm@`C}@jBmA~CiC~DcDjCwAfAa@bBe@nBa@pCYlCArDBlCHhCGnC_@~A]vBk@hAa@lF_CnMaGbDeArD}@vB[zEe@jFS`GFfBFxBJzO\\zZfAfCJdEPbDNvDRnEHvD?tEE~BQhC[zAYnCu@bA]dBm@bIkDtBy@bAYhB[rDYxJ[nB@vAHfBLbCf@|C~@vAp@nCdB|A`A`CzApAr@|Al@rBl@bBZbUbCZBzBDvBEtAMnF_AvB[vBOlCAlBFnBXbDr@~Bv@z@`@bBfAdD~BtB`Bv@f@nAn@x@ZZJ~A\\dBTdADtBEbAGnEg@dFi@`DYdDQdF?|DNfCV`BTlCl@dNvD`HnBdLvClAZn@DzB^hCRd@?fA?|@Ih@O`@Ud@a@h@w@\\u@Pm@Lw@HoBq@qK]eLUcIE{DC{AD}Fn@eSLeCJs@RwFRkDf@sCj@aE`AsFhAuGh@gDt@wEp@}En@_FPeBRkDByBCgBEgAS}B{@oEsA}Dy@eCi@yBGq@?s@Ds@V}@Rg@r@u@ZOj@Ml@Az@PrA^fBb@j@HV@f@e@`B}AbB_B]Ie@KeASiO}CmH_B{L}Bk@QTqBTgCAm@g@kCSaAs@V{CdAmDrAuAh@{@Ra@H{@D{Af@wBt@gAb@]ReBl@"
#
# df <- decode_pl(pl)
#
# df$weight <- runif(nrow(df)) * 10
# google_map(key = map_key, data = df) %>%
#   add_heatmap(lat = "lat", lon = "lon", weight = "weight", option_radius = 0.01, option_dissipating = F)


### polygon update
# library(googleway)
# library(magrittr)
#
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# ## polygon with a hole - Bermuda triangle
# pl_outer <- gepaf::encodePolyline(data.frame(lat = c(25.774, 18.466,32.321),
#                                              lng = c(-80.190, -66.118, -64.757)))
#
# pl_inner <- gepaf::encodePolyline(data.frame(lat = c(28.745, 29.570, 27.339),
#                                              lng = c(-70.579, -67.514, -66.668)))
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
# google_map(key = map_key, height = 800, location = c(25.774, -80.190), zoom = 3) %>%
#   add_polygons(data = df, polyline = "polyline") %>%
#   googleway:::update_polygons(data = df_update, id = "id", fill_colour = "fill_colour")
#
# m <- google_map(key = map_key, height = 800, location = c(25.774, -80.190), zoom = 3) %>%
#   add_polygons(data = df, polyline = "polyline")
#
# m <- googleway:::update_polygons(map = m, data = df_update, id = "id", fill_colour = "fill_colour")
#
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
#   df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
#                                -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
#   ), lon = c(144.968612670898, 144.968414306641, 144.868139648438,
#              144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
#                                                                                97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
#                                                                                77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
#                                                                                                                                                          "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
#
#
#
#   df$id <- 1:nrow(df)
#
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#   output$map <- renderGoogle_map({
#
#     google_map(key = map_key, height = 800) %>%
#        add_markers(data = df, lat = "lat", lon = "lon", id = "id")
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



