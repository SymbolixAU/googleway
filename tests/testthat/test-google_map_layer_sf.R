context("sf")


test_that("sf objects encoded", {

  sf <- structure(list(geometry = structure(list(structure(list(structure(c(-80.19,
-64.757, -66.118, -80.19, 26.774, 32.321, 18.466, 26.774), .Dim = c(4L,
2L), .Dimnames = list(c("4", "3", "2", "1"), c("lon", "lat"))),
structure(c(-70.579, -66.668, -67.514, -70.579, 28.745, 27.339,
29.57, 28.745), .Dim = c(4L, 2L), .Dimnames = list(c("8",
"7", "6", "5"), c("lon", "lat")))), class = c("XY", "POLYGON",
"sfg")), structure(list(list(structure(c(-80.19, -64.757, -66.118,
-80.19, 26.774, 32.321, 18.466, 26.774), .Dim = c(4L, 2L), .Dimnames = list(
c("4", "3", "2", "1"), c("lon", "lat"))), structure(c(-70.579,
-66.668, -67.514, -70.579, 28.745, 27.339, 29.57, 28.745), .Dim = c(4L,
2L), .Dimnames = list(c("8", "7", "6", "5"), c("lon", "lat")))),
list(structure(c(-70, -49, -51, -70, 22, 23, 22, 22), .Dim = c(4L,
2L), .Dimnames = list(c("9", "10", "11", "12"), c("lon",
"lat"))))), class = c("XY", "MULTIPOLYGON", "sfg")), structure(list(
structure(c(-80.19, -64.757, -66.118, -80.19, 26.774, 32.321,
18.466, 26.774), .Dim = c(4L, 2L), .Dimnames = list(c("4",
"3", "2", "1"), c("lon", "lat"))), structure(c(-70.579, -66.668,
-67.514, -70.579, 28.745, 27.339, 29.57, 28.745), .Dim = c(4L,
2L), .Dimnames = list(c("8", "7", "6", "5"), c("lon", "lat"
)))), class = c("XY", "MULTILINESTRING", "sfg")), structure(c(-70,
-49, -51, -70, 22, 23, 22, 22), .Dim = c(4L, 2L), .Dimnames = list(
c("9", "10", "11", "12"), c("lon", "lat")), class = c("XY",
"LINESTRING", "sfg")), structure(c(-80.19, 26.774), class = c("XY",
"POINT", "sfg")), structure(c(-80.19, -66.118, 26.774, 18.466
), .Dim = c(2L, 2L), .Dimnames = list(c("1", "2"), c("lon", "lat"
)), class = c("XY", "MULTIPOINT", "sfg"))), class = c("sfc_GEOMETRY",
"sfc"), precision = 0, bbox = structure(c(xmin = -80.19, ymin = 18.466,
xmax = -49, ymax = 32.321), class = "bbox"), crs = structure(list(
input = NA_character_, wkt = NA_character_), class = "crs"), n_empty = 0L, classes = c("POLYGON",
"MULTIPOLYGON", "MULTILINESTRING", "LINESTRING", "POINT", "MULTIPOINT"
))), row.names = c(NA, 6L), sf_column = "geometry", agr = structure(integer(0), class = "factor", .Label = c("constant",
"aggregate", "identity"), .Names = character(0)), class = c("sf",
"data.frame"))

  expect_true(inherits(googleway:::normalise_sf(sf), "sfencoded"))

  enc <- googlePolylines::encode(sf)
  expect_true(googleway:::findEncodedColumn(enc, NULL) == "geometry")
  expect_true(googleway:::findEncodedColumn(enc, "geometry") == "geometry")

  df <- data.frame(polyline = "abc")
  expect_true(googleway:::findEncodedColumn(df, 'polyline') == "polyline")

})

test_that("correct sf rows are returned", {

  sf <- structure(list(geometry = structure(list(structure(list(structure(c(-80.19,
-64.757, -66.118, -80.19, 26.774, 32.321, 18.466, 26.774), .Dim = c(4L,
2L), .Dimnames = list(c("4", "3", "2", "1"), c("lon", "lat"))),
structure(c(-70.579, -66.668, -67.514, -70.579, 28.745, 27.339,
29.57, 28.745), .Dim = c(4L, 2L), .Dimnames = list(c("8",
"7", "6", "5"), c("lon", "lat")))), class = c("XY", "POLYGON",
"sfg")), structure(list(list(structure(c(-80.19, -64.757, -66.118,
-80.19, 26.774, 32.321, 18.466, 26.774), .Dim = c(4L, 2L), .Dimnames = list(
c("4", "3", "2", "1"), c("lon", "lat"))), structure(c(-70.579,
-66.668, -67.514, -70.579, 28.745, 27.339, 29.57, 28.745), .Dim = c(4L,
2L), .Dimnames = list(c("8", "7", "6", "5"), c("lon", "lat")))),
list(structure(c(-70, -49, -51, -70, 22, 23, 22, 22), .Dim = c(4L,
2L), .Dimnames = list(c("9", "10", "11", "12"), c("lon",
"lat"))))), class = c("XY", "MULTIPOLYGON", "sfg")), structure(list(
structure(c(-80.19, -64.757, -66.118, -80.19, 26.774, 32.321,
18.466, 26.774), .Dim = c(4L, 2L), .Dimnames = list(c("4",
"3", "2", "1"), c("lon", "lat"))), structure(c(-70.579, -66.668,
-67.514, -70.579, 28.745, 27.339, 29.57, 28.745), .Dim = c(4L,
2L), .Dimnames = list(c("8", "7", "6", "5"), c("lon", "lat"
)))), class = c("XY", "MULTILINESTRING", "sfg")), structure(c(-70,
-49, -51, -70, 22, 23, 22, 22), .Dim = c(4L, 2L), .Dimnames = list(
c("9", "10", "11", "12"), c("lon", "lat")), class = c("XY",
"LINESTRING", "sfg")), structure(c(-80.19, 26.774), class = c("XY",
"POINT", "sfg")), structure(c(-80.19, -66.118, 26.774, 18.466
), .Dim = c(2L, 2L), .Dimnames = list(c("1", "2"), c("lon", "lat"
)), class = c("XY", "MULTIPOINT", "sfg"))), class = c("sfc_GEOMETRY",
"sfc"), precision = 0, bbox = structure(c(xmin = -80.19, ymin = 18.466,
xmax = -49, ymax = 32.321), class = "bbox"), crs = structure(list(
input = NA_character_, wkt = NA_character_), class = "crs"), n_empty = 0L, classes = c("POLYGON",
"MULTIPOLYGON", "MULTILINESTRING", "LINESTRING", "POINT", "MULTIPOINT"
))), row.names = c(NA, 6L), sf_column = "geometry", agr = structure(integer(0), class = "factor", .Label = c("constant",
"aggregate", "identity"), .Names = character(0)), class = c("sf",
"data.frame"))

  expect_true(nrow(googleway:::normaliseSfData(sf, "POLYGON")) == 2)
  expect_true(nrow(googleway:::normaliseSfData(sf, "LINE")) == 2)
  expect_true(nrow(googleway:::normaliseSfData(sf, "POINT")) == 2)

  enc <- googlePolylines::encode(sf)

  expect_identical(enc, googleway:::normalise_sf(sf))
  expect_identical(enc, googleway:::normalise_sf(enc))
  expect_error(googleway:::normalise_sf(""), "Expecting an sf or sfencoded object to add_sf")

  expect_true(nrow(googleway:::normaliseSfData(enc, "POLYGON")) == 2)
  expect_true(nrow(googleway:::normaliseSfData(enc, "LINE")) == 2)
  expect_true(nrow(googleway:::normaliseSfData(enc, "POINT")) == 2)

})

