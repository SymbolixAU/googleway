context("parameter checks")

test_that("lat and lon columns are successfully found", {

  expect_true(names(googleway:::latitude_column(data.frame(lat = c(1,2,3)), lat = NULL, "tests")) == "lat")
  expect_true(names(googleway:::latitude_column(data.frame(latitude = c(1,2,3)), lat = NULL, "tests")) == "lat")
  expect_true(names(googleway:::latitude_column(data.frame(lats = c(1,2,3)), lat = NULL, "tests")) == "lat")
  expect_true(names(googleway:::latitude_column(data.frame(latitudes = c(1,2,3)), lat = NULL, "tests")) == "lat")
  expect_error(names(googleway:::latitude_column(data.frame(myLat = c(1,2,3)), lat = NULL, "tests")) == "lat")
  expect_true(names(googleway:::longitude_column(data.frame(lon = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(longitude = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(lons = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(longitudes = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(lng = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(lngs = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(long = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_true(names(googleway:::longitude_column(data.frame(longs = c(1,2,3)), lon = NULL, "tests")) == "lng")
  expect_error(names(googleway:::longitude_column(data.frame(myLon = c(1,2,3)), lon = NULL, "tests")) == "lat")

})


test_that("opacity values between 0 and 1", {
  expect_error(googleway:::check_opacities(data.frame(o = 2), "o"),
               "opacity values for o must be between 0 and 1")
})

test_that("column check works", {
  expect_error(googleway:::check_for_columns(data.frame(col1 = "hi"),"col2"),
               "Could not find columns: col2 in the data")
})

test_that("hex colours works", {
  expect_error(googleway:::check_hex_colours(data.frame(hex = "123"), "hex"),
               "Incorrect colour specified in hex. Make sure the colours in the column are valid hexadecimal HTML colours")
})

test_that("LogicalCheck handles various arguments", {

  expect_silent(googleway:::logicalCheck(TRUE))
  expect_error(googleway:::logicalCheck("TRUE"), 'TRUE" must be logical - TRUE or FALSE')
  expect_error(googleway:::logicalCheck(c(T, F)))

})

test_that("latitude column is found", {

  df <- data.frame(myLat = c(1))
  expect_error(
    googleway:::latitude_column(df, NULL, 'test'),
    "Couldn't infer latitude column for test"
  )

  expect_error(
    googleway:::latitude_column(df, 'lat', 'test'),
    "Could not find columns: lat in the data"
  )

  df <- data.frame(lat = c(1))
  expect_silent(googleway:::latitude_column(df, NULL, 'test'))
})

test_that("longitude column is found", {

  df <- data.frame(myLon = c(1))
  expect_error(
    googleway:::longitude_column(df, NULL, 'test'),
    "Couldn't infer longitude columns for test"
  )

  expect_error(
    googleway:::longitude_column(df, 'lon', 'test'),
    "Could not find columns: lon in the data"
  )

  df <- data.frame(lon = c(1))
  expect_silent(googleway:::longitude_column(df, NULL, 'test'))
})

test_that("lat & lon are found", {

  df <- data.frame(lat = c(1), lon = c(1))
  expect_equal(googleway:::find_lat_column(names(df), 'test'), "lat")
  expect_equal(googleway:::find_lon_column(names(df), 'test'), "lon")

  df <- data.frame(latitude = c(1), lons = c(1))
  expect_equal(googleway:::find_lat_column(names(df), 'test'), "latitude")
  expect_equal(googleway:::find_lon_column(names(df), 'test'), "lons")

})

test_that("lat & lon return NA if error", {

  df <- data.frame(lat = 1, lats = 2)

  expect_true(is.na(googleway:::find_lat_column(names(df), "test", stopOnFailure = F)))

  df <- data.frame(lon = 1, lons = 2)

  expect_true(is.na(googleway:::find_lon_column(names(df), "test", stopOnFailure = F)))
})

test_that("URL method checks are correct", {

  myUrl <- "myurl"
  attr(myUrl, 'class') <- "url"
  expect_true(googleway:::urlCheck(myUrl) == "myurl")
  expect_error(googleway:::urlCheck(3))
})

test_that("locations are valid", {

  ## directions: a single location is required
  df_pass <- data.frame(location = "Melbourne", stringsAsFactors = F)
  df_fail <- data.frame(location = c("Melbourne", "Sydney"), stringsAsFactors = F)
  vec_pass <- c("Melbourne")
  vec_fail <- c("Melbourne", "Sydney")
  num_pass <- c(-37, 144)
  num_fail <- c(-37, 144, -36, 146)
  lst_pass <- list(c(-37, 144))

  d_pass <- googleway:::validateLocation(df_pass)
  v_pass <- googleway:::validateLocation(vec_pass)
  n_pass <- googleway:::validateLocation(num_pass)
  l_pass <- googleway:::validateLocation(lst_pass)

  expect_error(
    googleway:::validateLocation(df_fail),
    "Only a single location is allowed inside google_directions for origin or destination"
    )

  expect_error(
    googleway:::validateLocation(vec_fail),
    "Only a single location is allowed inside google_directions for origin or destination"
    )

  expect_error(
    googleway:::validateLocation(num_fail),
    "Only a single location is allowed inside google_directions for origin or destination"
  )

  expect_true(googleway:::check_location( d_pass , "origin") == "Melbourne")
  expect_true(googleway:::check_location( v_pass, "origin") == "Melbourne")
  expect_true(googleway:::check_location( n_pass, "origin") == "-37,144")
  expect_true(googleway:::check_location( l_pass, "origin") == "-37,144")

  ## Distance: multiple locations permitted

  df_pass <- data.frame(location = "Melbourne", stringsAsFactors = F)
  df_fail <- data.frame(location = c("Melbourne", "Sydney"), stringsAsFactors = F)
  vec_pass <- c("Melbourne")
  vec_fail <- c("Melbourne", "Sydney")
  num_pass <- c(-37, 144)
  num_fail <- c(-37, 144, -36, 146)
  lst_pass <- list(c(-37, 144))

  expect_true(googleway:::validateLocations(df_pass)[[1]] == "Melbourne")
  expect_true(googleway:::validateLocations(df_fail)[[1]] == "Melbourne")
  expect_true(googleway:::validateLocations(df_fail)[[2]] == "Sydney")
  expect_true(googleway:::validateLocations(vec_pass) == "Melbourne")
  expect_true(sum(googleway:::validateLocations(vec_fail) == c("Melbourne", "Sydney")) == 2)
  expect_true(sum(googleway:::validateLocations(vec_fail) == c("Melbourne", "Sydney")) == 2)

  ## diretions lat/lon columns permitted
  df_pass <- googleway::tram_stops[1, c("stop_lat", "stop_lon")]
  expect_true(sum(googleway:::validateLocation(df_pass) == c(-37.8090, 144.9731)) == 2)
  ## Other types are returned as-is
  expect_true(googleway:::validateLocation(T))
})

test_that("address check works", {
  expect_error(
    googleway:::check_address(c("add 1", "add 2")),
    "address must be a string of length 1"
  )
})


test_that("avoid arg is valid", {
  expect_true(googleway:::validateAvoid("TOLLS") == "tolls")
})

test_that("bounds arg is valid", {
  bounds <- list(c(0,0), c(1,1))
  expect_true(googleway:::validateBounds(bounds) == "0,0|1,1")
})


test_that("components arg is valid", {
  components <- data.frame(component = "country", value = "UK")
  expect_true(googleway:::validateComponents(components) == "country:uk")
})


test_that("country components are valid", {

  components <- c("US", "AUS", "NZ", "FR", "UK", "CA")

  expect_error(
    googleway:::validateComponentsCountries(components),
    "components only supports up to 5 countries"
  )

  components <- c("US", "AUS", "NZ", "FR", "UK")
  expect_error(
    googleway:::validateComponentsCountries(components),
    "components must be two characters and represent an ISO 3166"
  )

  components <- c("US", "AU", "NZ", "FR", "UK")
  expect_equal(
    googleway:::validateComponentsCountries(components),
    "country:US|country:AU|country:NZ|country:FR|country:UK"
  )

  components <- c(1, 2)
  expect_error(
    googleway:::validateComponentsCountries(components),
    "components must be two characters and represent an ISO 3166-1 Alpha-2 country code"
  )
})

test_that("language arg validate", {
  expect_true(googleway:::validateLanguage("EN") == "en")
})

test_that("heading arg validated", {
  expect_true(googleway:::validateHeading(23) == 23)
})

test_that("location_type arg validated", {
  expect_true(googleway:::validateLocationType("rooftop") == "ROOFTOP")
})


test_that("page token arg is validated", {
  expect_true(googleway:::validatePageToken("mypagetoken") == "mypagetoken")
})

test_that("place type arg is validated", {
  expect_true(googleway:::validatePlaceType("restaurant") == "restaurant")
})

test_that("price range arg is valid", {
  expect_true(all(googleway:::validatePriceRange(c(0, 4)) %in% c(0,4)))
})


test_that("region arg is valid", {
  expect_true(googleway:::validateRegion("EN") == "en")
})

test_that("result type arg is valid",{
  expect_true(
    googleway:::validateResultType("JSON") == "json"
  )
})

test_that("traffic model arg is valid", {
  expect_true(googleway:::validateTrafficModel(c("best guess")) == "best_guess")
})

test_that("transit routing preferences arg is valid", {
  expect_true(
    googleway:::validateTransitRoutingPreference("fewer_transfers", "transit") == "fewer_transfers"
  )
})
