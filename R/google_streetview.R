#' Google street view
#'
#' Displays a static street view image from Google Maps Street View Image API
#'
#' @param location numeric vector of lat/lon coordinates, or an address string.
#' @param panorama_id a specific panorama ID.
#' @param size numeric vector of length 2, specifying the output size of the
#' image in pixels, given in \code{width x height}. For example, \code{c(600, 400)}
#' returns an image 600 pixles wide and 400 pixles high.
#' @param heading indicates the compass heading of the camera. Accepted values are
#' from 0 to 360 (both 0 and 360 indicate north), 90 indicates east, 180 south and 270 west.
#' If no heading is specified a value will be calculated that directs the camera
#' to wards the specified \code{location}, from the point at which the closest
#' photograph was taken.
#' @param fov determines the horizontal field of view of the image. The field of
#' view is expressed in degrees, with a maximum allowed value of 120. When dealing
#' with a fixed-size viewport, as with Street View image of a set size, field of
#' view in essence represents zoom, with small numbers indicating a higher level of zoom
#' @param pitch specifies the up or down angle of the camera relative to the
#' Street View vehicle. This is often, but not always, flat horizontal.
#' Positive values angle the camera up (with 90 degrees indicating straight up);
#' negative values angle the camera down (with -90 indicating straight down)
#' @param output specifies whether the result should be displayed in R's viewer,
#' or embedded as HTML inside a webpage.
#' @param response_check logical indicating if the function should first check if
#' the image is available. If TRUE and no image is available, a warning message
#' is printed and no image will be downloaded. if FALSE and no image is available,
#' a blank image will be displayed saying 'Sorry, we have no imagery here'.
#' @param signature a digitial signature used to verify that any site generating
#' requests using your API key is authorised to do so. See Google Documentation
#' for further details \url{https://developers.google.com/maps/documentation/streetview/overview}
#' @param key string. A valid Google Developers Street View Image API key
#' @examples
#' \dontrun{
#'
#' ## download and display an image
#' # key <- "your_api_key"
#' google_streetview(location = c(-37.817714, 144.96726),
#'     size = c(400,400), output = "plot",
#'     key = key)
#'
#'
#' ## no response check - display 'sorry' message
#' google_streetview(location = c(-37.8, 144),
#'    size = c(400,400),
#'    panorama_id = NULL,
#'    output = "plot",
#'    heading = 90,
#'    fov = 90,
#'    pitch = 0,
#'    response_check = FALSE,
#'    key = key)
#'
#'
#' ## embed an image of Flinders Street Station into a Shiny webpage
#' library(shiny)
#' library(googleway)
#'
#' ui <- fluidPage(
#'   uiOutput(outputId = "myStreetview")
#' )
#'
#' server <- function(input, output){
#'   key <- "your_api_key"
#'
#'   output$myStreetview <- renderUI({
#'     tags$img(src = google_streetview(location = c(-37.817714, 144.96726),
#'                                      size = c(400,400), output = "html",
#'                                      key = key),  width = "400px", height = "400px")
#'   })
#' }
#'
#' shinyApp(ui, server)
#'
#' }
#' @export
google_streetview <- function(location = NULL,
                              panorama_id = NULL,
                              size = c(400, 400),
                              heading = NULL,
                              fov = 90,
                              pitch = 0,
                              output = c("plot","html"),
                              response_check = FALSE,
                              signature = NULL,
                              key = get_api_key("streetview")){


  if(is.null(location) & is.null(panorama_id))
    stop("please provide either a location, or a panorama_id")

  if(!is.null(location) & !is.null(panorama_id))
    stop("please provide one of location or panorama_id")

  if(!is.null(location)){
    location <- check_location(location, "location")
  }

  logicalCheck(response_check)
  output <- match.arg(output)

  heading <- validateHeading(heading)
  fov <- validateFov(fov)
  size <- validateSize(size)
  pitch <- validatePitch(pitch)

  if(response_check){
    ## test for imagry
    ## location OR panorama_id
    map_url <- "https://maps.googleapis.com/maps/api/streetview/metadata?"

    map_url <- constructURL(map_url, c("location" = location,
                                       "pano" = panorama_id,
                                       "size" = size,
                                       "heading" = heading,
                                       "fov" = fov,
                                       "pitch" = pitch,
                                       "key" = key))

    if(jsonlite::fromJSON(map_url)$status == "ZERO_RESULTS"){
      return(warning(paste0("No imagary was found at location ", location)))
    }
  }


  ## location OR panorama_id
  map_url <- "https://maps.googleapis.com/maps/api/streetview?"

  map_url <- constructURL(map_url, c("location" = location,
                                     "pano" = panorama_id,
                                     "size" = size,
                                     "heading" = heading,
                                     "fov" = fov,
                                     "pitch" = pitch,
                                     "key" = key))

  ## plot or embed
  if(output == "plot"){

    z <- tempfile()
    utils::download.file(map_url, z, mode = "wb")
    pic <- jpeg::readJPEG(z)
    file.remove(z)
    graphics::plot(0:1,0:1, type="n", ann=FALSE, axes=FALSE)
    return(graphics::rasterImage(pic, 0,0,1,1))
  }else{
    return(map_url)
  }

}
