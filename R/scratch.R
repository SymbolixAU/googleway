# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
# df <- data.frame(desc = c("Melbourne", "Melbourne Again"),
#                  lat = c(-37.9, -38),
#                  lon = c(144.9, 145.1))
#
# map <- google_map(key = key)
# map <- googleway:::add_markers(map, data = df)
#
# map <- google_map(key = map_key, markers = df)

# df2 <- data.frame(desc = c("Melbourne", "Melbourne Again"),
#                  lat = c(-38.1, -39),
#                  lon = c(144.3, 144.1))
#
# map$x$markers <- df

# map <- google_map(key = map_key)
#
# map <- googleway:::add_markers(map, df)

# library(magrittr)
#
# map <- google_map(key = map_key) %>%
#   add_markers(data = df) %>%
#   add_markers(data = df2)
#
#
# map <- google_map(key = map_key)
# map <- add_markers(map = map, data = df)



# key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_API_KEY")
#
# google_directions(origin = c(-37.669011,144.8410034),
#                   destination = c(-37.8182704,144.9670619),
#                   key = key)
#
# pl <- "~s|dF}{~rZnNoExBq@|@SfAIjA@~Et@fBBp@Iv@QxCoArNqGfA_@dB]`KgAfVkC|Gu@rAYf@Q|@i@p@m@n@{@^u@`@kAR_ALiADuACiAIeAOy@_@qA{@uB{@sB]gAUmAOaB?oCTkKr@kZZiN?s@Cq@EQDOLILFn@A\\CpI_A|AQjB[BGPOX@LHz@CpAKT?v@KpHu@vD]LGt@Ix@I\\QBGLOVCPJd@Dj@GnFq@`PaBp@KfBQzA[zAq@nAaAx@aA~ByDp@yAXe@VSVO@EVWPCRDJLBF@Hd@TrDj@rK`ADEJGJ@JFBFrSxBJOPCNHHPdBLnCb@bBb@lAf@zA~@lAbApAzAt@nAxA|C~BhHrAxD~AtEb@|@xAtBpBlBzCbB`AZhIhBrFpA|AZl@HRDLENGXORe@DKJSf@wD`@cDt@}INq@ZuEt@mHfBsN~BkS`CmR\\eDnAiKzAcM`CePNmAhAsGXmArAgFtDsM|DaOh@sC^kCf@kDb@uDl@kI\\sHn@yM?gDEoAOsA[}BUiBUsC@qCNuBViBrCcPp@oGHW|@oPBuDI_DKqAy@wD{Ja^}@oFY_CWoDIqBGqEBsENqE`C{^JuA\\aDj@oDn@cDxAcFz@yBtC{Fp@eAn@_An@s@t@}@j@g@bCaBtCsA`GiAzBm@`C}@jBmA~CiC~DcDjCwAfAa@bBe@nBa@pCYlCArDBlCHhCGnC_@~A]vBk@hAa@lF_CnMaGbDeArD}@vB[zEe@jFS`GFfBFxBJzO\\zZfAfCJdEPbDNvDRnEHvD?tEE~BQhC[zAYnCu@bA]dBm@bIkDtBy@bAYhB[rDYxJ[nB@vAHfBLbCf@|C~@vAp@nCdB|A`A`CzApAr@|Al@rBl@bBZbUbCZBzBDvBEtAMnF_AvB[vBOlCAlBFnBXbDr@~Bv@z@`@bBfAdD~BtB`Bv@f@nAn@x@ZZJ~A\\dBTdADtBEbAGnEg@dFi@`DYdDQdF?|DNfCV`BTlCl@dNvD`HnBdLvClAZn@DzB^hCRd@?fA?|@Ih@O`@Ud@a@h@w@\\u@Pm@Lw@HoBq@qK]eLUcIE{DC{AD}Fn@eSLeCJs@RwFRkDf@sCj@aE`AsFhAuGh@gDt@wEp@}En@_FPeBRkDByBCgBEgAS}B{@oEsA}Dy@eCi@yBGq@?s@Ds@V}@Rg@r@u@ZOj@Ml@Az@PrA^fBb@j@HV@f@e@`B}AbB_B]Ie@KeASiO}CmH_B{L}Bk@QTqBTgCAm@g@kCSaAs@V{CdAmDrAuAh@{@Ra@H{@D{Af@wBt@gAb@]ReBl@"
#
# df_line <- decode_pl(pl)
# names(df_line) <- c("lat", "lng")
#
# google_directions(origin = c(-37.8676715,144.9768734),
#                   destination = c(-37.841648,144.9608982),
#                   key = key)
#
# pl <- "`_cfFkuzsZ~ErBDFZv@kFrCyFrCo@^e@\\UTiBlCKLm@l@oBjAk@PQ@aA@mDWOAQIqA_AYM]Gw@AaAJUBm@N_Af@uAlAkBdB_@b@a@n@u@vA{AhDeKdTkEnJsCsB}MoKaDeCqBpCMPmBjC{DxEuG`HkGpFuGbFgAr@iCxAeBhAsCtAuBfAuAn@g@ZK[Si@g@m@s@o@q@u@MOG[cAuA}@mA`@QJEJUDQ@MDKHAJDDJBPIJAH?RTj@BLt@lALL"
#
# df_line2 <- decode_pl(pl)
# names(df_line2) <- c("lat", "lng")

# map <- google_map(key = map_key, polyline = list(df = df, df2 = df_line2))


# map <- google_map(key = map_key) %>%
#   add_markers(data = df) %>%
#   add_markers(data = df2) %>%
#   add_polyline(data = df_line) %>%
#   add_polyline(data = df_line2)


# google_map(key = map_key) %>%
#   add_markers(data = df) %>%
#   add_markers(data = df2) %>%
#   add_polyline(data = df_line)
#
#
# google_map(key = map_key) %>%
#   add_markers(data = df) %>%
#   add_polyline(data = list(df_line, df_line2))
#
# library(shiny)
# runApp(list(
#   ui = fluidPage(google_mapOutput("myMap")),
#
#   server = function(input, output){
#
#     map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#     output$myMap <- renderGoogle_map({
#
#       google_map(key = map_key)
#
#     })
#   }
# ))
#

# library(shinydashboard)
# library(shiny)
# library(magrittr)
# ui <- dashboardPage(
#   dashboardHeader(),
#   dashboardSidebar(),
#   dashboardBody(
#     google_mapOutput("myMap")
#   )
# )
#
#
# server <- function(input, output){
#
#   map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#   output$myMap <- renderGoogle_map({
#     google_map(key = map_key) %>%
#      add_heatmap(data = df_line)
#   })
# }
#
# shinyApp(ui, server)

#
# google_map(key = map_key) %>%
#   add_circles(data = df)
#

# df <- data.frame(desc = c("Melbourne", "Melbourne Again"),
#                  lat = c(-37.9, -38, -37.9, -38, -37.9, -37.9),
#                  lon = c(144.9, 145.1, 144.9, 144.9, 144.9, 144.9),
#                  weight = c(1, 200, 5, 3, 3, 3000))
#
# df_line$weight <- runif(nrow(df_line), min = 1, max = 100)
#
# google_map(key = map_key) %>%
#   add_heatmap(data = df_line)








