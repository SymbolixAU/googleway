## Version 2.3.0 (development)

* `google_map_directions()` loads a Google Map Directions search without an API key
* `google_map_search()` loads a Google Map Search without an API key
* `google_map_url()` loads a Google Map without an API key
* `load_interval` argument added to map layers
* `add_dragdrop` reads geoJSON styles
* `add_fusion` accepts JSON style argument, and query as a list
* `info_window` argument for all `update_` shape methods
* map layers auto-recognise [GTFS](https://developers.google.com/transit/gtfs/) column names: `stop_lat`, `stop_lon`, `shape_pt_lat`, `shape_pt_lon`
* `legend` values are formatted
* `legend_options` accepts `title`, `css`, `position`, `prefix`, `suffix`, `reverse`
* `legend` available for all shape layers
* `melbourne` data factor levels corrected
* `place_id` accepted as origin/destination in `google_direction` and `google_distance`
* `departure_time` defaults to `Sys.time()` if omitted when using `traffic_model`
* `google_distance()` now accepts a data.frame of locations
* `add_dragdrop ` drag & drop geojson onto a map
* `decode_pl` updated to now handle `jqr`-parsed character vectors
* `colours` - You can now map variables passed into the map layers to colours
* `add_drawing` draw shapes and markers onto the map
* `add_geojson` adds geojson to a map
* `access_result` function for accessing specific elements of a Google API query
* Down-graded R requirement to 3.3.0
* Fix for url encoding issue [#65](https://github.com/SymbolixAU/googleway/issues/65)
* Map Layers get `update_map_view` argument
* Fixed `add_rectanges` bug where coordinates were not recognised [#61](https://github.com/SymbolixAU/googleway/issues/61)

## Version 2.2.0

* removed roxygen comments for non-exported functions
* fixed arguments for `google_distance()`
* bug fixes for `transit` mode
* bug fixes for `waypoints` - fixes [#58](https://github.com/SymbolixAU/googleway/issues/58)
* `digits` argument for map layers, gets sent to `jsonlite::toJSON()` for coordinate precision - closes [#53](https://github.com/SymbolixAU/googleway/issues/53)
* `add_fusion()` adds a Fustion Table Layer to a map
* `add_kml()` adds KML layer to a map
* `add_overlay()` adds ground overlay layer to a map
* `add_markers()` gets `marker_icon` argument - closes [#54](https://github.com/SymbolixAU/googleway/issues/54)
* various control options added to `google_map()` (zoom, maptype, rotate, scale, etc...)




## Version 2.0.0 

* `add_rectangles()` adds rectangles to the map
* `google_nearestRoads()` finds closest road segment for given coordinates
* `google_snapToRoads()` snaps GPS coordinates to nearest road
* `add_kml()` adds kml layers to a google map
* `google_streetview()` to download a static streetview map
* `update_polygons()` to dynamically update polygons
* `update_style()` to dynamically update the map style
* `mouse_over` and `info_window` available for most layers
* `add_polygons()` adds polygons (comprised of encoded polylines)
* `add_polylines()` adds encoded polylines
* `add_bicycling()` adds a bicycling layer
* `add_transit()` adds a transit layer
* `optimise_waypoints` argument included for `google_directions()`
* `add_circles()` adds circles to a google map
* `add_traffic()` adds live traffic information to a google map
* `add_heatmap()` adds a heatmap layer to a google map
* `add_markers()` adds markers to a google map
* `google_map()` implemented to plot a google map 
* `google_place_autocomplete()` implemented to 'autcomplete' place names - closes [#23](https://github.com/SymbolixAU/googleway/issues/23)
* `google_place_details()` implemented to retrieve more details about a specific place - closes [#22](https://github.com/SymbolixAU/googleway/issues/22)
* `google_places()` implemented to retrieve information from Google Places API - closes [#21](https://github.com/SymbolixAU/googleway/issues/21)
* `traffic_model` arguments correctly defined - closes [#16](https://github.com/SymbolixAU/googleway/issues/16)
* Waypoint list elements must be named ('stop' or 'via') - closes [#12](https://github.com/SymbolixAU/googleway/issues/12)
* Error handling around downloading data - part of [#13](https://github.com/SymbolixAU/googleway/issues/13)
* **Fixed** Documentation for `key`s in each function - closes [#10](https://github.com/SymbolixAU/googleway/issues/10)


## Version 1.0.0

Deprecated the `get_route()` funciton. In its place is `google_directions()`.

New functions:

* `google_reverse_geocode()` Returns the street address of lat/lon coordinates
* `google_elevation()` Returns elevation data for locations
* `google_timezone()` Returns time offset data for locations on the surface of the earth.
* `google_geocode()` Returns a lat/lon encoding of a given address
* `google_distance()` Returns a distance matrix from Google Distance API call.
* `get_route()` is now deprecated. Use `google_directions()` instead.

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
