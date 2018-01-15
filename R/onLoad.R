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


