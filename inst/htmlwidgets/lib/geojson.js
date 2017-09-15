

function add_geojson(map_id, geojson, geojson_source, style, style_type, update_map_view, layer_id) {
    
    window[map_id + 'googleGeojson' + layer_id] = new google.maps.Data({ map: window[map_id + 'map'] });
    
    if (geojson_source === "local") {
        
        window[map_id + 'googleGeojson' + layer_id].addGeoJson(geojson);
        
    } else if (geojson_source === "url") {

        window[map_id + 'googleGeojson' + layer_id].loadGeoJson(geojson);
    }
    

    if (style_type === "auto") {
        // a function that computes the style for each feature
        window[map_id + 'googleGeojson' + layer_id].setStyle(function (feature) {

            return ({
                // all
                clickable: feature.getProperty("clickable"),
                visible: feature.getProperty("visible"),
                zIndex: feature.getProperty("zIndex"),
                // point
                cursor: feature.getProperty("cursor"),
                icon: feature.getProperty("icon"),
                shape: feature.getProperty("shape"),
                title: feature.getProperty("title"),
                // lines
                strokeColor: feature.getProperty("strokeColor"),
                strokeOpacity: feature.getProperty("strokeOpacity"),
                strokeWeight: feature.getProperty("strokeWeight"),
                // polygons
                fillColor: feature.getProperty("fillColor"),
                fillOpacity: feature.getProperty("fillOpacity")
            });
        });

    } else if (style_type === "all") {
    //style each feature wtih the same styleOptions:

        window[map_id + 'map'].data.setStyle({

            clickable: style.clickable,
            visible: style.visible,
            zIndex: style.zIndex,
            // point
            cursor: style.cursor,
            icon: style.icon,
            shape: style.shape,
            title: style.title,
            // lines
            strokeColor: style.strokeColor,
            strokeOpacity: style.strokeOpacity,
            strokeWeight: style.strokeWeight,
            // polygons
            fillColor: style.fillColor,
            fillOpacity: style.fillOpacity

        });
    }


    if (update_map_view === true) {
    // TODO: update bounds
    }
}


function clear_geojson (map_id, layer_id) {
    window[map_id + 'googleGeojson' + layer_id].setMap(null);
}