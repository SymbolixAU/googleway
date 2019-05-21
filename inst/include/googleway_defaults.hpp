#ifndef R_GOOGLEWAY_DEFAULTS_H
#define R_GOOGLEWAY_DEFAULTS_H

#include <Rcpp.h>

namespace googleway {
namespace defaults {

// dont' necessarily need polyline anymore
inline Rcpp::StringVector default_polyline( int n ) {
  Rcpp::StringVector sv(n);
  return sv;
}

inline Rcpp::NumericVector default_lon( int n ) {
  Rcpp::NumericVector nv(n, 0.0);
  return nv;
}

inline Rcpp::NumericVector default_lat( int n ) {
  Rcpp::NumericVector nv(n, 0.0);
  return nv;
}

inline Rcpp::IntegerVector default_radius( int n ) {
  Rcpp::IntegerVector iv(n, 1000);
  return iv;
}

inline Rcpp::NumericVector default_fill_colour( int n ) {
  Rcpp::NumericVector nv(n, 1.0);
  return nv;
}

inline Rcpp::NumericVector default_stroke_colour( int n ) {
  Rcpp::NumericVector nv(n, 1.0);
  return nv;
}

inline Rcpp::NumericVector default_fill_opacity( int n ) {
  Rcpp::NumericVector nv(n, 76.5);  // 255 * 0.3
  return nv;
}

inline Rcpp::NumericVector default_stroke_opacity( int n ) {
  Rcpp::NumericVector nv(n, 153.0);  // 255 * 0.6
  return nv;
}

inline Rcpp::NumericVector default_stroke_width( int n ) {
  Rcpp::NumericVector nv(n, 1.0);
  return nv;
}

inline Rcpp::NumericVector default_weight( int n ) {
  Rcpp::NumericVector nv(n, 1.0);
  return nv;
}

} // namespace defaults
} // namespace googleway



#endif
