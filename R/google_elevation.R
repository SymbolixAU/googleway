#' Google elevation
#'
#' The Google Maps Elevation API provides elevation data for all locations on
#' the surface of the earth, including depth locations on the ocean floor
#' (which return negative values).
#'
#' @details
#' Locations can be specified as either a data.frame containing both a lat/latitude
#' and lon/longitude column, or
#' a single encoded polyline
#'
#' @param df_locations \code{data.frame} of with two columns called 'lat' and 'lon'
#' (or 'latitude' / 'longitude') used as the locations
#' @param polyline \code{string} encoded polyline
#' @param location_type \code{string} Specifies the results to be returned as individual
#' locations or as a path. One of 'individual' or 'path'. If 'path', the data.frame
#' \code{df_locations} must contain at least two rows. The order of the path is
#' determined by the order of the rows.
#' @param samples \code{integer} Required if \code{location_type == "path"}.
#' Specifies the number of sample points along a path for which to return elevation data.
#' The samples parameter divides the given path into an ordered set of equidistant
#' points along the path.
#' @param key \code{string} A valid Google Developers Elevation API key
#' @param simplify \code{logical} - TRUE indicates the returned JSON will be coerced into a list. FALSE indicates the returend JSON will be returned as a string
#' @param curl_proxy a curl proxy object
#' @return Either list or JSON string of the elevation data
#'
#' @inheritSection google_geocode API use and limits
#'
#' @examples
#' \dontrun{
#'
#' set_key("YOUR_GOOGLE_API_KEY")
#' ## elevation data for the MCG in Melbourne
#' df <- data.frame(lat = -37.81659,
#'                  lon = 144.9841)
#'
#' google_elevation(df_locations = df,
#'                  simplify = TRUE)
#'
#'
#'
#' ## elevation data from the MCG to the beach at Elwood (due south)
#' df <- data.frame(lat = c(-37.81659, -37.88950),
#'                  lon = c(144.9841, 144.9841))
#'
#' df <- google_elevation(df_locations = df,
#'                        location_type = "path",
#'                        samples = 20,
#'                        simplify = TRUE)
#'
#' ## plot results
#' library(ggplot2)
#' df_plot <- data.frame(elevation = df$results$elevation,
#'                        location = as.integer(rownames(df$results)))
#'
#'ggplot(data = df_plot, aes(x = location, y = elevation)) +
#'  geom_line()
#' }
#'
#'
#' @export
google_elevation <- function(df_locations = NULL,
                             polyline = NULL,
                             location_type = c("individual","path"),
                             samples = NULL,
                             key = get_api_key("elevation"),
                             simplify = TRUE,
                             curl_proxy = NULL
                             ){

  if(!is.null(df_locations) & !is.null(polyline))
    stop("please specify only one of df_locations or polyline")

  if(is.null(df_locations) & is.null(polyline))
    stop("please provide either df_locations or polyline")

  if(!is.null(df_locations)){
    ## check location
    ## does df_locations have correct columns
    if(!inherits(df_locations, "data.frame"))
      stop("df_locations should be a data.frame containing at least two columns of lat and lon coordianates")

    df <- as.data.frame(df_locations)
    if(sum(tolower(names(df)) %in% c("lat","latitude")) > 1 | sum(tolower(names(df)) %in% c("lon","longitude")) > 1)
      stop("Multiple possible lat/lon columns detected. Only use one column for lat/latitude and one column for lon/longitude coordinates")

    lat <- which(tolower(names(df)) %in% c("lat","latitude"))
    lon <- which(tolower(names(df)) %in% c("lon","longitude"))

    if(any(is.na(lat), is.na(lon), length(lat)==0, length(lon) == 0))
      stop("data.frame of locations must contain the columns lat/latitude and lon/longitude")

    locations <- paste0(df[, lat], ",", df[, lon], collapse = "|")
  }else{

    if(length(polyline) > 1)
      stop("please only specify a single polyline")

    locations <-  paste0('enc:',polyline)

  }

  ## check location_type
  location_type <- match.arg(location_type)

  logicalCheck(simplify)

  ## check samples

  if(location_type == "path" & !is.numeric(samples)){
    message("samples has not been specified. 3 will be used")
    samples <- 3
  }else if(location_type != "path"){
    samples <- NULL
  }else if(!is.integer(samples)){
    samples <- as.integer(samples)
  }

  map_url <- "https://maps.googleapis.com/maps/api/elevation/json?"

  ## Temporary solution:
  if(location_type == "individual"){
    map_url <- constructURL(map_url, c("locations" = locations,
                                       "samples" = samples,
                                       "key" = key))
  }else{
    map_url <- constructURL(map_url, c("path" = locations,
                                       "samples" = samples,
                                       "key" = key))
  }

  if(nchar(map_url) > 8192)
    if(is.null(polyline)){
      stop(paste0("The length of the API query has exceeded 8192 characters and your request may not work ",
                   "(see documentation https://developers.google.com/maps/documentation/elevation/intro#Locations for details",
                   "\nTry reducing the number of coordinates, or using an encoded polyline in the 'polyline' argument"))
    }else{
      stop(paste0("The length of the API query has exceeded 8192 characters and your request may not work ",
                     "(see documentation https://developers.google.com/maps/documentation/elevation/intro#Locations for details",
                     "\nConsider decoding your polyline into coordinates, then sending subsets of the data into the elevation function."))
    }

  return(downloadData(map_url, simplify, curl_proxy))
}
