function add_traffic(map_id) {

  var traffic = new google.maps.TrafficLayer();
  window[map_id + 'googleTrafficLayer'] = traffic;
  traffic.setMap(window[map_id + 'map']);
}

function clear_traffic(map_id) {
  window[map_id + 'googleTrafficLayer'].setMap(null);
}

function add_bicycling(map_id) {

  var bicycle = new google.maps.BicyclingLayer();
  window[map_id + 'googleBicyclingLayer'] = bicycle;
  bicycle.setMap(window[map_id + 'map']);
}

function clear_bicycling(map_id) {
  window[map_id + 'googleBicyclingLayer'].setMap(null);
}

function add_transit(map_id) {

  var transit = new google.maps.TransitLayer();
  window[map_id + 'googleTransitLayer'] = transit;
  transit.setMap(window[map_id + 'map']);
}

function clear_transit(map_id) {
  window[map_id + 'googleTransitLayer'].setMap(null);
}

function clear_search(map_id) {
  window[map_id + 'googlePlaceMarkers'].forEach(function(marker) {
    marker.setMap(null);
  });
  window[map_id + 'googlePlaceMarkers'] = [];
}

function clear_bounds(map_id) {
  //console.log("clear bounds");

  //window[map_id + 'mapBounds'].setMap(null);
  window[map_id + 'mapBounds'] = new google.maps.LatLngBounds();
}
