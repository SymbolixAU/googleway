HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

          var mapDiv = document.getElementById(el.id);
          mapDiv.className = "googlemap";

          // use setInterval to check if the map can be loaded
          // the map is dependant on the Google Maps JS resource
          // - usually implemented via callback
          var checkExists = setInterval(function(){

            var map = new google.maps.Map(mapDiv, {
              center: {lat: x.lat, lng: x.lng},
              zoom: x.zoom
            });

            if (google !== 'undefined'){
              console.log("exists");
              clearInterval(checkExists);
            }else{
              console.log("does not exist!");
            }
            /*
            console.log('layers');
            if(x.markers !== null){

              setTimeout(function() {
                add_markers(map, x.markers);
             }, 0);
            }

            if(x.circles !== null){

              setTimeout(function() {
                add_circles(map, x.circles);
              }, 0);
            }

            if(x.polyline !== null){

              setTimeout(function() {
                add_polyline(map, x.polyline);
              }, 0);
            }

            if(x.heatmap !== null){

              setTimeout(function() {
                add_heatmap(map, x.heatmap, x.heatmap_options);
              }, 0);
            }
            */
          }, 100);
      },
      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      },

    };
  }
});

if (HTMLWidgets.shinyMode) {

  Shiny.addCustomMessageHandler("googlemap-calls", function(data) {
    var id = data.id;
    var el = document.getElementById(id);
    console.log(data);
    //var map = el ? $(el).data("googlemap") : null;
    //var map = el ? (0, jquery.default)(el).data("goglemap-map") : null;
    var map = el;
    console.log(map);
    if (!map) {
      console.log("Couldn't find map with id " + id);
      return;
    }

    for (let i = 0; i < data.calls.length; i++) {

      let call = data.calls[i];
      if (call.dependencies) {
        Shiny.renderDependencies(call.dependencies);
      }
      if (functions[call.method])
        functions[call.method].apply(map, call.args);
      else
        console.log("Unknown function " + call.method);
    }
  });
}

function add_heatmap(map, data_heatmap, heatmap_options){
  console.log("add_heatmap");
  heat = HTMLWidgets.dataframeToD3(data_heatmap);
  heat_options = HTMLWidgets.dataframeToD3(heatmap_options);

  // need an array of google.maps.LatLng points
  var heatmapData = [];
  console.log("heatmap");
  console.log(heat);
  console.log(heat_options);

  // turn row of the data into LatLng, and push it to the array
  for(i = 0; i < heat.length; i++){
    heatmapData[i] = {location: new google.maps.LatLng(heat[i].lat, heat[i].lng), weight: heat[i].weight};
  }

  var heatmap = new google.maps.visualization.HeatmapLayer({
    data: heatmapData,
  });

  heatmap.setOptions({
    radius: heat_options[0].radius,
    opacity: heat_options[0].opacity,
    dissipating: heat_options[0].dissipating
  });
  heatmap.setMap(map);
}

function add_circles(map, data_circles){
  console.log("add_circles");
    circles = HTMLWidgets.dataframeToD3(data_circles);

    var i;
    for (i = 0; i < circles.length; i++) {
      var latlon = new google.maps.LatLng(circles[i].lat, circles[i].lng);

      var circle = new google.maps.Circle({
            strokeColor: '#FF0000',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#FF0000',
            fillOpacity: 0.35,
            map: map,
            center: latlon,
            radius: 100
          });
      circle.setMap(map);
    }
}

function add_markers(map, data_markers){
  console.log("add_markers");
  markers = HTMLWidgets.dataframeToD3(data_markers);

  var i;
  for (i = 0; i < markers.length; i++) {

    var latlon = new google.maps.LatLng(markers[i].lat, markers[i].lng);

    var marker = new google.maps.Marker({
      position: latlon,
      draggable: markers[i].draggable,
      opacity: markers[i].opacity,
      title: markers[i].title,
    });
    marker.setMap(map);
  }
}


function add_polyline(map, data_polyline){
  console.log("add_polyline");
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
      add_lines(map, polyline[i]);
    }
  }

  function add_lines(map, polyline){
    var Polyline = new google.maps.Polyline({
            path: polyline,
            geodesic: true,
            strokeColor: '#0088FF',
            strokeOpacity: 0.6,
            strokeWeight: 4,
            map: map
          });
  }
}
