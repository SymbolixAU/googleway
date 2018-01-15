.onAttach <- function(libname, pkgname){

  if(is.null(getOption("googleway"))) {

    options <- list(
      google = list(
        api_key = NA_character_,
        map_key = NA_character_,
        directions_key = NA_character_,
        distance_key = NA_character_,
        elevation_key = NA_character_,
        geocode_key = NA_character_,
        places_key = NA_character_,
        places_autocomplete_key = NA_character_,
        places_details_key = NA_character_,
        roads_key = NA_character_,
        streetview_key = NA_character_,
        timezone_key = NA_character_
      )
    )
  }
  attr(options, "class") <- "googleway_api"
  options(googleway = options)
}


get_api_key <- function(api) {

  ## try and find specific key,
  ## then go for the general one
  api <- getOption("googleway")[['google']][[api]]
  if(is.null(api)) return(get_default_key())

  return(api)

}


#' @export
google_keys <- function() getOption("googleway")


#' @export
print.googleway_api <- function(x, ...) {

  for (i in 1:length(x)) {

    cat("Google APIs\n")

    for (j in 1:length(x[[i]])){
      cat(" - ", names(x[[i]])[j], ": ")
      key <- x[[i]][[j]]
      cat(ifelse(is.na(key), "", key), "\n")
    }
  }
}


get_map_key <- function() {
  key <- getOption("googleway")[['google']][['map_key']]
  if(is.null(key)) return(get_default_key())

  return(key)
}

get_default_key <- function() getOption("googleway")[['google']][['api_key']]

#' Set Key
#'
#' Sets an API key so it's available for all API calls. See details
#'
#' @param api_key Google API key
#' @param api The api for which the key applies. If NULL, the \code{api_key} is
#' assumed to apply to all APIs
#'
#' @export
set_key <- function(api_key, api = c("api_key", "map_key", "directions_key", "distance_key",
                                     "elevation_key", "geocode_key", "places_key",
                                     "places_autocomplete_key", "places_details_key",
                                     "roads_key", "streetview_key","timezone_key")) {

  options <- getOption("googleway")
  api <- match.arg(api)

  options[['google']][[api]] <- api_key
  class(options) <- "googleway_api"
  options(googleway = options)
  invisible(NULL)

}


