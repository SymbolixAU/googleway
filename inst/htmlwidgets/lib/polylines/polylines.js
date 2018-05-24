/** Add polylines
 *
 * Adds polylines to the map
 *
 * @param map_id
 * @param data_polyine
 * @param update_map_view
 * @param layer_id
 * @param use_polyline
 *          boolean indicating if the data is an encoded polyline
 */
function add_polylines(map_id, data_polyline, update_map_view, layer_id, use_polyline, legendValues, interval, focus) {

    if (focus === true) {
        clear_bounds(map_id);
    }
    createWindowObject(map_id, 'googlePolyline', layer_id);

    var i,
        infoWindow = new google.maps.InfoWindow();

    for (i = 0; i < Object.keys(data_polyline).length; i++) {
        set_lines(map_id, data_polyline[i], infoWindow, update_map_view, layer_id, use_polyline, i * interval);
    }

    if (legendValues !== false) {
        add_legend(map_id, layer_id, legendValues);
    }
}

// From R, polylines are now stored in a list-column (to account for MULTILINESTRINGS).
// However, Google doesn't like arrays of polylines
// (unlike for polygons). So we need to loop each polyline in the list/array

function set_lines(map_id, polyline, infoWindow, update_map_view, layer_id, use_polyline, timeout) {

    window.setTimeout(function () {

        var j,
            coords = [],
            path = [],
            Polyline,
            thisPath;

        if (use_polyline) {

            for (j = 0; j < polyline.polyline.length; j++) {

                //paths.push(google.maps.geometry.encoding.decodePath(polyline.polyline[j]));
                path = google.maps.geometry.encoding.decodePath(polyline.polyline[j]);

                // for each iteration, need to set the Polyline object ,rather than set
                // an array of paths
                Polyline = new google.maps.Polyline({
                    id: polyline.id,
                    path: path,
                    geodesic: polyline.geodesic,
                    editable: polyline.editable,
                    draggable: polyline.draggable,
                    strokeColor: polyline.stroke_colour,
                    strokeOpacity: polyline.stroke_opacity,
                    strokeOpacityHolder: polyline.stroke_opacity,
                    strokeWeight: polyline.stroke_weight,
                    mouseOver: polyline.mouse_over,
                    mouseOverGroup: polyline.mouse_over_group,
                    zIndex: polyline.z_index,
                    chart_type: polyline.chart_type,
                    chart_data: polyline.chart_data,
                    chart_options: polyline.chart_options
                });

                set_each_line(Polyline, polyline, infoWindow, update_map_view, map_id, layer_id);
            }
        } else {
            for (j = 0; j < polyline.coords.length; j++) {
                coords.push(polyline.coords[j]);
            }

            Polyline = new google.maps.Polyline({
                id: polyline.id,
                path: coords,
                geodesic: polyline.geodesic,
                editable: polyline.editable,
                draggable: polyline.draggable,
                strokeColor: polyline.stroke_colour,
                strokeOpacity: polyline.stroke_opacity,
                strokeOpacityHolder: polyline.stroke_opacity,
                strokeWeight: polyline.stroke_weight,
                mouseOver: polyline.mouse_over,
                mouseOverGroup: polyline.mouse_over_group,
                zIndex: polyline.z_index,
                chart_type: polyline.chart_type,
                chart_data: polyline.chart_data,
                chart_options: polyline.chart_options
            });

            set_each_line(Polyline, polyline, infoWindow, update_map_view, map_id, layer_id);
        }

        // TODO(polyline length) calculate and log the distance
        //    polyLengthInMeters = google.maps.geometry.spherical.computeLength(Polyline.getPath().getArray());

    }, timeout);
}

function set_each_line(Polyline, polyline, infoWindow, update_map_view, map_id, layer_id) {

    var n, points, polylineInfo;

    window[map_id + 'googlePolyline' + layer_id].push(Polyline);
    Polyline.setMap(window[map_id + 'map']);

    if (update_map_view === true) {
        // extend the bounds of the map
        points = Polyline.getPath().getArray();

        for (n = 0; n < points.length; n++) {
            window[map_id + 'mapBounds'].extend(points[n]);
        }
        window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
    }

    if (polyline.info_window) {
        add_infoWindow(map_id, Polyline, infoWindow, 'info_window', polyline.info_window);
    }

    // need to add the listener once so it's not overwritten?
    if (polyline.mouse_over || polyline.mouse_over_group) {
        add_mouseOver(map_id, Polyline, infoWindow, "_mouse_over", polyline.mouse_over, layer_id, 'googlePolyline');
    }

    polylineInfo = { layerId : layer_id };
    polyline_click(map_id, Polyline, polyline.id, polylineInfo);

    if (Polyline.editable) {
        // edit listeners must be set on paths
        polyline_edited(map_id, Polyline);

        // right-click listener for deleting vetices
        google.maps.event.addListener(Polyline, 'rightclick', function(event) {
            if (event.vertex === undefined) {
                return;
            } else {
                remove_vertex(event.vertex, Polyline);
            }
        })
    }

    if (Polyline.draggable) {
        polyline_dragged(map_id, Polyline);
    }
}


/**
 * Updates polyline options
 * @param map_id
 *          the map containing the polygons
 * @param data_polylines
 *          polyline data to update
 */
function update_polylines(map_id, data_polyline, layer_id, legendValues) {

  // for a given polygon_id, change the options
    var i, j,
        objectAttribute,
        attributeValue,
        thisId,
        thisUpdatePolyline,
        currentIds = [],
        newIds = [],
        newPolylines = [];

    if (window[map_id + 'googlePolyline' + layer_id] !== undefined) {

        for (i = 0; i < Object.keys(window[map_id + 'googlePolyline' + layer_id]).length; i++) {

            thisId = window[map_id + 'googlePolyline' + layer_id][i].id;

            currentIds.push(thisId);

            // find if there is a matching id in the new polyline data set
            thisUpdatePolyline = findById(data_polyline, thisId, "object");

            if (thisUpdatePolyline !== undefined) {
                //if(data_polyline.find(x => x.id === _id)){
                //thisUpdatePolyline = data_polyline.find(x => x.id === _id);

                //if the polygon is currently set to Null, re-put it on the map
                if (window[map_id + 'googlePolyline' + layer_id][i].getMap() === null) {
                    window[map_id + 'googlePolyline' + layer_id][i].setMap(window[map_id + 'map']);
                }

                // the new id exists in the current data set
                // update the values for this polygon

                // for each of the options in data_polyline, update the polygons
                for (j = 0; j < Object.keys(thisUpdatePolyline).length; j++) {

                    objectAttribute = Object.keys(thisUpdatePolyline)[j];
                    attributeValue = thisUpdatePolyline[objectAttribute];

                    switch (objectAttribute) {
                    case "stroke_colour":
                        window[map_id + 'googlePolyline' + layer_id][i].setOptions({strokeColor: attributeValue});
                        break;
                    case "stroke_weight":
                        window[map_id + 'googlePolyline' + layer_id][i].setOptions({strokeWeight: attributeValue});
                        break;
                    case "stroke_opacity":
                        window[map_id + 'googlePolyline' + layer_id][i].setOptions({strokeOpacity: attributeValue});
                        break;
                    case "info_window":
                        window[map_id + 'googlePolyline' + layer_id][i].setOptions({info_window: attributeValue});
                        break;
                    }
                }

            } else {
                // the id does not exist in the new data set
                //if(removeMissing){
                  // remove the polygon from the map
                  // (but don't clear it from the arrray?)
                window[map_id + 'googlePolyline' + layer_id][i].setMap(null);
            //}
            }
        }
    }

    if (legendValues !== false) {
        add_legend(map_id, layer_id, legendValues);
    }

}




function clear_polylines(map_id, layer_id) {
    clear_object(map_id, 'googlePolyline', layer_id);
}
