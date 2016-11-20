# library(shinydashboard)
# library(shiny)
# library(magrittr)
# library(leaflet)
# library(googleway)
# library(data.table)


# df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
# -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
# ), lon = c(144.968612670898, 144.968414306641, 144.968139648438,
# 144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
# 97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
# 77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
# "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
#
# google_map(key = map_key, data = df) %>%
#   add_markers(lat = "lat", lon = "lon", mouse_over = "weight", info_window = "lat")
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
#
# df <- data.frame(polyline = c(pl, pl2, pl3))
#
# google_map(key = map_key, data = df_line, search_box = T, height = 800) %>%
#   add_markers()
# google_map(key = map_key, data = df_line, search_box = T, height = 800) %>%
#   googleway:::add_polygons(data = df, polyline = "polyline")
#
# df <- data.frame(id = 1:3,
#                  val = letters[1:3])
#
# df$val <- as.list(as.character(df$val))
#
# df <- data.frame(id = 1:3,
#                  val = letters[1:3])
#
# df[, "val2"] <- list("a","b","c")
#
# df2 <- data.frame(polyline = I(list("a","b","c")))
# str(df2)
#
# df[, "val"] <- as.list(as.character(df[, "val"]))
#
#
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
#
# google_map(key = map_key, height = 800, location = c(25.774, -80.190), zoom = 3) %>%
#   googleway:::add_polygons(data = df, polyline = "polyline", mouse_over = "polyline")





