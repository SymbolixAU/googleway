
## Version 1.1.0 (development)

* `google_place_details()` implemented to retrieve more details about a specific place
* `google_places()` implemented to retrieve information from Google Places API
* `traffic_model` arguments correctly defined - closes [#16](https://github.com/SymbolixAU/googleway/issues/16)
* Waypoint list elements must be named ('stop' or 'via') - closes [#12](https://github.com/SymbolixAU/googleway/issues/12)
* Error handling around downloading data - part of [#13](https://github.com/SymbolixAU/googleway/issues/13)
* **Fixed** Documentation for `key`s in each function - closes [#10](https://github.com/SymbolixAU/googleway/issues/10)


## Version 1.0.0

Deprecated the `get_route()` funciton. In its place is `google_directions()`.

New functions:

`google_reverse_geocode()` Returns the street address of lat/lon coordinates

`google_elevation()` Returns elevation data for locations

`google_timezone()` Returns time offset data for locations on the surface of the earth.

`google_geocode()` Returns a lat/lon encoding of a given address

`google_distance()` Returns a distance matrix from Google Distance API call.

`get_route()` is now deprecated. Use `google_directions()` instead.

New arguments for `get_route()` , closes [#1](https://github.com/SymbolixAU/googleway/issues/1)

* `waypoints`
* `departure_time` 
* `arrival_time`
* `alternatives` 
* `avoid`
* `traffic_model`
* `units`
* `mode`
* `transit_mode`
* `transit_routing_preference`
* `language`
* `region`


## Version 0.2.0

First release

* decode_pl()
* get_route()
