
let googlewayMap;

async function initMap(el, x) {

  const { Map } = await google.maps.importLibrary("maps");
  const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary("marker");

  if( x.libraries.includes("visualization")) {
    const { visualization } = await google.maps.importLibrary("visualization");
  }
  if( x.libraries.includes("places")) {
    const { Places } = await google.maps.importLibrary("places");
  }
  if( x.libraries.includes("drawing")) {
    const { drawing } = await google.maps.importLibrary("drawing");
  }
  if( x.libraries.includes("geometry")) {
    const { encoding } = await google.maps.importLibrary("geometry");
  }

  googlewayMap = new Map(document.getElementById(el.id), {
    mapId: el.id,
    center: {lat: x.lat, lng: x.lng},
    zoom: x.zoom,
    minZoom: x.min_zoom,
    maxZoom: x.max_zoom,
    restriction: {
      latLngBounds: {
        north: x.mapBounds.north,
        south: x.mapBounds.south,
        east: x.mapBounds.east,
        west: x.mapBounds.west
      }
    },
    styles: JSON.parse(x.styles),
    zoomControl: x.zoomControl,
    mapTypeId: x.mapType,
    mapTypeControl: x.mapTypeControl,
    scaleControl: x.scaleControl,
    streetViewControl: x.streetViewControl,
    rotateControl: x.rotateControl,
    fullscreenControl: x.fullscreenControl
  });

  //googlewayMap = map;

  var mapInfo,
        input,
        places,
        icon,
        bounds,
        event_return_type,
        eventInfo;

    window[el.id + 'mapBounds'] = new google.maps.LatLngBounds();

    // CHARTS2
    //google.charts.load('current', {'packages': ['corechart']});

    // if places
    if (x.search_box === true) {
        input = document.getElementById(el.id+'pac-input');

        window[el.id + 'googleSearchBox'] = new google.maps.places.SearchBox(input);
        googlewayMap.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

        // Bias the SearchBox results towards current map's viewport.
        googlewayMap.addListener('bounds_changed', function () {
            window[el.id + 'googleSearchBox'].setBounds(googlewayMap.getBounds());
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
                    map: googlewayMap,
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
              googlewayMap.fitBounds(bounds);
            }
        });
    }

    if(x.split_view !== null) {

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

        map.setStreetView( panorama );

        window[ el.id + x.split_view ] = panorama;
    }

    // call initial layers
    if (x.calls !== undefined) {

        for (layerCalls = 0; layerCalls < x.calls.length; layerCalls++) {

            //push the map_id into the call.args
            x.calls[layerCalls].args.unshift(el.id);

            if (window[x.calls[layerCalls].functions]) {

                window[x.calls[layerCalls].functions].apply(googlewayMap, x.calls[layerCalls].args);
            } else {
                //console.log("Unknown function " + x.calls[layerCalls]);
            }
        }
    }

    if( x.geolocation === true) {
        add_geolocation(el.id, googlewayMap, mapInfo );
    }

    // listeners
    mapInfo = {};
    map_click(el.id, googlewayMap, mapInfo);
    map_right_click(el.id, googlewayMap, mapInfo);
    bounds_changed(el.id, googlewayMap, mapInfo);
    zoom_changed(el.id, googlewayMap, mapInfo);

    if( HTMLWidgets.shinyMode) {
      Shiny.setInputValue(el.id + "_initialised", {});
    }
}

HTMLWidgets.widget({

    name: 'google_map',
    type: 'output',

    factory: function (el, width, height) {

        console.log("render value for el.id " + el.id);

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
                    window[el.id + 'googleSearchBox'].setAttribute('id', el.id+'pac-input');
                    window[el.id + 'googleSearchBox'].setAttribute('class', 'pac-input');
                    window[el.id + 'googleSearchBox'].setAttribute('type', 'text');
                    window[el.id + 'googleSearchBox'].setAttribute('placeholder', 'Search location');
                    document.body.appendChild(window[el.id + 'googleSearchBox']);
                }

                window[el.id + 'event_return_type'] = x.event_return_type;

                var mapDiv = document.getElementById(el.id);
                mapDiv.className = "googlemap";

                console.log( x );

                initMap(el, x);
/*
                if (HTMLWidgets.shinyMode) {



                    // use setInterval to check if the map can be loaded
                    // the map is dependant on the Google Maps JS resource
                    // - usually implemented via callback
                    var checkExists = setInterval(function () {

                        var map = new google.maps.Map(mapDiv, {
                            center: {lat: x.lat, lng: x.lng},
                            zoom: x.zoom,
                            minZoom: x.min_zoom,
                            maxZoom: x.max_zoom,
                            restriction: {
                              latLngBounds: {
                                north: x.mapBounds.north,
                                south: x.mapBounds.south,
                                east: x.mapBounds.east,
                                west: x.mapBounds.west
                              }
                            },
                            styles: JSON.parse(x.styles),
                            zoomControl: x.zoomControl,
                            mapTypeId: x.mapType,
                            mapTypeControl: x.mapTypeControl,
                            scaleControl: x.scaleControl,
                            streetViewControl: x.streetViewControl,
                            rotateControl: x.rotateControl,
                            fullscreenControl: x.fullscreenControl
                        });

                        // split view

                        if(x.split_view !== null) {

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

                            map.setStreetView( panorama );

                            window[ el.id + x.split_view ] = panorama;
                        }


                        //global map object
                        googlewayMap = map;

                        if (google !== undefined && google.charts !== undefined ) {
                            //console.log("exists");
                            clearInterval(checkExists);

                            initialise_map(el, x);

                        } else {
                            //console.log("does not exist!");
                        }
                    }, 100);

                } else {

                    var map = new google.maps.Map(mapDiv, {
                        center: {lat: x.lat, lng: x.lng},
                        zoom: x.zoom,
                        minZoom: x.min_zoom,
                        maxZoom: x.max_zoom,
                        restriction: {
                          latLngBounds: {
                            north: x.mapBounds.north,
                            south: x.mapBounds.south,
                            east: x.mapBounds.east,
                            west: x.mapBounds.west
                          }
                        },
                        styles: JSON.parse(x.styles),
                        zoomControl: x.zoomControl,
                        mapTypeId: x.mapType,
                        mapTypeControl: x.mapTypeControl,
                        scaleControl: x.scaleControl,
                        streetViewControl: x.streetViewControl,
                        rotateControl: x.rotateControl,
                        fullscreenControl: x.fullscreenControl
                    });

                    googlewayMap = map;
                    initialise_map(el, x);
                }
*/
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



async function initialise_map(el, x) {

    var mapInfo,
        input,
        places,
        icon,
        bounds,
        event_return_type,
        eventInfo;

    window[el.id + 'mapBounds'] = new google.maps.LatLngBounds();

    // CHARTS2
    google.charts.load('current', {'packages': ['corechart']});

    // if places
    if (x.search_box === true) {
        input = document.getElementById(el.id+'pac-input');

        window[el.id + 'googleSearchBox'] = new google.maps.places.SearchBox(input);
        googlewayMap.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

        // Bias the SearchBox results towards current map's viewport.
        googlewayMap.addListener('bounds_changed', function () {
            window[el.id + 'googleSearchBox'].setBounds(googlewayMap.getBounds());
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
                    map: googlewayMap,
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
              googlewayMap.fitBounds(bounds);
            }
        });
    }


    // call initial layers
    if (x.calls !== undefined) {

        for (layerCalls = 0; layerCalls < x.calls.length; layerCalls++) {

            //push the map_id into the call.args
            x.calls[layerCalls].args.unshift(el.id);

            if (window[x.calls[layerCalls].functions]) {

                window[x.calls[layerCalls].functions].apply(googlewayMap, x.calls[layerCalls].args);
            } else {
                //console.log("Unknown function " + x.calls[layerCalls]);
            }
        }
    }

    if( x.geolocation === true) {
        add_geolocation(el.id, googlewayMap, mapInfo );
    }

    // listeners
    mapInfo = {};
    map_click(el.id, googlewayMap, mapInfo);
    map_right_click(el.id, googlewayMap, mapInfo);
    bounds_changed(el.id, googlewayMap, mapInfo);
    zoom_changed(el.id, googlewayMap, mapInfo);

    if( HTMLWidgets.shinyMode) {
      Shiny.setInputValue(el.id + "_initialised", {});
    }
}

function update_pano( map_id, pano, lat, lon ) {


  var pano = window[ map_id + pano];
  var map = googlewayMap;
  //var center = map.getCenter();
  var center = {lat: lat, lng: lon};

  //console.log( pano );
  pano.setPosition( center );
  //console.log( pano );

  googlewayMap.setStreetView( pano );

/*
  var panorama = new google.maps.StreetViewPanorama(
      document.getElementById( pano ), {
          position: {lat: center.lat(), lng: center.lng() },
          pov: {
          //    heading: location.heading,
          //    pitch: location.pitch
              heading: 34,
              pitch: 10
             }
      });
*/


  //map.setStreetView( panorama );
  //googlewayMap.setStreetView( panorama );
}



/**
 * Updates the google map with a particular style
 * @param map_id
 *          the map to which the style is applied
 * @param style
 *          style to apply (in the form of JSON)
 */
function update_style(map_id, style) {
    googlewayMap.set('styles', JSON.parse(style));
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

function placeControl(map_id, object, position) {

    var ledge = {};

    switch (position) {
    case 'RIGHT_BOTTOM':
        googlewayMap.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(object);
        break;
    case 'TOP_CENTER':
        googlewayMap.controls[google.maps.ControlPosition.TOP_CENTER].push(object);
        break;
    case 'TOP_LEFT':
        googlewayMap.controls[google.maps.ControlPosition.TOP_LEFT].push(object);
        break;
    case 'LEFT_TOP':
        googlewayMap.controls[google.maps.ControlPosition.LEFT_TOP].push(object);
        break;
    case 'TOP_RIGHT':
        googlewayMap.controls[google.maps.ControlPosition.TOP_RIGHT].push(object);
        break;
    case 'RIGHT_TOP':
        googlewayMap.controls[google.maps.ControlPosition.RIGHT_TOP].push(object);
        break;
    case 'LEFT_CENTER':
        googlewayMap.controls[google.maps.ControlPosition.LEFT_CENTER].push(object);
        break;
    case 'RIGHT_CENTER':
        googlewayMap.controls[google.maps.ControlPosition.RIGHT_CENTER].push(object);
        break;
    case 'LEFT_BOTTOM':
        googlewayMap.controls[google.maps.ControlPosition.LEFT_BOTTOM].push(object);
        break;
    case 'BOTTOM_CENTER':
        googlewayMap.controls[google.maps.ControlPosition.BOTTOM_CENTER].push(object);
        break;
    case 'BOTTOM_LEFT':
        googlewayMap.controls[google.maps.ControlPosition.BOTTOM_LEFT].push(object);
        break;
    case 'BOTTOM_RIGHT':
        googlewayMap.controls[google.maps.ControlPosition.BOTTOM_RIGHT].push(object);
        break;
    default:
        position = "LEFT_BOTTOM";
        googlewayMap.controls[google.maps.ControlPosition.LEFT_BOTTOM].push(object);
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
        clearControl(googlewayMap.controls[google.maps.ControlPosition.RIGHT_BOTTOM], legend_id);
        break;
    case 'TOP_CENTER':
        clearControl(googlewayMap.controls[google.maps.ControlPosition.TOP_CENTER], legend_id);
        break;
    case 'TOP_LEFT':
        clearControl(googlewayMap.controls[google.maps.ControlPosition.TOP_LEFT], legend_id);
        break;
    case 'LEFT_TOP':
        clearControl(googlewayMap.controls[google.maps.ControlPosition.LEFT_TOP], legend_id);
        break;
    case 'TOP_RIGHT':
        clearControl(googlewayMap.controls[google.maps.ControlPosition.TOP_RIGHT], legend_id);
        break;
    case 'RIGHT_TOP':
        clearControl(googlewayMap.controls[google.maps.ControlPosition.RIGHT_TOP], legend_id);
        break;
    case 'LEFT_CENTER':
        clearControl(googlewayMap.controls[google.maps.ControlPosition.LEFT_CENTER], legend_id);
        break;
    case 'RIGHT_CENTER':
        clearControl(googlewayMap.controls[google.maps.ControlPosition.RIGHT_CENTER], legend_id);
        break;
    case 'LEFT_BOTTOM':
        clearControl(googlewayMap.controls[google.maps.ControlPosition.LEFT_BOTTOM], legend_id);
        break;
    case 'BOTTOM_CENTER':
        clearControl(googlewayMap.controls[google.maps.ControlPosition.BOTTOM_CENTER], legend_id);
        break;
    case 'BOTTOM_LEFT':
        clearControl(googlewayMap.controls[google.maps.ControlPosition.BOTTOM_LEFT], legend_id);
        break;
    case 'BOTTOM_RIGHT':
        clearControl(googlewayMap.controls[google.maps.ControlPosition.BOTTOM_RIGHT], legend_id);
        break;
    default:
        position = "LEFT_BOTTOM";
        clearControl(googlewayMap.controls[google.maps.ControlPosition.LEFT_BOTTOM], legend_id);
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

  console.log(window[map_id + objType + layer_id]);
  console.log(window[map_id + objType + layer_id].length);

  var i = 0;
  if (window[map_id + objType + layer_id]) {
    for (i = 0; i < window[map_id + objType + layer_id].length; i++) {
      console.log(window[map_id + objType + layer_id][i]);
      //https://developers.google.com/maps/documentation/javascript/reference/3/#event
      google.maps.event.clearInstanceListeners(window[map_id + objType + layer_id][i]);
      window[map_id + objType + layer_id][i].setMap(null);
      window[map_id + objType + layer_id][i] = null;
    }
  window[map_id + objType + layer_id] = null;

  clear_legend(map_id, layer_id);
  }

  console.log(window[map_id + objType + layer_id]);
}

function delay(t, v) {
  return new Promise(function(resolve) {
    setTimeout(resolve.bind(null, v), t);
  });
}


function set_map_position(map_id, location, zoom) {

  var latlon = new google.maps.LatLng(location[0], location[1]);
  set_map_center(map_id, latlon);
  set_map_zoom(map_id, zoom);
}

function set_map_center(map_id, latlon) {
  googlewayMap.setCenter(latlon);
}

function set_map_zoom(map_id, zoom) {
  googlewayMap.setZoom(zoom);
}

