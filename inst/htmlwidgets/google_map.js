HTMLWidgets.widget({

    name: 'google_map',
    type: 'output',
    
    factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {
        renderValue: function(x) {
            window.params = [];
            window.params.push( {'map_id' : el.id } );
            window.params.push( {'event_return_type' : x.event_return_type})

            // visualisation layers
            window[el.id + 'googleTrafficLayer'] = [];
            window[el.id + 'googleBicyclingLayer'] = [];
            window[el.id + 'googleTransitLayer'] = [];
            window[el.id + 'googleSearchBox'] = [];
            window[el.id + 'googlePlaceMarkers'] = [];

            if(x.search_box === true){
                console.log("search box");
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

          if (HTMLWidgets.shinyMode){

            // use setInterval to check if the map can be loaded
            // the map is dependant on the Google Maps JS resource
            // - usually implemented via callback
            var checkExists = setInterval(function(){

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

              //global map object
              window[el.id + 'map'] = map;

              if (google !== undefined){
                console.log("exists");
                clearInterval(checkExists);

                initialise_map(el, x);

              }else{
                console.log("does not exist!");
              }
            }, 100);

          }else{
            console.log("not shiny mode");

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
      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      },

    };
  }
});



if (HTMLWidgets.shinyMode) {

    Shiny.addCustomMessageHandler("googlemap-calls", function(data) {

        var id = data.id;   // the div id of the map
        var el = document.getElementById(id);
        var map = el;
        if (!map) {
            console.log("Couldn't find map with id " + id);
            return;
        }

        for (var i = 0; i < data.calls.length; i++) {

            var call = data.calls[i];

            //push the mapId into the call.args
            call.args.unshift(id);

            if (call.dependencies) {
                Shiny.renderDependencies(call.dependencies);
            }

            if (window[call.method])
                window[call.method].apply(window[id + 'map'], call.args);
            else
                console.log("Unknown function " + call.method);
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
 * hex to rgb
 *
 * Converts hex colours to rgb
 */
function hexToRgb(hex) {
    var arrBuff = new ArrayBuffer(4);
    var vw = new DataView(arrBuff);
    vw.setUint32(0, parseInt(hex, 16), false);
    var arrByte = new Uint8Array(arrBuff);

    return arrByte[1] + "," + arrByte[2] + "," + arrByte[3];
}

/**
 * Finds an object by the .id field
 *
 * @param source data object
 * @param id the id to search for
 **/
function findById(source, id) {
    for (var i = 0; i < source.length; i++) {
        if (source[i].id === id) {
            return source[i];
        }
    }
    return;
}

function initialise_map(el, x) {

  // map bounds object
  //console.log("initialising map: el.id: ");
  //console.log(el.id);
  window[el.id + 'mapBounds'] = new google.maps.LatLngBounds();

  // if places
  if(x.search_box === true){
      var input = document.getElementById('pac-input');
      
      window[el.id + 'googleSearchBox'] = new google.maps.places.SearchBox(input);
      window[el.id + 'map'].controls[google.maps.ControlPosition.TOP_LEFT].push(input);

      // Bias the SearchBox results towards current map's viewport.
      window[el.id + 'map'].addListener('bounds_changed', function() {
          window[el.id + 'googleSearchBox'].setBounds(window[el.id + 'map'].getBounds());
      });

      // listen for deleting the search bar
      input.addEventListener('input', function(){
          if(input.value.length === 0){
              clear_search(el.id);
          }
      });

      // Listen for the event fired when the user selects a prediction and retrieve
      // more details for that place.
      window[el.id + 'googleSearchBox'].addListener('places_changed', function() {
          var places = window[el.id + 'googleSearchBox'].getPlaces();
          if (places.length == 0) {
              return;
          }
          
          // Clear out the old markers.
          window[el.id + 'googlePlaceMarkers'].forEach(function(marker) {
              marker.setMap(null);
          });
          window[el.id + 'googlePlaceMarkers'] = [];

          // For each place, get the icon, name and location.
          var bounds = new google.maps.LatLngBounds();

          places.forEach(function(place) {
              if (!place.geometry) {
                  console.log("Returned place contains no geometry");
                  return;
              }
              
              var icon = {
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
          });
          window[el.id + 'map'].fitBounds(bounds);
      });
  }

    // call initial layers
    if(x.calls !== undefined){

        for(layerCalls = 0; layerCalls < x.calls.length; layerCalls++){

            //push the map_id into the call.args
            x.calls[layerCalls].args.unshift(el.id);

            if (window[x.calls[layerCalls].functions]){

                window[x.calls[layerCalls].functions].apply(window[el.id + 'map'], x.calls[layerCalls].args);
            }else{
                console.log("Unknown function " + x.calls[layerCalls]);
            }
        }
    }

    // listeners
    mapInfo = {};
    map_click(el.id, window[el.id + 'map'], mapInfo);
    bounds_changed(el.id, window[el.id + 'map'], mapInfo);
    zoom_changed(el.id, window[el.id + 'map'], mapInfo);
}


