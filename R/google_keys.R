#' Google Keys
#'
#' Retrieves the list of Google Keys that have been set.
#'
#' @export
google_keys <- function() getOption("googleway")


#' @export
print.googleway_api <- function(x, ...) {

  for (i in 1:length(x)) {

    cat("Google API keys\n")

    for (j in 1:length(x[[i]])){
      cat(" - ", names(x[[i]])[j], ": ")
      key <- x[[i]][[j]]
      cat(ifelse(is.na(key), "", key), "\n")
    }
  }
}

#' Set Key
#'
#' Sets an API key so it's available for all API calls. See details
#'
#' @param key Google API key
#' @param api The api for which the key applies. If NULL, the \code{api_key} is
#' assumed to apply to all APIs
#'
#' @details
#' Use \code{set_key} to make API keys available for all the \code{google_}
#' functions, so you don't need to specify the \code{key} parameter within those
#' functions (for example, see \link{google_directions}).
#'
#' The \code{api} argument is useful if you use a different API key to access
#' different APIs. If you just use one API key to access all the APIs,
#' there is no need to specify the \code{api} parameter, the default value \code{api_key}
#' will be used.
#'
#' @examples
#'
#' ## not specifying 'api' will add the key to the 'api_key' list element
#' set_key(key = "xxx_your_api_key_xxx")
#'
#' ## api key for directions
#' set_key(key = "xxx_your_api_key_xxx", api = "directions")
#'
#' ## api key for maps
#' set_key(key = "xxx_your_api_key_xxx", api = "map")
#'
#'
#' @export
set_key <- function(
  key,
  api = c("default", "map", "directions", "distance","elevation", "geocode",
          "places","place_autocomplete", "places_details","roads", "streetview",
          "timezone")
) {

  options <- getOption("googleway")
  api <- match.arg(api)

  options[['google']][[api]] <- key
  class(options) <- "googleway_api"
  options(googleway = options)
  invisible(NULL)

}


#' Clear Keys
#'
#' Clears all the API keys
#'
#' @export
clear_keys <- function() {

  options <- list(
    google = list(
      default = NA_character_,
      map = NA_character_,
      directions = NA_character_,
      distance = NA_character_,
      elevation = NA_character_,
      geocode = NA_character_,
      places = NA_character_,
      place_autocomplete = NA_character_,
      place_details = NA_character_,
      reverse_geocode = NA_character_,
      roads = NA_character_,
      streetview = NA_character_,
      timezone = NA_character_
    )
  )
  attr(options, "class") <- "googleway_api"
  options(googleway = options)

}

get_api_key <- function(api) {

  ## try and find specific key,
  ## then go for the general one
  api <- getOption("googleway")[['google']][[api]]
  if(is.na(api)) return(get_default_key())

  return(api)
}


get_default_key <- function() {
  key <- getOption("googleway")[['google']][['default']]
  if(is.na(key)) stop("No API key provided. Use either set_key() to set a key, or provide it as a function argument in the 'key' parameter")
  return(key)

}



