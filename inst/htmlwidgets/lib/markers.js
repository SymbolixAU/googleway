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
function add_markers(map_id, data_markers, cluster, update_map_view, layer_id, use_polyline, interval) {

    var markers = [],
        i,
        infoWindow = new google.maps.InfoWindow();

    createWindowObject(map_id, 'googleMarkers', layer_id);

    for (i = 0; i < Object.keys(data_markers).length; i++) {
        set_markers(map_id, markers, infoWindow, data_markers[i], cluster, infoWindow, update_map_view, layer_id, use_polyline, i * interval);
    }

    if (cluster === true) {
        window[map_id + 'googleMarkerClusterer' + layer_id] = new MarkerClusterer(window[map_id + 'map'], markers, {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});
    }
    

}

function set_markers(map_id, markers, infoWindow, aMarker, cluster, infoWindow, update_map_view, layer_id, use_polyline, timeout) {
    
    window.setTimeout(function () {
        
        var j, lon, lat, path, latlon, marker;
        
        if (use_polyline) {
        
            for (j = 0; j < aMarker.polyline.length; j++) {

                path = google.maps.geometry.encoding.decodePath(aMarker.polyline[j]);
                latlon = new google.maps.LatLng(path[0].lat(), path[0].lng());
                
                marker = new google.maps.Marker({
                    id: aMarker.id,
                    icon: aMarker.url,
                    position: latlon,
                    draggable: aMarker.draggable,
                    opacity: aMarker.opacity,
                    opacityHolder: aMarker.opacity,
                    title: aMarker.title,
                    label: aMarker.label,
                    mouseOverGroup: aMarker.mouse_over_group
                });
                
                set_each_marker(markers, marker, aMarker, infoWindow, update_map_view, map_id, layer_id);
                
                if (update_map_view === true) {
                    window[map_id + 'mapBounds'].extend(latlon);
                    window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
                }
            }
        } else {
            latlon = new google.maps.LatLng(aMarker.lat, aMarker.lng);
            marker = new google.maps.Marker({
                id: aMarker.id,
                icon: aMarker.url,
                position: latlon,
                draggable: aMarker.draggable,
                opacity: aMarker.opacity,
                opacityHolder: aMarker.opacity,
                title: aMarker.title,
                label: aMarker.label,
                mouseOverGroup: aMarker.mouse_over_group
            });

            set_each_marker(markers, marker, aMarker, infoWindow, update_map_view, map_id, layer_id);
            
            if (update_map_view === true) {
                window[map_id + 'mapBounds'].extend(latlon);
                window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
            }
        }
    }, timeout);
}


function set_each_marker(markers, marker, aMarker, infoWindow, update_map_view, map_id, layer_id) {
    
    if (aMarker.info_window) {

        marker.infowindow = new google.maps.InfoWindow({
            content: aMarker.info_window
        });

        google.maps.event.addListener(marker, 'click', function () {
            this.infowindow.open(window[map_id + 'map'], this);
        });

    // the listener is being bound to the mapObject. So, when the infowindow
    // contents are updated, the 'click' listener will need to see the new information
    // ref: http://stackoverflow.com/a/13504662/5977215

    }

    if (aMarker.mouse_over || aMarker.mouse_over_group) {
        add_mouseOver(map_id, marker, infoWindow, '_mouse_over', aMarker.mouse_over, layer_id, 'googleMarkers');
    }

    markerInfo = {
        layerId : layer_id
        //lat : aMarker.lat.toFixed(4),
        //lon : aMarker.lng.toFixed(4)
    };

    marker_click(map_id, marker, marker.id, markerInfo);

    window[map_id + 'googleMarkers' + layer_id].push(marker);
    markers.push(marker);
    marker.setMap(window[map_id + 'map']);
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
function clear_markers(map_id, layer_id) {

    // the markers know which map they're on
    // http://stackoverflow.com/questions/7961522/removing-a-marker-in-google-maps-api-v3
    clear_object(map_id, 'googleMarkers', layer_id);

    if (window[map_id + 'googleMarkerClusterer' + layer_id]) {
        window[map_id + 'googleMarkerClusterer' + layer_id].clearMarkers();
        window[map_id + 'googleMarkerClusterer' + layer_id] = null;
    }
}


