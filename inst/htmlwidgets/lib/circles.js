/**
 * Add circles
 *
 * Adds circles to the map
 *
 * @param map_id
 * @param data_circles
 * @param layer_id
 */
function add_circles(map_id, data_circles, update_map_view, layer_id, legendValues, legendOptions){

    var i;
    //if(window[map_id + 'googleCircles' + layer_id] == null){
    //    window[map_id + 'googleCircles' + layer_id] = [];
    //}
    createWindowObject(map_id, 'googleCircles', layer_id);
    
    var infoWindow = new google.maps.InfoWindow();

    for (i = 0; i < Object.keys(data_circles).length; i++) {
        add_circle(map_id, data_circles[i]);
    }

    function add_circle(map_id, circle){

        var latlon = new google.maps.LatLng(circle.lat, circle.lng);

        var Circle = new google.maps.Circle({
            id: circle.id,
            strokeColor: circle.stroke_colour,
            strokeOpacity: circle.stroke_opacity,
            strokeWeight: circle.stroke_weight,
            fillColor: circle.fill_colour,
            fillOpacity: circle.fill_opacity,
            fillOpacityHolder: circle.fill_opacity,
            draggable: circle.draggable,
            center: latlon,
            radius: circle.radius,
            mouseOverGroup: circle.mouse_over_group,
            zIndex: circle.z_index
          });

        window[map_id + 'googleCircles' + layer_id].push(Circle);
        Circle.setMap(window[map_id + 'map']);

        if(circle.info_window){
            add_infoWindow(map_id, Circle, infoWindow, '_information', circle.info_window);
        }

        if(circle.mouse_over || circle.mouse_over_group){
            add_mouseOver(map_id, Circle, infoWindow, "_mouse_over", circle.mouse_over, layer_id, 'googleCircles');
        }

        shapeInfo = { layerId : layer_id };
        shape_click(map_id, Circle, circle.id, shapeInfo);

        if(update_map_view === true){
            window[map_id + 'mapBounds'].extend(latlon);
        }
    }

    if(update_map_view === true){
        window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
    }
    
    if(legendValues !== false){
        add_legend(map_id, layer_id, legendValues, legendOptions);
    }
}

/**
 * clears circles from a google map object
 * @param map_id
 *          the map to clear
 * @param layer_id
 *          the layer to clear
 */
function clear_circles(map_id, layer_id){ 
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
function update_circles(map_id, data_circle, layer_id, legendValues){

  // for a given circle_id, change the options
  var objectAttribute;
  var attributeValue;
  var _id;
  var thisUpdateCircle;
  var currentIds = [];
  var newIds = [];
  var newPolygons = [];

  for(i = 0; i < Object.keys(window[map_id + 'googleCircles' + layer_id]).length; i++){

    _id = window[map_id + 'googleCircles' + layer_id][i].id;
    currentIds.push(_id);

    thisUpdateCircle = findById(data_circle, _id, "object");
    if(thisUpdateCircle !== undefined){

    //if(data_circle.find(x => x.id === _id)){
      //thisUpdateCircle = data_circle.find(x => x.id === _id);

      //if the circle is currently set to Null, re-put it on the map
      if(window[map_id + 'googleCircles' + layer_id][i].getMap() === null){
        window[map_id + 'googleCircles' + layer_id][i].setMap(window[map_id + 'map']);
      }

      // the new id exists in the current data set
      // update the values for this circle

      // for each of the options in data_circle, update the circles
      for(j = 0; j < Object.keys(thisUpdateCircle).length; j++){

        objectAttribute = Object.keys(thisUpdateCircle)[j];

        attributeValue = thisUpdateCircle[objectAttribute];

        switch(objectAttribute){
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
            window[map_id + 'googleCircles' + layer_id][i].setOptions({_information: attributeValue});
            break;
        }
      }

    }else{
        window[map_id + 'googleCircles' + layer_id][i].setMap(null);
    }
  }
    
    if(legendValues !== false){
        add_legend(map_id, layer_id, legendValues);
    }
}
