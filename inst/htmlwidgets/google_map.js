HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {
        console.log('renderValue');
        // to replicate the async callback
        //setTimeout(function() { call_function } , 0);
        window.onload = function() {

          console.log('onload');

          var mapDiv = document.getElementById(el.id);

            mapDiv.className = "googlemap";
            var map = new google.maps.Map(mapDiv, {
              center: {lat: x.lat, lng: x.lng},
              zoom: x.zoom
            });

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

        };

      },
      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      },
    };
  }
});


function add_heatmap(map, data_heatmap, heatmap_options){

  heat = HTMLWidgets.dataframeToD3(data_heatmap);
  heat_options = HTMLWidgets.dataframeToD3(heatmap_options);

  // need an array of google.maps.LatLng points
  var heatmapData = [];

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

    circles = HTMLWidgets.dataframeToD3(data_circles);

    var i;
    for (i = 0; i < circles.length; i++) {
      var latlon = new google.maps.LatLng(circles[i].lat, circles[i].lng);

      var cityCircle = new google.maps.Circle({
            strokeColor: '#FF0000',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#FF0000',
            fillOpacity: 0.35,
            map: map,
            center: latlon,
            radius: 100
          });
    }
}

function add_markers(map, data_markers){

  markers = HTMLWidgets.dataframeToD3(data_markers);

  var i;
  for (i = 0; i < markers.length; i++) {

    var latlon = new google.maps.LatLng(markers[i].lat, markers[i].lng);

    var marker = new google.maps.Marker({
      position: latlon,
      draggable: markers[i].draggable,
      opacity: markers[i].opacity,
      title: markers[i].title,
      map: map
    });
  }
}


function add_polyline(map, data_polyline){

        //if a list of polyline data.frames were provided, need to iterate
        //through them
        //otherwise, just a single call to add the data.frame
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




/*
methods.add_markers = function(lat, lon){
  let df = new DataFrame()
    .col("lat", lat)
    .col("lon", lon);

  add_markers(this, lat, lon);
//  add_markers(this, df, (df, i) => {
//    return L.marker([df.get(i, "lat"), df.get(i, "lon")]);
//  });
};
*/

