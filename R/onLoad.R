.onLoad <- function(...){

  if(is.null(getOption("googleway"))) {

    options <- list(
      google = list(
        default = NA_character_,
        map = NA_character_,
        directions = NA_character_,
        distance = NA_character_,
        elevation = NA_character_,
        geocode = NA_character_,
        places = NA_character_,
        find_place = NA_character_,
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
}


