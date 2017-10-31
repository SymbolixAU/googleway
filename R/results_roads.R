
#' @describeIn access_result the coordinates from a nearest roads query
#' @export
nearest_roads_coordinates <- function(res) .access_result(resultType(res), "nearest_road_coords")

