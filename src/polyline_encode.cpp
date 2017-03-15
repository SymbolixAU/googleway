#include <Rcpp.h>
#include <stdint.h>
using namespace Rcpp;

// ref: https://briancaos.wordpress.com/2009/10/16/google-maps-polyline-encoding-in-c/

Rcpp::String EncodeSignedNumber(int num);
Rcpp::String EncodeNumber(int num);

// [[Rcpp::export]]
Rcpp::String EncodeCoordinates(Rcpp::NumericVector latitude,
                               Rcpp::NumericVector longitude,
                               int num_coords){

  int plat = 0;
  int plon = 0;
  String output_str;

  for(int i = 0; i < num_coords; i++){
    int late5 = latitude[i] * 1e5;
    int lone5 = longitude[i] * 1e5;

    output_str += EncodeSignedNumber(late5 - plat);
    output_str += EncodeSignedNumber(lone5 - plon);

    plat = late5;
    plon = lone5;
  }
  return output_str;
}


Rcpp::String EncodeSignedNumber(int num){

  Rcpp::Rcout << "num " << num << std::endl;
  int sgn_num = num << 1;
  Rcpp::Rcout << "sign_num " << sgn_num << std::endl;

  if (sgn_num < 0) {
    sgn_num = ~sgn_num;
  }

  return EncodeNumber(sgn_num);

}

Rcpp::String EncodeNumber(int num){

  String out;

  while(num >= 0x20){
    //Rcpp::Rcout << "out " << (0x20 | num * 0x1f) + 63 << std::endl;
    out += static_cast<char> (static_cast<char> (0x20 | (int) (num & 0x1f)) + 63);
    num >>= 5;
  }

  Rcpp::Rcout << "out: " << num + 63 << std::endl;
  out += static_cast<char>(num + 63);

  return out;
}

/**

//Polyline::Polyline(int precision) {
//  _precision = 5;
//  _factor = power(10, _precision);
//}

//Polyline::Polyline() { }

//void encodePolyline(NumericVector lat, NumericVector lon, int num_coords, char *output_str);
void encodeSingleCoord(float coordinate, char *output_str);
float power(float base, int exponent);
int32_t strlen(char *str);


// [[Rcpp::export]]
Rcpp::String encode(NumericVector lat, NumericVector lon, int num_coords) {

  char out;
  char *output_str = new char();

  encodeSingleCoord(lat[0], output_str);
  encodeSingleCoord(lon[0], output_str);

  for (int i = 1; i < num_coords; i++) {
    encodeSingleCoord(lat[i] - lat[i - 1], output_str);
    encodeSingleCoord(lon[i] - lon[i - 1], output_str);
    Rcpp::Rcout << "out " << output_str << std::endl;
  }

  //out = *output_str;
  return out;
}


void encodeSingleCoord(float coordinate, char *output_str) {

  int32_t intCoord = (int32_t) (coordinate * power(10, 3));
  intCoord <<= (int32_t) 1;

  if (intCoord < 0) {
    intCoord = ~intCoord;
  }

  int index;
  for (index = 0; output_str[index]; index++) { }

  while (intCoord >= 0x20) {
    output_str[index++] = static_cast<char> (static_cast<char> (0x20 | (int32_t) (intCoord & 0x1f)) + 63);
    intCoord >>= (int32_t) 5;
  }

  output_str[index] = static_cast<char> (intCoord + 63);
}


inline int32_t strlen(char *str) {
  int32_t len = 0;
  while (str[++len]) {}
  return len;
}

inline float power(float base, int exponent) {
  float r = 1.0;
  if (exponent < 0) {
    base = r / base;
    exponent = -exponent;
  }
  while (exponent) {
    if (exponent & 1)
      r *= base;
    base *= base;
    exponent >>= 1;
  }
  return r;
}
**/
