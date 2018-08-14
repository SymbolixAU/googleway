HTMLWidgets.widget({

    name: 'google_map',
    type: 'output',

    factory: function (el, width, height) {

        return {
            renderValue: function (x) {

                //console.log( x ) ;
                window.googleway = [];
                window.googleway.params = [];
                window.googleway.params.push({'map_id' : el.id });
                window.googleway.params.push({'event_return_type' : x.event_return_type});
                //console.log( window.googleway.params );

                // visualisation layers
                window[el.id + 'googleTrafficLayer'] = [];
                window[el.id + 'googleBicyclingLayer'] = [];
                window[el.id + 'googleTransitLayer'] = [];
                window[el.id + 'googleSearchBox'] = [];
                window[el.id + 'googlePlaceMarkers'] = [];
                window[el.id + 'legendPositions'] = [];     // array for keeping a referene to legend positions

                if (x.search_box === true) {
                    //console.log("search box");
                    // create a place DOM element
                    window[el.id + 'googleSearchBox'] = document.createElement("input");
                    window[el.id + 'googleSearchBox'].setAttribute('id', 'pac-input');
                    window[el.id + 'googleSearchBox'].setAttribute('class', 'controls');
                    window[el.id + 'googleSearchBox'].setAttribute('type', 'text');
                    window[el.id + 'googleSearchBox'].setAttribute('placeholder', 'Search location');
                    document.body.appendChild(window[el.id + 'googleSearchBox']);
                }

                window[el.id + 'event_return_type'] = x.event_return_type;

                var mapDiv = document.getElementById(el.id);
                mapDiv.className = "googlemap";

                if (HTMLWidgets.shinyMode) {

                    // use setInterval to check if the map can be loaded
                    // the map is dependant on the Google Maps JS resource
                    // - usually implemented via callback
                    var checkExists = setInterval(function () {

                        var map = new google.maps.Map(mapDiv, {
                            center: {lat: x.lat, lng: x.lng},
                            zoom: x.zoom,
                            styles: JSON.parse(x.styles),
                            zoomControl: x.zoomControl,
                            mapTypeControl: x.mapTypeControl,
                            scaleControl: x.scaleControl,
                            streetViewControl: x.streetViewControl,
                            rotateControl: x.rotateControl,
                            fullscreenControl: x.fullscreenControl
                        });

                        // split view

                        if(x.split_view !== null) {

                          //console.log("split view");
                          //console.log(x.split_view_options);

                            var panorama = new google.maps.StreetViewPanorama(
                                document.getElementById(x.split_view), {
                                    position: {lat: x.lat, lng: x.lng},
                                    pov: {
                                        heading: x.split_view_options.heading,
                                        pitch: x.split_view_options.pitch
                                        //heading: 34,
                                        //pitch: 10
                                      }
                                });

                            map.setStreetView(panorama);
                        }


                        //global map object
                        window[el.id + 'map'] = map;

                        if (google !== undefined) {
                            //console.log("exists");
                            clearInterval(checkExists);

                            initialise_map(el, x);

                        } else {
                            //console.log("does not exist!");
                        }
                    }, 100);

                } else {
                    //console.log("not shiny mode");

                    var map = new google.maps.Map(mapDiv, {
                        center: {lat: x.lat, lng: x.lng},
                        zoom: x.zoom,
                        styles: JSON.parse(x.styles),
                        zoomControl: x.zoomControl,
                        mapTypeControl: x.mapTypeControl,
                        scaleControl: x.scaleControl,
                        streetViewControl: x.streetViewControl,
                        rotateControl: x.rotateControl,
                        fullscreenControl: x.fullscreenControl
                    });

                    window[el.id + 'map'] = map;
                    initialise_map(el, x);
                }
            },
            resize: function (width, height) {
            // TODO: code to re-render the widget with a new size
            }
        };
    }
});



if (HTMLWidgets.shinyMode) {

    Shiny.addCustomMessageHandler("googlemap-calls", function (data) {

        var id = data.id,   // the div id of the map
            el = document.getElementById(id),
            map = el,
            call = [],
            i = 0;


        if (!map) {
            //console.log("Couldn't find map with id " + id);
            return;
        }

        for (i = 0; i < data.calls.length; i++) {

            call = data.calls[i];

            //push the mapId into the call.args
            call.args.unshift(id);

            if (call.dependencies) {
                Shiny.renderDependencies(call.dependencies);
            }

            if (window[call.method]) {
                window[call.method].apply(window[id + 'map'], call.args);
            } else {
                //console.log("Unknown function " + call.method);
            }
        }
    });
}



/**
 * Updates the google map with a particular style
 * @param map_id
 *          the map to which the style is applied
 * @param style
 *          style to apply (in the form of JSON)
 */
function update_style(map_id, style) {
    window[map_id + 'map'].set('styles', JSON.parse(style));
}


/**
* Creates a window object for a given shape type if it doens't exist
*
*/
function createWindowObject(map_id, objType, layer_id) {
    if (window[map_id + objType + layer_id] == null) {
        window[map_id + objType + layer_id] = [];
    }
}

/**
 * hex to rgb
 *
 * Converts hex colours to rgb
 */
function hexToRgb(hex) {
    var arrBuff = new ArrayBuffer(4),
        vw = new DataView(arrBuff),
        arrByte = new Uint8Array(arrBuff);

    vw.setUint32(0, parseInt(hex, 16), false);

    return arrByte[1] + "," + arrByte[2] + "," + arrByte[3];
}

/**
 * Finds an object by the .id field
 *
 * @param source data object
 * @param id the id to search for
 **/
function findById(source, id, returnType) {
    var i = 0;
    for (i = 0; i < source.length; i++) {
        if (source[i].id === id) {
            if (returnType === "object") {
                return source[i];
            } else {
                return i;
            }
        }
    }
    return;
}

function initialise_map(el, x) {

    var mapInfo,
        input,
        places,
        icon,
        bounds,
        event_return_type,
        eventInfo;
    // map bounds object
    //console.log("initialising map: el.id: ");
    //console.log(el.id);
    window[el.id + 'mapBounds'] = new google.maps.LatLngBounds();

    // CHARTS2
    google.charts.load('current', {'packages': ['corechart']});

    // if places
    if (x.search_box === true) {
        input = document.getElementById('pac-input');

        window[el.id + 'googleSearchBox'] = new google.maps.places.SearchBox(input);
        window[el.id + 'map'].controls[google.maps.ControlPosition.TOP_LEFT].push(input);

        // Bias the SearchBox results towards current map's viewport.
        window[el.id + 'map'].addListener('bounds_changed', function () {
            window[el.id + 'googleSearchBox'].setBounds(window[el.id + 'map'].getBounds());
        });

        // listen for deleting the search bar
        input.addEventListener('input', function () {
            if (input.value.length === 0) {
                clear_search(el.id);
            }
        });

        // Listen for the event fired when the user selects a prediction and retrieve
        // more details for that place.
        window[el.id + 'googleSearchBox'].addListener('places_changed', function () {
            places = window[el.id + 'googleSearchBox'].getPlaces();
            if (places.length == 0) {
                return;
            }

            // Clear out the old markers.
            window[el.id + 'googlePlaceMarkers'].forEach(function (marker) {
                marker.setMap(null);
            });

            window[el.id + 'googlePlaceMarkers'] = [];

            // For each place, get the icon, name and location.
            bounds = new google.maps.LatLngBounds();

            places.forEach(function (place) {
                if (!place.geometry) {
                    //console.log("Returned place contains no geometry");
                    return;
                }

                icon = {
                    url: place.icon,
                    size: new google.maps.Size(71, 71),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(17, 34),
                    scaledSize: new google.maps.Size(25, 25)
                };

                // Create a marker for each place.
                window[el.id + 'googlePlaceMarkers'].push(new google.maps.Marker({
                    map: window[el.id + 'map'],
                    icon: icon,
                    title: place.name,
                    position: place.geometry.location
                }));

                if (place.geometry.viewport) {
                    // Only geocodes have viewport.
                    bounds.union(place.geometry.viewport);
                } else {
                    bounds.extend(place.geometry.location);
                }

                if (HTMLWidgets.shinyMode) {

                    event_return_type = window.googleway.params[1].event_return_type,
                        eventInfo = {
                            address_components: place.address_components,
                            lat: place.geometry.location.lat(),
                            lon: place.geometry.location.lng(),
                            name: place.name,
                            address: place.formatted_address,
                            place_id: place.place_id,
                            vicinity: place.vicinity,
                            randomValue: Math.random()
                        };

                    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
                    Shiny.onInputChange(el.id + "_place_search", eventInfo);
                }

            //console.log(places);
            });

            if(x.update_map_view) {
              window[el.id + 'map'].fitBounds(bounds);
            }
        });
    }


    // call initial layers
    if (x.calls !== undefined) {

        for (layerCalls = 0; layerCalls < x.calls.length; layerCalls++) {

            //push the map_id into the call.args
            x.calls[layerCalls].args.unshift(el.id);

            if (window[x.calls[layerCalls].functions]) {

                window[x.calls[layerCalls].functions].apply(window[el.id + 'map'], x.calls[layerCalls].args);
            } else {
                //console.log("Unknown function " + x.calls[layerCalls]);
            }
        }
    }

    if( x.geolocation === true) {
        add_geolocation();
    }

    // listeners
    mapInfo = {};
    map_click(el.id, window[el.id + 'map'], mapInfo);
    bounds_changed(el.id, window[el.id + 'map'], mapInfo);
    zoom_changed(el.id, window[el.id + 'map'], mapInfo);
}


function placeControl(map_id, object, position) {

    var ledge = {};

    switch (position) {
    case 'RIGHT_BOTTOM':
        window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(object);
        break;
    case 'TOP_CENTER':
        window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_CENTER].push(object);
        break;
    case 'TOP_LEFT':
        window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_LEFT].push(object);
        break;
    case 'LEFT_TOP':
        window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_TOP].push(object);
        break;
    case 'TOP_RIGHT':
        window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_RIGHT].push(object);
        break;
    case 'RIGHT_TOP':
        window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_TOP].push(object);
        break;
    case 'LEFT_CENTER':
        window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_CENTER].push(object);
        break;
    case 'RIGHT_CENTER':
        window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_CENTER].push(object);
        break;
    case 'LEFT_BOTTOM':
        window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_BOTTOM].push(object);
        break;
    case 'BOTTOM_CENTER':
        window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_CENTER].push(object);
        break;
    case 'BOTTOM_LEFT':
        window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_LEFT].push(object);
        break;
    case 'BOTTOM_RIGHT':
        window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_RIGHT].push(object);
        break;
    default:
        position = "LEFT_BOTTOM";
        window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_BOTTOM].push(object);
        break;
    }

    ledge = {
        id: object.getAttribute('id'),
        position: position
    };
    window[map_id + 'legendPositions'].push(ledge);
}

function removeControl(map_id, legend_id, position) {

    //console.log("removeControl()");
    //console.log(position);

    switch (position) {
    case 'RIGHT_BOTTOM':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_BOTTOM], legend_id);
        break;
    case 'TOP_CENTER':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_CENTER], legend_id);
        break;
    case 'TOP_LEFT':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_LEFT], legend_id);
        break;
    case 'LEFT_TOP':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_TOP], legend_id);
        break;
    case 'TOP_RIGHT':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_RIGHT], legend_id);
        break;
    case 'RIGHT_TOP':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_TOP], legend_id);
        break;
    case 'LEFT_CENTER':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_CENTER], legend_id);
        break;
    case 'RIGHT_CENTER':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_CENTER], legend_id);
        break;
    case 'LEFT_BOTTOM':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_BOTTOM], legend_id);
        break;
    case 'BOTTOM_CENTER':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_CENTER], legend_id);
        break;
    case 'BOTTOM_LEFT':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_LEFT], legend_id);
        break;
    case 'BOTTOM_RIGHT':
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_RIGHT], legend_id);
        break;
    default:
        position = "LEFT_BOTTOM";
        clearControl(window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_BOTTOM], legend_id);
        break;
    }
}

function clearControl(control, legend_id) {

  if (control != null) {
    control.forEach(function (item, index) {
      if (item != null) {
        if (item.getAttribute('id') === legend_id) {
          control.removeAt(index);
        }
      }
    });
  }
}

/**
* clears an object from it's window-array, and then the map
* and then calls 'clear_legend'
*/
function clear_object(map_id, objType, layer_id) {

  var i = 0;
  if (window[map_id + objType + layer_id] && window[map_id + objType + layer_id].length) {
    for (i = 0; i < window[map_id + objType + layer_id].length; i++) {
    //https://developers.google.com/maps/documentation/javascript/reference/3/#event
    google.maps.event.clearInstanceListeners(window[map_id + objType + layer_id][i]);
    window[map_id + objType + layer_id][i].setMap(null);
    window[map_id + objType + layer_id][i] = null;
  }
  window[map_id + objType + layer_id] = null;

  clear_legend(map_id, layer_id);
  }
}

function delay(t, v) {
  return new Promise(function(resolve) {
    setTimeout(resolve.bind(null, v), t);
  });
}
