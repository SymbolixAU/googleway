% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/google_roads.R
\name{google_speedLimits}
\alias{google_speedLimits}
\title{Speed Limits}
\usage{
google_speedLimits(
  df_path = NULL,
  lat = NULL,
  lon = NULL,
  placeIds = NULL,
  units = c("KPH", "MPH"),
  simplify = TRUE,
  curl_proxy = NULL,
  key = get_api_key("roads")
)
}
\arguments{
\item{df_path}{\code{data.frame} with at least two columns specifying the
latitude & longitude coordinates, with a maximum of 100 pairs of coordinates.}

\item{lat}{string specifying the latitude column}

\item{lon}{string specifying the longitude column}

\item{placeIds}{vector of Place IDs of the road segments. Place IDs are returned in
response to \link{google_snapToRoads}
and \link{google_nearestRoads} reqeusts. You can pass up to 100 placeIds at a time}

\item{units}{Whether to return speed limits in kilometers or miles per hour}

\item{simplify}{\code{logical} - TRUE indicates the returned JSON will be
coerced into a list. FALSE indicates the returend JSON will be returned as a string}

\item{curl_proxy}{a curl proxy object}

\item{key}{\code{string} A valid Google Developers Places API key}
}
\description{
Returns the posted speed limit for a given road segment. In the case of road segments
with variable speed limits, the default speed limit for the segment is returned.
The speed limits service is only available to Google Maps API Premium Plan customers with an Asset Tracking license.
}
\note{
The accuracy of speed limit data returned by Google Maps Roads API can not be
guaranteed. The speed limit data provided is not real-time, and may be estimated,
inaccurate, incomplete, and / or outdated.
}
