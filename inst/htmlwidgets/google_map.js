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
          window[el.id + 'googleMarkerClusterer'];
          window[el.id + 'googleHeatmapLayer'] = [];
          window[el.id + 'googleHeatmapLayerMVC'] = [];
          window[el.id + 'googleCircles'] = [];
          window[el.id + 'googlePolyline'] = [];
          window[el.id + 'googlePolygon'] = [];
          window[el.id + 'googlePolygonMVC'] = [];

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

/**
 * adds markers to a google map object
 * @param map_id
 *          the map object to which the markers will be added
 * @param data_markers
 *          JSON array of marker data
 * @param cluster
 *          logical, indicating if the markers should cluster when zoomed out
 */
function add_markers(map_id, data_markers, cluster){

  var markers = [];
  var i;
  var bounds = new google.maps.LatLngBounds();
  var infoWindow = new google.maps.InfoWindow();

  for (i = 0; i < Object.keys(data_markers).length; i++){

    var latlon = new google.maps.LatLng(data_markers[i].lat, data_markers[i].lng);

    var marker = new google.maps.Marker({
      position: latlon,
      draggable: data_markers[i].draggable,
      opacity: data_markers[i].opacity,
      title: data_markers[i].title,
      label: data_markers[i].label
    });

    if(data_markers[i].info_window){
      add_infoWindow(map_id, infoWindow, marker, '_information', data_markers[i].info_window);
    }

    if(data_markers[i].mouse_over){
      add_mouseOver(map_id, infoWindow, marker, "_mouse_over", data_markers[i].mouse_over);
    }

    bounds.extend(latlon);

    window[map_id + 'googleMarkers'].push(marker);
    markers.push(marker);
    marker.setMap(window[map_id + 'map']);
  }

  if(cluster === true){
    //var markerCluster = new MarkerClusterer(window[map_id + 'map'], markers,
    window[map_id + 'googleMarkerClusterer'] = new MarkerClusterer(window[map_id + 'map'], markers,
    {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});

//    window[el.id + 'googleMarkerClusterer'].push(markerCluster);
  }

  window[map_id + 'googleBounds'].push(bounds);
  window[map_id + 'map'].fitBounds(bounds);
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
 * clears markes from a google map object
 * @param map_id
 *          the map to clear
 */
function clear_markers(map_id){

  // the markers know which map they're on
  // http://stackoverflow.com/questions/7961522/removing-a-marker-in-google-maps-api-v3
  for (i = 0; i < window[map_id + 'googleMarkers'].length; i++){
    window[map_id + 'googleMarkers'][i].setMap(null);
  }

  window[map_id + 'googleMarkers'] = [];
  if(window[map_id + 'googleMarkerClusterer']){
    window[map_id + 'googleMarkerClusterer'].clearMarkers();
  }

}

/**
 * Adds a heatmap layer to a google map object
 * @param map_id
 *          the map to which the heatmap will be added
 * @param data_heatmap
 *          JSON array of heatmap data
 * @param heatmap_options
 *          other options passed to the heatmap layer
 */
function add_heatmap(map_id, data_heatmap, heatmap_options){

  //heat = HTMLWidgets.dataframeToD3(data_heatmap);
  heat_options = HTMLWidgets.dataframeToD3(heatmap_options);

  // need an array of google.maps.LatLng points
  var heatmapData = [];
  var i;
  // turn row of the data into LatLng, and push it to the array
  for(i = 0; i < Object.keys(data_heatmap).length; i++){
    heatmapData[i] = {
      location: new google.maps.LatLng(data_heatmap[i].lat, data_heatmap[i].lng),
      weight: data_heatmap[i].weight
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
    dissipating: heat_options[0].dissipating
  });

  // fill the heatmap variable with the MVC array of heatmap data
  // when the MVC array is updated, the layer is also updated
  window[map_id + 'googleHeatmapLayer'] = heatmap;
  heatmap.setMap(window[map_id + 'map']);
}

/**
 * Updates the heatmap layer with new data
 * @param map_id
 *          the map to update
 * @param data_heatmap
 *          the data to put into the heatmap layer
 */
function update_heatmap(map_id, data_heatmap){


  // update the heatmap array
  window[map_id + 'googleHeatmapLayerMVC'].clear();

  var heatmapData = [];
  var i;
  // turn row of the data into LatLng, and push it to the array
  for(i = 0; i < Object.keys(data_heatmap).length; i++){
    heatmapData[i] = {
      location: new google.maps.LatLng(data_heatmap[i].lat, data_heatmap[i].lng),
      weight: data_heatmap[i].weight
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

  var bicycle = new google.maps.BicyclingLayer();
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


function add_circles(map_id, data_circles){

  var i;
  var infoWindow = new google.maps.InfoWindow();

  for (i = 0; i < Object.keys(data_circles).length; i++) {
    add_circle(map_id, data_circles[i]);
  }

  function add_circle(map_id, circle){

    var latlon = new google.maps.LatLng(circle.lat, circle.lng);

    var Circle = new google.maps.Circle({
        strokeColor: circle.stroke_colour,
        strokeOpacity: circle.stroke_opacity,
        strokeWeight: circle.stroke_weight,
        fillColor: circle.fill_colour,
        fillOpacity: circle.fill_opacity,
        center: latlon,
        radius: circle.radius
      });

    window[map_id + 'googleCircles'].push(Circle);
    Circle.setMap(window[map_id + 'map']);

    if(circle.info_window){
      add_infoWindow(map_id, infoWindow, Circle, '_information', circle.info_window);
    }

    if(circle.mouse_over){
      add_mouseOver(map_id, infoWindow, Circle, "_mouse_over", circle.mouse_over);
    }
  }

}

function clear_circles(map_id){
  for (i = 0; i < window[map_id + 'googleCircle'].length; i++){
    window[map_id + 'googleCircle'][i].setMap(null);
  }
}

//function add_polyline(map, lat, lng, id){
function add_polylines(map_id, data_polyline){

  // decode and plot polylines
  var infoWindow = new google.maps.InfoWindow();

  for(i = 0; i < Object.keys(data_polyline).length; i++){
    add_lines(map_id, data_polyline[i]);
  }

  function add_lines(map_id, polyline){

    var Polyline = new google.maps.Polyline({
            path: google.maps.geometry.encoding.decodePath(polyline.polyline),
            geodesic: polyline.geodesic,
            //strokeColor: '#0088FF',
            strokeColor: polyline.stroke_colour,
            strokeOpacity: polyline.stroke_opacity,
            strokeWeight: polyline.stroke_weight
          });

    window[map_id + 'googlePolyline'].push(Polyline);
    Polyline.setMap(window[map_id + 'map']);

    if(polyline.info_window){
      add_infoWindow(map_id, infoWindow, Polyline, '_information', polyline.info_window);
    }

//    if(polyline.mouse_over){
//      add_mouseOver(map_id, infoWindow, Polyline, "_mouse_over", polyline.mouse_over);
//    }

  }
}

function clear_polylines(map_id){

  for (i = 0; i < window[map_id + 'googlePolyline'].length; i++){
    window[map_id + 'googlePolyline'][i].setMap(null);
  }
}

function add_polygons(map_id, data_polygon){

  var infoWindow = new google.maps.InfoWindow();

  for(i = 0; i < Object.keys(data_polygon).length; i++){
      add_gons(map_id, data_polygon[i]);
  }

  function add_gons(map_id, polygon){

    var paths = [];
    for(j = 0; j < polygon.polyline.length; j ++){
      paths.push(google.maps.geometry.encoding.decodePath(polygon.polyline[j]));
    }

    //https://developers.google.com/maps/documentation/javascript/reference?csw=1#PolygonOptions
    var Polygon = new google.maps.Polygon({
      paths: paths,
      strokeColor: polygon.stroke_colour,
      strokeOpacity: polygon.stroke_opacity,
      strokeWeight: polygon.stroke_weight,
      fillColor: polygon.fill_colour,
      fillOpacity: polygon.fill_opacity,
      fillOpacityHolder: polygon.fill_opacity,
      mouseOverGroup: polygon.mouse_over_group
      //_information: polygon.information
//      clickable: true,
//      draggable: false,
//      editable: false,
//      strokePosition: "CENTER",
//      visible: true
      //zIndex:1
    });

    if(polygon.info_window){
      add_infoWindow(map_id, infoWindow, Polygon, '_information', polygon.info_window);
    }

    if(polygon.mouse_over || polygon.mouse_over_group){
      add_mouseOver(map_id, infoWindow, Polygon, "_mouse_over", polygon.mouse_over);
    }

    window[map_id + 'googlePolygon'].push(Polygon);
    Polygon.setMap(window[map_id + 'map']);
  }

}

function clear_polygons(map_id){
 for (i = 0; i < window[map_id + 'googlePolygon'].length; i++){
    window[map_id + 'googlePolygon'][i].setMap(null);
  }
}

/**
 *
 * @param map_id
 * @param mapObject
 *          the object the info window is being attached to
 * @param objectAttribute
 *          string attribute name
 * @param attributeValue
 *          the value of the attribute
 */
function add_infoWindow(map_id, infoWindow, mapObject, objectAttribute, attributeValue){

    mapObject.set(objectAttribute, attributeValue);

    google.maps.event.addListener(mapObject, 'click', function(event){

      var infoWindow = new google.maps.InfoWindow();
      infoWindow.setContent(mapObject.get(objectAttribute));

      infoWindow.setPosition(event.latLng);
      infoWindow.open(window[map_id + 'map']);
    });
}

function add_mouseOver(map_id, infoWindow, mapObject, objectAttribute, attributeValue){

  mapObject.set(objectAttribute, attributeValue);

  google.maps.event.addListener(mapObject, 'mouseover', function(event){

    console.log(mapObject);

    if(mapObject.get("mouseOverGroup") !== "NA"){
      // highlight all the shapes in the same group
      for (i = 0; i < window[map_id + 'googlePolygon'].length; i++){
        if(window[map_id + 'googlePolygon'][i].mouseOverGroup == this.mouseOverGroup){
          window[map_id + 'googlePolygon'][i].setOptions({fillOpacity: 1});
        }else{
          window[map_id + 'googlePolygon'][i].setOptions({fillOpacity: 0.1});
        }
      }
    }else{
      this.setOptions({fillOpacity: 1});
    }

    infoWindow.setContent(mapObject.get(objectAttribute).toString());

    infoWindow.setPosition(event.latLng);
    infoWindow.open(window[map_id + 'map']);
  });

  google.maps.event.addListener(mapObject, 'mouseout', function(event){

    if(mapObject.get("mouseOverGroup")){
      // highlight all the shapes in the same group
      for (i = 0; i < window[map_id + 'googlePolygon'].length; i++){
        window[map_id + 'googlePolygon'][i].setOptions({fillOpacity: window[map_id + 'googlePolygon'][i].get('fillOpacityHolder')});
      }
    }else{
      this.setOptions({fillOpacity: mapObject.get('fillOpacityHolder')});
    }
    infoWindow.close();
  });

}



function initialise_map(el, x) {

  // if places
  if(x.search_box === true){
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


