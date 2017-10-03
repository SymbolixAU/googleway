/**
 * adds a fusion layer to the map
 *
 */
function add_fusion(map_id, query, styles, heat, layer_id) {

    // TODO: extend map bounds
    // - currenlty haven't found any resources that explains if this is even possible

    createWindowObject(map_id, 'googleFusion', layer_id);

    var s = JSON.parse(styles),
        layer = new google.maps.FusionTablesLayer({
            query: query,
            styles: s,
            heatmap: { enabled: heat }
        });

    window[map_id + 'googleFusion' + layer_id] = layer;
    layer.setMap(window[map_id + 'map']);
}

/**
 * clear fusion
 *
 * clears fusion layer
 */
function clear_fusion(map_id, layer_id) {
    window[map_id + 'googleFusion' + layer_id].setMap(null);
    window[map_id + 'googleFusion' + layer_id] = null;
}
