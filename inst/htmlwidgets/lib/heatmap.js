/**
 * Adds a heatmap layer to a google map object
 * @param map_id
 *          the map to which the heatmap will be added
 * @param data_heatmap
 *          JSON array of heatmap data
 * @param heatmap_options
 *          other options passed to the heatmap layer
 * @param layer_id
 *          the id of the layer
 */
function add_heatmap(map_id, data_heatmap, heatmap_options, layer_id){

  //heat = HTMLWidgets.dataframeToD3(data_heatmap);
  //heat_options = HTMLWidgets.dataframeToD3(heatmap_options);
  heat_options = heatmap_options;

  // need an array of google.maps.LatLng points
  var heatmapData = [];
  var i;
  window[map_id + 'googleHeatmap' + layer_id] = [];
  window[map_id + 'googleHeatmapLayerMVC' + layer_id] = [];
//  var bounds = new google.maps.LatLngBounds();

  // turn row of the data into LatLng, and push it to the array

  for(i = 0; i < Object.keys(data_heatmap).length; i++){
    latlon = new google.maps.LatLng(data_heatmap[i].lat, data_heatmap[i].lng);
    heatmapData[i] = {
      location: latlon,
      weight: data_heatmap[i].weight
    };

    //bounds.extend(latlon);
    window[map_id + 'mapBounds'].extend(latlon);
  }

  // store in MVC array
  window[map_id + 'googleHeatmapLayerMVC' + layer_id] = new google.maps.MVCArray(heatmapData);

  var heatmap = new google.maps.visualization.HeatmapLayer({
    data: window[map_id + 'googleHeatmapLayerMVC' + layer_id]
  });

  heatmap.setOptions({
    radius: heat_options[0].radius,
    opacity: heat_options[0].opacity,
    dissipating: heat_options[0].dissipating
  });

  if(heat_options[0].gradient !== undefined){
    heatmap.set('gradient', heat_options[0].gradient);
  }

  window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);

  // fill the heatmap variable with the MVC array of heatmap data
  // when the MVC array is updated, the layer is also updated
  window[map_id + 'googleHeatmap' + layer_id] = heatmap;
  heatmap.setMap(window[map_id + 'map']);
}

/**
 * Updates the heatmap layer with new data
 * @param map_id
 *          the map to update
 * @param data_heatmap
 *          the data to put into the heatmap layer
 * @param layer_id
 *          the heatmap layer to update
 */
function update_heatmap(map_id, data_heatmap, layer_id){

  if(window[map_id + 'googleHeatmap' + layer_id] !== undefined){

    // update the heatmap array
    window[map_id + 'googleHeatmapLayerMVC' + layer_id].clear();

    var heatmapData = [];
    var i;

    // turn row of the data into LatLng, and push it to the array
    for(i = 0; i < Object.keys(data_heatmap).length; i++){
      var latlon = new google.maps.LatLng(data_heatmap[i].lat, data_heatmap[i].lng);

      heatmapData[i] = {
        location: latlon,
        weight: data_heatmap[i].weight
      };

      window[map_id + 'googleHeatmapLayerMVC' + layer_id].push(heatmapData[i]);
      //bounds.extend(latlon);
      window[map_id + 'mapBounds'].extend(latlon);
    }

    window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
  }

}

/** Clear heatmap
 *
 * Clears heatmap from the map
 *
 * @param map_id
 *          the id of the map
 * @param layer_id
 *          the id of the layer
 */
function clear_heatmap(map_id, layer_id){
  window[map_id + 'googleHeatmap' + layer_id].setMap(null);
  window[map_id + 'googleHeatmap' + layer_id] = null;
}
