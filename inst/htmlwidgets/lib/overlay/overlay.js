function add_overlay (map_id, data_overlay, update_map_view, layer_id) {

    //console.log("adding overlay");
    createWindowObject(map_id, 'googleOverlay', layer_id);

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

    window[map_id + 'googleOverlay' + layer_id].push(overlayLayer);
    overlayLayer.setMap(window[map_id + 'map']);

    if (update_map_view === true) {
        window[map_id + 'mapBounds'].extend(latlonNorthEast);
        window[map_id + 'mapBounds'].extend(latlonSouthWest);

        window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
    }
}


function clear_overlay (map_id, layer_id) {

  //console.log(window[map_id + 'googleOverlay' + layer_id]);

//    for (i = 0; i < window[map_id + 'googleOverlay' + layer_id].length; i++){
//        window[map_id + 'googleOverlay' + layer_id][i].setMap(null);
//    }
//    window[map_id + 'googleOverlay' + layer_id] = null;
//    window[map_id + 'googleOverlay' + layer_id].setMap(null);
    clear_object(map_id, 'googleOverlay', layer_id);
}
