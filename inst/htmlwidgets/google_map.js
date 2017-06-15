HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {
      renderValue: function(x) {

//        DEBUGGING numeric / text
//        myInfo = {id: "a"};
//        let myVar = {
//          myNumber: 123.45678,
//          otherNumber: 987.654321
//        };
//        myInfo = $.extend(myVar, myInfo);
//        Shiny.onInputChange("myData", myInfo);

          // global map objects
          // - display elements
//          window[el.id + 'googleMarkers'] = [];
//          window[el.id + 'googleMarkerClusterer'];
//          window[el.id + 'googleHeatmapLayer'] = [];
//          window[el.id + 'googleHeatmapLayerMVC'] = [];
//          window[el.id + 'googleCircles'] = [];
//          window[el.id + 'googlePolyline'] = [];
//          window[el.id + 'googlePolygon'] = [];
//          window[el.id + 'googlePolygonMVC'] = [];

//          window[el.id + 'googleBounds'] = [];
//          window[el.id + 'googleBounds'] = new google.maps.LatLngBounds();

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
            //window[el.id + 'googleSearchBox'].setAttribute('id', 'search-container');
            window[el.id + 'googleSearchBox'].setAttribute('id', 'pac-input');
            window[el.id + 'googleSearchBox'].setAttribute('class', 'controls');
            window[el.id + 'googleSearchBox'].setAttribute('type', 'text');
            window[el.id + 'googleSearchBox'].setAttribute('placeholder', 'Search location');
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

            //window.onload = function() {

              console.log("window onload");
              var mapDiv = document.getElementById(el.id);

              mapDiv.className = "googlemap";

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
            //};
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
 * adds a fusion layer to the map
 *
 */
function add_fusion(map_id, query, styles, heat, layer_id){

// TODO: extend map bounds

  window[map_id + 'googleFusion' + layer_id] = [];

  var s = JSON.parse(styles);

  var layer = new google.maps.FusionTablesLayer({
    query: query,
    styles: s,
    heatmap: { enabled: heat }
  });

  window[map_id + 'googleFusion' + layer_id] = layer;
  layer.setMap(window[map_id + 'map']);
}

/**
 * clear fusion
 *
 * clears fusion layer
 */
function clear_fusion(map_id, layer_id){
  window[map_id + 'googleFusion' + layer_id].setMap(null);
  window[map_id + 'googleFusion' + layer_id] = null;
}



/**
 * Add markers
 *
 * adds markers to a google map object
 *
 * @param map_id
 *          the map object to which the markers will be added
 * @param data_markers
 *          JSON array of marker data
 * @param cluster
 *          logical, indicating if the markers should cluster when zoomed out
 * @param layer_id
 *          the layer identifier
 */
function add_markers(map_id, data_markers, cluster, layer_id){

  var markers = [];
  var i;
  var infoWindow = new google.maps.InfoWindow();
//  var bounds = new google.maps.LatLngBounds();
  window[map_id + 'googleMarkers' + layer_id] = [];

  for (i = 0; i < Object.keys(data_markers).length; i++){

    var latlon = new google.maps.LatLng(data_markers[i].lat, data_markers[i].lng);

    var marker = new google.maps.Marker({
      id: data_markers[i].id,
      icon: data_markers[i].url,
      position: latlon,
      draggable: data_markers[i].draggable,
      opacity: data_markers[i].opacity,
      opacityHolder: data_markers[i].opacity,
      title: data_markers[i].title,
      label: data_markers[i].label,
      mouseOverGroup: data_markers[i].mouse_over_group
    });

    if(data_markers[i].info_window){

      marker.infowindow = new google.maps.InfoWindow({
        content: data_markers[i].info_window
      });

      google.maps.event.addListener(marker, 'click', function() {
        this.infowindow.open(window[map_id + 'map'], this);
      });

      //add_infoWindow(map_id, marker, infoWindow, '_information', data_markers[i].info_window);

      //mapObject.set(objectAttribute, attributeValue);
//      marker.addListener('click', function(event){
//              console.log(data_markers[i]);

        // the listener is being bound to the mapObject. So, when the infowindow
        // contents are updated, the 'click' listener will need to see the new information
        // ref: http://stackoverflow.com/a/13504662/5977215
        //mapObject.setOptions({"_information": mapObject.get(objectAttribute)});

//        infoWindow.setContent(data_markers[i].info_window);

//        infoWindow.setPosition(event.latLng);
//        infoWindow.open(window[map_id + 'map']);
//      });

    }

    if(data_markers[i].mouse_over || data_markers[i].mouse_over_group){
      add_mouseOver(map_id, marker, infoWindow, '_mouse_over', data_markers[i].mouse_over, layer_id, 'googleMarkers');
    }

    markerInfo = {
      layerId : layer_id,
      lat : data_markers[i].lat.toFixed(4),
      lon : data_markers[i].lng.toFixed(4)
    };

    marker_click(map_id, marker, marker.id, markerInfo);


    window[map_id + 'mapBounds'].extend(latlon);

    window[map_id + 'googleMarkers' + layer_id].push(marker);
    markers.push(marker);
    marker.setMap(window[map_id + 'map']);
  }

  if(cluster === true){
    window[map_id + 'googleMarkerClusterer' + layer_id] = new MarkerClusterer(window[map_id + 'map'], markers,
    {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});

  }

  window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
}

/**
 * Clear markers
 *
 * clears markes from a google map object
 *
 * @param map_id
 *          the map to clear
 * @param layer_id
 *          the layer to clear
 */
function clear_markers(map_id, layer_id){

  // the markers know which map they're on
  // http://stackoverflow.com/questions/7961522/removing-a-marker-in-google-maps-api-v3
  for (i = 0; i < window[map_id + 'googleMarkers' + layer_id ].length; i++){
      window[map_id + 'googleMarkers' + layer_id][i].setMap(null);
  }
  window[map_id + 'googleMarkers' + layer_id] = null;

  if(window[map_id + 'googleMarkerClusterer' + layer_id]){
    window[map_id + 'googleMarkerClusterer' + layer_id].clearMarkers();
    window[map_id + 'googleMarkerClusterer' + layer_id] = null;
  }

}

/**
 * Add circles
 *
 * Adds circles to the map
 *
 * @param map_id
 * @param data_circles
 * @param layer_id
 */
function add_circles(map_id, data_circles, layer_id){

  var i;
  window[map_id + 'googleCircles' + layer_id] = [];
  var infoWindow = new google.maps.InfoWindow();

  for (i = 0; i < Object.keys(data_circles).length; i++) {
    add_circle(map_id, data_circles[i]);
  }

  function add_circle(map_id, circle){

    var latlon = new google.maps.LatLng(circle.lat, circle.lng);

    var Circle = new google.maps.Circle({
        id: circle.id,
        strokeColor: circle.stroke_colour,
        strokeOpacity: circle.stroke_opacity,
        strokeWeight: circle.stroke_weight,
        fillColor: circle.fill_colour,
        fillOpacity: circle.fill_opacity,
        fillOpacityHolder: circle.fill_opacity,
        draggable: circle.draggable,
        center: latlon,
        radius: circle.radius,
        mouseOverGroup: circle.mouse_over_group,
        zIndex: circle.z_index
      });

    window[map_id + 'googleCircles' + layer_id].push(Circle);
    Circle.setMap(window[map_id + 'map']);

    if(circle.info_window){
      add_infoWindow(map_id, Circle, infoWindow, '_information', circle.info_window);
    }

    if(circle.mouse_over || circle.mouse_over_group){
      add_mouseOver(map_id, Circle, infoWindow, "_mouse_over", circle.mouse_over, layer_id, 'googleCircles');
    }

    shapeInfo = { layerId : layer_id };
    shape_click(map_id, Circle, circle.id, shapeInfo);

    window[map_id + 'mapBounds'].extend(latlon);
  }

  window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);

}

/**
 * clears circles from a google map object
 * @param map_id
 *          the map to clear
 * @param layer_id
 *          the layer to clear
 */
function clear_circles(map_id, layer_id){
  for (i = 0; i < window[map_id + 'googleCircles' + layer_id].length; i++){
    window[map_id + 'googleCircles' + layer_id][i].setMap(null);
  }
  window[map_id + 'googleCircles' + layer_id] = null;

}

/**
 * Updates polygon options
 * @param map_id
 *          the map containing the circles
 * @param data_circle
 *          circles data to update
 * @param addRemove
 *          boolean specifying if circles should be added or removed if they are / are not included in the udpated data set
 */
function update_circles(map_id, data_circle, layer_id){

  // for a given circle_id, change the options
  var objectAttribute;
  var attributeValue;
  var _id;
  var thisUpdateCircle;
  var currentIds = [];
  var newIds = [];
  var newPolygons = [];

  for(i = 0; i < Object.keys(window[map_id + 'googleCircles' + layer_id]).length; i++){

    _id = window[map_id + 'googleCircles' + layer_id][i].id;
    currentIds.push(_id);

    // find if there is a matching id in the new circle data set


    // array is date_circles[],
    // value to find is _id,

    thisUpdateCircle = findById(data_circle, _id);
    if(thisUpdateCircle !== undefined){

    //if(data_circle.find(x => x.id === _id)){
      //thisUpdateCircle = data_circle.find(x => x.id === _id);

      //if the circle is currently set to Null, re-put it on the map
      if(window[map_id + 'googleCircles' + layer_id][i].getMap() === null){
        window[map_id + 'googleCircles' + layer_id][i].setMap(window[map_id + 'map']);
      }

      // the new id exists in the current data set
      // update the values for this circle

      // for each of the options in data_circle, update the circles
      for(j = 0; j < Object.keys(thisUpdateCircle).length; j++){

        objectAttribute = Object.keys(thisUpdateCircle)[j];

        attributeValue = thisUpdateCircle[objectAttribute];

        switch(objectAttribute){
          case "radius":
            window[map_id + 'googleCircles' + layer_id][i].setOptions({radius: attributeValue});
            break;
          case "draggable":
            window[map_id + 'googleCircles' + layer_id][i].setOptions({draggable: attributeValue});
            break;
          case "fill_colour":
            window[map_id + 'googleCircles' + layer_id][i].setOptions({fillColor: attributeValue});
            break;
          case "fill_opacity":
            window[map_id + 'googleCircles' + layer_id][i].setOptions({fillOpacity: attributeValue});
            window[map_id + 'googleCircles' + layer_id][i].setOptions({fillOpacityHolder: attributeValue});
            break;
          case "stroke_colour":
            window[map_id + 'googleCircles' + layer_id][i].setOptions({strokeColor: attributeValue});
            break;
          case "stroke_weight":
            window[map_id + 'googleCircles' + layer_id][i].setOptions({strokeWeight: attributeValue});
            break;
          case "stroke_opacity":
            window[map_id + 'googleCircles' + layer_id][i].setOptions({strokeOpacity: attributeValue});
            break;
          case "info_window":
            window[map_id + 'googleCircles' + layer_id][i].setOptions({_information: attributeValue});
            break;
        }
      }

    }else{
        window[map_id + 'googleCircles' + layer_id][i].setMap(null);
    }
  }
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
 * Adds a heatmap layer to a google map object
 * @param map_id
 *          the map to which the heatmap will be added
 * @param data_heatmap
 *          JSON array of heatmap data
 * @param heatmap_options
 *          other options passed to the heatmap layer
 * @param layer_id
 *          the id of the layer
 */
function add_heatmap(map_id, data_heatmap, heatmap_options, layer_id){

  //heat = HTMLWidgets.dataframeToD3(data_heatmap);
  //heat_options = HTMLWidgets.dataframeToD3(heatmap_options);
  heat_options = heatmap_options;

  // need an array of google.maps.LatLng points
  var heatmapData = [];
  var i;
  window[map_id + 'googleHeatmap' + layer_id] = [];
  window[map_id + 'googleHeatmapLayerMVC' + layer_id] = [];
//  var bounds = new google.maps.LatLngBounds();

  // turn row of the data into LatLng, and push it to the array

  for(i = 0; i < Object.keys(data_heatmap).length; i++){
    latlon = new google.maps.LatLng(data_heatmap[i].lat, data_heatmap[i].lng);
    heatmapData[i] = {
      location: latlon,
      weight: data_heatmap[i].weight
    };

    //bounds.extend(latlon);
    window[map_id + 'mapBounds'].extend(latlon);
  }

  // store in MVC array
  window[map_id + 'googleHeatmapLayerMVC' + layer_id] = new google.maps.MVCArray(heatmapData);

  var heatmap = new google.maps.visualization.HeatmapLayer({
    data: window[map_id + 'googleHeatmapLayerMVC' + layer_id]
  });

  heatmap.setOptions({
    radius: heat_options[0].radius,
    opacity: heat_options[0].opacity,
    dissipating: heat_options[0].dissipating
  });

  if(heat_options[0].gradient !== undefined){
    heatmap.set('gradient', heat_options[0].gradient);
  }

  window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);

  // fill the heatmap variable with the MVC array of heatmap data
  // when the MVC array is updated, the layer is also updated
  window[map_id + 'googleHeatmap' + layer_id] = heatmap;
  heatmap.setMap(window[map_id + 'map']);
}

/**
 * Updates the heatmap layer with new data
 * @param map_id
 *          the map to update
 * @param data_heatmap
 *          the data to put into the heatmap layer
 * @param layer_id
 *          the heatmap layer to update
 */
function update_heatmap(map_id, data_heatmap, layer_id){

  if(window[map_id + 'googleHeatmap' + layer_id] !== undefined){

    // update the heatmap array
    window[map_id + 'googleHeatmapLayerMVC' + layer_id].clear();

    var heatmapData = [];
    var i;

    // turn row of the data into LatLng, and push it to the array
    for(i = 0; i < Object.keys(data_heatmap).length; i++){
      var latlon = new google.maps.LatLng(data_heatmap[i].lat, data_heatmap[i].lng);

      heatmapData[i] = {
        location: latlon,
        weight: data_heatmap[i].weight
      };

      window[map_id + 'googleHeatmapLayerMVC' + layer_id].push(heatmapData[i]);
      //bounds.extend(latlon);
      window[map_id + 'mapBounds'].extend(latlon);
    }

    window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
  }

}

/** Clear heatmap
 *
 * Clears heatmap from the map
 *
 * @param map_id
 *          the id of the map
 * @param layer_id
 *          the id of the layer
 */
function clear_heatmap(map_id, layer_id){
  window[map_id + 'googleHeatmap' + layer_id].setMap(null);
  window[map_id + 'googleHeatmap' + layer_id] = null;
}

/** Add polylines
 *
 * Adds polylines to the map
 *
 * @param map_id
 * @param data_polyine
 * @param update_map_view
 * @param layer_id
 * @param use_polyline
 *          boolean indicating if the data is an encoded polyline
 */
function add_polylines(map_id, data_polyline, update_map_view, layer_id, use_polyline){

  window[map_id + 'googlePolyline' + layer_id] = [];
  var infoWindow = new google.maps.InfoWindow();

  // if we are using a polyline column, then it's just one row per line
  // if it's columns of lat/lon, then it's many rows per line
  for(i = 0; i < Object.keys(data_polyline).length; i++){

    if(use_polyline){
      thisPath = google.maps.geometry.encoding.decodePath(data_polyline[i].polyline);
    }else{
      thisPath = [];

      for(j = 0; j < Object.keys(data_polyline[i].coords).length; j++){
        thisPath.push(data_polyline[i].coords[j]);
      }
    }
    add_lines(map_id, data_polyline[i], layer_id, thisPath);
  }


  function add_lines(map_id, polyline, layer_id, thisPath){

    var Polyline = new google.maps.Polyline({
      path: thisPath,
      id: polyline.id,
      geodesic: polyline.geodesic,
      strokeColor: polyline.stroke_colour,
      strokeOpacity: polyline.stroke_opacity,
      strokeOpacityHolder: polyline.stroke_opacity,
      strokeWeight: polyline.stroke_weight,
      mouseOver: polyline.mouse_over,
      mouseOverGroup: polyline.mouse_over_group,
      zIndex: polyline.z_index

    });

    window[map_id + 'googlePolyline' + layer_id].push(Polyline);
    Polyline.setMap(window[map_id + 'map']);

    if(update_map_view === true){
      // extend the bounds of the map
      var points = Polyline.getPath().getArray();

      for ( var n = 0; n < points.length; n++){
        window[map_id + 'mapBounds'].extend(points[n]);
      }
    }

    if(polyline.info_window){
      add_infoWindow(map_id, Polyline, InfoWindow, '_information', polyline.info_window);
    }

    // need to add the listener once so it's not overwritten?
    if(polyline.mouse_over || polyline.mouse_over_group){
      add_mouseOver(map_id, Polyline, infoWindow, "_mouse_over", polyline.mouse_over, layer_id, 'googlePolyline');
    }

    polylineInfo = { layerId : layer_id };
    polyline_click(map_id, Polyline, polyline.id, polylineInfo);

    //shapeInfo = { layerId : layer_id };
    //shape_click(map_id, Polyline, polyline.id, shapeInfo);

  }

  if(update_map_view === true){
    window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
  }

}


/**
 * Updates polyline options
 * @param map_id
 *          the map containing the polygons
 * @param data_polylines
 *          polyline data to update
 */
function update_polylines(map_id, data_polyline, layer_id){

  // for a given polygon_id, change the options
  var objectAttribute;
  var attributeValue;
  var _id;
  var thisUpdatePolyline;
  var currentIds = [];
  var newIds = [];
  var newPolylines = [];

  if(window[map_id + 'googlePolyline' + layer_id] !== undefined ){

    for(i = 0; i < Object.keys(window[map_id + 'googlePolyline' + layer_id]).length; i++){

      _id = window[map_id + 'googlePolyline' + layer_id][i].id;

      currentIds.push(_id);

      // find if there is a matching id in the new polyline data set
    thisUpdatePolyline = findById(data_polyline, _id);
    if(thisUpdatePolyline !== undefined){
      //if(data_polyline.find(x => x.id === _id)){
        //thisUpdatePolyline = data_polyline.find(x => x.id === _id);

        //if the polygon is currently set to Null, re-put it on the map
        if(window[map_id + 'googlePolyline' + layer_id][i].getMap() === null){
          window[map_id + 'googlePolyline' + layer_id][i].setMap(window[map_id + 'map']);
        }

        // the new id exists in the current data set
        // update the values for this polygon

        // for each of the options in data_polyline, update the polygons
        for(j = 0; j < Object.keys(thisUpdatePolyline).length; j++){

          objectAttribute = Object.keys(thisUpdatePolyline)[j];
          attributeValue = thisUpdatePolyline[objectAttribute];

          switch(objectAttribute){
            case "stroke_colour":
              window[map_id + 'googlePolyline' + layer_id][i].setOptions({strokeColor: attributeValue});
              break;
            case "stroke_weight":
              window[map_id + 'googlePolyline' + layer_id][i].setOptions({strokeWeight: attributeValue});
              break;
            case "stroke_opacity":
              window[map_id + 'googlePolyline' + layer_id][i].setOptions({strokeOpacity: attributeValue});
              break;
            case "info_window":
              window[map_id + 'googlePolyline' + layer_id][i].setOptions({_information: attributeValue});
              break;
          }
        }

      }else{
        // the id does not exist in the new data set
        //if(removeMissing){
          // remove the polygon from the map
          // (but don't clear it from the arrray?)
          window[map_id + 'googlePolyline' + layer_id][i].setMap(null);
        //}
      }
    }
  }

}




function clear_polylines(map_id, layer_id){

  for (i = 0; i < window[map_id + 'googlePolyline' + layer_id].length; i++){
    window[map_id + 'googlePolyline' + layer_id][i].setMap(null);
  }
  window[map_id + 'googlePolyline' + layer_id] = null;
}


/** Add polygons
 *
 * adds polygons to the map
 * @param map_id
 * @param data_polygon
 */
function add_polygons(map_id, data_polygon, update_map_view, layer_id, use_polyline){

  window[map_id + 'googlePolygon' + layer_id] = [];
  var infoWindow = new google.maps.InfoWindow();

  for(i = 0; i < Object.keys(data_polygon).length; i++){
      add_gons(map_id, data_polygon[i]);
  }

  function add_gons(map_id, polygon){

    var paths = [];

    if(use_polyline){
      for(j = 0; j < polygon.polyline.length; j ++){
        paths.push(google.maps.geometry.encoding.decodePath(polygon.polyline[j]));
      }
    }else{

      for(j = 0; j < polygon.coords.length; j++){
        paths.push(polygon.coords[j]);
      }
    }


    //https://developers.google.com/maps/documentation/javascript/reference?csw=1#PolygonOptions
    var Polygon = new google.maps.Polygon({
      id: polygon.id,
      paths: paths,
      strokeColor: polygon.stroke_colour,
      strokeOpacity: polygon.stroke_opacity,
      strokeWeight: polygon.stroke_weight,
      fillColor: polygon.fill_colour,
      fillOpacity: polygon.fill_opacity,
      fillOpacityHolder: polygon.fill_opacity,
      mouseOver: polygon.mouse_over,
      mouseOverGroup: polygon.mouse_over_group,
      draggable: polygon.draggable,
      editable: polygon.editable,
      zIndex: polygon.z_index
      //_information: polygon.information
//      clickable: true,
//      editable: false,
//      strokePosition: "CENTER",
//      visible: true
      //zIndex:1
    });

    //console.log(Polygon);

    if(polygon.info_window){
      add_infoWindow(map_id, Polygon, infoWindow, '_information', polygon.info_window);
    }

    if(polygon.mouse_over || polygon.mouse_over_group){
      add_mouseOver(map_id, Polygon, infoWindow, "_mouse_over", polygon.mouse_over, layer_id, 'googlePolygon');
    }

    polygonInfo = { layerId : layer_id };
    polygon_click(map_id, Polygon, polygon.id, polygonInfo);

    window[map_id + 'googlePolygon' + layer_id].push(Polygon);
    Polygon.setMap(window[map_id + 'map']);

    if(update_map_view === true){

      var points = paths[0];

      for ( var n = 0; n < points.length; n++){
        window[map_id + 'mapBounds'].extend(points[n]);
      }
    }
  }

  if(update_map_view === true){
    window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
  }

}

/**
 * Updates polygon options
 * @param map_id
 *          the map containing the polygons
 * @param data_polygon
 *          polygon data to update
 * @param addRemove
 *          boolean specifying if polygons should be added or removed if they are / are not included in the udpated data set
 */
function update_polygons(map_id, data_polygon, layer_id){

  // for a given polygon_id, change the options
  var objectAttribute;
  var attributeValue;
  var _id;
  var thisUpdatePolygon;
  var currentIds = [];
  var newIds = [];
  var newPolygons = [];

  for(i = 0; i < Object.keys(window[map_id + 'googlePolygon' + layer_id]).length; i++){

    _id = window[map_id + 'googlePolygon' + layer_id][i].id;
    currentIds.push(_id);

    // find if there is a matching id in the new polygon data set
    thisUpdatePolygon = findById(data_polygon, _id);
    if(thisUpdatePolygon !== undefined){
    //if(data_polygon.find(x => x.id === _id)){
      //thisUpdatePolygon = data_polygon.find(x => x.id === _id);

      //if the polygon is currently set to Null, re-put it on the map
      if(window[map_id + 'googlePolygon' + layer_id][i].getMap() === null){
        window[map_id + 'googlePolygon' + layer_id][i].setMap(window[map_id + 'map']);
      }

      // the new id exists in the current data set
      // update the values for this polygon

      // for each of the options in data_polygon, update the polygons
      for(j = 0; j < Object.keys(thisUpdatePolygon).length; j++){

        objectAttribute = Object.keys(thisUpdatePolygon)[j];
        attributeValue = thisUpdatePolygon[objectAttribute];

        switch(objectAttribute){
          case "fill_colour":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({fillColor: attributeValue});
            break;
          case "fill_opacity":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({fillOpacity: attributeValue});
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({fillOpacityHolder: attributeValue});
            break;
          case "stroke_colour":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({strokeColor: attributeValue});
            break;
          case "stroke_weight":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({strokeWeight: attributeValue});
            break;
          case "stroke_opacity":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({strokeOpacity: attributeValue});
            break;
          case "info_window":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({_information: attributeValue});
            break;
        }
      }

    }else{
      // the id does not exist in the new data set
      //if(removeMissing){
        // remove the polygon from the map
        // (but don't clear it from the arrray?)
        window[map_id + 'googlePolygon' + layer_id][i].setMap(null);
      //}
    }
  }


// NOTE:
// can't add individual polygons to the map
//  if(addExtra){
      // find those in the new set that aren't in the current set
//      for(var o in data_polygon){
//        newIds.push(data_polygon[o].id);
//      }

//      let difference = newIds.filter(x => currentIds.indexOf(x) == -1);

//      for(i = 0; i < difference.length; i++){
//        newPolygons.push(data_polygon.find(x => x.id === difference[i]));
//        window[map_id + 'googlePolygon'].find(x => x.id === difference[i]).setMap(window[map_id + 'map']);
//      }
//      if(Object.keys(newPolygons).length > 0){
//        newPolygons = Object.keys(newPolygons).map(key => newPolygons[key]);
//        add_polygons(map_id, newPolygons);
//     }
//    }
}

/**
 * Clears polygons from a map
 *
 * @param map_id
 * @param layer_id
 */
function clear_polygons(map_id, layer_id){

 for (i = 0; i < window[map_id + 'googlePolygon' + layer_id].length; i++){
    window[map_id + 'googlePolygon' + layer_id][i].setMap(null);
  }
  window[map_id + 'googlePolygon' + layer_id] = null;
}


function add_rectangles(map_id, data_rectangles, layer_id){

  var i;
  window[map_id + 'googleRectangles' + layer_id] = [];
  var infoWindow = new google.maps.InfoWindow();

 for (i = 0; i < Object.keys(data_rectangles).length; i++) {
    add_rectangle(map_id, data_rectangles[i]);
  }

  function add_rectangle(map_id, rectangle){

    var latlonNorthEast = new google.maps.LatLng(rectangle.north, rectangle.east);
    var latlonSouthWest = new google.maps.LatLng(rectangle.south, rectangle.west);

    var bounds = new google.maps.LatLngBounds(
      latlonSouthWest,
      latlonNorthEast
    )

    var Rectangle = new google.maps.Rectangle({
        id: rectangle.id,
        bounds: bounds,
        strokeColor: rectangle.stroke_colour,
        strokeOpacity: rectangle.stroke_opacity,
        strokeWeight: rectangle.stroke_weight,
        fillColor: rectangle.fill_colour,
        fillOpacity: rectangle.fill_opacity,
        draggable: rectangle.draggable,
        editable: rectangle.editable,
        radius: rectangle.radius,
        mouseOverGroup: rectangle.mouse_over_group,
        zIndex: rectangle.z_index
      });

    window[map_id + 'googleRectangles' + layer_id].push(Rectangle);
    Rectangle.setMap(window[map_id + 'map']);

    if(rectangle.info_window){
      add_infoWindow(map_id, Rectangle, infoWindow, '_information', rectangle.info_window);
    }

    if(rectangle.mouse_over || rectangle.mouse_over_group){
      add_mouseOver(map_id, Rectangle, infoWindow, "_mouse_over", rectangle.mouse_over, layer_id, 'googleRectangles');
    }

    shapeInfo = { layerId : layer_id };
    shape_click(map_id, Rectangle, rectangle.id, shapeInfo);

    window[map_id + 'mapBounds'].extend(latlonNorth);
    window[map_id + 'mapBounds'].extend(latlonSouth);
  }

  window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);

}


/**
 * clears rectangles from a google map object
 * @param map_id
 *          the map to clear
 * @param layer_id
 *          the layer to clear
 */
function clear_rectangles(map_id, layer_id){
  for (i = 0; i < window[map_id + 'googleRectangles' + layer_id].length; i++){
    window[map_id + 'googleRectangles' + layer_id][i].setMap(null);
  }
  window[map_id + 'googleRectangles' + layer_id] = null;
}



function update_rectangles(map_id, data_rectangles, layer_id){

  // for a given circle_id, change the options
  var objectAttribute;
  var attributeValue;
  var _id;
  var thisUpdateRectangle;
  var currentIds = [];

  for(i = 0; i < Object.keys(window[map_id + 'googleRectangles' + layer_id]).length; i++){

    _id = window[map_id + 'googleRectangles' + layer_id][i].id;
    currentIds.push(_id);

    // find if there is a matching id in the new polygon data set
    thisUpdateRectangle = findById(data_rectangles, _id);
    if(thisUpdateRectangle !== undefined){

//    if(data_rectangles.find(x => x.id === _id)){
//      thisUpdateRectangle = data_rectangles.find(x => x.id === _id);

      //if the polygon is currently set to Null, re-put it on the map
      if(window[map_id + 'googleRectangles' + layer_id][i].getMap() === null){
        window[map_id + 'googleRectangles' + layer_id][i].setMap(window[map_id + 'map']);
      }

      // the new id exists in the current data set
      // update the values for this polygon

      // for each of the options in data_polygon, update the polygons
      for(j = 0; j < Object.keys(thisUpdateRectangle).length; j++){

        objectAttribute = Object.keys(thisUpdateRectangle)[j];

        attributeValue = thisUpdateRectangle[objectAttribute];

        switch(objectAttribute){
          case "draggable":
            window[map_id + 'googleRectangles' + layer_id][i].setOptions({draggable: attributeValue});
            break;
          case "fill_colour":
            window[map_id + 'googleRectangles' + layer_id][i].setOptions({fillColor: attributeValue});
            break;
          case "fill_opacity":
            window[map_id + 'googleRectangles' + layer_id][i].setOptions({fillOpacity: attributeValue});
            window[map_id + 'googleRectangles' + layer_id][i].setOptions({fillOpacityHolder: attributeValue});
            break;
          case "stroke_colour":
            window[map_id + 'googleRectangles' + layer_id][i].setOptions({strokeColor: attributeValue});
            break;
          case "stroke_weight":
            window[map_id + 'googleRectangles' + layer_id][i].setOptions({strokeWeight: attributeValue});
            break;
          case "stroke_opacity":
            window[map_id + 'googleRectangles' + layer_id][i].setOptions({strokeOpacity: attributeValue});
            break;
          case "info_window":
            window[map_id + 'googleRectangles' + layer_id][i].setOptions({_information: attributeValue});
            break;
        }
      }

    }else{
        window[map_id + 'googleRectangles' + layer_id][i].setMap(null);
    }
  }
}


function add_kml(map_id, kml_data, layer_id){

  window[map_id + 'googleKml' + layer_id] = [];

  var kmlLayer = new google.maps.KmlLayer({
    url: kml_data[0].url,
    map: window[map_id + 'map']
  });

  window[map_id + 'googleKml' + layer_id].push(kmlLayer);

}


function clear_kml(map_id, layer_id){
  for (i = 0; i < window[map_id + 'googleKml' + layer_id].length; i++){
    window[map_id + 'googleKml' + layer_id][i].setMap(null);
  }
  window[map_id + 'googleKml' + layer_id] = null;
}

function add_overlay(map_id, data_overlay, layer_id){

  window[map_id + 'googleOverlay' + layer_id] = [];

  var latlonNorthEast = new google.maps.LatLng(data_overlay[0].north, data_overlay[0].east);
  var latlonSouthWest = new google.maps.LatLng(data_overlay[0].south, data_overlay[0].west);

  var bounds = {
    north: data_overlay[0].north,
    east: data_overlay[0].east,
    south: data_overlay[0].south,
    west: data_overlay[0].west
  };

  var overlayLayer = new google.maps.GroundOverlay(
    data_overlay[0].url,
    bounds
  );

  overlayLayer.setMap(window[map_id + 'map']);

  window[map_id + 'mapBounds'].extend(latlonNorthEast);
  window[map_id + 'mapBounds'].extend(latlonSouthWest);

  window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds'])
  window[map_id + 'googleOverlay' + layer_id].push(overlayLayer);

}


function clear_overlay(map_id, layer_id){
  for (i = 0; i < window[map_id + 'googleOverlay' + layer_id].length; i++){
    window[map_id + 'googleOverlay' + layer_id][i].setMap(null);
  }
  window[map_id + 'googleOverlay' + layer_id] = null;
}

function add_mouseOver(map_id, mapObject, infoWindow, objectAttribute, attributeValue, layer_id, layerType){

  // notes
  // - mouseOver and mosueOverGroup need to have the same listener.
  // - the group takes precedence.


  mapObject.set(objectAttribute, attributeValue);

  // this infoWindow object is created so the 'mouseout' function doeesn't 'close'
  // the info window that's generated by clicking on the map.
  var infoWindow = new google.maps.InfoWindow();

  google.maps.event.addListener(mapObject, 'mouseover', function(event){

    if(mapObject.get("mouseOverGroup") !== undefined){
      // polygons can be made up of many shapes
      // so we need to iterate each one with the same id

      // markers only have opacity
      if(layerType === 'googleMarkers'){

        for (i = 0; i < window[map_id + layerType + layer_id].length; i++){
          if(window[map_id + layerType + layer_id][i].mouseOverGroup == this.mouseOverGroup){
            window[map_id + layerType + layer_id][i].setOptions({Opacity: 1});
          }else{
            window[map_id + layerType + layer_id][i].setOptions({Opacity: 0.01});
          }
        }

      // polylines only have strokeOpacity
      }else if(layerType === 'googlePolyline'){

        for (i = 0; i < window[map_id + layerType + layer_id].length; i++){
          if(window[map_id + layerType + layer_id][i].mouseOverGroup == this.mouseOverGroup){
            window[map_id + layerType + layer_id][i].setOptions({strokeOpacity: 1});
          }else{
            window[map_id + layerType + layer_id][i].setOptions({strokeOpacity: 0.01});
          }
        }
      }else{

        // other shapes have fillOpacity
        for (i = 0; i < window[map_id + layerType + layer_id].length; i++){
          if(window[map_id + layerType + layer_id][i].mouseOverGroup == this.mouseOverGroup){
            window[map_id + layerType + layer_id][i].setOptions({fillOpacity: 1});
          }else{
            window[map_id + layerType + layer_id][i].setOptions({fillOpacity: 0.01});
          }
        }
      }

    //}else{
      // mouseOverGroup is undefined...
      /**
      if(layerType === 'googleMarkers'){
        this.setOptions({Opacity: 1})
      }else if(layerType === 'googlePolyline'){
        this.setOptions({strokeOpacity: 1})
      }else{
        this.setOptions({fillOpacity: 1});
      }
      **/

      // infoWindow if 'mouseOver' is also specified
      if(mapObject.get("mouseOver") !== undefined){

        mapObject.setOptions({"_mouse_over": mapObject.get(objectAttribute)});

        infoWindow.setContent(mapObject.get(objectAttribute).toString());

        infoWindow.setPosition(event.latLng);
        infoWindow.open(window[map_id + 'map']);
      }

    }else{

      // if the mouse_over is specified without the group, we need an info window
      if(mapObject.get("mouseOver") !== undefined){
        mapObject.setOptions({"_mouse_over": mapObject.get(objectAttribute)});

        infoWindow.setContent(mapObject.get(objectAttribute).toString());

        infoWindow.setPosition(event.latLng);
        infoWindow.open(window[map_id + 'map']);
      }
    }

  });

  google.maps.event.addListener(mapObject, 'mouseout', function(event){

    if(mapObject.get("mouseOverGroup") !== undefined){
      // reset highlights

      if(layerType === 'googleMarkers'){
        for (i = 0; i < window[map_id + layerType + layer_id].length; i++){
          window[map_id + layerType + layer_id][i].setOptions({Opacity: window[map_id + layerType + layer_id][i].get('OpacityHolder')});
        }
      }else if(layerType === 'googlePolyline'){
        for (i = 0; i < window[map_id + layerType + layer_id].length; i++){
          window[map_id + layerType + layer_id][i].setOptions({strokeOpacity: window[map_id + layerType + layer_id][i].get('strokeOpacityHolder')});
        }
      }else{
        for (i = 0; i < window[map_id + layerType + layer_id].length; i++){
          window[map_id + layerType + layer_id][i].setOptions({fillOpacity: window[map_id + layerType + layer_id][i].get('fillOpacityHolder')});
        }
      }

    }else{

      if(layerType === 'googleMarkers'){
        this.setOptions({Opacity: mapObject.get('OpacityHolder')});
      }else if(layerType === 'googlePolyline'){
        this.setOptions({strokeOpacity: mapObject.get('strokeOpacityHolder')})
      }else{
        this.setOptions({fillOpacity: mapObject.get('fillOpacityHolder')});
      }

    }
    infoWindow.close();
  });

}

/**
 * Map click
 *
 * Returns details of the click even on a map
 **/
function map_click(map_id, mapObject, mapInfo){

  if(!HTMLWidgets.shinyMode) return;

  //Shiny.onInputChange("myMapData", 123.7887);

  google.maps.event.addListener(mapObject, 'click', function(event){
//   mapObject.addListener('click', function(){
//
    var eventInfo = $.extend(
      mapInfo,
      {
        id: map_id,
//        latNumeric: event.latLng.lat(),
        lat: event.latLng.lat().toFixed(4),
        lon: event.latLng.lng().toFixed(4),
        centerLat: mapObject.getCenter().lat().toFixed(4),
        centerLng: mapObject.getCenter().lng().toFixed(4),
        zoom: mapObject.getZoom(),
        randomValue: Math.random()
      }
    );

    // logging messages for debugging numerics / text error
//    console.log("map clicked - event.latLng.lat(): ");
//    console.log(event.latLng.lat());

    Shiny.onInputChange(map_id + "_map_click", eventInfo);
  })
}

function bounds_changed(map_id, mapObject, mapInfo){
  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(mapObject, 'bounds_changed', function(event){
    var eventInfo = $.extend(
      {
        id: map_id,
//        bounds:mapObject.getBounds(),
//        east: mapObject.getBounds().toJSON().east.toFixed(4),
//        north: mapObject.getBounds().toJSON().north.toFixed(4),
//        south: mapObject.getBounds().toJSON().south.toFixed(4),
//        west: mapObject.getBounds().toJSON().west.toFixed(4),
        northEastLat: mapObject.getBounds().getNorthEast().lat().toFixed(4),
        northEastLon: mapObject.getBounds().getNorthEast().lng().toFixed(4),
        southWestLat: mapObject.getBounds().getSouthWest().lat().toFixed(4),
        southWestLon: mapObject.getBounds().getSouthWest().lng().toFixed(4),
        randomValue: Math.random()
      },
      mapInfo
    );

    Shiny.onInputChange(map_id + "_bounds_changed", eventInfo);
  })
}

function zoom_changed(map_id, mapObject, mapInfo){

    if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(mapObject, 'bounds_changed', function(event){
    var eventInfo = $.extend(
      {
        id: map_id,
        zoom: mapObject.getZoom(),
        randomValue: Math.random()
      },
      mapInfo
    );

    Shiny.onInputChange(map_id + "_zoom_changed", eventInfo);
  })

}

/**
 * Marker click
 *
 * Returns details of the marker that was clicked
 **/
function marker_click(map_id, markerObject, marker_id, markerInfo){
  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(markerObject, 'click', function(event){

    var eventInfo = $.extend(
      {
        id: marker_id,
        lat: event.latLng.lat().toFixed(4),
        lon: event.latLng.lng().toFixed(4),
        randomValue: Math.random()
      },
      markerInfo
    );

    Shiny.onInputChange(map_id + "_marker_click", eventInfo);
  })
}

/**
 * Shape Click
 *
 * Returns the 'id' of the shape that was clicked back to shiny
 *
 **/
function shape_click(map_id, shapeObject, shape_id, shapeInfo){

  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(shapeObject, 'click', function(event){

    var eventInfo = $.extend(
      {
        id: shape_id,
        lat: event.latLng.lat().toFixed(4),
        lon: event.latLng.lng().toFixed(4),
        randomValue: Math.random() // force reactivity so that 'onInputChange' thinks the input has changed
      },
      shapeInfo
    );

    Shiny.onInputChange(map_id + "_shape_click", eventInfo);
  });

}

function polyline_click(map_id, polylineObject, polyline_id, polylineInfo){

  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(polylineObject, 'click', function(event){

    var eventInfo = $.extend(
      {
        id: polyline_id,
        lat: event.latLng.lat().toFixed(4),
        lon: event.latLng.lng().toFixed(4),
        path: google.maps.geometry.encoding.encodePath(polylineObject.getPath()),
        randomValue: Math.random()
      },
      polylineInfo
    );

    Shiny.onInputChange(map_id + "_polyline_click", eventInfo);
  });

}

function polygon_click(map_id, polygonObject, polygon_id, polygonInfo){

  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(polygonObject, 'click', function(event){

    var polygonOuterPath = google.maps.geometry.encoding.encodePath(polygonObject.getPath());
    var polygonAllPaths = [];
    var paths = polygonObject.getPaths();

    for(i = 0; i < paths.getLength(); i++){
      polygonAllPaths.push(google.maps.geometry.encoding.encodePath(paths.getAt(i)));
    }

    var eventInfo = $.extend(
      {
        id: polygon_id,
        lat: event.latLng.lat().toFixed(4),
        lon: event.latLng.lng().toFixed(4),
        path: polygonOuterPath,
        paths: polygonAllPaths,
        randomValue: Math.random()
      },
      polygonInfo
    );

    Shiny.onInputChange(map_id + "_polygon_click", eventInfo);
  });

}


/**
 * Adds infowindow to the specified map object
 *
 * @param map_id
 * @param mapObject
 *          the object the info window is being attached to
 * @param objectAttribute
 *          string attribute name
 * @param attributeValue
 *          the value of the attribute
 */
function add_infoWindow(map_id, mapObject, infoWindow, objectAttribute, attributeValue){

  mapObject.set(objectAttribute, attributeValue);

  google.maps.event.addListener(mapObject, 'click', function(event){

    // the listener is being bound to the mapObject. So, when the infowindow
    // contents are updated, the 'click' listener will need to see the new information
    // ref: http://stackoverflow.com/a/13504662/5977215
    mapObject.setOptions({"_information": mapObject.get(objectAttribute)});

    infoWindow.setContent(mapObject.get(objectAttribute));

    infoWindow.setPosition(event.latLng);
    infoWindow.open(window[map_id + 'map']);
  });
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

function clear_search(map_id){
  window[map_id + 'googlePlaceMarkers'].forEach(function(marker) {
    marker.setMap(null);
  });
  window[map_id + 'googlePlaceMarkers'] = [];
}

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
    //var input = document.getElementById('search-container');

    window[el.id + 'googleSearchBox'] = new google.maps.places.SearchBox(input);
    window[el.id + 'map'].controls[google.maps.ControlPosition.TOP_LEFT].push(input);

    // Bias the SearchBox results towards current map's viewport.
    window[el.id + 'map'].addListener('bounds_changed', function() {
      window[el.id + 'googleSearchBox'].setBounds(window[el.id + 'map'].getBounds());
    });

    var markers = [];

    // listen for deleting the search bar
    input.addEventListener('input', function(){
      if(input.value.length === 0){
        clear_search(el.id)
      }
    })

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
//  console.log('map info');
//  console.log(mapInfo);

  map_click(el.id, window[el.id + 'map'], mapInfo);
  bounds_changed(el.id, window[el.id + 'map'], mapInfo);
  zoom_changed(el.id, window[el.id + 'map'], mapInfo);

//  console.log("map info 2");
//  console.log(mapInfo);

}
