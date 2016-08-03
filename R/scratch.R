# library(shinydashboard)
# library(shiny)
# library(magrittr)
# library(leaflet)
# library(googleway)
#
# ui <- dashboardPage(
#   dashboardHeader(),
#   dashboardSidebar(),
#   dashboardBody(
#     sliderInput(inputId = "slider", label = "heat",
#                 min = 0, max = 100, value = 50),
#     actionButton(inputId = "traffic", label = "traffic"),
#     google_mapOutput("myMap")
#   )
# )
#
#
# server <- function(input, output){
#
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
# pl <- "~s|dF}{~rZnNoExBq@|@SfAIjA@~Et@fBBp@Iv@QxCoArNqGfA_@dB]`KgAfVkC|Gu@rAYf@Q|@i@p@m@n@{@^u@`@kAR_ALiADuACiAIeAOy@_@qA{@uB{@sB]gAUmAOaB?oCTkKr@kZZiN?s@Cq@EQDOLILFn@A\\CpI_A|AQjB[BGPOX@LHz@CpAKT?v@KpHu@vD]LGt@Ix@I\\QBGLOVCPJd@Dj@GnFq@`PaBp@KfBQzA[zAq@nAaAx@aA~ByDp@yAXe@VSVO@EVWPCRDJLBF@Hd@TrDj@rK`ADEJGJ@JFBFrSxBJOPCNHHPdBLnCb@bBb@lAf@zA~@lAbApAzAt@nAxA|C~BhHrAxD~AtEb@|@xAtBpBlBzCbB`AZhIhBrFpA|AZl@HRDLENGXORe@DKJSf@wD`@cDt@}INq@ZuEt@mHfBsN~BkS`CmR\\eDnAiKzAcM`CePNmAhAsGXmArAgFtDsM|DaOh@sC^kCf@kDb@uDl@kI\\sHn@yM?gDEoAOsA[}BUiBUsC@qCNuBViBrCcPp@oGHW|@oPBuDI_DKqAy@wD{Ja^}@oFY_CWoDIqBGqEBsENqE`C{^JuA\\aDj@oDn@cDxAcFz@yBtC{Fp@eAn@_An@s@t@}@j@g@bCaBtCsA`GiAzBm@`C}@jBmA~CiC~DcDjCwAfAa@bBe@nBa@pCYlCArDBlCHhCGnC_@~A]vBk@hAa@lF_CnMaGbDeArD}@vB[zEe@jFS`GFfBFxBJzO\\zZfAfCJdEPbDNvDRnEHvD?tEE~BQhC[zAYnCu@bA]dBm@bIkDtBy@bAYhB[rDYxJ[nB@vAHfBLbCf@|C~@vAp@nCdB|A`A`CzApAr@|Al@rBl@bBZbUbCZBzBDvBEtAMnF_AvB[vBOlCAlBFnBXbDr@~Bv@z@`@bBfAdD~BtB`Bv@f@nAn@x@ZZJ~A\\dBTdADtBEbAGnEg@dFi@`DYdDQdF?|DNfCV`BTlCl@dNvD`HnBdLvClAZn@DzB^hCRd@?fA?|@Ih@O`@Ud@a@h@w@\\u@Pm@Lw@HoBq@qK]eLUcIE{DC{AD}Fn@eSLeCJs@RwFRkDf@sCj@aE`AsFhAuGh@gDt@wEp@}En@_FPeBRkDByBCgBEgAS}B{@oEsA}Dy@eCi@yBGq@?s@Ds@V}@Rg@r@u@ZOj@Ml@Az@PrA^fBb@j@HV@f@e@`B}AbB_B]Ie@KeASiO}CmH_B{L}Bk@QTqBTgCAm@g@kCSaAs@V{CdAmDrAuAh@{@Ra@H{@D{Af@wBt@gAb@]ReBl@"
# df_line <- decode_pl(pl)
# set.seed(123)
# df_line$weight <- runif(nrow(df_line), min = 1, max = 100)
# # df_line$weight <- row.names(df_line)
# df_line$opacity <- 0.2
#
#    output$myMap <- renderGoogle_map({
#
#     google_map(key = map_key, data = df_line) %>%
#       add_markers() %>%
#       add_heatmap(data = df_line) %>%
#       add_traffic()
#
#   })
#
#   observe({
#
#     df <- df_line[df_line$weight >= (input$slider - 1), ]
#
#     google_map_update(map_id = "myMap") %>%
#       clear_markers() %>%
#       update_heatmap(data = df)
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


