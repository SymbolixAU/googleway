#
# set_key("abc")
# m <- google_map()
#
# df <- data.frame(wkt = c("POINT(0 0)"))
#
# add_circles(m, data = df, wkt = "wkt")
#
# ## TODO(geometry column same name as object)
# ## - this fails
#
# sf <- sf::st_as_sfc("POINT(0 0)")
# sf <- sf::st_sf(sf)
#
# add_circles(m, data = sf)
#
# g <- sf::st_as_sfc("POINT(0 0)")
# g <- sf::st_sf(g=g)
#
# add_circles(m, data = g)
#
# geometry <- sf::st_as_sfc("POINT(0 0)")
# geometry <- sf::st_sf(g = geometry)
#
# add_circles(m, data = geometry)
#
#
# sf <- sf::st_as_sfc("POINT(0 0)")
# sf <- sf::st_sf(geometry = sf)
#
# add_circles(m, data = sf)
