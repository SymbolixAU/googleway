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
function update_style(map_id, style){
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
    
    //add_legend(el.id);
    //add_legend_category(el.id);
}


// legend logic:
// - it will be added during each 'add_layer' call.
// - the layer will have an associated palette list, containing the variable name and the colours
// - the javascript needs to know if it's numeric or categorical
// - when the layer calls 'add_legend', the code will need to create a new 'window[map_id + 'legend' + layer_id]' legend
// and push it onto the map
// 
// Need stroke colours too
// 
// TODO:
// - legend title == variable name
// - label formats
function add_legend_gradient(map_id, layer_id, legendValues, legendOptions){
    // fill gradient
    
    if(window[map_id + 'legend' + layer_id] === undefined){
        window[map_id + 'legend' + layer_id] = document.createElement("div");
        window[map_id + 'legend' + layer_id].setAttribute('id', map_id + 'legend' + layer_id);
        window[map_id + 'legend' + layer_id].setAttribute('class', 'legend');   
    }
    
    var colourContainer = document.createElement("div");
    colourContainer.setAttribute('class', 'labelContainer');

    var tickContainer = document.createElement("div");
    tickContainer.setAttribute('class', 'labelContainer');

    var labelContainer = document.createElement("div");
    labelContainer.setAttribute('class', 'labelContainer');

    if(legendOptions.css !== null){
        window[map_id + 'legend' + layer_id].setAttribute('style', legendOptions.css);
    }

    document.body.appendChild(tickContainer);
    document.body.appendChild(labelContainer);

    // for numeric gradient...
    var legendColours = document.createElement('div');
    // create array of colours
    console.log(legendValues);
    var jsColours = [];
    for(var i = 0; i < legendValues.length; i++){
        jsColours.push(legendValues[i].colour);
    }
//    var jsColours = Object.values(legendValues.colour);
    console.log(jsColours);
//    var jsColours = ["#440154", "#443A83", "#31688E", "#21908C", "#35B779", "#8FD744", "#FDE725"];
    var colours = '(' + jsColours.join() + ')';
    console.log(colours);

    style = 'display: inline-block; height: ' + jsColours.length * 20 + 'px; width: 15px;';
    style += 'background: ' + jsColours[1] + ';';
    style += 'background: -webkit-linear-gradient' + colours + ';'
    style += 'background: -o-linear-gradient' + colours + ';'
    style += 'background: -moz-linear-gradient' + colours + ';' 
    style += 'background: linear-gradient' + colours + ';'

    legendColours.setAttribute('style', style);
    window[map_id + 'legend' + layer_id].appendChild(legendColours);

    for (var i = 0; i < legendValues.length; i++) {
        var legendValue = 'text-align: center; color: #b8b9ba; font-size: 12px; height: 20px;';

        var divTicks = document.createElement('div');
        var divVal = document.createElement('div');

        divTicks.setAttribute('style', legendValue);
        divTicks.innerHTML = '-';
        tickContainer.appendChild(divTicks);

        divVal.setAttribute('style', legendValue);
        divVal.innerHTML = legendValues[i].variable;
        labelContainer.appendChild(divVal);
    }

    //window[map_id + 'legend' + layer_id].appendChild(colourContainer);
    window[map_id + 'legend' + layer_id].appendChild(tickContainer);
    window[map_id + 'legend' + layer_id].appendChild(labelContainer);
    
    placeLegend(map_id, window[map_id + 'legend' + layer_id], legendOptions.position);
}


function add_legend_category(map_id, layer_id, legendValues, legendOptions) {
    
    if(window[map_id + 'legend' + layer_id] === undefined){
        window[map_id + 'legend' + layer_id] = document.createElement("div");
        window[map_id + 'legend' + layer_id].setAttribute('id', map_id + 'legend' + layer_id);
        window[map_id + 'legend' + layer_id].setAttribute('class', 'legend');   
    }
    
    var colourContainer = document.createElement("div");
    colourContainer.setAttribute('class', 'labelContainer');

    var tickContainer = document.createElement("div");
    tickContainer.setAttribute('class', 'labelContainer');

    var labelContainer = document.createElement("div");
    labelContainer.setAttribute('class', 'labelContainer');

    if(legendOptions.css !== null){
        window[map_id + 'legend' + layer_id].setAttribute('style', legendOptions.css);
    }

    document.body.appendChild(tickContainer);
    document.body.appendChild(labelContainer);
    
    var legendColours = document.createElement('div');

    for (var i = 0; i < legendValues.length; i++) {

        var tickVal = 'text-left: center; color: #b8b9ba; font-size: 12px; height: 20px;';

        var divCol = document.createElement('div');
        var divTicks = document.createElement('div');
        var divVal = document.createElement('div');

        colourBox = 'height: 20px; width: 15px; background: ' + legendValues[i].colour;
        divCol.setAttribute('style', colourBox);
        colourContainer.appendChild(divCol);

        divTicks.setAttribute('style', tickVal);
        divTicks.innerHTML = '-';
        tickContainer.appendChild(divTicks);

        divVal.setAttribute('style', tickVal);
        divVal.innerHTML = legendValues[i].variable;
        labelContainer.appendChild(divVal);
    }

    window[map_id + 'legend' + layer_id].appendChild(colourContainer);
    window[map_id + 'legend' + layer_id].appendChild(tickContainer);
    window[map_id + 'legend' + layer_id].appendChild(labelContainer);
    
    placeLegend(map_id, window[map_id + 'legend' + layer_id], legendOptions.position);
}

function placeLegend(map_id, legend, position){

    switch(position){
        case 'RIGHT_BOTTOM':
            window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legend);
            break;
        case 'TOP_CENTER':
            window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_CENTER].push(legend);
            break;
        case 'TOP_LEFT':
            window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_LEFT].push(legend);
            break;
        case 'LEFT_TOP':
            window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_TOP].push(legend);
            break;
        case 'RIGHT_TOP':
            window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_TOP].push(legend);
            break;
        case 'LEFT_CENTER':
            window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_CENTER].push(legend);
            break;
        case 'RIGHT_CENTER':
            window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_CENTER].push(legend);
            break;
        case 'LEFT_BOTTOM':
            window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_BOTTOM].push(legend);
            break;
        case 'BOTTOM_CENTER':
            window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_CENTER].push(legend);
            break;
        case 'BOTTOM_LEFT':
            window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_LEFT].push(legend);
            break;
        case 'BOTTOM_RIGHT':
            window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_RIGHT].push(legend);
            break;
        default:
            window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legend);
            break;
    }
}

