
function add_geolocation() {

  //var infoWindow = new google.maps.InfoWindow;
  // Try HTML5 geolocation.
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {

      //console.log( position );
      /*
      var pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
        };

      infoWindow.setPosition(pos);
      infoWindow.setContent('Location found.');
      infoWindow.open(map);
      map.setCenter(pos);
      */
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? position : JSON.stringify(position);
    Shiny.onInputChange(map_id + "_geolocation", position);

    }, function() {
      //handleLocationError(true, infoWindow, map.getCenter());
    });
  } else {
    // Browser doesn't support Geolocation
    //handleLocationError(false, infoWindow, map.getCenter());
  }
}

/*
function handleLocationError(browserHasGeolocation, infoWindow, pos) {
  infoWindow.setPosition(pos);
  infoWindow.setContent(browserHasGeolocation ?
    'Error: The Geolocation service failed.' :
    'Error: Your browser doesn\'t support geolocation.');
  infoWindow.open(map);
}
*/
