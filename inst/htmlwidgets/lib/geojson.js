
function update_geojson(map_id, style, layer_id) {
    
    var operators = {
        '>': function (a, b) { return a > b },
        '>=': function (a, b) { return a >= b },
        '<': function (a, b) { return a < b },
        '<=': function (a, b) { return a <= b },
        '=': function (a, b) { return a === b }
    };
    
    var op = (style.operator === undefined ? "=" : style.operator);
    console.log("operator: " + op);

    var property = style.property,
        value = style.value,
        feature = style.feature,
        styleValue = style.style;
    
    var newFeatures = style.features;
    
        
    window[map_id + 'googleGeojson' + layer_id].setStyle(function (feature) {
        
        var featureFillColor = feature.getProperty("fillColor"),
            featureFillOpacity = feature.getProperty("fillOpacity"),
            featureStrokeColor = feature.getProperty("strokeColor"),
            featureStrokeOpacity = feature.getProperty("strokeOpacity"),
            featureStrokeWeight = feature.getProperty("strokeWeight"),
            featureCursor = feature.getProperty("cursor"),
            featureIcon = feature.getProperty("icon"),
            featureShape = feature.getProperty("shape"),
            featureTitle = feature.getProperty("title"),
            newFillColor = newFeatures.fillColor,
            newFillOpacity = newFeatures.fillOpacity,
            newStrokeColor = newFeatures.strokeColor,
            newStrokeOpacity = newFeatures.strokeOpacity,
            newStrokeWeight = newFeatures.strokeWeight,
            newCursor = newFeatures.cursor,
            newIcon = newFeatures.icon,
            newShape = newFeatures.shape,
            newTitle = newFeatures.title;
        
        if (operators[op](feature.getProperty(property), value) ) {
            featureFillColor = (newFillColor === undefined ? featureFillColor : newFillColor);
            featureFillOpacity = (newFillOpacity === undefined ? featureFillOpacity : newFillOpacity);
            featureStrokeColor = (newStrokeColor === undefined ? featureStrokeColor : newStrokeColor);
            featureStrokeOpacity = (newStrokeOpacity === undefined ? featureStrokeOpacity : newStrokeOpacity);
            featureStrokeWeight = (newStrokeWeight === undefined ? featureStrokeWeight : newStrokeWeight);
            featureCursor = (newCursor === undefined ? featureCursor : newCursor);
            featureIcon = (newIcon === undefined ? featureIcon : newIcon);
            featureShape = (newShape === undefined ? featureShape : newShape);
            featureTitle = (newTitle === undefined ? featureTitle : newTitle);
        }
        
        return {
            fillColor : featureFillColor,
            fillOpacity : featureFillOpacity,
            strokeColor : featureStrokeColor,
            strokeOpacity : featureStrokeOpacity,
            strokeWeight : featureStrokeWeight,
            cursor: featureCursor,
            icon : featureIcon,
            shape : featureShape,
            title : featureTitle
        }
        
    });
}
                                                          
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


function clear_geojson(map_id, layer_id) {
    window[map_id + 'googleGeojson' + layer_id].setMap(null);
    window[map_id + 'googleGeojson' + layer_id] = null;
}