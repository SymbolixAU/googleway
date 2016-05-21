#include <Rcpp.h>
using namespace Rcpp;
using namespace std;

// ------------------------------------------------------
// C++ implementation of the google api polyline decoder
// https://developers.google.com/maps/documentation/utilities/polylineutility
//
// ------------------------------------------------------

// [[Rcpp::export]]
List rcpp_decode( std::string encoded ) {

  int len = encoded.size();
  int index = 0;
  float lat = 0;
  float lng = 0;

  //vector<ofVec2f>* points = new vector<ofVec2f>();

  //NumericVector out(len);

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

    double point;
    //point = lat * (float)1e-5;
    //point = lng * (float)1e-5;
    pointsLat.push_back(lat * (float)1e-5);
    pointsLon.push_back(lng * (float)1e-5);

//    ofVec2f point;
//    point.y = lat * (float)1e-5;
//    point.x = lng * (float)1e-5;
//    points->push_back(point);
  }

  return List::create(Named("lat") = pointsLat,
                      Named("lon") = pointsLon);
}


/*
static vector<ofVec2f>* decode(string encoded) {
  int len = encoded.length();
  int index = 0;
  vector<ofVec2f>* points = new vector<ofVec2f>();
  float lat = 0;
  float lng = 0;

  while (index < len) {
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

    ofVec2f point;
    point.y = lat * (float)1e-5;
    point.x = lng * (float)1e-5;
    points->push_back(point);
  }

  return points;
}
*/
