# library(shinydashboard)
# library(shiny)
# library(magrittr)
# library(leaflet)
# library(googleway)
# library(data.table)
#
# ui <- dashboardPage(
#   dashboardHeader(),
#   dashboardSidebar(),
#   dashboardBody(
#     sliderInput(inputId = "slider", label = "heat",
#                 min = 0, max = 100, value = 50, animate = T),
#     actionButton(inputId = "traffic", label = "traffic"),
#     box(width = 10,
#         height = 600,
#       google_mapOutput("myMap")
#     )
#   )
# )
#
#
# server <- function(input, output){
#
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
# pl <- "~s|dF}{~rZnNoExBq@|@SfAIjA@~Et@fBBp@Iv@QxCoArNqGfA_@dB]`KgAfVkC|Gu@rAYf@Q|@i@p@m@n@{@^u@`@kAR_ALiADuACiAIeAOy@_@qA{@uB{@sB]gAUmAOaB?oCTkKr@kZZiN?s@Cq@EQDOLILFn@A\\CpI_A|AQjB[BGPOX@LHz@CpAKT?v@KpHu@vD]LGt@Ix@I\\QBGLOVCPJd@Dj@GnFq@`PaBp@KfBQzA[zAq@nAaAx@aA~ByDp@yAXe@VSVO@EVWPCRDJLBF@Hd@TrDj@rK`ADEJGJ@JFBFrSxBJOPCNHHPdBLnCb@bBb@lAf@zA~@lAbApAzAt@nAxA|C~BhHrAxD~AtEb@|@xAtBpBlBzCbB`AZhIhBrFpA|AZl@HRDLENGXORe@DKJSf@wD`@cDt@}INq@ZuEt@mHfBsN~BkS`CmR\\eDnAiKzAcM`CePNmAhAsGXmArAgFtDsM|DaOh@sC^kCf@kDb@uDl@kI\\sHn@yM?gDEoAOsA[}BUiBUsC@qCNuBViBrCcPp@oGHW|@oPBuDI_DKqAy@wD{Ja^}@oFY_CWoDIqBGqEBsENqE`C{^JuA\\aDj@oDn@cDxAcFz@yBtC{Fp@eAn@_An@s@t@}@j@g@bCaBtCsA`GiAzBm@`C}@jBmA~CiC~DcDjCwAfAa@bBe@nBa@pCYlCArDBlCHhCGnC_@~A]vBk@hAa@lF_CnMaGbDeArD}@vB[zEe@jFS`GFfBFxBJzO\\zZfAfCJdEPbDNvDRnEHvD?tEE~BQhC[zAYnCu@bA]dBm@bIkDtBy@bAYhB[rDYxJ[nB@vAHfBLbCf@|C~@vAp@nCdB|A`A`CzApAr@|Al@rBl@bBZbUbCZBzBDvBEtAMnF_AvB[vBOlCAlBFnBXbDr@~Bv@z@`@bBfAdD~BtB`Bv@f@nAn@x@ZZJ~A\\dBTdADtBEbAGnEg@dFi@`DYdDQdF?|DNfCV`BTlCl@dNvD`HnBdLvClAZn@DzB^hCRd@?fA?|@Ih@O`@Ud@a@h@w@\\u@Pm@Lw@HoBq@qK]eLUcIE{DC{AD}Fn@eSLeCJs@RwFRkDf@sCj@aE`AsFhAuGh@gDt@wEp@}En@_FPeBRkDByBCgBEgAS}B{@oEsA}Dy@eCi@yBGq@?s@Ds@V}@Rg@r@u@ZOj@Ml@Az@PrA^fBb@j@HV@f@e@`B}AbB_B]Ie@KeASiO}CmH_B{L}Bk@QTqBTgCAm@g@kCSaAs@V{CdAmDrAuAh@{@Ra@H{@D{Af@wBt@gAb@]ReBl@"
# pl2 <- "vibfFix{sZzAaUz@sLhAgP\\}Ex@oMfBmYdAqPpBw[fCga@pByZz@kNhA_QnBo[dAqPtBk]FsAEk@EQIOfFyFsAyBhJwJnB_Ct@u@`AkA|@qAj@kAj@}AXkAXaBT}BL}CZ}EZ_CRcACo@Ck@Qq@?eAJiAdAwPjBqZvBs]pBu\\dAyPd@cJCWEMGWRQ`A}@r@}@tAcCp@mBd@{BV_CHaC?wAa@yIEg@_@gCaA}GuBqNuAyI_@}Bc@}Ci@uCaB}KGqAAoA@o@F{@Ba@VyA\\oA\\_Ab@{@rAiBhFyGLg@b@s@xAgCTk@dCLrBRpANVDLEb@IZMt@k@d@]N[hAmCz@cChAoEd@_Cn@yDn@uF^sDHeATi@z@uJnBqVhBcUb@gFr@yFn@{Dp@yCnAaFjAeDdAmCzBuEdEuIl@qAjBqFfBeId@gCl@iFZsEh@_Kh@wJpAqVvA}ZhBc]r@gLPkBb@uCbAeFhAkDt@kB`A}BdAkBpAsBfA}A~AgBpCgCpJ}H?KN[tBmBzCuClCoCp@eAVi@Zy@`@oBXgCVyBFSb@yHf@mIXgFLuBBo@CYCOAOIYGKEEcBUyEq@iEq@kIcAkNgB{c@{DwGg@qBW_RmBiAOB_@fAL"
# pl3 <- "pizeF_{~sZjLhAdAJLwBJkBv@wN~Bgd@x@sNjAeUR_FTkEAqBGiAQuAw@{E_C}NGwA?sANaELkDDu@LgAfAiF?g@EI?EIo@EMMKe@UQGaAM}IaA_Fg@_JaAsEc@_[iDiI_AeT}BgI{@mBSJ{AHwANgCn@}JdAaPiZgD"
# df_line <- decode_pl(pl)
# df1 = decode_pl(pl)
# df2 = decode_pl(pl2)
# df3 = decode_pl(pl3)
# df1$id <- 1
# df2$id <- 2
# df3$id <- 3
# df_routes <- rbind(df1, df2, df3)
# set.seed(123)
# df_line$weight <- runif(nrow(df_line), min = 1, max = 100)
# # df_line$weight <- row.names(df_line)
# df_line$opacity <- 0.2
# df_line$title <- paste0("<p><b>", df_line$weight, "</b></p><p>", df_line$weight, "</p>")
# df_line$title <- sample(letters, nrow(df_line), replace = T)

   # output$myMap <- renderGoogle_map({
#
# google_map(key = map_key, data = df_line, search_box = T, height = 800) %>%
# #  add_markers(info_window = "title", title = "title", cluster = T) %>%
#   googleway:::add_polyline(data = df_routes, group = "id")
#
# df <- data.frame(polyline = c(pl, pl2, pl3))
# df$id <- c(1,2,3)
# google_map(key = map_key, data = df_line, search_box = T, height = 800) %>%
#   googleway:::add_polyline(data = df, lineSource = "polyline", polyline = "polyline")
#  })
#
#   observe({
#
#     df <- df_line[df_line$weight >= (input$slider - 1), ]
#
#     google_map_update(map_id = "myMap") %>%
#      # update_heatmap()
#       clear_markers() %>%
#       add_markers(data = df, lat = "lat", lon = "lon")
#
#       # update_heatmap(data = df)
#   })
#
#   observe({
#     if(input$traffic){
#
#       if(as.numeric(input$traffic) %% 2 == 0){
#         google_map_update(map_id = 'myMap') %>%
#           add_traffic()
#       }else{
#         google_map_update(map_id = 'myMap') %>%
#           clear_traffic()
#       }
#     }
#   })
#
# }
#
# shinyApp(ui, server)
# library(png)
# key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_STATIC_MAP")
# temp_file <- tempfile()
# map_url <- paste0("https://maps.googleapis.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=12&size=400x400&key=", key)
# download.file(map_url, temp_file, mode = "wb")
# map <- readPNG(temp_file)
# map
# file.remove(temp_file)

# df <- data.frame(table(df_routes$id))
#
# df$end <- cumsum(df$Freq)
#
# df$start <- df$end - df$Freq
#
# c(1, diff(df$end))
#
# df_routes
#
# ave(df_routes[, c("lat","lon")], df_routes$id, FUN = function(x) gepaf::encodePolyline)
#
# lst <- split(df_routes, df_routes$id)
#
# lapply(lst, function(x){ gepaf::encodePolyline(x[, c("lat","lon")])   })
#
#
#
#
# group_options <- data.frame(group = c(1,2,3),
#                             strokeColour = c("#00ff00","#ff00ff","#ffff00"),
#                             strokeOpacity = c(0.3, 0.2, 0.9),
#                             strokeWeight = c(2,3,4),
#                             fillColour = c("#00ff00","#ff00ff","#ffff00"),
#                             fillOpacity = c(0.9, 0.5, 0.2))
#
#
# polyline <- lapply(split(df_routes, df_routes$id),
#                    function(x){
#                      data.frame(polyline = gepaf::encodePolyline(x[, c("lat","lon")]),
#                                 group = unique(x['id']))
#                    })
#
#
# s <- split(df_routes, df_routes$id)
#
# lapply(s, function(x){
#   ## create polyline
#   pl <- gepaf::encodePolyline(x[, c("lat", "lon")])
#   i <- unique(x[, 'id'])
#   data.frame(pl = pl, id = i)
# })





