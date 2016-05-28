#include <Rcpp.h>
using namespace Rcpp;
using namespace std;

// ------------------------------------------------------
// C++ implementation of the google api polyline decoder
// https://developers.google.com/maps/documentation/utilities/polylineutility
//
// This code is adapted from an Open Frameworks implementation
// and used in this package with the permission of the author
// https://github.com/paulobarcelos/ofxGooglePolyline
//
// ------------------------------------------------------

// [[Rcpp::export]]
DataFrame rcpp_decode_pl( std::string encoded ) {

  int len = encoded.size();
  int index = 0;
  float lat = 0;
  float lng = 0;

  NumericVector pointsLat;
  NumericVector pointsLon;

  while (index < len){
    char b;
    int shift = 0;
    int result = 0;
    do {
      b = encoded.at(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    float dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.at(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    float dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    pointsLat.push_back(lat * (float)1e-5);
    pointsLon.push_back(lng * (float)1e-5);
  }

  return DataFrame::create(Named("lat") = pointsLat,
                           Named("lon") = pointsLon);
}
