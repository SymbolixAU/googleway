#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
  Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP googleway_rcpp_decode_pl(SEXP);
extern SEXP googleway_rcpp_encode_pl(SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"googleway_rcpp_decode_pl", (DL_FUNC) &googleway_rcpp_decode_pl, 1},
  {"googleway_rcpp_encode_pl", (DL_FUNC) &googleway_rcpp_encode_pl, 3},
  {NULL, NULL, 0}
};

void R_init_googleway(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
