function add_kml(map_id, kml_data, layer_id, update_map_view) {

  //window[map_id + 'googleKml' + layer_id] = [];
  createWindowObject(map_id, 'googleKml', layer_id);

  console.log(update_map_view);
  var kmlLayer = new google.maps.KmlLayer({
    url: kml_data[0].url,
    preserveViewport: update_map_view,
    map: window[map_id + 'map']
  });

  window[map_id + 'googleKml' + layer_id].push(kmlLayer);
}


function clear_kml(map_id, layer_id) {

    for (i = 0; i < window[map_id + 'googleKml' + layer_id].length; i++) {
        window[map_id + 'googleKml' + layer_id][i].setMap(null);
    }
    window[map_id + 'googleKml' + layer_id] = null;
}
