HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {
      renderValue: function(x) {

          // global map objects
          window.googleMarkers = [];
          window.heatmapLayer = [];
          window.trafficLayer = [];

          var mapDiv = document.getElementById(el.id);
          mapDiv.className = "googlemap";

          if (HTMLWidgets.shinyMode){

            // use setInterval to check if the map can be loaded
            // the map is dependant on the Google Maps JS resource
            // - usually implemented via callback
            var checkExists = setInterval(function(){

              window.map = new google.maps.Map(mapDiv, {
                center: {lat: x.lat, lng: x.lng},
                zoom: x.zoom
              });

              if (google !== 'undefined'){
                console.log("exists");
                clearInterval(checkExists);

                // call initial layers
                for(i = 0; i < x.calls.length; i++){

                  //TODO
                  // why do I use window.map here, but just 'map' in in
                  // addCustomMessageHandler ?

                  //push the mapId inot the call.args
                  x.calls[i].args.unshift(window.map);

                  if (window[x.calls[i].functions])
                    window[x.calls[i].functions].apply(map, x.calls[i].args);
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

             window.map = new google.maps.Map(mapDiv, {
               center: {lat: x.lat, lng: x.lng},
                zoom: x.zoom
              });

              // call initial layers
                for(i = 0; i < x.calls.length; i++){

                  //TODO
                  // why do I use window.map here, but just 'map' in in
                  // addCustomMessageHandler ?

                  //push the mapId inot the call.args
                  x.calls[i].args.unshift(window.map);

                  if (window[x.calls[i].functions])
                    window[x.calls[i].functions].apply(map, x.calls[i].args);
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

    var id = data.id;
    var el = document.getElementById(id);
    //var map = el ? $(el).data("googlemap") : null;
    //var map = el ? (0, jquery.default)(el).data("goglemap-map") : null;
    var map = el;
    if (!map) {
      console.log("Couldn't find map with id " + id);
      return;
    }

    for (let i = 0; i < data.calls.length; i++) {

      var call = data.calls[i];

      //push the mapId inot the call.args
      call.args.unshift(map);

      if (call.dependencies) {
        Shiny.renderDependencies(call.dependencies);
      }

      if (window[call.method])
        window[call.method].apply(map, call.args);
      else
        console.log("Unknown function " + call.method);
    }
  });
}


function add_markers(map, lat, lng, title, opacity, draggable, label){

  var i;
  for (i = 0; i < lat.length; i++) {

    var latlon = new google.maps.LatLng(lat[i], lng[i]);
    //var latlon = new google.maps.LatLng(-38, 144);
    //var thisMap = document.getElementById(map.id);

    var marker = new google.maps.Marker({
      position: latlon,
      draggable: draggable[i],
      opacity: opacity[i],
      title: title[i],
      label: label[i]
      //map: window.map
    });

    //TODO
    // clear window.googleMarkers if it was initialised in the first
    // shiny::renderGoogle_map call?

    window.googleMarkers.push(marker);
    //marker.setMap(thisMap);
    marker.setMap(window.map);
  }
}

function clear_markers(){
  //TODO
  // how does this know the 'map' to remove them from?
  for (i = 0; i < window.googleMarkers.length; i++){
    window.googleMarkers[i].setMap(null);
  }
}


function add_heatmap(map, lat, lng, weight, heatmap_options){
  console.log(weight);
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

  var heatmap = new google.maps.visualization.HeatmapLayer({
    data: heatmapData,
  });

  //heatmap.setOptions({
  //  radius: heat_options[0].radius,
  //  opacity: heat_options[0].opacity,
  //  dissipating: heat_options[0].dissipating
  //});

  window.heatmapLayer = heatmap;

  heatmap.setMap(window.map);
}

function clear_heatmap(){

  //TODO
  // can the transition be smooth?
  // http://stackoverflow.com/a/13479758/5977215
  window.heatmapLayer.setMap(null);
}

function add_traffic(map){
  var traffic = new google.maps.TrafficLayer();
  window.trafficLayer = traffic;
  traffic.setMap(map);
}

function clear_traffic(){
  console.log('clear traffic');
  window.trafficLayer.setMap(null);
}

function add_circles(map, lat, lng, radius){

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
            map: map,
            center: latlon,
            radius: radius[i]
          });
      circle.setMap(map);
    }
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
