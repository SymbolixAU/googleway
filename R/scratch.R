#
#
#
# df <- melbourne[1:3,]
# df$rand <- as.character(rnorm(nrow(df)))
# iw <- "rand"
# objArgs <- quote(add_polygons(map = ., data = df, polyline = "polyline", id = "polygonId", info_window = iw))
#
# # dataNames <- names(df)
# #
# # argsIdx <- match(cols, names(objArgs)) ## those that exist in 'cols'
# # argsIdx <- argsIdx[!is.na(argsIdx)]
#
# sapply(3:length(objArgs), function(x) {
#   objArgs[[x]]
# })
#
#
#
#
#
# argValues <- sapply(1:length(objArgs), function(x) objArgs[[x]] )
#
# one <- as.character(sapply(1:length(objArgs), function(x) objArgs[[x]])) %in% names(df)
# two <- argValues %in% names(df)
#
# toReplace <- which( !one & two )
#
# sapply(objArgs, print)
#
# for( i in seq_len(length(objArgs)) ) {
#   if (i %in% toReplace) {
#     objArgs[[i]] <- argValues[[i]]
#   }
# }
#
#
# sapply(seq_along(objArgs), function(x) if(x %in% toReplace) {
#   objArgs[[x]] <<- argValues[[x]]
# })
#
#
#
# lapply( toReplace, function(x) {
#   objArgs[[x]] <<- argValues[[x]]
# })
#
#
#
#
