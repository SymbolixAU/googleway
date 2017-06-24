#' Google places
#'
#' The Google Places API Web Service allows you to query for place information
#' on a variety of categories, such as: establishments, prominent points of interest,
#' geographic locations, and more.
#'
#' @note
#' The Google Places API Web Service enforces a default limit of 1,000 free requests
#' per 24 hour period, calculated as the sum of client-side and server-side requets.
#' See \url{https://developers.google.com/places/web-service/usage} for details.
#'
#' Use of the Places Library must be in accordance with the polices described
#' for the Google Places API Web Service \url{https://developers.google.com/places/web-service/policies}
#'
#'
#' @param search_string \code{string} A search term representing a place for
#' which to search. If blank, the \code{location} argument must be used.
#' @param location \code{numeric} vector of latitude/longitude coordinates
#' (in that order) around which to retrieve place information. If blank, the
#' \code{search_string} argument must be used. If used in conjunction with
#' \code{search_string} it represents the latitude/longitude around which to
#' retrieve place information.
#' @param radar \code{boolean} The Google Places API Radar Search Service allows
#' you to search for up to 200 places at once, but with less detail than is typically
#' returned from a Text Search (\code{search_string}) or Nearby Search (\code{location}) request.
#' A radar search must contain a \code{location} and \code{radius}, and one of \code{keyword},
#' \code{name} or \code{type}. A radar search will not use a \code{search_string}
#' @param radius \code{numeric} Defines the distance (in meters) within which to
#' return place results. Required if only a \code{location} search is specified.
#' The maximum allowed radius is 50,000 meters. Radius must not be included if
#' \code{rankby="distance"} is specified. see Details.
#' @param rankby \code{string} Specifies the order in which results are listed.
#' Possible values are \code{"prominence"}, \code{"distance"} or \code{"location"}.
#' If \code{rankby = distance}, then one of \code{keyword}, \code{name} or
#' \code{place_type} must be specified. If a \code{search_string} is used then
#' \code{rankby} is ignored.
#' @param keyword \code{string} A term to be matched against all content that
#' Google has indexed for this place, including but not limited to name, type,
#' and address, as well as customer reviews and other third-party content.
#' @param language \code{string} The language code, indicating in which language
#' the results should be returned, if possible. Searches are also biased to the
#' selected language; results in the selected language may be given a higher ranking.
#' See the list of supported languages and their codes
#' \url{https://developers.google.com/maps/faq#languagesupport}.
#' @param name \code{string} \code{vector} One or more terms to be matched against
#' the names of places. Ignored when used with a \code{search_string}. Results will
#' be restricted to those containing the passed \code{name} values. Note that a
#' place may have additional names associated with it, beyond its listed name.
#' The API will try to match the passed name value against all of these names.
#' As a result, places may be returned in the results whose listed names do not
#' match the search term, but whose associated names do.
#' @param place_type \code{string} Restricts the results to places matching the
#' specified type. Only one type may be specified. For a list of valid types,
#' please visit \url{https://developers.google.com/places/supported_types}.
#' @param price_range \code{numeric} \code{vector} Specifying the minimum and
#' maximum price ranges. Values range between 0 (most affordable) and 4 (most expensive).
#' @param open_now \code{logical} Returns only those places that are open for
#' business at the time the query is sent. Places that do not specify opening
#' hours in the Google Places database will not be returned if you include this
#' parameter in your query.
#' @param page_token \code{string} Returns the next 20 results from a previously
#' run search. Setting a \code{page_token} parameter will execute a search with
#' the same parameters used in a previous search. All parameters other than
#' \code{page_token} will be ignored. The \code{page_token} can be found in the
#' result set of a previously run query.
#' @param simplify \code{logical} - TRUE indicates the returned JSON will be coerced into a list. FALSE indicates the returend JSON will be returned as a string
#' into a list.
#' @param key \code{string} A valid Google Developers Places API key.
#'
#' @details
#' With the Places service you can perform four kinds of searches:
#' \itemize{
#'   \item{Nearby Search}
#'   \item{Text Search}
#'   \item{Radar Sarch}
#'   \item{Place Details request}
#' }
#'
#' A Nearby search lets you search for places within a specified area or by keyword.
#' A Nearby search must always include a \code{location}, which can be specified
#' as a point defined by a pair of lat/lon coordinates, or a circle defined by a
#' point and a \code{radius}.
#'
#' A Text search returns information about a set of places based on the \code{search_string}.
#' The service responds with a list of places matching the string and any location
#' bias that has been set.
#'
#' A Radar search lets you search for places within a specified search radius
#' by keyword, type or name. The Radar search returns more results than a
#' Nearby or Text search, but the results contain fewer fields.
#'
#' A Place Detail search (using \link{google_place_details}) can be performed when
#' you have a given \code{place_id}
#' from one of the other three search methods.
#'
#'
#' \code{radius} - Required when only using a \code{location} search, \code{radius}
#' defines the distance (in meters) within which to return place results. The maximum
#' allowed radius is 50,000 meters. Note that radius must not be included if
#' \code{rankby = distance} is specified.
#'
#' \code{radius} - Optional when using a \code{search_string}. Defines the distance
#' (in meters) within which to bias place results. The maximum allowed radius is
#' 50,000 meters. Results inside of this region will be ranked higher than results
#' outside of the search circle; however, prominent results from outside of the
#' search radius may be included.
#'
#' @seealso \link{google_place_details}
#'
#' @examples
#' \dontrun{
#'
#' ## query restaurants in Melbourne (will return 20 results)
#' key <- 'your_api_key'
#'
#' res <- google_places(search_string = "Restaurants in Melbourne, Australia",
#'                      key = key)
#'
#' ## use the 'next_page_token' from the previous search to get the next 20 results
#' res_next <- google_places(search_string = "Restaurants in Melbourne, Australia",
#'                           page_token = res$next_page_token,
#'                           key = key)
#'
#' ## search for a specific place type
#' google_places(location = c(-37.817839,144.9673254),
#'               place_type = "bicycle_store",
#'               radius = 20000,
#'               key = key)
#'
#' ## search for places that are open at the time of query
#'  google_places(search_string = "Bicycle shop, Melbourne, Australia",
#'                open_now = TRUE,
#'                key = key)
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
                          place_type = NULL,
                          price_range = NULL,
                          open_now = NULL,
                          page_token = NULL,
                          simplify = TRUE,
                          key
                          ){

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

    if(is.null(keyword) & is.null(name) & is.null(place_type))
      stop("when using a radar search, one of keyword, name or place_type must be provided")

    if(is.null(location))
      stop("when using a radar search, location must be provided")

    if(is.null(radius))
      stop("when using a radar search, radius must be provided")

  }

  ## radius must be included if using a location search
  if(is.null(search_string) & !is.null(location) & is.null(radius))
    stop("you must specify a radius if only using a 'location' search")

  ## check radius < 50000m
  if(!is.null(radius)){
    if(!is.numeric(radius))
      stop("radius must be numeric between 0 and 50000")

     if(radius > 50000 | radius < 0)
       stop("radius must be numeric between 0 and 50000")
  }

  ## rankby has correct arguments
  if(!is.null(rankby) & !is.null(location))
    if(!rankby %in% c("prominence","distance","location"))
      stop("rankby must be one of either prominence, distance or location")

  ## warning if rankby used with search_string
  if(!is.null(search_string) & !is.null(rankby))
    warning("The 'rankby' argument is ignored when using a 'search_string'")

  ## radius must not be included if rankby=distance
  if(!is.null(rankby) & !is.null(location)){
    if(!is.null(radius) & rankby == "distance"){
      warning("radius is ignored when rankby == 'distance'")
     radius <- NULL
    }
  }

    ## if rankby == distance, then one of keyword, name or place_type must be specified
  if(!is.null(rankby) & !is.null(location)){
    if(rankby == "distance" &
       is.null(keyword) & is.null(name) & is.null(place_type))
      stop("you have specified rankby to be 'distance', so you must provide one of 'keyword','name' or 'place_type'")
  }

  ## language check
  if(!is.null(language) & (class(language) != "character" | length(language) > 1))
    stop("language must be a single character vector or string")


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

  ## check place type
  if(!is.null(place_type)){
    if(length(place_type) > 1 | !is.character(place_type))
      stop("place_type must be a string vector of length 1")
  }

  ## open_now is boolean
  if(!is.null(open_now)){
    if(!is.logical(open_now) | length(open_now) != 1)
      stop("open_now must be logical of length 1")
  }

  ## page token is single string
  if(!is.null(page_token)){
    if(!is.character(page_token) | length(page_token) != 1)
      stop("page_token must be a string of length 1")
  }

  LogicalCheck(simplify)

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

  map_url <- constructURL(map_url, c("location" = location,
                                     "radius" = radius,
                                     "rankby" = rankby,
                                     "keywrod" = keyword,
                                     "language" = language,
                                     "name" = name,
                                     "type" = place_type,
                                     "minprice" = price_range[1],
                                     "maxprice" = price_range[2],
                                     "opennow" = open_now,
                                     "pagetoken" = page_token,
                                     "key" = key))


  return(fun_download_data(map_url, simplify))

}
