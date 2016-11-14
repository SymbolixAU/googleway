HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {
      renderValue: function(x) {

          // global map objects
          // - display elements
          window[el.id + 'googleMarkers'] = [];
          window[el.id + 'googleHeatmapLayer'] = [];
          window[el.id + 'googleHeatmapLayerMVC'] = [];
          window[el.id + 'googleCircles'] = [];
          window[el.id + 'googlePolyline'] = [];

          window[el.id + 'googleBounds'] = [];

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
            // <input id="pac-input" class="controls" type="text" placeholder="Search place">
            window[el.id + 'googleSearchBox'].setAttribute('id', 'pac-input');
            window[el.id + 'googleSearchBox'].setAttribute('class', 'controls');
            window[el.id + 'googleSearchBox'].setAttribute('type', 'text');
            window[el.id + 'googleSearchBox'].setAttribute('placeholder', 'Search Box');
            document.body.appendChild(window[el.id + 'googleSearchBox']);
          }

          var mapDiv = document.getElementById(el.id);
          mapDiv.className = "googlemap";

          if (HTMLWidgets.shinyMode){
            console.log("shiny mode");

            // use setInterval to check if the map can be loaded
            // the map is dependant on the Google Maps JS resource
            // - usually implemented via callback
            var checkExists = setInterval(function(){

              var map = new google.maps.Map(mapDiv, {
                center: {lat: x.lat, lng: x.lng},
                zoom: x.zoom,
                styles: JSON.parse(x.styles)
              });

              //global map object
              window[el.id + 'map'] = map;

              if (google !== 'undefined'){
                console.log("exists");
                clearInterval(checkExists);

                initialise_map(el, x);

              }else{
                console.log("does not exist!");
              }

            }, 100);

          }else{
            console.log("not shiny mode");
            window.onload = function() {

              console.log("window onload");

              var mapDiv = document.getElementById(el.id);

              mapDiv.className = "googlemap";

              var map = new google.maps.Map(mapDiv, {
                center: {lat: x.lat, lng: x.lng},
                zoom: x.zoom,
                styles: JSON.parse(x.styles)
              });

              window[el.id + 'map'] = map;
              initialise_map(el, x);
            };
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

    for (let i = 0; i < data.calls.length; i++) {

      var call = data.calls[i];

      //push the mapId inot the call.args
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


function add_markers(map_id, cluster, lat, lng, title, opacity, draggable,
                      label, info_window){

  cluster = cluster;
  lat = [].concat(lat);
  lng = [].concat(lng);
  title = [].concat(title);
  opacity = [].concat(opacity);
  draggable = [].concat(draggable);
  label = [].concat(label);
  info_window = [].concat(info_window);

  console.log(cluster);

//  console.log(info_window);
//  console.log(title);

//  var len = $('script').filter(function () {
//    return ($(this).attr('src') == '<https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js>');
//  }).length;

//  if(cluster === true){

//    var script = document.createElement('script');
//    script.type = 'text/javascript';
//    script.src = 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js';

//    document.getElementsByTagName('head')[0].appendChild(script);
//  }

  var markers = [];
  var i;
  var bounds = new google.maps.LatLngBounds();

  for (i = 0; i < lat.length; i++) {

    var latlon = new google.maps.LatLng(lat[i], lng[i]);

    var marker = new google.maps.Marker({
      position: latlon,
      draggable: draggable[i],
      opacity: opacity[i],
      title: title[i],
      label: label[i]
    });

    if(info_window[i]){

      marker.infowindow = new google.maps.InfoWindow({
        content: info_window[i]
      });

      google.maps.event.addListener(marker, 'click', function() {
        this.infowindow.open(window[map_id + 'map'], this);
      });

      //var infowindow = new google.maps.InfoWindow({
      //  content: info_window[i]
      //});

      //google.maps.event.addListener(marker, 'click', function () {
      //  infowindow.setContent(infowindow);
      //  infowindow.open(window[map_id + 'map'], marker);
      //});

      //marker.addListener('click', function() {
      //    infowindow.open(window[map_id + 'map'], marker);
      //});
    }

    bounds.extend(latlon);
    window[map_id + 'googleMarkers'].push(marker);
    markers.push(marker);
    marker.setMap(window[map_id + 'map']);
  }

  if(cluster === true){
    var markerCluster = new MarkerClusterer(window[map_id + 'map'], markers,
    {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});
  }

  window[map_id + 'googleBounds'].push(bounds);
  window[map_id + 'map'].fitBounds(bounds);
}


function clear_markers(map_id){

  // the markers know which map they're on
  // http://stackoverflow.com/questions/7961522/removing-a-marker-in-google-maps-api-v3
  for (i = 0; i < window[map_id + 'googleMarkers'].length; i++){
    window[map_id + 'googleMarkers'][i].setMap(null);
  }
}


function add_heatmap(map_id, lat, lng, weight, heatmap_options){

  lat = [].concat(lat);
  lng = [].concat(lng);
  weight = [].concat(weight);

  //heat = HTMLWidgets.dataframeToD3(data_heatmap);
  heat_options = HTMLWidgets.dataframeToD3(heatmap_options);

  // need an array of google.maps.LatLng points
  var heatmapData = [];
  var i;
  // turn row of the data into LatLng, and push it to the array
  for(i = 0; i < lat.length; i++){
    heatmapData[i] = {
      location: new google.maps.LatLng(lat[i], lng[i]),
      weight: weight[i]
    };
  }

  // store in MVC array
  window[map_id + 'googleHeatmapLayerMVC'] = new google.maps.MVCArray(heatmapData);

  var heatmap = new google.maps.visualization.HeatmapLayer({
    data: window[map_id + 'googleHeatmapLayerMVC']
  });

  heatmap.setOptions({
    radius: heat_options[0].radius,
    opacity: heat_options[0].opacity,
  //  dissipating: heat_options[0].dissipating
  });

  // fill the heatmap variable with the MVC array of heatmap data
  // when the MVC array is updated, the layer is also updated
  window[map_id + 'googleHeatmapLayer'] = heatmap;
  heatmap.setMap(window[map_id + 'map']);
}

function update_heatmap(map_id, lat, lng, weight){

  lat = [].concat(lat);
  lng = [].concat(lng);
  weight = [].concat(weight);

  // update the heatmap array
  window[map_id + 'googleHeatmapLayerMVC'].clear();

  var heatmapData = [];
  var i;
  // turn row of the data into LatLng, and push it to the array
  for(i = 0; i < lat.length; i++){
    heatmapData[i] = {
      location: new google.maps.LatLng(lat[i], lng[i]),
      weight: weight[i]
    };
  window[map_id + 'googleHeatmapLayerMVC'].push(heatmapData[i]);
  }
}

function clear_heatmap(map_id){
  window[map_id + 'googleHeatmapLayer'].setMap(null);
}


function add_traffic(map_id){

  var traffic = new google.maps.TrafficLayer();
  window[map_id + 'googleTrafficLayer'] = traffic;
  traffic.setMap(window[map_id + 'map']);
}

function clear_traffic(map_id){
  window[map_id + 'googleTrafficLayer'].setMap(null);
}

function add_bicycling(map_id){

  var bicycle = new google.maps.BicycleLayer();
  window[map_id + 'googleBicyclingLayer'] = bicycle;
  bicycle.setMap(window[map_id + 'map']);
}

function clear_bicycling(map_id){
  window[map_id + 'googleBicyclingLayer'].setMap(null);
}

function add_transit(map_id){

  var transit = new google.maps.TransitLayer();
  window[map_id + 'googleTransitLayer'] = transit;
  transit.setMap(window[map_id + 'map']);
}

function clear_transit(map_id){
  window[map_id + 'googleTransitLayer'].setMap(null);
}


function add_circles(map_id, lat, lng, radius, stroke_colour, stroke_opacity, stroke_weight, fill_colour, fill_opacity){

  lat = [].concat(lat);
  lng = [].concat(lng);
  radius = [].concat(radius);
  stroke_colour = [].concat(stroke_colour);
  stroke_opacity = [].concat(stroke_opacity);
  stroke_weight = [].concat(stroke_weight);
  fill_colour = [].concat(fill_colour);
  fill_opacity = [].concat(fill_opacity);

  //circles = HTMLWidgets.dataframeToD3(data_circles);
  var i;
  for (i = 0; i < lat.length; i++) {
    var latlon = new google.maps.LatLng(lat[i], lng[i]);

    var circle = new google.maps.Circle({
          strokeColor: stroke_colour[i],
          strokeOpacity: stroke_opacity[i],
          strokeWeight: stroke_weight[i],
          fillColor: fill_colour[i],
          fillOpacity: fill_opacity[i],
          center: latlon,
          radius: radius[i]
        });

      window[map_id + 'googleCircles'].push(circle);
      circle.setMap(window[map_id + 'map']);
    }

}

function clear_circles(map_id){
  window[map_id + 'googleCircles'].setMap(null);
}

//function add_polyline(map, lat, lng, id){
function add_polyline(map, data_polyline){

  // pass in a data.frame of lat/lons, and ids.
  // the data.frame will contain a row for each lat/lon pair
  // and the id will be a data.frame containing an option for each line

  //if a list of polyline data.frames were provided, need to iterate
  //through them, otherwise, just a single call to add the data.frame
  var polyline = [];
  var i;

  // http://stackoverflow.com/a/2647888/5977215
  // and the edit history of accepted answer
  if(data_polyline.length == null){
    polyline = HTMLWidgets.dataframeToD3(data_polyline);
    add_lines(map, polyline);
  }else{
    for (i = 0; i < data_polyline.length; i++) {
      polyline[i] = HTMLWidgets.dataframeToD3(data_polyline[i]);
      //console.log(polyline[i])
      add_lines(map, polyline[i]);
    }
  }

  function add_lines(map_id, polyline){
    var Polyline = new google.maps.Polyline({
            path: polyline,
            geodesic: true,
            strokeColor: '#0088FF',
            strokeOpacity: 0.6,
            strokeWeight: 4
          });

          window[map_id + 'googlePolyline'].push(Polyline);
          Polyline.setMap(window[map_id + 'map']);
  }
}



function initialise_map(el, x) {

  // if places
  if(x.place_search === true){
    var input = document.getElementById('pac-input');
    window[el.id + 'googleSearchBox'] = new google.maps.places.SearchBox(input);
    window[el.id + 'map'].controls[google.maps.ControlPosition.TOP_LEFT].push(input);

    // Bias the SearchBox results towards current map's viewport.
    window[el.id + 'map'].addListener('bounds_changed', function() {
      window[el.id + 'googleSearchBox'].setBounds(window[el.id + 'map'].getBounds());
    });

    var markers = [];
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
  for(i = 0; i < x.calls.length; i++){

    //push the map_id into the call.args
    x.calls[i].args.unshift(el.id);

    if (window[x.calls[i].functions])
      window[x.calls[i].functions].apply(window[el.id + 'map'], x.calls[i].args);
    else
      console.log("Unknown function " + x.calls[i]);
  }

}


