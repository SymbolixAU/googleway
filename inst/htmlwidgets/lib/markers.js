


/**
 * Add markers
 *
 * adds markers to a google map object
 *
 * @param map_id
 *          the map object to which the markers will be added
 * @param data_markers
 *          JSON array of marker data
 * @param cluster
 *          logical, indicating if the markers should cluster when zoomed out
 * @param layer_id
 *          the layer identifier
 */
function add_markers(map_id, data_markers, cluster, update_map_view, layer_id){

    var markers = [],
        i,
        infoWindow = new google.maps.InfoWindow();
  
//    if(window[map_id + 'googleMarkers' + layer_id] == null){
//        window[map_id + 'googleMarkers' + layer_id] = [];
//    }
    
    createWindowObject(map_id, 'googleMarkers', layer_id);


  for (i = 0; i < Object.keys(data_markers).length; i++){

    var latlon = new google.maps.LatLng(data_markers[i].lat, data_markers[i].lng);

    var marker = new google.maps.Marker({
      id: data_markers[i].id,
      icon: data_markers[i].url,
      position: latlon,
      draggable: data_markers[i].draggable,
      opacity: data_markers[i].opacity,
      opacityHolder: data_markers[i].opacity,
      title: data_markers[i].title,
      label: data_markers[i].label,
      mouseOverGroup: data_markers[i].mouse_over_group
    });

    if(data_markers[i].info_window){

      marker.infowindow = new google.maps.InfoWindow({
        content: data_markers[i].info_window
      });

      google.maps.event.addListener(marker, 'click', function() {
        this.infowindow.open(window[map_id + 'map'], this);
      });

      //add_infoWindow(map_id, marker, infoWindow, '_information', data_markers[i].info_window);

      //mapObject.set(objectAttribute, attributeValue);
//      marker.addListener('click', function(event){
//              console.log(data_markers[i]);

        // the listener is being bound to the mapObject. So, when the infowindow
        // contents are updated, the 'click' listener will need to see the new information
        // ref: http://stackoverflow.com/a/13504662/5977215
        //mapObject.setOptions({"_information": mapObject.get(objectAttribute)});

//        infoWindow.setContent(data_markers[i].info_window);

//        infoWindow.setPosition(event.latLng);
//        infoWindow.open(window[map_id + 'map']);
//      });

    }

    if(data_markers[i].mouse_over || data_markers[i].mouse_over_group){
      add_mouseOver(map_id, marker, infoWindow, '_mouse_over', data_markers[i].mouse_over, layer_id, 'googleMarkers');
    }

    markerInfo = {
      layerId : layer_id,
      lat : data_markers[i].lat.toFixed(4),
      lon : data_markers[i].lng.toFixed(4)
    };

    marker_click(map_id, marker, marker.id, markerInfo);

    if(update_map_view === true){
     window[map_id + 'mapBounds'].extend(latlon);
    }

    window[map_id + 'googleMarkers' + layer_id].push(marker);
    markers.push(marker);
    marker.setMap(window[map_id + 'map']);
  }

  if(cluster === true){
    window[map_id + 'googleMarkerClusterer' + layer_id] = new MarkerClusterer(window[map_id + 'map'], markers,
    {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});

  }

  if(update_map_view === true){
    window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
  }

  //window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
}

/**
 * Clear markers
 *
 * clears markes from a google map object
 *
 * @param map_id
 *          the map to clear
 * @param layer_id
 *          the layer to clear
 */
function clear_markers(map_id, layer_id){

  // the markers know which map they're on
  // http://stackoverflow.com/questions/7961522/removing-a-marker-in-google-maps-api-v3
  for (i = 0; i < window[map_id + 'googleMarkers' + layer_id ].length; i++){
      window[map_id + 'googleMarkers' + layer_id][i].setMap(null);
  }
  window[map_id + 'googleMarkers' + layer_id] = null;

  if(window[map_id + 'googleMarkerClusterer' + layer_id]){
      window[map_id + 'googleMarkerClusterer' + layer_id].clearMarkers();
      window[map_id + 'googleMarkerClusterer' + layer_id] = null;
  }

}


