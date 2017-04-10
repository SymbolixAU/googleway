context("methods polyline")

test_that("correct polyline list returned",{

  df <- data.frame(id = c(1,1,2,2),
                   lat = 1:4,
                   lng = 1:4)

  lst_expected <- list(list(coords = data.frame(lat = 1:2, lng =  1:2),
                            id = 1),
                       list(coords = data.frame(lat = 3:4, lng = 3:4),
                            id = 2))

  lst_polyline <- googleway:::objPolylineCoords(obj = df,
                                                ids = unique(df$id),
                                                otherColumns = c())

  expect_equal(lst_expected[[1]]$id, lst_polyline[[1]]$id)
  expect_equal(lst_expected[[1]]$coords[, 'lat'], lst_polyline[[1]]$coords[, 'lat'])
  expect_equal(lst_expected[[1]]$coords[, 'lng'], lst_polyline[[1]]$coords[, 'lng'])

  expect_equal(lst_expected[[2]]$id, lst_polyline[[2]]$id)
  expect_equal(lst_expected[[2]]$coords[, 'lat'], lst_polyline[[2]]$coords[, 'lat'])
  expect_equal(lst_expected[[2]]$coords[, 'lng'], lst_polyline[[2]]$coords[, 'lng'])


  df <- data.frame(id = c(1,1,2,2),
                   lat = 1:4,
                   lng = 1:4,
                   width = c(3,3,6,6))

  lst_expected <- list(list(coords = data.frame(lat = 1:2, lng =  1:2),
                            width = 3,
                            id = 1),
                       list(coords = data.frame(lat = 3:4, lng = 3:4),
                            width = 6,
                            id = 2))

  lst_polyline <- googleway:::objPolylineCoords(obj = df,
                                                ids = unique(df$id),
                                                otherColumns = c('width'))

  expect_equal(lst_expected[[1]]$width, lst_polyline[[1]]$width)
  expect_equal(lst_expected[[2]]$width, lst_polyline[[2]]$width)


})

test_that("correct polygon list returned", {

  df <- data.frame(id = c(1,1,1,1,1,1,2,2,2),
                   pathId = c(1,1,1,2,2,2,1,1,1),
                   lat = c(26.774, 18.466, 32.321, 28.745, 29.570, 27.339, 22, 23, 22),
                   lng = c(-80.190, -66.118, -64.757, -70.579, -67.514, -66.668, -50, -49, -51),
                   colour = c(rep("#00FF0F", 6), rep("#FF00FF", 3)),
                   stringsAsFactors = FALSE)

  js_expected <- '[{"coords":[[{"lat":26.774,"lng":-80.19},{"lat":18.466,"lng":-66.118},{"lat":32.321,"lng":-64.757}],[{"lat":28.745,"lng":-70.579},{"lat":29.57,"lng":-67.514},{"lat":27.339,"lng":-66.668}]],"colour":["#00FF0F"],"id":[1]},{"coords":[[{"lat":22,"lng":-50},{"lat":23,"lng":-49},{"lat":22,"lng":-51}]],"colour":["#FF00FF"],"id":[2]}]'

  lst <- googleway:::objPolygonCoords(obj = df,
                                      ids = unique(df$id),
                                      otherColumns = c("colour"))

  js_polygon <- jsonlite::toJSON(lst)

  expect_equal(js_expected, as.character(js_polygon))



  js_expected <- '[{"coords":[[{"lat":26.774,"lng":-80.19},{"lat":18.466,"lng":-66.118},{"lat":32.321,"lng":-64.757}],[{"lat":28.745,"lng":-70.579},{"lat":29.57,"lng":-67.514},{"lat":27.339,"lng":-66.668}]],"id":[1]},{"coords":[[{"lat":22,"lng":-50},{"lat":23,"lng":-49},{"lat":22,"lng":-51}]],"id":[2]}]'

  lst <- googleway:::objPolygonCoords(obj = df,
                                      ids = unique(df$id),
                                      otherColumns = c())

  js_polygon <- jsonlite::toJSON(lst)

  expect_equal(js_expected, as.character(js_polygon))

})
