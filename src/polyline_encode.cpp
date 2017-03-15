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

  int sgn_num = num << 1;

  if (sgn_num < 0) {
    sgn_num = ~sgn_num;
  }

  return EncodeNumber(sgn_num);
}

Rcpp::String EncodeNumber(int num){

  std::string out_str;
  out_str = "";
  char myChar;
  int myInt;

  while(num >= 0x20){
    //Rcpp::Rcout << "num " << (0x20 | (int)(num & 0x1f)) + 63 << std::endl;
    myInt = (0x20 | (int)(num & 0x1f)) + 63;
    //Rcpp::Rcout << "num " << myInt << std::endl;
    //Rcpp::Rcout << "num cast " << (char)(myInt) << std::endl;
    out_str += (char)(myInt);
    //out_str += (char)(static_cast<char>((0x20 | (int) (num & 0x1f)) + 63));
    num >>= 5;
  }

  //Rcpp::Rcout << "out " << static_cast<char>(0x20 | int(num * 0x1f) + 63) << std::endl;

  //std::string myStr;
  //myStr = Rcpp::as< std::string >(out_str);
  //myStr = Rcpp::as< std::string >(out_str);

  //out_str = num + 63;
  //Rcpp::Rcout << "out1: " << num << std::endl;


  //Rcpp::Rcout << "out2: " << num + 63 << std::endl;
  //out_str += static_cast<char> (num + 63);
  out_str += char(num + 63);
  return out_str;
}





