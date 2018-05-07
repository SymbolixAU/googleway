#' Snap To Roads
#'
#' Takes up to 100 GPS coordinates collected along a route and returns a similar set of data,
#' with the points snapped to the most likely roads the vehicle was treveling along
#'
#' @note The snapping algorithm works best for points that are not too far apart.
#' If you observe odd snapping behaviour, try creating paths that have points closer together.
#' To ensure the best snap-to-road quality, you should aim to provide paths on which consecutive
#' pairs of points are within 300m of each other. This will also help in handling any
#' isolated, long jumps between consecutive points caused by GPS signal loss or noise.
#'
#' @param df_path \code{data.frame} with at least two columns specifying the latitude & longitude coordinates,
#' with a maximum of 100 pairs of coordinates.
#' @param lat string specifying the column of \code{df_path} containing the
#' 'latitude' coordinates. If left NULL, a best-guess will be made.
#' @param lon string specifying the column of \code{df_path} containing the '
#' longitude' coordinates. If left NULL, a best-guess will be made.
#' @param interpolate logical indicating whether to interpolate a path to
#' include all points forming the full road-geometry.
#' When \code{TRUE}, additional interpolated points will also be returned, resulting in a path
#' that smoothly follows the geometry of the road, even around corners and through
#' tunnels. Interpolated paths will most likely contain more ponts that the original path.
#' @param simplify \code{logical} - TRUE indicates the returned JSON will be coerced into a list.
#' FALSE indicates the returend JSON will be returned as a string
#' @param curl_proxy a curl proxy object
#' @param key \code{string} A valid Google Developers Places API key
#'
#' @inheritSection google_geocode API use and limits
#'
#' @seealso \link{google_nearestRoads}
#'
#' @examples
#' \dontrun{
#'
#' key <- 'your_api_key'
#'
#' df_path <- read.table(text = "lat lon
#' -35.27801 149.12958
#' -35.28032 149.12907
#' -35.28099 149.12929
#' -35.28144 149.12984
#' -35.28194 149.13003
#' -35.28282 149.12956
#' -35.28302 149.12881
#' -35.28473 149.12836", header = T)
#'
#' google_snapToRoads(df_path, key = key, interpolate = TRUE, simplify = TRUE)
#'
#'
#' }
#' @export
google_snapToRoads <- function(df_path,
                               lat = NULL,
                               lon = NULL,
                               interpolate = FALSE,
                               simplify = TRUE,
                               curl_proxy = NULL,
                               key = get_api_key("roads")
                               ){


  if(nrow(df_path) > 100)
    stop("the maximum number of pairs of coordinates that can be supplied is 100")

  logicalCheck(interpolate)
  logicalCheck(simplify)

  if(is.null(lat)){
    df_path <- latitude_column(df_path, lat, 'google_snapToRoads')
    lat <- "lat"
  }

  if(is.null(lon)){
    df_path <- longitude_column(df_path, lon, 'google_snapToRoads')
    lon <- "lng"
  }

  path <- paste0(df_path[, lat], ",", df_path[, lon], collapse = "|")

  map_url <- "https://roads.googleapis.com/v1/snapToRoads?"

  map_url <- constructURL(map_url, c("path" = path,
                                     "interpolate" = interpolate,
                                     "key" = key))

  return(downloadData(map_url, simplify, curl_proxy))
}




#' Nearest Roads
#'
#' Takes up to 100 independent coordinates and returns the closest road segment for each point.
#' The points passed do not need to be part of a continuous path.
#'
#'
#' @seealso \link{google_snapToRoads}
#'
#' @param df_points \code{data.frame} with at least two columns specifying the latitude & longitude coordinates,
#' with a maximum of 100 pairs of coordinates.
#'
#' @param lat string specifying the column of \code{df_path} containing the
#' 'latitude' coordinates. If left NULL, a best-guess will be made
#' @param lon string specifying the column of \code{df_path} containing the
#' 'longitude' coordinates. If left NULL, a best-guess will be made
#' @param simplify \code{logical} - TRUE indicates the returned JSON will be
#' coerced into a list. FALSE indicates the returend JSON will be returned as a string
#' @param curl_proxy a curl proxy object
#' @param key \code{string} A valid Google Developers Places API key
#'
#' @examples
#' \dontrun{
#'
#' key <- 'your_api_key'
#'
#'df_points <- read.table(text = "lat lon
#'  60.1707 24.9426
#'  60.1708 24.9424
#'  60.1709 24.9423", header = T)
#'
#' google_nearestRoads(df_points, key = key)
#'
#' }
#' @export
google_nearestRoads <- function(df_points,
                                lat = NULL,
                                lon = NULL,
                                simplify = TRUE,
                                curl_proxy = NULL,
                                key = get_api_key("roads")){

  logicalCheck(simplify)

  if(is.null(lat)){
    df_points <- latitude_column(df_points, lat, 'google_snapToRoads')
    lat <- "lat"
  }

  if(is.null(lon)){
    df_points <- longitude_column(df_points, lon, 'google_snapToRoads')
    lon <- "lng"
  }

  points <- paste0(df_points[, lat], ",", df_points[, lon], collapse = "|")

  map_url <- "https://roads.googleapis.com/v1/nearestRoads?"

  map_url <- constructURL(map_url, c("points" = points,
                                     "key" = key))

  return(downloadData(map_url, simplify, curl_proxy))

}



#' Speed Limits
#'
#' Returns the posted speed limit for a given road segment. In the case of road segments
#' with variable speed limits, the default speed limit for the segment is returned.
#' The speed limits service is only available to Google Maps API Premium Plan customers with an Asset Tracking license.
#'
#' @note The accuracy of speed limit data returned by Google Maps Roads API can not be
#' guaranteed. The speed limit data provided is not real-time, and may be estimated,
#' inaccurate, incomplete, and / or outdated.
#'
#' @param df_path \code{data.frame} with at least two columns specifying the
#' latitude & longitude coordinates, with a maximum of 100 pairs of coordinates.
#' @param lat string specifying the latitude column
#' @param lon string specifying the longitude column
#' @param placeIds vector of Place IDs of the road segments. Place IDs are returned in
#' response to \link{google_snapToRoads}
#' and \link{google_nearestRoads} reqeusts. You can pass up to 100 placeIds at a time
#' @param units Whether to return speed limits in kilometers or miles per hour
#' @param simplify \code{logical} - TRUE indicates the returned JSON will be
#' coerced into a list. FALSE indicates the returend JSON will be returned as a string
#' @param curl_proxy a curl proxy object
#' @param key \code{string} A valid Google Developers Places API key
#' @export
google_speedLimits <- function(df_path = NULL,
                               lat = NULL,
                               lon = NULL,
                               placeIds = NULL,
                               units = c("KPH","MPH"),
                               simplify = TRUE,
                               curl_proxy = NULL,
                               key = get_api_key("roads")){

  if(is.null(df_path) & is.null(placeIds))
    stop("please specify one of df_path or placeIds")

  if(!is.null(df_path) & !is.null(placeIds))
    stop("please specify one of df_path or placeIds, not both")

  units <- match.arg(units)
  logicalCheck(simplify)

  map_url <- "https://roads.googleapis.com/v1/speedLimits?"

  if(!is.null(df_path)){

    if(is.null(lat)){
      df_path <- latitude_column(df_path, lat, 'google_speedLimits')
      lat <- "lat"
    }

    if(is.null(lon)){
      df_path <- longitude_column(df_path, lon, 'google_speedLimits')
      lon <- "lng"
    }

    path <- paste0(df_path[, lat], ",", df_path[, lon], collapse = "|")

    map_url <- constructURL(map_url, c("path" = path,
                                       "units" = units,
                                       "key" = key))
  }else{

    if(length(placeIds) > 100)
      stop("the maximum number of placeIds allowed is 100")

    places <- paste0(paste0("placeId=", placeIds), collapse = "&")

    map_url <- constructURL(map_url, c("placeId" = places,
                                       "units" = units,
                                       "key" = key))

  }

  return(downloadData(map_url, simplify, curl_proxy))
}


