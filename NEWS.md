
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
