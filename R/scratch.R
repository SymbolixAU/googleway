
# ## Geojson
#
# library(symbolix.utils)
# m <- ConnectToMongo(db = "ABS", collection = "VIC_2016", usr = "db_user")
#
# geo <- m$find(' { "features.properties.SA3_NAME16" : "Wodonga - Alpine"  } ', fields = '{"features" : 1, "_id" : 0}', ndjson = T)
#
# ## plot a feature collection of all the features
#
# geo <- substr(x = geo, start = 17, nchar(geo) - 3)
# geo <- paste0(geo, collapse = ",")
# geo <- paste0('{ "type" : "FeatureCollection", "features" : [ ', geo, ' ] }')
#
# google_map(key = mapKey()) %>%
#   add_geojson(geojson = geo)



