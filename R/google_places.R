#' Google places
#'
#' The Google Places API Web Service allows you to query for place information on a variety of categories, such as: establishments, prominent points of interest, geographic locations, and more.
#'
#' You can search for places either by proximity or a text string. A Place Search returns a list of places along with summary information about each place; additional information is available via a Place Details query.
#'
#' The \code{search_string} argument is only needed if you are searching by a
#'
#' @param search_string \code{string} A search term representing a place for which to search. If blank, the \code{location} argument must be used.
#' @param location \code{numeric} vector of latitude/longitude coordinates around which to retrieve place information. If blank, the \code{search_string} argument must be used. If used in absence of a \code{search_string}, If used in conjunction with \code{search_string} it represents the latitude/longitude around which to retrieve place information, and must be used in conjunction with \code{radius}.
#' @param radius \code{numeric} Defines the distance (in meters) within which to return place results. The maximum allowed radius is 50,000 meters. Note that radius must not be included if \code{rankby="distance"} is specified.
#' @param rankby \code{string} Specifies the order in which results are listed. Possible values are \code{"prominence"}, \code{"distance"} or \code{"location"}. If \code{rankby = distance}, then one of \code{keyword}, \code{name} or \code{type} must be specified
#' @param keyword \code{string} A term to be matched against all content that Google has indexed for this place, including but not limited to name, type, and address, as well as customer reviews and other third-party content.
#' @param language \code{string} The language code, indicating in which language the results should be returned, if possible. Searches are also biased to the selected language; results in the selected language may be given a higher ranking. See the list of supported languages and their codes \link{https://developers.google.com/maps/faq#languagesupport}
#' @param name \code{string} One or more terms to be matched against the names of places. Ignored when used with a \code{search_string}. Results will be restricted to those containing the passed \code{name} values. Note that a place may have additional names associated with it, beyond its listed name. The API will try to match the passed name value against all of these names. As a result, places may be returned in the results whose listed names do not match the search term, but whose associated names do.
#' @param type \code{string} Restricts the results to places matching the specified type. Only one type may be specified (if more than one type is provided, all types following the first entry are ignored). For a list of valid types, please visit \link{https://developers.google.com/places/supported_types}
#' @param simplify logical Inidicates if the returned JSON should be coerced into a list
#' @param key \code{string} A valid Google Developers Places API key
#' @export
#'
google_places <- function(search_string = NULL,
                          location = NULL,
                          radius = NULL,
                          rankby = c("prominence","distance","location"),
                          keyword = NULL,
                          language = NULL,
                          name = NULL,
                          type = NULL,
                          simplify = TRUE,
                          key
                          ){

  ## either a text search or nearby search
  ## - determine type of search by the 'location' - either a lat/lon vector, or a string
  ## - can override?


  ## check if both search_string & location == NULL
  if(is.null(search_string) & is.null(location))
    stop("One of 'search_string' or 'location' must be specified")

  location <- paste0(location, collapse = ",")

  ## check radius < 50000m
  if(!is.null(radius)){
     if(radius > 50000 | radius < 0)
       stop("Radius must be positivie, and less than or equal to 50,000")
  }

  ## rankby has correct arguments
  if(!is.null(rankby))
    rankby <- match.arg(rankby)

  ## if !is.null(radius), then rankby must not equal "distance"
  if(!is.null(radius) & rankby=="distance")
    stop("'rankby' can not be 'distance' when a radius is supplied")

  ## if rankby == distance, then one of keyword, name or type must be specified
  if(rankby == "distance" & is.null(keyword) & is.null(name) & is.null(type))
    stop("you have specified rankby to be 'distance', so you must provide one of 'keyword','name' or 'type'")


  ## warning if name used with search_string
  if(!is.null(search_string) & !is.null(name))
    warning("The 'name' argument is ignored when using a 'search_string'")


  ## construct the URL
  ## if search string is specified, use the 'textsearch' url
  ## if no search_string, use the 'lat/lon' url
  if(!is.null(search_string)){
    search_string <- gsub(" ", "+", search_string)
    map_url <- paste0("https://maps.googleapis.com/maps/api/place/textsearch/json?query=", search_string)
  }else{
    map_url <- paste0("https://maps.googleapis.com/maps/api/place/nearbysearch/json?")
  }

  map_url <- paste0(map_url,
                    "&location=", location,
                    "&radius=", radius,
                    "&rankby=", rankby,
                    "&keyword=", keyword,
                    "&language=", language,
                    "&name=", name,
                    "&type=", type,
                    "&key=", key)

  return(fun_download_data(map_url, simplify))

}
