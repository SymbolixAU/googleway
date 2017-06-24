#' Google place details
#'
#' Once you have a place_id from a Place Search, you can request more details
#' about a particular establishment or point of interest by initiating a Place
#' Details request. A Place Details request returns more comprehensive information
#' about the indicated place such as its complete address, phone number, user
#' rating and reviews.
#'
#'
#' @param place_id \code{string} A textual identifier that uniquely identifies a
#' place, usually of the form \code{ChIJrTLr-GyuEmsRBfy61i59si0}, returned from
#' a place search
#' @param language \code{string} The language code, indicating in which language
#' the results should be returned, if possible. Searches are also biased to the
#' selected language; results in the selected language may be given a higher ranking.
#' See the list of supported languages and their codes
#' \url{https://developers.google.com/maps/faq#languagesupport}
#' @param simplify \code{logical} - TRUE indicates the returned JSON will be coerced into a list. FALSE indicates the returend JSON will be returned as a string
#' @param key \code{string} A valid Google Developers Places API key
#'
#' @seealso \link{google_places}
#'
#' @examples
#' \dontrun{
#' ## search for a specific restaurant, Maha, in Melbourne, firstly using google_places()
#' res <- google_places(search_string = "Maha Restaurant, Melbourne, Australia",
#'                      radius = 1000,
#'                      key = key)
#'
#' ## request more details about the restaurant using google_place_details()
#' google_place_details(place_id = res$results$place_id, key = key)
#'
#' }
#' @export

google_place_details <- function(place_id,
                                 language = NULL,
                                 simplify = TRUE,
                                 key){

  ## language check
  if(!is.null(language) & (class(language) != "character" | length(language) > 1))
    stop("language must be a single character vector or string")

  if(!is.null(language))
    language <- tolower(language)

  LogicalCheck(simplify)

  map_url <- "https://maps.googleapis.com/maps/api/place/details/json?"

  map_url <- constructURL(map_url, c("placeid" = place_id,
                                     "language" = language,
                                     "key" = key))


  return(fun_download_data(map_url, simplify))

}
