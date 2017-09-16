function update_geojson(map_id, style, layer_id) {
    
    var operators = {
        '>': function (a, b) { return a > b; },
        '>=': function (a, b) { return a >= b; },
        '<': function (a, b) { return a < b; },
        '<=': function (a, b) { return a <= b; },
        '=': function (a, b) { return a === b; }
    },
        op = (style.operator === undefined ? "=" : style.operator),
        property = style.property,
        value = style.value,
        feature = style.feature,
        styleValue = style.style,
        newFeatures = style.features;
    
        
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
        
        if (operators[op](feature.getProperty(property), value)) {
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
                                                          
function add_geojson(map_id, geojson, geojson_source, style, update_map_view, layer_id) {
    
    window[map_id + 'googleGeojson' + layer_id] = new google.maps.Data({ map: window[map_id + 'map'] });
    
    if (geojson_source === "local") {
        
        window[map_id + 'googleGeojson' + layer_id].addGeoJson(geojson);
        
        window[map_id + 'googleGeojson' + layer_id].forEach(function(feature) {
            
//            console.log('feature');
            //console.log(feature.getGeometry());
            feature.getGeometry().forEachLatLng(function(latLng){
                console.log(latLng);
                window[map_id + 'mapBounds'].extend(latLng);
            });
        });
        
        window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
        

        
    } else if (geojson_source === "url") {

        window[map_id + 'googleGeojson' + layer_id].loadGeoJson(geojson);
    }
    
        // a function that computes the style for each feature
    window[map_id + 'googleGeojson' + layer_id].setStyle(function (feature) {

        return ({
            // all
            clickable: getAttribute(feature, style, 'clickable'),
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
            fillColor: getAttribute(feature, style, 'fillColor'),
            fillOpacity: feature.getProperty("fillOpacity")
        });
    });
    
    if (update_map_view === true) {
        console.log("update map view is true")
    // TODO: update bounds
       // zoom(map_id, layer_id)
    }
}

/**
* Update a map's viewport to fit each geometry in a dataset
* @param {google.maps.Map} map The map to adjust
*/
function zoom(map_id, layer_id) {
    
//  if(update_map_view === true){
//    window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
//  }
    
    var bounds = new google.maps.LatLngBounds();

    console.log(window[map_id + 'googleGeojson' + layer_id]);
    
     window[map_id + 'googleGeojson' + layer_id].data.forEach(function(feature) {
         
         console.log(feature.geometry());
         
         console.log("feature");
         console.log(feature);
         
         processPoints(feature.getGeometry(), 
                       //bounds.extend, 
                       window[map_id + 'mapBounds'].extend,
                       bounds);
    });
    
    console.log("bounds");
    console.log(bounds);
    window[map_id + 'map'].fitBounds(bounds);
//    window[map_id + 'map'].fitBounds(bounds);
}

function getAttribute(feature, style, attr){
    
    if (style == null){
        return feature.getProperty(attr);
    }
    
	if (style[attr] !== undefined) {   // a style has been provided
		if (feature.getProperty([style[attr]]) !== undefined) {   // the provided style doesn't exist in the feature
			return feature.getProperty([style[attr]]);
		} else {                      // so assume the style is a valid colour/feature
			return style[attr];
		}
	} else { 
        return feature.getProperty(attr);
	}
}


function clear_geojson(map_id, layer_id) {
    window[map_id + 'googleGeojson' + layer_id].setMap(null);
    window[map_id + 'googleGeojson' + layer_id] = null;
}