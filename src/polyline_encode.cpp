// #include <Rcpp.h>
// #include "Polyline.h"
// using namespace Rcpp;
// using namespace std;
//
//
// Polyline::Polyline() { }
//
// /**
// * Encodes the given latitude, longitude coordinates.
// *
// * @param {float[2]} coordinates
// *  coordinates[0] = latitude
// *  coordinates[1] = longitude
// * @param {char*} output_str - The output c-string that is passed back by reference.
// */
// void Polyline::encode(GPSCoordinate gpsCoordinates[], int num_coords, char *output_str) {
//
//
//
// //  encodeSingleCoord(gpsCoordinates[0].latitude(), output_str);
// //  encodeSingleCoord(gpsCoordinates[0].longitude(), output_str);
//
// //  for (int i = 1; i < num_coords && !gpsCoordinates[i].is_empty(); i++) {
// //    encodeSingleCoord(gpsCoordinates[i].latitude() - gpsCoordinates[i - 1].latitude(), output_str);
// //    encodeSingleCoord(gpsCoordinates[i].longitude() - gpsCoordinates[i - 1].longitude(), output_str);
// //  }
// }
//
//
// /**
//  * Based off https://developers.google.com/maps/documentation/utilities/polylinealgorithm
//  */
// void Polyline::encodeSingleCoord(float coordinate, char *output_str) {
//   int32_t int_coord = (int32_t) (coordinate * _factor);
//   int_coord <<= (int32_t) 1;
//
//   if (int_coord < 0) {
//     int_coord = ~int_coord;
//   }
//
//   int index;
//   for (index = 0; output_str[index]; index++) {}
//
//   for (index; int_coord >= 0x20; index++) {
//     output_str[index] = static_cast<char> (static_cast<char> (0x20 | (int32_t) (int_coord & 0x1f)) + 63);
//     int_coord >>= (int32_t) 5;
//   }
//   output_str[index] = static_cast<char> (int_coord + 63);
// }
