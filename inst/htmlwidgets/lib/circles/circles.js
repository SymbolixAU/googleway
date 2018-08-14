// TODO:
// - if not using an interval, don't update map bounds in the loop

/**
 * Add circles
 *
 * Adds circles to the map
 *
 * @param map_id
 * @param data_circles
 * @param layer_id
 */

function add_circles(map_id, data_circles, update_map_view, layer_id, use_polyline, legendValues, interval, focus) {

    if (focus === true) {
        clear_bounds(map_id);
    }

    var i,
        infoWindow = new google.maps.InfoWindow();

    createWindowObject(map_id, 'googleCircles', layer_id);

    for (i = 0; i < Object.keys(data_circles).length; i++) {
        set_circle(map_id, data_circles[i], infoWindow, update_map_view, layer_id, use_polyline, i * interval);
    }

    if (legendValues !== false) {
        add_legend(map_id, layer_id, legendValues);
    }
}

function set_circle(map_id, circle, infoWindow, update_map_view, layer_id, use_polyline, timeout) {

    window.setTimeout(function () {

        var j, lon, lat, path, latlon, Circle;

        if (use_polyline) {

            for (j = 0; j < circle.polyline.length; j++) {
                path = google.maps.geometry.encoding.decodePath(circle.polyline[j]);

                latlon = new google.maps.LatLng(path[0].lat(), path[0].lng());

                Circle = new google.maps.Circle({
                    id: circle.id,
                    strokeColor: circle.stroke_colour,
                    strokeOpacity: circle.stroke_opacity,
                    strokeWeight: circle.stroke_weight,
                    fillColor: circle.fill_colour,
                    fillOpacity: circle.fill_opacity,
                    fillOpacityHolder: circle.fill_opacity,
                    draggable: circle.draggable,
                    editable: circle.editable,
                    center: latlon,
                    radius: circle.radius,
                    mouseOver: circle.mouse_over,
                    mouseOverGroup: circle.mouse_over_group,
                    zIndex: circle.z_index
                });

                set_each_circle(Circle, circle, infoWindow, update_map_view, map_id, layer_id);

                if (update_map_view === true) {
                    window[map_id + 'mapBounds'].extend(latlon);
                    window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
                }
            }
        } else {

            latlon = new google.maps.LatLng(circle.lat, circle.lng);
            Circle = new google.maps.Circle({
                id: circle.id,
                strokeColor: circle.stroke_colour,
                strokeOpacity: circle.stroke_opacity,
                strokeWeight: circle.stroke_weight,
                fillColor: circle.fill_colour,
                fillOpacity: circle.fill_opacity,
                fillOpacityHolder: circle.fill_opacity,
                draggable: circle.draggable,
                editable: circle.editable,
                center: latlon,
                radius: circle.radius,
                mouseOver: circle.mouse_over,
                mouseOverGroup: circle.mouse_over_group,
                zIndex: circle.z_index,
                chart_type: circle.chart_type,
                chart_data: circle.chart_data,
                chart_options: circle.chart_options
            });

            set_each_circle(Circle, circle, infoWindow, update_map_view, map_id, layer_id);

            if (update_map_view === true) {
                window[map_id + 'mapBounds'].extend(latlon);
                window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
            }
        }
    }, timeout);
}

function set_each_circle(Circle, circle, infoWindow, update_map_view, map_id, layer_id) {

  //console.log(Circle);

    var shapeInfo;

    window[map_id + 'googleCircles' + layer_id].push(Circle);
    Circle.setMap(window[map_id + 'map']);

    if (circle.info_window) {
        add_infoWindow(map_id, Circle, infoWindow, 'info_window', circle.info_window);
    }

    if (circle.mouse_over || circle.mouse_over_group) {
        add_mouseOver(map_id, Circle, infoWindow, "_mouse_over", circle.mouse_over, layer_id, 'googleCircles');
    }

    shapeInfo = { layerId : layer_id };
    shape_click(map_id, Circle, circle.id, shapeInfo);

    if (Circle.editable) {
        // edit listeners must be set on paths
        circle_edited(map_id, Circle);
    }

    if (Circle.draggable) {
        circle_dragged(map_id, Circle);
    }
}

/**
 * clears circles from a google map object
 * @param map_id
 *          the map to clear
 * @param layer_id
 *          the layer to clear
 */
function clear_circles(map_id, layer_id) {
    clear_object(map_id, 'googleCircles', layer_id);
}


/**
 * Updates polygon options
 * @param map_id
 *          the map containing the circles
 * @param data_circle
 *          circles data to update
 * @param addRemove
 *          boolean specifying if circles should be added or removed if they are / are not included in the udpated data set
 */
function update_circles(map_id, data_circle, layer_id, legendValues) {

    // for a given circle_id, change the options
    var i, j,
        objectAttribute,
        attributeValue,
        thisId,
        thisUpdateCircle,
        currentIds = [],
        newIds = [],
        newPolygons = [];

    for (i = 0; i < Object.keys(window[map_id + 'googleCircles' + layer_id]).length; i++) {

        thisId = window[map_id + 'googleCircles' + layer_id][i].id;
        currentIds.push(thisId);

        thisUpdateCircle = findById(data_circle, thisId, "object");
        if (thisUpdateCircle !== undefined) {

            //if(data_circle.find(x => x.id === _id)){
            //thisUpdateCircle = data_circle.find(x => x.id === _id);

            //if the circle is currently set to Null, re-put it on the map
            if (window[map_id + 'googleCircles' + layer_id][i].getMap() === null) {
                window[map_id + 'googleCircles' + layer_id][i].setMap(window[map_id + 'map']);
            }

            // the new id exists in the current data set
            // update the values for this circle

            // for each of the options in data_circle, update the circles
            for (j = 0; j < Object.keys(thisUpdateCircle).length; j++) {

                objectAttribute = Object.keys(thisUpdateCircle)[j];
                attributeValue = thisUpdateCircle[objectAttribute];

                switch (objectAttribute) {
                case "radius":
                    window[map_id + 'googleCircles' + layer_id][i].setOptions({radius: attributeValue});
                    break;
                case "draggable":
                    window[map_id + 'googleCircles' + layer_id][i].setOptions({draggable: attributeValue});
                    break;
                case "fill_colour":
                    window[map_id + 'googleCircles' + layer_id][i].setOptions({fillColor: attributeValue});
                    break;
                case "fill_opacity":
                    window[map_id + 'googleCircles' + layer_id][i].setOptions({fillOpacity: attributeValue});
                    window[map_id + 'googleCircles' + layer_id][i].setOptions({fillOpacityHolder: attributeValue});
                    break;
                case "stroke_colour":
                    window[map_id + 'googleCircles' + layer_id][i].setOptions({strokeColor: attributeValue});
                    break;
                case "stroke_weight":
                    window[map_id + 'googleCircles' + layer_id][i].setOptions({strokeWeight: attributeValue});
                    break;
                case "stroke_opacity":
                    window[map_id + 'googleCircles' + layer_id][i].setOptions({strokeOpacity: attributeValue});
                    break;
                case "info_window":
                    window[map_id + 'googleCircles' + layer_id][i].setOptions({info_window: attributeValue});
                    break;
                }
            }
        } else {
            window[map_id + 'googleCircles' + layer_id][i].setMap(null);
        }
    }

    if (legendValues !== false) {
        add_legend(map_id, layer_id, legendValues);
    }
}
