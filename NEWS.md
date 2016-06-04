
## Version 0.2.0.9000 - Dev

Development version

`google_distance()` implemented. Returns a distance matrix from Google Distance API call.

`get_route()` is now deprecated. Use `google_directions()` instead.

New arguments for `get_route()` 

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
