#' Google elevation
#'
#' The Google Maps Elevation API provides elevation data for all locations on the surface of the earth, including depth locations on the ocean floor (which return negative values).
#'
#' You can specify the locations in one of two ways. Either as a set of single locations, or as a path (a series of connected locations).
#'
#' @param df_locations data.frame of with two columns called 'lat' and 'lon' (or 'latitude' / 'longitude') used as the locations
#' @param location_type string Specifies the results to be returned as individual locations or as a path. One of 'individual' or 'path'. If 'path', the data.frame df_locations must contain at least two rows. The order of the path is determined by the order of the rows.
#' @param samples integer required if \code{location_type == "path"}. Specifies the number of sample points along a path for which to return elevation data. The samples parameter divides the given path into an ordered set of equidistant points along the path.
#' @param key string A valid Google Developers Directions API key
#' @param simplify logical Inidicates if the returned JSON should be coerced into a list
#' @return Either list or JSON string of the elevation data
#' @examples
#' \dontrun{
#'
#' ## elevation data for the MCG in Melbourne
#' df <- data.frame(lat = -37.81659,
#'                  lon = 144.9841)
#'
#' google_elevation(df_locations = df,
#'                  key = "<your valid api key>",
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
#'                        key = "<your valid api key>",
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
google_elevation <- function(df_locations,
                             location_type = c("individual","path"),
                             samples = NULL,
                             key,
                             simplify = TRUE
                             ){

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

  ## check location_type
  location_type <- match.arg(location_type)

  if(!is.logical(simplify))
    stop("simplify must be logical - TRUE or FALSE")

  ## check samples

  if(location_type == "path" & !is.numeric(samples)){
    warning("samples has not been specified. 3 will be used")
    samples <- 3
  }else if(location_type != "path"){
    samples <- NULL
  }else if(!is.integer(samples)){
    samples <- as.integer(samples)
  }

  location_string <- switch(location_type,
                            "individual" = "&locations=",
                            "path" = "&path=")

  map_url <- paste0("https://maps.googleapis.com/maps/api/elevation/json?",
                    location_string, locations,
                    "&samples=",samples,
                    "&key=",key)

  return(fun_download_data(map_url, simplify))
}
