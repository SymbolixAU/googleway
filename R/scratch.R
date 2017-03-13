
## elevation URL length
# pl1 <- "q{|aHknlv@n@Mt@IxAGb@B\\Eb@AZGRG^W`AyAPQF?NHDJFZBz@FVNPn@D`@C|@DjACv@@h@Dh@Ll@Zj@^\\`@fAx@j@r@d@n@\\ZJPNd@NbANzAFhANb@JNLHD?PKHMRGPSr@UPMXGDGJELMFCPAbBWROpAm@h@YZe@dAaC@Of@aAb@a@t@iALg@LWNQROf@IjAJnFbAv@Dr@Aj@BpBx@fFdCd@HlAHd@Pp@b@|@d@~@j@n@R~@n@\\NTCXBNEZCZKbB]rAKpDK~BO\\?NCd@?`DMz@SLO`@URCR@XLRRRVHd@NXNP\\RXf@JHXN\\Xn@ZD@Z?\\NvArA~BxA"
# pl2 <- "uipaHmmcv@iBoFm@{AKQy@}B}AoDyA_CASEMGKKI]y@i@y@EOi@q@kAw@KEMAu@M]?[@WDkAZiB~@]H_@PUF]TUL_@XkAn@}CzAyAx@e@P_@JSNGROPa@Fu@[UOc@IOAu@_@WIUMIIWGu@]YEk@SoBiAc@_@gAeAg@{@]mAMq@YmBA]Oq@YuBKYUg@UQa@QiAOI@QIm@EiA[w@BSFYZ_@h@]t@o@bAOb@}@zAWn@_@jAGf@SbAKbAKXSpAS`@ICa@FSHICQ@gAHq@KSAa@I[CQ@k@KOGMKYg@aBkEs@u@k@g@_@a@{@o@W]IAYQYAsDIODc@LW\\GRKn@Ch@WtAO`BCzAIj@Wh@SRc@NS@a@KaAg@kCgAm@]iBo@w@_@UQc@S}@Ww@e@MCa@Sm@Sk@WYI{@g@IIMAMIIIm@QuBaAIGu@_@SQiAqA_AmASSYIUEqAKQBm@Im@Qe@i@k@UQBSCe@NO?[FKFYBSH_ADa@GQIw@OOSKF[b@M@gAl@i@b@{@b@OLwAj@KLWRI@yBvAuAd@m@F_@@qAEk@Kc@Oi@_@_@e@oAeBc@u@SSi@]i@We@Im@Q}@k@w@_@i@a@w@a@SQ[Qy@OeCSUGg@WSOa@e@W]MK_@i@CMMWIEMWa@m@[QEIICK@QHUTe@n@ELKFa@l@u@t@WNYLYXO?IBGHc@Tc@Ja@@{@Q{@]s@a@kBq@YOcAYs@IU?_@NU@GAu@^a@LSPg@X]^YJc@h@]PKHI@w@n@]h@AXEJMTCZc@|AS`@OVg@j@_Av@{@bA"
# apiKey <- symbolix.utils::apiKey()
#
# google_elevation(polyline = pl1, key = apiKey)

# google_elevation(decode_pl(pl2), key=apiKey)

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


### Coordinate polylines

# library(googleway)
# df <- structure(list(airline = c("BB", "US", "TK", "QF", "LH", "LH",
# "AB", "9N"), airlineID = c(399, 473, 450, 379, 313, 313, 199,
# 178), sourceAirport = c("VIJ", "CLT", "LED", "LAX", "FRA", "FRA",
# "KGS", "SPR"), sourceAirportID = c(2463, 1647, 1100, 1434, 1387,
# 1387, 248, 1908), destinationAirport = c("SJU", "PBI", "IST",
# "NAN", "AGP", "LCY", "MUC", "CZH"), destinationAirportID = c(1053,
# 1568, 383, 537, 159, 2019, 1424, 2879), codeshare = c("", "",
# "", "Y", "", "Y", "", ""), stops = c(0L, 0L, 0L, 0L, 0L, 0L,
# 0L, 0L), equipment = c("DHT", "320 319 734", "321 738", "332",
# "321 320", "E90", "738", "CNC"), latSource = c(-31.9451999664,
# 46.1766014099121, 10.0354995728, 49.310001, 49.0966667, 49.0966667,
# 5.60518980026245, 20.0853004455566), lonSource = c(-65.1463012695,
# 21.261999130249, -10.7698001862, 4.05, 2.0408333, 2.0408333,
# -0.166786000132561, -75.1583023071289), latDest = c(18.4393997192,
# 26.6832008361816, 40.9768981934, -17.7553997039795, 36.6749000549316,
# 51.505299, 48.353801727295, NA), lonDest = c(-66.0018005371,
# -80.0955963134766, 28.8145999908, 177.442993164062, -4.49911022186279,
# 0.055278, 11.786100387573, NA)), .Names = c("airline", "airlineID",
# "sourceAirport", "sourceAirportID", "destinationAirport", "destinationAirportID",
# "codeshare", "stops", "equipment", "latSource", "lonSource",
# "latDest", "lonDest"), row.names = c(14971L, 58839L, 52704L,
# 46967L, 38214L, 38303L, 7371L, 3775L), class = "data.frame")
#
# df <- df[!is.na(df$latDest), ]
#
# df$id <- 1:nrow(df)
#
# df_orig <- df[, c("id", "latSource","lonSource")]
# df_dest <- df[, c("id","latDest","lonDest")]
#
# df_orig <- setNames(df_orig, c("id","lat","lon"))
# df_dest <- setNames(df_dest, c("id", "lat", "lon"))
#
# df <- rbind(df_orig, df_dest)
#
# lst <- lapply(unique(df$id), function(x){
#   data.frame(id = x, polyline = gepaf::encodePolyline(df[df['id'] == x, c("lat", "lon")]))
# })
#
# df <- do.call(rbind, lst)
#
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# style <- '[{"featureType":"all","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"all","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"all","elementType":"labels.text.fill","stylers":[{"saturation":36},{"color":"#000000"},{"lightness":40}]},{"featureType":"all","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":"#000000"},{"lightness":16}]},{"featureType":"all","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"administrative","elementType":"geometry.fill","stylers":[{"color":"#000000"}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#000000"},{"lightness":17},{"weight":1.2}]},{"featureType":"administrative","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"administrative","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"administrative.country","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"administrative.country","elementType":"geometry","stylers":[{"visibility":"simplified"}]},{"featureType":"administrative.country","elementType":"labels.text","stylers":[{"visibility":"simplified"}]},{"featureType":"administrative.province","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"all","stylers":[{"visibility":"simplified"},{"saturation":"-100"},{"lightness":"30"}]},{"featureType":"administrative.neighborhood","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"administrative.land_parcel","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"landscape","elementType":"all","stylers":[{"visibility":"simplified"},{"gamma":"0.00"},{"lightness":"74"}]},{"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":20}]},{"featureType":"landscape","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"landscape","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"landscape.man_made","elementType":"all","stylers":[{"lightness":"3"}]},{"featureType":"poi","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":21}]},{"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"geometry","stylers":[{"visibility":"simplified"},{"color":"#424242"},{"lightness":"-61"}]},{"featureType":"road","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#000000"},{"lightness":17}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#000000"},{"lightness":29},{"weight":0.2}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":18}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":16}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2a2727"},{"lightness":"-61"},{"saturation":"-100"}]},{"featureType":"transit","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":17}]},{"featureType":"water","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"labels.text","stylers":[{"visibility":"off"}]}]'
#
# google_map(key = map_key, style = style) %>%
#   add_polylines(data = df, polyline = "polyline", stroke_weight = , stroke_opacity = 0.3, stroke_colour = "#ccffff")
#
#

#
#
# jsonlite::toJSON(df, pretty = T)
# jsonlite::toJSON(aggregate(lat + lon ~ id, data = df, list), pretty = T)
#
# ids <- unique(df$id)
#
# jsonlite::toJSON(df[df$id == ids[1], ], pretty = T)
#
# df_melt <- melt(df, id.vars = "id")
#
# jsonlite::toJSON(df_melt[df_melt$id == ids[1], ], pretty = T)
#
# aggregate(value ~ id,  data = aggregate(value ~ id + variable, df_melt, list), list)
#
# js <- '{"id" : 1, "coords" : [ {"lat": -31.9520, "lng": -65.141}, {"lat": 46.17, "lng": 21.261}   ] }'
#
# lst <- jsonlite::fromJSON(js)
#
# jsonlite::toJSON(lst)
#
# lst <- lapply(unique(df[, 'id']), function(x) {
#   list(id = x,
#   coords = data.frame(lat = df[df['id'] == x, 'lat'], lon = df[df['id'] == x, 'lon']))
#
#   })
#
#
# jsonlite::toJSON(lst, pretty = T)
#
# #
# google_map(key = map_key, data = df, style = googleway:::map_styles()$dark) %>%
#   add_polylines(id = "id", lat = "lat",
#                 lon = "lon", stroke_opacity = 0.6,
#                 stroke_colour = "#ccffff",
#                 stroke_weight = 2,
#                 geodesic = TRUE)
#
#
#
#
# air <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2011_february_us_airport_traffic.csv')
# # flights between airports
# flights <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv')
# flights$id <- seq_len(nrow(flights))
#
# lst <- lapply(unique(flights$id), function(x){
#   lat = c(flights[flights["id"] == x, c("start_lat")], flights[flights["id"] == x, c("end_lat")])
#   lon = c(flights[flights["id"] == x, c("start_lon")], flights[flights["id"] == x, c("end_lon")])
#   data.frame(id = x, polyline = gepaf::encodePolyline(data.frame(lat = lat, lon = lon)))
# })
#
# flights <- merge(flights, do.call(rbind, lst), by = "id")
#


# google_map(key = map_key, style = style) %>%
#   add_polylines(data = flights, polyline = "polyline", mouse_over_group = "airport1",
#                 stroke_weight = 1, stroke_opacity = 0.3, stroke_colour = "#ccffff")
#



# map_key <- symbolix.utils::mapKey()
#
# df <- tram_route
# df$id <- c(rep(1, 27), rep(2, 10), rep(1, 18))
#
# google_map(data = df, key = map_key) %>%
#   add_polylines(lat = "shape_pt_lat", lon = "shape_pt_lon", mouse_over = "id", mouse_over_group = "id", id = "id")
#
#
# google_map(key = map_key) %>%
#   add_polylines(data = df, lat = "shape_pt_lat", lon = "shape_pt_lon", mouse_over = "id", mouse_over_group = "id", id = "id")
#


#
#
#
# ## using encoded polyline and various colour / fill options
# flights <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv')
# flights$id <- seq_len(nrow(flights))
# ## encode the routes as polylines
# lst <- lapply(unique(flights$id), function(x){
#  lat = c(flights[flights["id"] == x, c("start_lat")], flights[flights["id"] == x, c("end_lat")])
#  lon = c(flights[flights["id"] == x, c("start_lon")], flights[flights["id"] == x, c("end_lon")])
#  data.frame(id = x, polyline = gepaf::encodePolyline(data.frame(lat = lat, lon = lon)))
# })
# flights <- merge(flights, do.call(rbind, lst), by = "id")
# ## style is taken from https://snazzymaps.com/style/6617/dark-greys
#
# style <- '[{"featureType":"all","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"all","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"all","elementType":"labels.text.fill","stylers":[{"saturation":36},{"color":"#000000"},{"lightness":40}]},{"featureType":"all","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":"#000000"},{"lightness":16}]},{"featureType":"all","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"administrative","elementType":"geometry.fill","stylers":[{"color":"#000000"}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#000000"},{"lightness":17},{"weight":1.2}]},{"featureType":"administrative","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"administrative","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"administrative.country","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"administrative.country","elementType":"geometry","stylers":[{"visibility":"simplified"}]},{"featureType":"administrative.country","elementType":"labels.text","stylers":[{"visibility":"simplified"}]},{"featureType":"administrative.province","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"all","stylers":[{"visibility":"simplified"},{"saturation":"-100"},{"lightness":"30"}]},{"featureType":"administrative.neighborhood","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"administrative.land_parcel","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"landscape","elementType":"all","stylers":[{"visibility":"simplified"},{"gamma":"0.00"},{"lightness":"74"}]},{"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":20}]},{"featureType":"landscape","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"landscape","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"landscape.man_made","elementType":"all","stylers":[{"lightness":"3"}]},{"featureType":"poi","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":21}]},{"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"geometry","stylers":[{"visibility":"simplified"},{"color":"#424242"},{"lightness":"-61"}]},{"featureType":"road","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#000000"},{"lightness":17}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#000000"},{"lightness":29},{"weight":0.2}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":18}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":16}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2a2727"},{"lightness":"-61"},{"saturation":"-100"}]},{"featureType":"transit","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":17}]},{"featureType":"water","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"labels.text","stylers":[{"visibility":"off"}]}]'
#
# google_map(key = map_key, style = style) %>%
#  add_polylines(data = flights, polyline = "polyline", mouse_over_group = "airport1", mouse_over = "airport1",
#               stroke_weight = 1, stroke_opacity = 0.3, stroke_colour = "#ccffff")
#
#
#
#
# library(data.table)
# dt_routes <- fread("https://github.com/jpatokal/openflights/raw/master/data/routes.dat", header = F)
# setnames(dt_routes, c("Airline", "AirlineID","SourceAirport","SourceAirportID","DestinationAirport","DestinationAirportID","CodeShare","Stops","Equipment"))
#
# dt_airports <- fread("https://github.com/jpatokal/openflights/raw/master/data/airports.dat")
# setnames(dt_airports, c("AirportID","Name","City","Country","IATA","ICAO","Latitude","Longitude","Altitude","Timezone","DST", "TzDatabaseTimeZone","Type","Source"))
#
# str(dt_routes)
# str(dt_airports)
#
# dt_airports[, AirportID := as.character(AirportID)]
#
# dt_routes <- dt_routes[
#   dt_airports[, .(AirportID, Latitude, Longitude)]
#   , on = c(SourceAirportID = "AirportID")
#   , nomatch = 0
#   ]
#
# setnames(dt_routes, c("Latitude", "Longitude"), c("SourceLatitude", "SourceLongitude"))
#
#
# dt_routes <- dt_routes[
#   dt_airports[, .(AirportID, Latitude, Longitude)]
#   , on = c(DestinationAirportID = "AirportID")
#   , nomatch = 0
#   ]
#
# setnames(dt_routes, c("Latitude", "Longitude"), c("DestinationLatitude", "DestinationLongitude"))
#
# lapply(1:nrow(dt_routes),function(x){
#
#   df <- data.frame(lat = c(dt_routes[x, SourceLatitude], dt_routes[x, DestinationLatitude]),
#                    lon = c(dt_routes[x, SourceLongitude], dt_routes[x, DestinationLongitude]))
#   pl <- gepaf::encodePolyline(df)
#   dt_routes[x, polyline := pl]
# })
#
#
#
# style <- '[{"featureType":"all","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"all","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"all","elementType":"labels.text.fill","stylers":[{"saturation":36},{"color":"#000000"},{"lightness":40}]},{"featureType":"all","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":"#000000"},{"lightness":16}]},{"featureType":"all","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"administrative","elementType":"geometry.fill","stylers":[{"color":"#000000"}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#000000"},{"lightness":17},{"weight":1.2}]},{"featureType":"administrative","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"administrative","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"administrative.country","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"administrative.country","elementType":"geometry","stylers":[{"visibility":"simplified"}]},{"featureType":"administrative.country","elementType":"labels.text","stylers":[{"visibility":"simplified"}]},{"featureType":"administrative.province","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"all","stylers":[{"visibility":"simplified"},{"saturation":"-100"},{"lightness":"30"}]},{"featureType":"administrative.neighborhood","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"administrative.land_parcel","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"landscape","elementType":"all","stylers":[{"visibility":"simplified"},{"gamma":"0.00"},{"lightness":"74"}]},{"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":20}]},{"featureType":"landscape","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"landscape","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"landscape.man_made","elementType":"all","stylers":[{"lightness":"3"}]},{"featureType":"poi","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":21}]},{"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"geometry","stylers":[{"visibility":"simplified"},{"color":"#424242"},{"lightness":"-61"}]},{"featureType":"road","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"labels.text","stylers":[{"visibility":"off"}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#000000"},{"lightness":17}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#000000"},{"lightness":29},{"weight":0.2}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":18}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":16}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2a2727"},{"lightness":"-61"},{"saturation":"-100"}]},{"featureType":"transit","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":17}]},{"featureType":"water","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"labels.text","stylers":[{"visibility":"off"}]}]'
#
# airports <- dt_airports[Country == "United Kingdom", AirportID]
#
# google_map(key = map_key, style = style) %>%
#   add_polylines(data = unique(dt_routes[SourceAirportID %in% airports, .(polyline)]), polyline = "polyline",
#                 stroke_weight = 1, stroke_opacity = 0.05, stroke_colour = "#ccffff")
#
#
# google_map(key = map_key, style = style) %>%
#   add_polylines(data = unique(dt_routes[, .(polyline)]), polyline = "polyline",
#                 stroke_weight = 1, stroke_opacity = 0.05, stroke_colour = "#ccffff")





# #' Polygon transform
# #'
# #' Encodes and foramts a \code{SpatialPolygonDataFrame} object into a Google-friendly \code{data.frame} of encoded polylines
# #'
# #' @param SPDF Spatial Polygons data frame to be encoded
# #' @param id_field field in @data that identifies the object
# #' @param CRSObj specify to also change the projection (default output is google map friendly EPSG:4326)
# #' @return data.frame with id field, encoded poly lines, `hole` boolean and `ringDir` info
# polygon_transform <- function(SPDF, id_field, CRSObj = "+init=epsg:4326"){
#
#   ## TODO:
#   ## - check incoming SPDF object (class, attr etc)
#   ## - check id field
#   ## - aggregate the output into the correct list-column structure for using as the polygon data.frame
#
#
#   SPDF <- spTransform(SPDF, CRSobj = CRS(CRSObj))
#   # creat poly lines and merge onto dt_wetlands
#
#   lst_poly <- lapply(1:length(SPDF), function(x, dat = SPDF, id_field_ = id_field){
#     p <- slot(slot(dat, "polygons")[[x]], "Polygons")
#
#     lst <- lapply(p, function(y){
#       coords <- data.frame(lat = slot(y, "coords")[,2],
#                            lng = slot(y, "coords")[,1])
#
#       pl <- gepaf::encodePolyline(coords)
#
#       df <- data.frame(polyline = pl,
#                        id_tmp = dat@data[x, id_field_, with=FALSE],
#                        hole = slot(y, "hole"),
#                        ringDir = slot(y, "ringDir"))
#
#       names(df)[names(df) == "id_tmp"] <- id_field_
#
#       return(df)
#     })
#     return(do.call(rbind, lst))
#   })
#
#   df_poly <- do.call(rbind, lst_poly)
#
#   return(df_poly)
# }


### Spatial polylines
# library(sp)
# library(rgdal)
#
# shp <- readOGR(dsn = "../../SVNStuff/Clients/HT0_HydroTasmania/MRBU_MRWF_BUS_surveys/Data/Received_BUSData/GIS",
#                layer = "Roads_line")
# map_key <- symbolix.utils::mapKey()

# google_map(key = map_key) %>%
#   add_polylines(data = shp)









