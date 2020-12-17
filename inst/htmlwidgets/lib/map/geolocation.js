
function add_geolocation(map_id) {

  if(!HTMLWidgets.shinyMode) return;

  //var infoWindow = new google.maps.InfoWindow;
  // Try HTML5 geolocation.
  var eventInfo;

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {

    console.log( position );

    eventInfo = {
      lat: position.coords.latitude,
      lon: position.coords.longitude,
      accuracy: position.coords.accuracy,
      altitude: position.coords.altitude,
      altitudeAccuracy: position.coords.altitudeAccuracy,
      heading: position.coords.heading,
      speed: position.coords.speed,
      timestamp: position.timestamp,
      randomValue: Math.random()
    };

    console.log( eventInfo );

      //infoWindow.setPosition(pos);
      //infoWindow.setContent('Location found.');
      //infoWindow.open(map);
      //map.setCenter(pos);

    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);

    console.log( eventInfo );

    Shiny.onInputChange(map_id + "_geolocation", eventInfo);

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
