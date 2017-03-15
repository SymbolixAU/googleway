#ifndef POLYLINE_H_
#define POLYLINE_H_

class Polyline {

  public:
    Polyline();
    explicit Polyline(int precision);
    void encode(Rcpp::NumericVector lat, Rcpp::NumericVector lon, int num_coords, char *output_str);


  private:
    int _precision;
    float _factor;

    void encodeSingleCoord(float coordinate, char *output_str);

  /*
  * @param: base and exponent
  * returns: the power of the base to the exponent, as a float
  */
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

  /**
  * Reimplementing a basic strlen because we don't want to include string.h in an embedded system.
  */
  inline int32_t strlen(char *str) {
    int32_t len = 0;
    while (str[++len]) {}
    return len;
  }
};


#endif


