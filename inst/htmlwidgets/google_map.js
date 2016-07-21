HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        locations = HTMLWidgets.dataframeToD3(x.data);
        /*
        var locations = [ [ 'hello marker', -37.89, 144],
                          [ 'oh, hi', -37.99, 144.5]
                        ];
        */
        //console.log(data);
        //console.log(locations);
        //console.log(locations[0].lat);

        // to replicate the async callback
        setTimeout(function() {
          var mapDiv = document.getElementById(el.id);
            mapDiv.className = "googlemap";
            var map = new google.maps.Map(mapDiv, {
              center: {lat: x.lat, lng: x.lon},
              zoom: x.zoom
            });
            /*
            var latlon = new google.maps.LatLng(locations[1], locations[2]);
            //var latlon = {lat: -37.9, lng: 144.9};
            var marker = new google.maps.Marker({
              position: latlon,
              draggable: false,
              map: map
            });
            */
            var i;
            for (i = 0; i < locations.length; i ++) {
             addMarker(i, map, locations[i].lat, locations[i].lon, locations[i].desc);
            }

        }, 1000);

      },
      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }

    };
  }
});


function addMarker(i, map, lat, lon, title){

  var latlon = new google.maps.LatLng(lat, lon);

  var marker = new google.maps.Marker({
    position: latlon,
    draggable: false,
    map: map
  });


}



