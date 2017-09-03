
#' Access Result
#'
#' Methods for accessing specific elements of a Google API query.
#'
#' @param res result from a Google API query
#' @param result the specific field of the result you want to access
#'
#' @examples
#' \dontrun{
#'
#' apiKey <- "your_api_key"
#'
#' ## results returned as a list (simplify == TRUE)
#' lst <- google_directions(origin = c(-37.8179746, 144.9668636),
#'                         destination = c(-37.81659, 144.9841),
#'                         mode = "walking",
#'                         key = apiKey,
#'                         simplify = TRUE)
#'
#' ## results returned as raw JSON character vector
#' js <- google_directions(origin = c(-37.8179746, 144.9668636),
#'                          destination = c(-37.81659, 144.9841),
#'                         mode = "walking",
#'                          key = apiKey,
#'                          simplify = FALSE)
#'
#' access_result(js, "polyline")
#' "zgyeFiyxsZe@_CMu@_@gBO_@OKs@sDG[q@qDeAiFAi@[mBi@sB[oB@o@DmBLeB|@kMp@{Jj@aKZsFA]Hm@Di@LwCm@{@KSDq@"
#'
#' direction_polyline(js)
#' "zgyeFiyxsZe@_CMu@_@gBO_@OKs@sDG[q@qDeAiFAi@[mBi@sB[oB@o@DmBLeB|@kMp@{Jj@aKZsFA]Hm@Di@LwCm@{@KSDq@"
#'
#' }
#' @export
access_result <- function(res,
                          result = c("instructions", "routes", "legs", "steps",
                                     "points", "polyline", "coordinates", "address")){
  result <- match.arg(result)
  func <- getFunc(result)

  do.call(paste0(func, "_", result), list(res))
}

getFunc <- function(res){
  switch(res,
         "instructions" = "direction",
         "routes" = "direction",
         "legs" = "direction",
         "steps" = "direction",
         "points" = "direction",
         "polyline" = "direction",
         "coordinates" = "geocode",
         "address" = "geocode")
}

resultJs <- function(js, jqr_string) jqr::jq(js, jqr_string)

jsAccessor <- function(resType){
  switch(resType,
         "routes" = ".routes[]",
         "legs" = ".routes[].legs[]",
         "steps" = ".routes[].legs[].steps",
         "points" = ".routes[].legs[].steps[].polyline.points",
         "polyline" = ".routes[].overview_polyline.points",
         "instructions" = ".routes[].legs[].steps[].html_instructions")
}
