% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/results_access.R, R/results_directions.R,
%   R/results_distance.R, R/results_elevation.R, R/results_geocode.R,
%   R/results_places.R, R/results_roads.R
\name{access_result}
\alias{access_result}
\alias{direction_instructions}
\alias{direction_routes}
\alias{direction_legs}
\alias{direction_steps}
\alias{direction_points}
\alias{direction_polyline}
\alias{distance_origins}
\alias{distance_destinations}
\alias{distance_elements}
\alias{elevation}
\alias{elevation_location}
\alias{geocode_coordinates}
\alias{geocode_address}
\alias{geocode_address_components}
\alias{geocode_place}
\alias{geocode_type}
\alias{place}
\alias{place_next_page}
\alias{place_name}
\alias{place_location}
\alias{place_type}
\alias{place_hours}
\alias{place_open}
\alias{nearest_roads_coordinates}
\title{Access Result}
\usage{
access_result(
  res,
  result = c("instructions", "routes", "legs", "steps", "points", "polyline",
    "coordinates", "address", "address_components", "geo_place_id", "dist_origins",
    "dist_destinations", "elevation", "elev_location", "place", "place_name",
    "next_page", "place_location", "place_type", "place_hours", "place_open")
)

direction_instructions(res)

direction_routes(res)

direction_legs(res)

direction_steps(res)

direction_points(res)

direction_polyline(res)

distance_origins(res)

distance_destinations(res)

distance_elements(res)

elevation(res)

elevation_location(res)

geocode_coordinates(res)

geocode_address(res)

geocode_address_components(res)

geocode_place(res)

geocode_type(res)

place(res)

place_next_page(res)

place_name(res)

place_location(res)

place_type(res)

place_hours(res)

place_open(res)

nearest_roads_coordinates(res)
}
\arguments{
\item{res}{result from a Google API query}

\item{result}{the specific field of the result you want to access}
}
\description{
Methods for accessing specific elements of a Google API query.
}
\section{Functions}{
\itemize{
\item \code{direction_instructions}: the instructions from a directions query

\item \code{direction_routes}: the routes from a directions query

\item \code{direction_legs}: the legs from a directions query

\item \code{direction_steps}: the steps from a directions query

\item \code{direction_points}: the points from a directions query

\item \code{direction_polyline}: the encoded polyline from a direction query

\item \code{distance_origins}: the origin addresses from a distance query

\item \code{distance_destinations}: the destination addresses from a distance query

\item \code{distance_elements}: the element results from a distance query

\item \code{elevation}: the elevation from an elevation query

\item \code{elevation_location}: the elevation from an elevation query

\item \code{geocode_coordinates}: the coordinates from a geocode or reverse geocode query

\item \code{geocode_address}: the formatted address from a geocode or reverse geocode query

\item \code{geocode_address_components}: the address components from a geocode or reverse geocode query

\item \code{geocode_place}: the place id from a geocode or reverse geocode query

\item \code{geocode_type}: the geocoded place types from a geocode or reverse geocode query

\item \code{place}: the place_id from a places query

\item \code{place_next_page}: the next page token from a places query

\item \code{place_name}: the place name from a places query

\item \code{place_location}: the location from a places query

\item \code{place_type}: the type of place from a places query

\item \code{place_hours}: the opening hours from a place details query

\item \code{place_open}: the open now result from a place details query

\item \code{nearest_roads_coordinates}: the coordinates from a nearest roads query
}}

\examples{
\dontrun{

apiKey <- "your_api_key"

## results returned as a list (simplify == TRUE)
lst <- google_directions(origin = c(-37.8179746, 144.9668636),
                        destination = c(-37.81659, 144.9841),
                        mode = "walking",
                        key = apiKey,
                        simplify = TRUE)

## results returned as raw JSON character vector
js <- google_directions(origin = c(-37.8179746, 144.9668636),
                         destination = c(-37.81659, 144.9841),
                        mode = "walking",
                         key = apiKey,
                         simplify = FALSE)

access_result(js, "polyline")

direction_polyline(js)

}
}
