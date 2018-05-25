# context("sf")
#
#
# test_that("sf objects encoded", {
#
#   df <- data.frame(
#     myId = c(1,1,1,1,1,1,1,1,2,2,2,2)
#     , lineId = c(1,1,1,1,2,2,2,2,1,1,1,2)
#     , lon = c(-80.190, -66.118, -64.757, -80.190,  -70.579, -67.514, -66.668, -70.579, -70, -49, -51, -70)
#     , lat = c(26.774, 18.466, 32.321, 26.774, 28.745, 29.570, 27.339, 28.745, 22, 23, 22, 22)
#     )
#
#   p1 <- as.matrix(df[4:1, c("lon", "lat")])
#   p2 <- as.matrix(df[8:5, c("lon", "lat")])
#   p3 <- as.matrix(df[9:12, c("lon", "lat")])
#
#   sfAttrs <- function(sf, geom) {
#     attr(sf, "class") <- c("XY", geom, "sfg")
#     sf <- list(sf)
#     attr(sf, "class") <- c("sfc_POINT", "sfc")
#     attr(sf, "precision") <- 0
#     bbox <- c(xmin = 0, ymin = 0, xmax = 0, ymax = 0)
#     attr(sf, "bbox") <- bbox
#     attr(sf, "precision") <- 0
#     attr(sf, "n_empty") <- 0
#     return(sf)
#   }
#
#   constructSf <- function(sf) {
#     sf <- data.frame(geometry = sf)
#     attr(sf, "class") <- c("sf", "data.frame")
#     attr(sf, "sf_column") <- "geometry"
#     attr(sf, "agr") <- factor()
#     return(sf)
#   }
#
#   pt <- matrix(c(df[1, "lon"], df[1, "lat"]), nrow = 1)
#   mp <- as.matrix(df[1:2, c("lon", "lat")])
#   ln <- p3
#
#   dfpt <- data.frame(geometry = as.list(pt))
#   attr(dfpt, "class") <- c("sf", "data.frame")
#
#   data.frame(list(mp))
#   data.frame(list(ln))
#   data.frame(geometry = list(mp, ln))
#
#   pt <- sfAttrs(pt, "POINT")
#   pt <- constructSf(pt)
#
#   mp <- sfAttrs(mp, "MULTIPOINT")
#   #mp <- constructSf(mp)
#   ln <- sfAttrs(ln, "LINESTRING")
#   #ln <- constructSf(ln)
#   ml <- list(p1, p2)
#   ml <- sfAttrs(ml, "MULTILINESTRING")
#   #ml <- constructSf(ml)
#   po <- list(p1, p2)
#   po <- sfAttrs(po, "POLYGON")
#   #po <- constructSf(po)
#   mpl <- list( list(p1, p2), list(p3) )
#   mpl <- sfAttrs(mpl, "MULTIPOLYGON")
#   #mpl <- constructSf(mpl)
#
#   rbind(pt, mp)
#
#   #
#   sf <- rbind(
#     sf::st_sf(geometry = point),
#     sf::st_sf(geometry = multipolygon),
#     sf::st_sf(geometry = multilinestring),
#     sf::st_sf(geometry = linestring),
#     sf::st_sf(geometry = point),
#     sf::st_sf(geometry = multipoint)
#   )
#
#   expect_true(inherits(googleway:::normalise_sf(sf), "sfencoded"))
#
#   enc <- googlePolylines::encode(sf)
#   expect_true(googleway:::findEncodedColumn(enc, NULL) == "geometry")
#   expect_true(googleway:::findEncodedColumn(enc, "geometry") == "geometry")
#
#   df <- data.frame(polyline = "abc")
#   expect_true(googleway:::findEncodedColumn(df, 'polyline') == "polyline")
#
# })
#
# test_that("correct sf rows are returned", {
#
#   df <- data.frame(myId = c(1,1,1,1,1,1,1,1,2,2,2,2),
#   								 lineId = c(1,1,1,1,2,2,2,2,1,1,1,2),
#   								 lon = c(-80.190, -66.118, -64.757, -80.190,  -70.579, -67.514, -66.668, -70.579, -70, -49, -51, -70),
#   								 lat = c(26.774, 18.466, 32.321, 26.774, 28.745, 29.570, 27.339, 28.745, 22, 23, 22, 22))
#
#   p1 <- as.matrix(df[4:1, c("lon", "lat")])
#   p2 <- as.matrix(df[8:5, c("lon", "lat")])
#   p3 <- as.matrix(df[9:12, c("lon", "lat")])
#
#   point <- sf::st_sfc(sf::st_point(x = c(df[1,"lon"], df[1,"lat"])))
#   multipoint <- sf::st_sfc(sf::st_multipoint(x = as.matrix(df[1:2, c("lon", "lat")])))
#   polygon <- sf::st_sfc(sf::st_polygon(x = list(p1, p2)))
#   linestring <- sf::st_sfc(sf::st_linestring(p3))
#   multilinestring <- sf::st_sfc(sf::st_multilinestring(list(p1, p2)))
#   multipolygon <- sf::st_sfc(sf::st_multipolygon(x = list(list(p1, p2), list(p3))))
#
#   sf <- rbind(
#   	sf::st_sf(geometry = polygon),
#   	sf::st_sf(geometry = multipolygon),
#   	sf::st_sf(geometry = multilinestring),
#   	sf::st_sf(geometry = linestring),
#   	sf::st_sf(geometry = point),
#     sf::st_sf(geometry = multipoint)
#   	)
#
#   expect_true(nrow(googleway:::normaliseSfData(sf, "POLYGON")) == 2)
#   expect_true(nrow(googleway:::normaliseSfData(sf, "LINE")) == 2)
#   expect_true(nrow(googleway:::normaliseSfData(sf, "POINT")) == 2)
#
#   enc <- googlePolylines::encode(sf)
#
#   expect_identical(enc, googleway:::normalise_sf(sf))
#   expect_identical(enc, googleway:::normalise_sf(enc))
#   expect_error(googleway:::normalise_sf(""), "Expecting an sf or sfencoded object to add_sf")
#
#   expect_true(nrow(googleway:::normaliseSfData(enc, "POLYGON")) == 2)
#   expect_true(nrow(googleway:::normaliseSfData(enc, "LINE")) == 2)
#   expect_true(nrow(googleway:::normaliseSfData(enc, "POINT")) == 2)
#
# })
#
