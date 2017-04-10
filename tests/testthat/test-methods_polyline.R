context("methods polyline")

test_that("correct list returned",{

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
