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
function add_heatmap(map_id, data_heatmap, heatmap_options, update_map_view, layer_id, legendValues) {

    var heat_options = heatmap_options,
        heatmapData = [],
        i;

    createWindowObject(map_id, 'googleHeatmap', layer_id);
    createWindowObject(map_id, 'googleHeatmapLayerMVC', layer_id);

    for (i = 0; i < Object.keys(data_heatmap).length; i++) {

        latlon = new google.maps.LatLng(data_heatmap[i].lat, data_heatmap[i].lng);
        heatmapData[i] = {
            location: latlon,
            //weight: data_heatmap[i].weight
            weight: data_heatmap[i].fill_colour
        };
        //bounds.extend(latlon);
        if (update_map_view === true) {
            window[map_id + 'mapBounds'].extend(latlon);
        }
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

    if (heat_options[0].gradient !== undefined) {
        heatmap.set('gradient', heat_options[0].gradient);
    }

    if (update_map_view === true) {
        window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
    }

    // fill the heatmap variable with the MVC array of heatmap data
    // when the MVC array is updated, the layer is also updated
    window[map_id + 'googleHeatmap' + layer_id] = heatmap;
    heatmap.setMap(window[map_id + 'map']);

    if (legendValues !== false) {
        add_legend(map_id, layer_id, legendValues);
    }

}

/**
 * Updates the heatmap layer with new data
 * @param map_id
 *          the map to update
 * @param data_heatmap
 *          the data to put into the heatmap layer
 * @param layer_id
 *          the heatmap layer to update
 * @param legendValues
 *          legend values
 * @param update_map_view
 */
function update_heatmap(map_id, data_heatmap, heatmap_options, layer_id, legendValues, update_map_view) {

    if (window[map_id + 'googleHeatmap' + layer_id] !== undefined) {

        // update the heatmap array
        window[map_id + 'googleHeatmapLayerMVC' + layer_id].clear();

        var heat_options = heatmap_options,
            heatmapData = [],
            i;

        // turn row of the data into LatLng, and push it to the array
        for (i = 0; i < Object.keys(data_heatmap).length; i++) {
            var latlon = new google.maps.LatLng(data_heatmap[i].lat, data_heatmap[i].lng);

            heatmapData[i] = {
                location: latlon,
                weight: data_heatmap[i].fill_colour
            };

            window[map_id + 'googleHeatmapLayerMVC' + layer_id].push(heatmapData[i]);
            //bounds.extend(latlon);
            window[map_id + 'mapBounds'].extend(latlon);
        }

        // the variable 'heatmap' is created inside add_heatmap, and so is not avaialble here
        // need a way to use it so we can update the colours & opacity & options and stuff

        var heatmap = new google.maps.visualization.HeatmapLayer({
            data: window[map_id + 'googleHeatmapLayerMVC' + layer_id]
        });

        //console.log(heat_options);

        window[map_id + 'googleHeatmap' + layer_id].setOptions({
            radius: heat_options[0].radius,
            opacity: heat_options[0].opacity,
            dissipating: heat_options[0].dissipating
        });

        if (heat_options[0].gradient !== undefined) {
             window[map_id + 'googleHeatmap' + layer_id].set('gradient', heat_options[0].gradient);
        }

        if (update_map_view === true) {
            window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
        }

        if (legendValues !== false) {
            add_legend(map_id, layer_id, legendValues);
        }
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
function clear_heatmap(map_id, layer_id) {
    window[map_id + 'googleHeatmap' + layer_id].setMap(null);
    window[map_id + 'googleHeatmap' + layer_id] = null;
    window[map_id + 'googleHeatmapLayerMVC' + layer_id] = null;
}
