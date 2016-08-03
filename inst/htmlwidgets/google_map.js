HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {
      renderValue: function(x) {

          // global map objects
          console.log("el.id");
          console.log(el.id);
          console.log(el);
          window[el.id + 'googleMarkers'] = [];
          window[el.id + 'googleHeatmapLayer'] = [];
          window[el.id + 'googleHeatmapLayerMVC'] = [];
          window[el.id + 'googleTrafficLayer'] = [];
          window[el.id + 'googleCircles'] = [];

          var mapDiv = document.getElementById(el.id);
          mapDiv.className = "googlemap";

          if (HTMLWidgets.shinyMode){

            // use setInterval to check if the map can be loaded
            // the map is dependant on the Google Maps JS resource
            // - usually implemented via callback
            var checkExists = setInterval(function(){

              var map = new google.maps.Map(mapDiv, {
                center: {lat: x.lat, lng: x.lng},
                zoom: x.zoom
              });

              //global map object
              window[el.id + 'map'] = map;

              if (google !== 'undefined'){
                console.log("exists");
                clearInterval(checkExists);

                // call initial layers
                for(i = 0; i < x.calls.length; i++){

                  //TODO
                  // why do I use window.map here, but just 'map' in in
                  // addCustomMessageHandler ?

                  //push the map_id inot the call.args
                  x.calls[i].args.unshift(el.id);

                  if (window[x.calls[i].functions])
                    window[x.calls[i].functions].apply(window[el.id + 'map'], x.calls[i].args);
                  else
                    console.log("Unknown function " + x.calls[i]);
                }

              }else{
                console.log("does not exist!");
              }

            }, 100);

          }else{
            window.onload = function() {
              var mapDiv = document.getElementById(el.id);

              mapDiv.className = "googlemap";

             var map = new google.maps.Map(mapDiv, {
               center: {lat: x.lat, lng: x.lng},
                zoom: x.zoom
              });

              window[el.id + 'map'] = map;

              // call initial layers
              for(i = 0; i < x.calls.length; i++){

                //push the map_id into the call.args
                x.calls[i].args.unshift(el.id);

                if (window[x.calls[i].functions])
                  window[x.calls[i].functions].apply(window[el.id + 'map'], x.calls[i].args);
                else
                  console.log("Unknown function " + x.calls[i]);
              }

            };
            //}, 2000);
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


function add_markers(map_id, lat, lng, title, opacity, draggable, label){

  var i;
  for (i = 0; i < lat.length; i++) {

    var latlon = new google.maps.LatLng(lat[i], lng[i]);

    var marker = new google.maps.Marker({
      position: latlon,
      draggable: draggable[i],
      opacity: opacity[i],
      title: title[i],
      label: label[i]
    });

    window[map_id + 'googleMarkers'].push(marker);
    marker.setMap(window[map_id + 'map']);
  }
}

function clear_markers(map_id){

  // the markers know which map they're on
  // http://stackoverflow.com/questions/7961522/removing-a-marker-in-google-maps-api-v3
  for (i = 0; i < window[map_id + 'googleMarkers'].length; i++){
    window[map_id + 'googleMarkers'][i].setMap(null);
  }
}


function add_heatmap(map_id, lat, lng, weight, heatmap_options){

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

  window[map_id + 'googleHeatmapLayer'] = heatmap;
  heatmap.setMap(window[map_id + 'map']);
}

function update_heatmap(map_id, lat, lng, weight){

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

function add_circles(map_id, lat, lng, radius){
  console.log('add_circles');
    //circles = HTMLWidgets.dataframeToD3(data_circles);

    var i;
    for (i = 0; i < lat.length; i++) {
      var latlon = new google.maps.LatLng(lat[i], lng[i]);

      var circle = new google.maps.Circle({
            strokeColor: '#FF0000',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#FF0000',
            fillOpacity: 0.35,
            center: latlon,
            radius: 100
          });

      window[map_id + 'googleCircles'].push(circle);
      circle.setMap(window[map_id + 'map']);
    }

}

function clear_circles(map_id){
  window[map_id + 'googleCircles'].setMap(null);
}

/*
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
*/
