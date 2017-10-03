#
# dt_inner <- as.data.table(melbourne[melbourne$SA4_NAME == "Melbourne - Inner", ])
#
# dt_coords <- dt_inner[, decode_pl(polyline), by = polygonId]
#
#
# dt_coords <- dt_coords[
#   dt_inner[, .(polygonId, SA2_NAME, SA3_NAME, SA4_NAME, AREASQKM)]
#   , on = c("polygonId")
#   , nomatch = 0
#   ]
#
# polygon <- lapply(unique(dt_coords$polygonId), function(x){
#   sp::Polygon(
#     matrix(c(dt_coords[polygonId == x, lon], dt_coords[polygonId == x, lat]), ncol = 2)
#   )
# })
#
# ids <- unique(dt_coords$polygonId)
# polygons <- lapply(seq_along(polygon), function(x){
#   sp::Polygons(list(polygon[[x]]),
#                ID = ids[x])
# })
#
#
# # polygons <- sp::Polygons(polygon, "ID")
#
# spPolygons <- sp::SpatialPolygons(polygons)
#
# spPolyData <- sp::SpatialPolygonsDataFrame(
#   spPolygons,
#   data = unique(dt_coords[, .(polygonId, SA2_NAME, SA3_NAME, AREASQKM) ] ),
#   match.ID = F
#   )
#
# plot(spPolyData)
#
# sf <- sf::st_as_sf(spPolyData)
#
# plot(sf)
#
# pal <- googleway:::generatePalette(sf$SA2_NAME, viridisLite::viridis)
#
# sf <- merge(sf, pal, by.x = "SA2_NAME", by.y = "variable")
# sf <- setNames(sf, c("SA2_NAME", "polygonId", "SA3_NAME", "AREASQKM", "fillColor", "geometry"))
#
# geo_melbourne <- geojsonio::geojson_json(sf)
#
# # geojson <- geojsonio::geojson_atomize(geojson)
#
# devtools::use_data(geo_melbourne)
#
#
# google_map(key = mapKey) %>%
#   add_geojson(geo_melbourne)
#
# ## TODO:
# ## add style information to geo...
#
#
#
#
#
