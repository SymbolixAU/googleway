
# googleway

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/googleway)](http://cran.r-project.org/package=googleway)
![downloads](http://cranlogs.r-pkg.org/badges/grand-total/googleway)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/googleway)](http://cran.r-project.org/web/packages/googleway/index.html)
[![Github Stars](https://img.shields.io/github/stars/SymbolixAU/googleway.svg?style=social&label=Github)](https://github.com/SymbolixAU/googleway)
[![Build Status](https://travis-ci.org/SymbolixAU/googleway.svg?branch=master)](https://travis-ci.org/SymbolixAU/googleway)
[![Coverage Status](https://codecov.io/github/SymbolixAU/googleway/coverage.svg?branch=master)](https://codecov.io/github/SymbolixAU/googleway?branch=master)

Provides a mechanism to access various [Google Maps APIs](https://developers.google.com/maps/), including plotting a Google Map from R and overlaying it with shapes and markers, and retrieving data from the places, directions, roads, distances, geocoding, elevation and timezone APIs.

## v2.2.0

Various bug fixes and a few more features added
see [News](https://github.com/SymbolixAU/googleway/blob/master/NEWS.md) for a list of changes

See [**vignettes**](https://github.com/SymbolixAU/googleway/blob/master/vignettes/googleway-vignette.Rmd) for instructions and examples.

## v2.3.0 - development

### Breaking Changes

The objects returned from map events (e.g., `map_click`, `shape_clik`, `map_zoom`) currently return list objects. I am changing these to return raw JSON


## Installation

```
## install release version from CRAN
install.packages("googleway")

## install the development version from github
devtools::install_github("SymbolixAU/googleway")

```



