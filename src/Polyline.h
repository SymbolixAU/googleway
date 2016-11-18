// #ifndef POLYLINE_H_
// #define POLYLINE_H_
//
// #include <stdint.h>
// #include "datatypes/GPSCoordinate.h"
//
// class Polyline {
//  public:
//   Polyline();
//   explicit Polyline(int precision);
//   void encode(GPSCoordinate coordinates[], int num_coords, char *output_str);
//   int decode(char *str, GPSCoordinate decoded_coords[]);
//
//  private:
//   int _precision = 5;
//   float _factor = power(10, _precision);
//
//   void encodeSingleCoord(float coordinate, char *output_str);
//
//   /*
//   * @param: base and exponent
//   * returns: the power of the base to the exponent, as a float
//   */
//   inline float power(float base, int exponent) {
//     float r = 1.0;
//     if (exponent < 0) {
//       base = 1.0 / base;
//       exponent = -exponent;
//     }
//     while (exponent) {
//       if (exponent & 1)
//         r *= base;
//       base *= base;
//       exponent >>= 1;
//     }
//     return r;
//   }
//
// /**
//  * Reimplementing a basic strlen because we don't want to include string.h in an embedded system.
//  */
//   inline int strlen(char *str) {
//     int len;
//     for (len = 0; str[len]; len++) {}
//     return len;
//   }
// };
//
// #endif  // POLYLINE_H_
