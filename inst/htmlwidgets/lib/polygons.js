/** Add polygons
 *
 * adds polygons to the map
 * @param map_id
 * @param data_polygon
 */
function add_polygons(map_id, data_polygon, update_map_view, layer_id, use_polyline, legendValues){

    //if(window[map_id + 'googlePolygon' + layer_id == null]){
    //    window[map_id + 'googlePolygon' + layer_id] = [];
    //}
    createWindowObject(map_id, 'googlePolygon', layer_id);
  
  var infoWindow = new google.maps.InfoWindow(),
      aPath,
      paths = [];

  for(i = 0; i < Object.keys(data_polygon).length; i++){
      add_gons(map_id, data_polygon[i]);
  }

  function add_gons(map_id, polygon){

      if(use_polyline){
          for(j = 0; j < polygon.polyline.length; j ++){
              aPath = google.maps.geometry.encoding.decodePath(polygon.polyline[j]);
              paths.push(aPath);
          }
      }else{

          for(j = 0; j < polygon.coords.length; j++){
              aPath = polygon.coords[j];
              paths.push(aPath);
          }
      }

      //https://developers.google.com/maps/documentation/javascript/reference?csw=1#PolygonOptions
      var Polygon = new google.maps.Polygon({
          id: polygon.id,
          paths: paths,
          strokeColor: polygon.stroke_colour,
          strokeOpacity: polygon.stroke_opacity,
          strokeWeight: polygon.stroke_weight,
          fillColor: polygon.fill_colour,
          fillOpacity: polygon.fill_opacity,
          fillOpacityHolder: polygon.fill_opacity,
          mouseOver: polygon.mouse_over,
          mouseOverGroup: polygon.mouse_over_group,
          draggable: polygon.draggable,
          editable: polygon.editable,
          zIndex: polygon.z_index
          //_information: polygon.information
    //      clickable: true,
    //      editable: false,
    //      strokePosition: "CENTER",
    //      visible: true
          //zIndex:1
      });
      //console.log(Polygon);
      
      if(polygon.info_window){
          add_infoWindow(map_id, Polygon, infoWindow, '_information', polygon.info_window);
      }
      
      if(polygon.mouse_over || polygon.mouse_over_group){
          add_mouseOver(map_id, Polygon, infoWindow, "_mouse_over", polygon.mouse_over, layer_id, 'googlePolygon');
      }
      
      polygonInfo = { layerId : layer_id };
      polygon_click(map_id, Polygon, polygon.id, polygonInfo);

      if(Polygon.editable) {
          // edit listeners must be set on paths
          polygon_edited(map_id, Polygon);
          
          // right-click listener for deleting vetices
          google.maps.event.addListener(Polygon, 'rightclick', function(event) {
              if (event.vertex === undefined) {
                  return;
              } else {
                  remove_vertex(event.vertex, Polygon);
              }
          })
      }
      
      
      
      
    window[map_id + 'googlePolygon' + layer_id].push(Polygon);
    Polygon.setMap(window[map_id + 'map']);

    if(update_map_view === true){

      var points = paths[0];

      for ( var n = 0; n < points.length; n++){
        window[map_id + 'mapBounds'].extend(points[n]);
      }
    }
  }

    if(update_map_view === true){
        window[map_id + 'map'].fitBounds(window[map_id + 'mapBounds']);
    }
    
    if(legendValues !== false){
        add_legend(map_id, layer_id, legendValues);
    }

}

/**
 * Updates polygon options
 * @param map_id
 *          the map containing the polygons
 * @param data_polygon
 *          polygon data to update
 * @param addRemove
 *          boolean specifying if polygons should be added or removed if they are / are not included in the udpated data set
 */
function update_polygons(map_id, data_polygon, layer_id, legendValues){

  // for a given polygon_id, change the options
  var objectAttribute;
  var attributeValue;
  var _id;
  var thisUpdatePolygon;
  var currentIds = [];
  var newIds = [];
  var newPolygons = [];

  for(i = 0; i < Object.keys(window[map_id + 'googlePolygon' + layer_id]).length; i++){

    _id = window[map_id + 'googlePolygon' + layer_id][i].id;
    currentIds.push(_id);

    // find if there is a matching id in the new polygon data set
    thisUpdatePolygon = findById(data_polygon, _id, "object");
    if(thisUpdatePolygon !== undefined){
    //if(data_polygon.find(x => x.id === _id)){
      //thisUpdatePolygon = data_polygon.find(x => x.id === _id);

      //if the polygon is currently set to Null, re-put it on the map
      if(window[map_id + 'googlePolygon' + layer_id][i].getMap() === null){
        window[map_id + 'googlePolygon' + layer_id][i].setMap(window[map_id + 'map']);
      }

      // the new id exists in the current data set
      // update the values for this polygon

      // for each of the options in data_polygon, update the polygons
      for(j = 0; j < Object.keys(thisUpdatePolygon).length; j++){

        objectAttribute = Object.keys(thisUpdatePolygon)[j];
        attributeValue = thisUpdatePolygon[objectAttribute];

        switch(objectAttribute){
          case "fill_colour":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({fillColor: attributeValue});
            break;
          case "fill_opacity":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({fillOpacity: attributeValue});
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({fillOpacityHolder: attributeValue});
            break;
          case "stroke_colour":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({strokeColor: attributeValue});
            break;
          case "stroke_weight":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({strokeWeight: attributeValue});
            break;
          case "stroke_opacity":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({strokeOpacity: attributeValue});
            break;
          case "info_window":
            window[map_id + 'googlePolygon' + layer_id][i].setOptions({_information: attributeValue});
            break;
        }
      }

    }else{
      // the id does not exist in the new data set
      //if(removeMissing){
        // remove the polygon from the map
        // (but don't clear it from the arrray?)
        window[map_id + 'googlePolygon' + layer_id][i].setMap(null);
      //}
    }
      
    if(legendValues !== false){
        add_legend(map_id, layer_id, legendValues);
    }
  }


// NOTE:
// can't add individual polygons to the map
//  if(addExtra){
      // find those in the new set that aren't in the current set
//      for(var o in data_polygon){
//        newIds.push(data_polygon[o].id);
//      }

//      let difference = newIds.filter(x => currentIds.indexOf(x) == -1);

//      for(i = 0; i < difference.length; i++){
//        newPolygons.push(data_polygon.find(x => x.id === difference[i]));
//        window[map_id + 'googlePolygon'].find(x => x.id === difference[i]).setMap(window[map_id + 'map']);
//      }
//      if(Object.keys(newPolygons).length > 0){
//        newPolygons = Object.keys(newPolygons).map(key => newPolygons[key]);
//        add_polygons(map_id, newPolygons);
//     }
//    }
}

/**
 * Clears polygons from a map
 *
 * @param map_id
 * @param layer_id
 */
function clear_polygons(map_id, layer_id){
    clear_object(map_id, 'googlePolygon', layer_id);
}
