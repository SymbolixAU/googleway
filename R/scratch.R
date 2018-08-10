

# library(googleway)
# library(deck.gl)
#
# set_key(read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY"))
#
# df <- mapdeck::melbourne
# df$elevation <- sample(100:5000, size = nrow(df))
# df$info <- paste0("<b>SA2 - </b><br>",df$SA2_NAME)
#
# google_map() %>%
#   deck.gl::add_polygon(
#     data = df
#     , polyline = "geometry"
#     , layer = "polygon_layer"
#     , fill_colour = "fillColor",
#     , stroke_colour = "fillColor",
#     , elevation = "elevation"
#     , stroke_width = 0
#     , tooltip = 'info'
#   )

