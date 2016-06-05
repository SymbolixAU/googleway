
The next release will be version 1.0.0 and will remove the `get_route()` funciton. In its place will be `google_directions()`.

## Version 0.3.0 - Development version on github


Development version

`google_elevation()` implemented. Returns elevation data for locations

`google_timezone()` implemented. Returns time offset data for locations on the surface of the earth.

`google_geocode()` implemented. Returns a lat/lon encoding of a given address

`google_distance()` implemented. Returns a distance matrix from Google Distance API call.

`get_route()` is now deprecated. Use `google_directions()` instead.

New arguments for `get_route()` , closes [#1](https://github.com/SymbolixAU/googleway/issues/1)

* `waypoints`
* `departure_time` 
* `arrival_time`
* `alternatives` argument for displaying alternative routes
* `avoid` - tolls, highways, ferries, indoors
* `traffic_model` - best_guess, optimistic, pessimistic
* `units` - metric or imperial (only the displayed text - value field is always metric)
* `mode`
* `transit_mode`
* `transit_routing_preference`
* `language`
* `region`


## Version 0.2.0

First release

* decode_pl()
* get_route()
