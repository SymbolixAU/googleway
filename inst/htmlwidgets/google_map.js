HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        markers = HTMLWidgets.dataframeToD3(x.markers);

        //if a list of polyline data.frames were provided, need to iterate
        //through them
        //otherwise, just a single call to add the data.frame
        var polyline = [];
        var polyFlag;
        // http://stackoverflow.com/questions/2647867/how-to-determine-if-variable-is-undefined-or-null/2647888#2647888
        // and the edit history of accepted answer
        if(x.polyline.length == null){
          polyline = HTMLWidgets.dataframeToD3(x.polyline);
          polyFlag = 'single';
        }else{
          var i;
          for (i = 0; i < x.polyline.length; i++) {
            polyline[i] = HTMLWidgets.dataframeToD3(x.polyline[i]);
            polyFlag = 'multi';
          }
        }
        console.log(polyline.length);

        // to replicate the async callback
        //setTimeout(function() { call_function } , 0);
          var mapDiv = document.getElementById(el.id);
            mapDiv.className = "googlemap";
            var map = new google.maps.Map(mapDiv, {
              center: {lat: x.lat, lng: x.lon},
              zoom: x.zoom
            });


        setTimeout(function() {
          var i;
          for (i = 0; i < markers.length; i++) {
            add_markers(map, markers[i].lat, markers[i].lon);
          }
        } , 0);

        setTimeout(function() {
          var i;

          if(polyFlag == 'single'){
            add_polyline(map, polyline);
          }else{
            for (i = 0; i < polyline.length; i++) {
              add_polyline(map, polyline[i]);
            }
          }
        }, 0);

      },
      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      },
    };
  }
});


function add_polyline(map, polyline){
  var Polyline = new google.maps.Polyline({
          path: polyline,
          geodesic: true,
          strokeColor: '#0088FF',
          strokeOpacity: 0.6,
          strokeWeight: 4,
          map: map
        });
}

function add_markers(map, lat, lon){
  var latlon = new google.maps.LatLng(lat, lon);

  var marker = new google.maps.Marker({
    position: latlon,
    draggable: false,
    map: map
  });

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

