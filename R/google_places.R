#' Google places
#'
#' The Google Places API Web Service allows you to query for place information on a variety of categories, such as: establishments, prominent points of interest, geographic locations, and more.
#'
#' @param search_string \code{string} A search term representing a place for which to search. If blank, the \code{location} argument must be used.
#' @param location \code{numeric} vector of latitude/longitude coordinates (in that order) around which to retrieve place information. If blank, the \code{search_string} argument must be used. If used in absence of a \code{search_string}, If used in conjunction with \code{search_string} it represents the latitude/longitude around which to retrieve place information, and must be used in conjunction with \code{radius}.
#' @param radar \code{boolean} The Google Places API Radar Search Service allows you to search for up to 200 places at once, but with less detail than is typically returned from a Text Search (\code{search_string}) or Nearby Search (\code{location}) request. A radar search must contain a \code{location} and \code{radius}, and one of \code{keyword}, \code{name} or \code{type}. A radar search will not use a \code{search_string}
#' @param radius \code{numeric} Defines the distance (in meters) within which to return place results. The maximum allowed radius is 50,000 meters. Note that radius must not be included if \code{rankby="distance"} is specified.
#' @param rankby \code{string} Specifies the order in which results are listed. Possible values are \code{"prominence"}, \code{"distance"} or \code{"location"}. If \code{rankby = distance}, then one of \code{keyword}, \code{name} or \code{type} must be specified. If a \code{search_string} is used then \code{rankby} is ignored
#' @param keyword \code{string} A term to be matched against all content that Google has indexed for this place, including but not limited to name, type, and address, as well as customer reviews and other third-party content.
#' @param language \code{string} The language code, indicating in which language the results should be returned, if possible. Searches are also biased to the selected language; results in the selected language may be given a higher ranking. See the list of supported languages and their codes \url{https://developers.google.com/maps/faq#languagesupport}
#' @param name \code{string} \code{vector} One or more terms to be matched against the names of places. Ignored when used with a \code{search_string}. Results will be restricted to those containing the passed \code{name} values. Note that a place may have additional names associated with it, beyond its listed name. The API will try to match the passed name value against all of these names. As a result, places may be returned in the results whose listed names do not match the search term, but whose associated names do.
#' @param type \code{string} Restricts the results to places matching the specified type. Only one type may be specified (if more than one type is provided, all types following the first entry are ignored). For a list of valid types, please visit \url{https://developers.google.com/places/supported_types}
#' @param price_range \code{numeric} \code{vector} Specifying the minimum and maximum price ranges. Values range between 0 (most affordable) and 4 (most expensive)
#' @param page_token \code{string} Returns the next 20 results from a previously run search. Setting a pagetoken parameter will execute a search with the same parameters used previously — all parameters other than pagetoken will be ignored. The \code{page_token} can be found in the result set of a previously run query
#' @param simplify logical Inidicates if the returned JSON should be coerced into a list
#' @param key \code{string} A valid Google Developers Places API key
#'
#' @details
#' You can search for places either by proximity or a text string. A Place Search returns a list of places along with summary information about each place; additional information is available via a Place Details query.
#'
#' The \code{search_string} argument is only needed if you are searching by a
#'
#' @examps
#' \dontrun{
#'
#' ## query Restaurants in Melbourne (will return 20 results)
#' res <- google_places(search_string = "Restaurants in Melbourne, Australia",
#'                      key = key)
#'
#' ## use the 'next_page_token' from the previous search to get the next 20 results
#' res_next <- google_places(search_string = "Restaurants in Melbourne, Australia",
#'                           page_token = res$next_page_token,
#'                           key = key)
#'
#'
#' }
#' @export
#'
google_places <- function(search_string = NULL,
                          location = NULL,
                          radar = FALSE,
                          radius = NULL,
                          rankby = NULL,
                          keyword = NULL,
                          language = NULL,
                          name = NULL,
                          type = NULL,
                          simplify = TRUE,
                          price_range = NULL,
                          page_token = NULL,
                          key
                          ){

  ## either a text search or nearby search
  ## - determine type of search by the 'location' - either a lat/lon vector, or a string
  ## - can override?


  ## check if both search_string & location == NULL
  if(is.null(search_string) & is.null(location))
    stop("One of 'search_string' or 'location' must be specified")

  if(!is.null(location)){
    if(length(location) != 2 | !is.numeric(location)){
      stop("location must be a numeric vector of latitude/longitude coordinates")
    }else{
      location <- paste0(location, collapse = ",")
    }
  }

  ## check radar is logical
  if(!is.logical(radar))
    stop("radar must be logical")

  ## if radar search, must provide location, key, radius
  ## if radar search, one of keyword, name or type
  if(isTRUE(radar)){
    if(!is.null(search_string))
      warning("the search_string in a radar search will be ignored")

    if(is.null(keyword) & is.null(name) & is.null(type))
      stop("when using a radar search, one of keyword, name or type must be provided")

    if(is.null(location))
      stop("when using a radar search, location must be provided")

    if(is.null(radius))
      stop("when using a radar search, radius must be provided")

  }


  ## check radius < 50000m
  if(!is.null(radius)){
     if(radius > 50000 | radius < 0)
       stop("Radius must be positivie, and less than or equal to 50,000")
  }

  ## rankby has correct arguments
  if(!is.null(rankby) & is.null(search_string))
    if(!rankby %in% c("prominence","distance","location"))
      stop("rankby must be one of either prominence, distance or location")

  ## warning if rankby used with search_string
  if(!is.null(search_string) & !is.null(rankby))
    warning("The 'rankby' argument is ignored when using a 'search_string'")

  ## if !is.null(radius), then rankby must not equal "distance"
  if(!is.null(rankby)){
    if(!is.null(radius) & rankby == "distance")
      stop("'rankby' can not be 'distance' when a radius is supplied")

    ## if rankby == distance, then one of keyword, name or type must be specified
    if(rankby == "distance" & is.null(keyword) & is.null(name) & is.null(type))
      stop("you have specified rankby to be 'distance', so you must provide one of 'keyword','name' or 'type'")
  }

  ## warning if name used with search_string
  if(!is.null(search_string) & !is.null(name))
    warning("The 'name' argument is ignored when using a 'search_string'")

  if(length(name) > 1)
    name <- paste0(name, collapse = "|")

  ## price range is between 0 and 4
  if(!is.null(price_range)){
    if(!is.numeric(price_range) | (is.numeric(price_range) & length(price_range) != 2))
      stop("price_range must be a numeric vector of length 2")
  }

  if(!is.null(price_range)){
    if(!price_range[1] %in% 0:4 | !price_range[2] %in% 0:4)
      stop("price_range must be between 0 and 4 inclusive")
  }

  ## page token is single string
  if(!is.null(page_token)){
    if(!is.character(page_token) | length(page_token) != 1)
      stop("page_token must be a string of length 1")
  }

  ## construct the URL
  ## if search string is specified, use the 'textsearch' url
  ## if no search_string, use the 'lat/lon' url
  if(isTRUE(radar)){
    map_url <- "https://maps.googleapis.com/maps/api/place/radarsearch/json?"
  }else{
    if(!is.null(search_string)){
      search_string <- gsub(" ", "+", search_string)
      map_url <- paste0("https://maps.googleapis.com/maps/api/place/textsearch/json?query=", search_string)
    }else{
      map_url <- paste0("https://maps.googleapis.com/maps/api/place/nearbysearch/json?")
    }
  }
  map_url <- paste0(map_url,
                    "&location=", location,
                    "&radius=", radius,
                    "&rankby=", rankby,
                    "&keyword=", keyword,
                    "&language=", language,
                    "&name=", name,
                    "&type=", type,
                    "&minprice=", price_range[1],
                    "&maxprice=", price_range[2],
                    "&pagetoken=", page_token,
                    "&key=", key)
  print(map_url)


  return(fun_download_data(map_url, simplify))

}
