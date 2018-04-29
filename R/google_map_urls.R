
#' Google Map Url
#'
#' Opens a Google Map in a browser
#'
#' @param center vector of lat/lon coordinates which defines the centre of the map window
#' @param zoom number that sets the zoom level of the map (from 0 to 21)
#' @param basemap defines the typ eof map to display.
#' @param layer defines an extra layer to display on the map, if any.
#'
#' @examples
#' \dontrun{
#'
#' google_map_url()
#'
#' google_map_url(center = c(-37.817727, 144.968246))
#'
#' google_map_url(center = c(-37.817727, 144.968246), zoom = 5)
#'
#' google_map_url(center = c(-37.817727, 144.968246), basemap = "terrain")
#'
#' google_map_url(center = c(-37.817727, 144.968246), layer = "traffic")
#'
#' }
#' @export
google_map_url <- function(center = NULL,
                           zoom = 15,
                           basemap = c("roadmap", "satellite", "terrain"),
                           layer = c("none", "transit", "traffic", "bicycling")) {

  mapUrl <- "https://www.google.com/maps/@?api=1&map_action=map"

  basemap <- match.arg(basemap)
  layer <- match.arg(layer)

  center <- paste0(center, collapse = ",")

  urlArgs <- c(
    center = center,
    zoom = zoom,
    basemap = basemap,
    layer = layer
    )

  utils::browseURL(
    utils::URLencode(
      constructURL(mapUrl, urlArgs)
    )
  )
}

#' Google Map Search
#'
#' Opens a Google Map in a browser with the result of the specified search query.
#'
#' @note There is no need for an api key
#'
#' @param query string or vector of lat/lon coordinates (in that order)
#' @param place_id a Google place id (\url{https://developers.google.com/places/place-id}).
#'
#' @details
#' If both parameters are given, the \code{query} is only used if Google Maps cannot
#' find the \code{place_id}.
#'
#' @examples
#' \dontrun{
#'
#' google_map_search("Melbourne, Victoria")
#'
#' google_map_search("Restaruants")
#'
#' ## Melbourne Cricket Ground
#' google_map_search(c(-37.81997, 144.9834), place_id = "ChIJgWIaV5VC1moR-bKgR9ZfV2M")
#'
#' ## Without the place_id, no additional place inforamtion is displayed on the map
#' google_map_search(c(-37.81997, 144.9834))
#'
#' }
#'
#' @export
google_map_search <- function(
  query,
  place_id = NULL) {

  mapUrl <- "https://www.google.com/maps/search/?api=1"

  query <- validateLocationQuery(query)

  urlArgs <- c(query = query, query_place_id = place_id)

  utils::browseURL(
    utils::URLencode(
      constructURL(mapUrl, urlArgs)
    )
  )
}

validateLocationQuery <- function(query) UseMethod("validateLocationQuery")

#' @export
validateLocationQuery.character <- function(query) query

#' @export
validateLocationQuery.numeric <- function(query) {
  if(length(query) != 2)
    stop("Expecting either a string or a vector of lat/lon coordinates")

  return(
    paste0(query, collapse = ",")
  )
}

validateLocationQuery.default <- function(query) stop("Unknown query type")

#' Google Map Directions
#'
#' Opens Google Maps in a browser with the resutls of the specified directions query
#'
#' @note There is no need for an api key
#'
#' Waypoints are not supported on all Google Map products. In those cases, this parameter
#' will be ignored.
#'
#' @param origin string of an address or search term, or vector of lat/lon coordinates
#' @param origin_place_id a Google place id (\url{https://developers.google.com/places/place-id}).
#' If used, you must also specify an \code{origin}
#' @param destination string of an address or vector of lat/lon coordinates
#' @param destination_place_id a Google place id (\url{https://developers.google.com/places/place-id}).
#' If used, you must also specify an \code{destination}
#' @param travel_mode one of \code{driving}, \code{walking}, \code{bicycling} or
#' \code{transit}. If not supplied, the Google Map will show one or more of the
#' most relevant modes for the route.
#' @param dir_action can only be "navigate". If set, the map will attempt to launch turn-by-turn navigation
#' or route preview to the destination.
#' @param waypoints List of either place names, addresses, or \code{vectors} of lat/lon coordinates.
#' Up to 3 are allowed on mobile devices, and up to 9 otherwise.
#' @param waypoint_place_ids vector of \code{place_id}s to match against the list of \code{waypoints}.
#' If used, the \code{waypoints} must also be used.
#'
#'
#' @examples
#' \dontrun{
#'
#' google_map_directions(origin = "Google Pyrmont NSW",
#'   destination = "QVB, Sydney", destination_place_id = "ChIJISz8NjyuEmsRFTQ9Iw7Ear8",
#'   travel_mode = "walking")
#'
#'
#' google_map_directions(origin = "Melbourne Cricket Ground",
#'   destination = "Flinders Street Station",
#'   dir_action = "navigate")
#'
#' google_map_directions(origin = "Melbourne Cricket Ground",
#'   destination = "Flinders Street Station",
#'   travel_mode = "walking",
#'   waypoints = list("National Gallery of Victoria", c(-37.820860, 144.961894)))
#'
#'
#' google_map_directions(origin = "Paris, France",
#'   destination = "Cherbourg, France",
#'   travel_mode = "driving",
#'   waypoints = list("Versailles, France", "Chartres, France", "Le Mans, France",
#'     "Caen, France"))
#'
#'
#' google_map_directions(origin = "Paris, France",
#'   destination = "Cherbourg, France",
#'   travel_mode = "driving",
#'   waypoints = list("Versailles, France", "Chartres, France", "Le Mans, France",
#'     "Caen, France"),
#'   waypoint_place_ids = list("ChIJdUyx15R95kcRj85ZX8H8OAU",
#'   "ChIJKzGHdEgM5EcR_OBTT3nQoEA", "ChIJG2LvQNCI4kcRKXNoAsPi1Mc", "ChIJ06tnGbxCCkgRsfNjEQMwUsc"))
#'
#' }
#'
#' @export
google_map_directions <- function(
  origin = NULL,
  origin_place_id = NULL,
  destination = NULL,
  destination_place_id = NULL,
  travel_mode = NULL,
  dir_action = NULL,
  waypoints = NULL,
  waypoint_place_ids = NULL) {

  mapUrl <- "https://www.google.com/maps/dir/?api=1"

  if(!is.null(origin_place_id) && is.null(origin) )
    stop("You must supply an origin with an origin_place_id")

  if(!is.null(destination_place_id) && is.null(destination) )
    stop("You must supply an destination with an destination_place_id")

  origin <- validateLocationQuery(origin)
  destination <- validateLocationQuery(destination)

  if(!is.null(travel_mode))
    travel_mode <- match.arg(travel_mode, c("driving", "walking", "bicycling", "transit"))

  if(!is.null(dir_action))
    dir_action <- match.arg(dir_action, c("navigate"))

  if(!is.null(waypoint_place_ids) && is.null(waypoints))
    stop("You must supply waypoints along with the waypoint_place_ids")

  if(!is.null(waypoint_place_ids)){
    if(length(waypoint_place_ids) != length(waypoints)){
      stop("Different lengts of waypoints and waypoint_place_ids")
    }else{
      waypoint_place_ids <- paste0(waypoint_place_ids, collapse = "|")
    }
  }

  if(!is.null(waypoints))
    waypoints <- constructWaypoints2(waypoints)

  urlArgs <- c(
    origin = origin,
    destination = destination,
    origin_place_id = origin_place_id,
    destination_place_id = destination_place_id,
    travelmode = travel_mode,
    dir_action = dir_action,
    waypoints = waypoints,
    waypoint_place_ids = waypoint_place_ids
  )

  utils::browseURL(
    utils::URLencode(
      constructURL(mapUrl, urlArgs)
    )
  )

}

constructWaypoints2 <- function(waypoints) UseMethod("constructWaypoints2")

#' @export
constructWaypoints2.list <- function(waypoints) {
  paste0(sapply(waypoints, validateLocationQuery), collapse = "|")
}

#' @export
constructWaypoints2.default <- function(waypoints) stop("I was expecting a list of waypoints")



#' Google Map Panorama
#'
#' Opens an interactive street view panorama in a browser
#'
#' @param viewpoint vector of lat/lon coordinates. If NULL, \code{pano} must be used.
#' @param pano string of a specific panorama ID (see \url{https://developers.google.com/maps/documentation/urls/guide#pano-id}).
#' If NULL, \code{viewpoint} must be used.
#' @param heading number between -180 and 360. Indicates the compass heading of the camera
#' in degrees clockwise from north.
#' @param pitch number between -90 and 90, specifying the angle, up or down, of the camera
#' @param fov number between 10 and 100, determines the orizontal field of view
#' of the image.
#'
#' @examples
#' \dontrun{
#'
#' google_map_panorama(viewpoint = c(48.857832, 2.295226))
#'
#' google_map_panorama(viewpoint = c(48.857832,2.295226),
#'   heading = -90, pitch = 38, fov = 80)
#'
#' google_map_panorama(pano = "4U-oRQCNsC6u7r8gp02sLA")
#'
#'
#' }
#' @export
google_map_panorama <- function(
  viewpoint = NULL,
  pano = NULL,
  heading = NULL,
  pitch = 0,
  fov = 90
) {

  if(is.null(viewpoint) && is.null(pano))
    stop("one of viewpoint or pano must be used")

  if(!is.null(viewpoint)) viewpoint <- paste0(viewpoint, collapse = ",")

  mapUrl <- "https://www.google.com/maps/@?api=1&map_action=pano"

  heading <- validatePanoHeading(heading)
  fov <- validatePanoFov(fov)
  pitch <- validatePitch(pitch)

  urlArgs <- c(
    viewpoint = viewpoint,
    pano = pano,
    heading = heading,
    pitch = pitch,
    fov = fov
  )

  utils::browseURL(
    utils::URLencode(
      constructURL(mapUrl, urlArgs)
    )
  )


}

validatePanoFov <- function(fov) {
  if(is.null(fov)) return(NULL)
  UseMethod("validatePanoFov")
}

#' @export
validatePanoFov.numeric <- function(fov) {
  if(length(fov) != 1)
    stop("expecting a single fov value")

  if(fov < 10 || fov > 100)
    stop("expecting a fov value between 10 and 100")

  fov
}


#' @export
validatePanoFov.default <- function(fov) stop("expecting a number between 10 and 100")

validatePanoHeading <- function(heading) {
  if(is.null(heading)) return(NULL)
  UseMethod("validatePanoHeading")
}

#' @export
validatePanoHeading.numeric <- function(heading) {
  if(length(heading) != 1)
    stop("expecting a single heading value")

  if(heading < -180 || heading > 360)
    stop("expecting a heading value between -180 and 360")

  heading
}


#' @export
validatePanoHeading.default <- function(heading) stop("Expecting a number between -180 and 360")

