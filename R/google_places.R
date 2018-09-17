#' Google places
#'
#' The Google Places API Web Service allows you to query for place information
#' on a variety of categories, such as: establishments, prominent points of interest,
#' geographic locations, and more.
#'
#' A Nearby Search (using \code{google_places}) lets you search for places within a specified area.
#' You can refine your search request by supplying keywords or specifying the type of place you are searching for.
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
#' (in that order) around which to retrieve place information.
#' @param radius \code{numeric} Defines the distance (in meters) within which to
#' return place results. Required if only a \code{location} search is specified.
#' The maximum allowed radius is 50,000 meters. Radius must not be included if
#' \code{rankby} is used. see Details.
#' @param rankby \code{string} Specifies the order in which results are listed.
#' Possible values are \code{"prominence"} or \code{"distance"}.
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
#' @param curl_proxy a curl proxy object
#' @param key \code{string} A valid Google Developers Places API key.
#' @param radar deprecated, no longer used
#'
#' @details
#' With the Places service you can perform three kinds of searches:
#' \itemize{
#'   \item{Nearby Search}
#'   \item{Text Search}
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
#' @inheritSection google_geocode API use and limits
#'
#' @seealso \link{google_place_details} \link{google_find_place}
#'
#' @examples
#' \dontrun{
#'
#' ## query restaurants in Melbourne (will return 20 results)
#' api_key <- 'your_api_key'
#'
#' res <- google_places(search_string = "Restaurants in Melbourne, Australia",
#'                      key = api_key)
#'
#' ## use the 'next_page_token' from the previous search to get the next 20 results
#' res_next <- google_places(search_string = "Restaurants in Melbourne, Australia",
#'                           page_token = res$next_page_token,
#'                           key = api_key)
#'
#' ## search for a specific place type
#' google_places(location = c(-37.817839,144.9673254),
#'               place_type = "bicycle_store",
#'               radius = 20000,
#'               key = api_key)
#'
#' ## search for places that are open at the time of query
#'  google_places(search_string = "Bicycle shop, Melbourne, Australia",
#'                open_now = TRUE,
#'                key = api_key)
#'
#' }
#' @export
#'
google_places <- function(
  search_string = NULL,
  location = NULL,
  #radar = FALSE,
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
  curl_proxy = NULL,
  key = get_api_key("places"),
  radar = NULL
  ) {

  ## check if both search_string & location == NULL
  if(is.null(search_string) & is.null(location))
    stop("One of 'search_string' or 'location' must be specified")

  if(!is.null(location)){
    location <- validateGeocodeLocation(location)
  }

  logicalCheck(simplify)
  logicalCheck(open_now)

  location <- validateLocationSearch(location, search_string, radius, rankby, keyword, name, place_type)
  radius <- validateRadius(radius)
  rankby <- validateRankBy(rankby, location, search_string)
  radius <- validateRadiusRankBy(rankby, radius, location)
  validateRadar( radar )

  language <- validateLanguage(language)
  name <- validateName(name, search_string)
  price_range <- validatePriceRange(price_range)
  place_type <- validatePlaceType(place_type)
  page_token <- validatePageToken(page_token)

  ## construct the URL
  ## if search string is specified, use the 'textsearch' url
  ## if no search_string, use the 'lat/lon' url
  if(!is.null(search_string)){
    search_string <- gsub(" ", "+", search_string)
    map_url <- paste0("https://maps.googleapis.com/maps/api/place/textsearch/json?query=", search_string)
  }else{
    map_url <- paste0("https://maps.googleapis.com/maps/api/place/nearbysearch/json?")
  }

  map_url <- constructURL(
    map_url
    , c("location" = location
        , "radius" = radius
        , "rankby" = rankby
        , "keyword" = keyword
        , "language" = language
        , "name" = name
        , "type" = place_type
        , "minprice" = price_range[1]
        , "maxprice" = price_range[2]
        , "opennow" = open_now
        , "pagetoken" = page_token
        , "key" = key
        )
    )

  return(
    downloadData(map_url, simplify, curl_proxy)
    )
}



#' Google Find Place
#'
#' A Find Place request takes a text input, and returns a place.
#' The text input can be any kind of Places data, for example, a name, address, or phone number
#'
#'
#' @inheritParams google_places
#' @param input The text input specifying which place to search for
#' (for example, a name, address, or phone number).
#' @param inputtype The type of input. This can be one of either textquery or phonenumber.
#' Phone numbers must be in international format (prefixed by a plus sign ("+"),
#' followed by the country code, then the phone number itself).
#' @param fields vector of place data types to return. All Basic fields are returned by default.
#' See details
#' @param point vector of lat & lon values. Prefer results near this point.
#' @param circle list of two elements, point (vector of lat & lon) and radius.
#' Prefer results in this circle. Ignored if point is supplied
#' @param rectangle list of two elements, sw (vector of lat & lon) and ne (vector of lat & lon)
#' specifying the south-west and north-east bounds of a rectangle. Prefer results
#' in this rectangle. Ignored if either point or circle are supplied
#'
#' @details
#'
#' Fields correspond to place search results
#'  \url{https://developers.google.com/places/web-service/search#PlaceSearchResults}
#' and are divided into three billing categories: Basic, Contact and Atmosphere.
#'
#' Basic fields are billed at base rate, and incur no additional charges. Contact
#' and atmosphere fields are billed at a hihger rate. See pricing sheet for more information
#' \url{https://cloud.google.com/maps-platform/pricing/sheet/?__utma=102347093.1187532699.1510801584.1537138439.1537138439.1&__utmb=102347093.0.10.1537138439&__utmc=102347093&__utmx=-&__utmz=102347093.1537138439.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)&__utmv=-&__utmk=133826830&_ga=2.227832157.1738618203.1537137400-1187532699.1510801584}
#'
#' \itemize{
#'  \item{Basic - }{formatted_address, geometry, icon, id, name, permanently_closed, photos, place_id, plus_code, types}
#'  \item{Contact - }{opening_hours}
#'  \item{Atmosphere - }{price_level, rating}
#' }
#'
#' @seealso \link{google_place_details} \link{google_places}
#'
#' @examples
#' \donttest{
#'
#' ## specifying fields
#' google_find_place(
#'   input = "Museum of Contemporary Art Australia"
#'   , fields = c("photos","formatted_address","name","rating","opening_hours","geometry")
#' )
#'
#' ## Using location bias - circle
#' google_find_place(
#'   input = "Mongolian Grill"
#'   , circle = list(point = c(47.7, -122.2), radius = 2000)
#' )
#'
#' ## finding by a phone number
#' google_find_place(
#'  input = "+61293744000"
#'  , inputtype = "phonenumber"
#' )
#'
#' }
#'
#' @export
google_find_place <- function(
  input,
  inputtype = c("textquery","phonenumber"),
  language = NULL,
  fields = place_fields(),
  point = NULL,
  circle = NULL,
  rectangle = NULL,
  simplify = TRUE,
  curl_proxy = NULL,
  key = get_api_key("find_place")
  ) {


  inputtype <- match.arg(inputtype)
  input <- validateFindInput( input, inputtype )

  logicalCheck(simplify)


  fields <- paste0(fields, collapse = ",")
  point <- validateLocationPoint( point )
  circle <- validateLocationCircle( circle )
  rectangle <- validateLocationRectangle( rectangle )
  locationbias <- validateLocationBias(point, circle, rectangle)

  input <- gsub(" ", "+", input)
  map_url <- paste0("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=", input)

  map_url <- constructURL(
    map_url
    , c("inputtype" = inputtype
        , "fields" = fields
        , "language" = language
        , "locationbias" = locationbias
        , "key" = key
    )
  )

  return(
    downloadData(map_url, simplify, curl_proxy)
  )
}


#' Place Fields
#'
#' Convenience function to return all the valid basic field values for use in a \link{google_find_place}
#' search
#'
#' @export
place_fields <- function() {
  return(
    c(
      "formatted_address"
      ,"geometry"
      ,"icon"
      ,"id"
      ,"name"
      ,"permanently_closed"
      ,"photos"
      ,"place_id"
      ,"plus_code"
      #,"scope"  ## this causes invalid request from Google
      ,"types"
      )
    )
}

