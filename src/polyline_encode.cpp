#include <Rcpp.h>
#include <stdint.h>
using namespace Rcpp;


// ref: https://briancaos.wordpress.com/2009/10/16/google-maps-polyline-encoding-in-c/

Rcpp::String EncodeSignedNumber(int num);
Rcpp::String EncodeNumber(int num);

// [[Rcpp::export]]
Rcpp::String rcpp_encode_pl(Rcpp::NumericVector latitude,
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

  int sgn_num = num << 1;

  if (sgn_num < 0) {
    sgn_num = ~sgn_num;
  }

  return EncodeNumber(sgn_num);
}

Rcpp::String EncodeNumber(int num){

  std::string out_str;

  while(num >= 0x20){
    out_str += (char)(0x20 | (int)(num & 0x1f)) + 63;
    num >>= 5;
  }

  out_str += char(num + 63);
  return out_str;
}





