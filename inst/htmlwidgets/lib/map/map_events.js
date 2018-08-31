/**
 * Map click
 *
 * Returns details of the click even on a map
 **/
function map_click(map_id, mapObject, mapInfo) {

  //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }

  google.maps.event.addListener(mapObject, 'click', function (event) {

    var eventInfo = $.extend(
      {
        id: map_id,
        lat: event.latLng.lat(),
        lon: event.latLng.lng(),
        centerLat: mapObject.getCenter().lat(),
        centerLon: mapObject.getCenter().lng(),
        zoom: mapObject.getZoom(),
        randomValue: Math.random()
      },
      mapInfo
    ),
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_map_click", eventInfo);
  });
}


function bounds_changed(map_id, mapObject, mapInfo) {

    //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }

  google.maps.event.addListener(mapObject, 'bounds_changed', function (event) {
    var eventInfo = $.extend(
      {
        id: map_id,
        northEastLat: mapObject.getBounds().getNorthEast().lat(),
        northEastLon: mapObject.getBounds().getNorthEast().lng(),
        southWestLat: mapObject.getBounds().getSouthWest().lat(),
        southWestLon: mapObject.getBounds().getSouthWest().lng(),
        randomValue: Math.random()
      },
      mapInfo
    ),
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_bounds_changed", eventInfo);
  });
}

function zoom_changed(map_id, mapObject, mapInfo) {

  //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }
  google.maps.event.addListener(mapObject, 'bounds_changed', function (event) {
    var eventInfo = $.extend(
      {
        id: map_id,
        zoom: mapObject.getZoom(),
        randomValue: Math.random()
       },
      mapInfo
    ),
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_zoom_changed", eventInfo);
  });
}

/**
 * Marker click
 *
 * Returns details of the marker that was clicked
 **/
function marker_click(map_id, markerObject, marker_id, markerInfo) {

    //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }

  google.maps.event.addListener(markerObject, 'click', function (event) {

    var eventInfo = $.extend(
      {
        id: marker_id,
        lat: event.latLng.lat(),
        lon: event.latLng.lng(),
        randomValue: Math.random()
      },
      markerInfo
    ),
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_marker_click", eventInfo);
  });
}

/**
 * Shape Click
 *
 * Returns the 'id' of the shape that was clicked back to shiny
 **/
function shape_click(map_id, shapeObject, shape_id, shapeInfo) {

    //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }
  google.maps.event.addListener(shapeObject, 'click', function (event) {

  //console.log( window );
  //console.log( window.googleway.params );

  var event_return_type,
    eventInfo = $.extend(
      {
        id: shape_id,
        lat: event.latLng.lat(),
        lon: event.latLng.lng(),
        randomValue: Math.random()
      },
      shapeInfo
    ),
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);

    Shiny.onInputChange(map_id + "_shape_click", eventInfo);
    Shiny.onInputChange(map_id + "_circle_click", eventInfo);
  });
}

/**
 * Rectangle Click
 *
 * Returns the 'id' of the shape that was clicked back to shiny
 *
 **/
function rectangle_click(map_id, shapeObject, shape_id, shapeInfo) {

  //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }
  google.maps.event.addListener(shapeObject, 'click', function (event) {

    var eventInfo = $.extend(
      {
        id: shape_id,
        lat: event.latLng.lat(),
        lon: event.latLng.lng(),
        randomValue: Math.random()
      },
      shapeInfo
    ),
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_rectangle_click", eventInfo);
  });
}

function polyline_click(map_id, polylineObject, polyline_id, polylineInfo) {

  //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }
  google.maps.event.addListener(polylineObject, 'click', function (event) {

    var eventInfo = $.extend(
      {
        id: polyline_id,
        lat: event.latLng.lat(),
        lon: event.latLng.lng(),
        path: google.maps.geometry.encoding.encodePath(polylineObject.getPath()),
        randomValue: Math.random()
      },
    polylineInfo
    ),
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_polyline_click", eventInfo);
  });
}

function polygon_click(map_id, polygonObject, polygon_id, polygonInfo) {

  //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }

  google.maps.event.addListener(polygonObject, 'click', function (event) {

    var polygonOuterPath = google.maps.geometry.encoding.encodePath(polygonObject.getPath()),
      polygonAllPaths = [],
      paths = polygonObject.getPaths(),
      i = 0;

    for (i = 0; i < paths.getLength(); i++) {
      polygonAllPaths.push(google.maps.geometry.encoding.encodePath(paths.getAt(i)));
    }

    var eventInfo = $.extend(
      {
        id: polygon_id,
        lat: event.latLng.lat(),
        lon: event.latLng.lng(),
        outerPath: polygonOuterPath,
        allPaths: polygonAllPaths,
        randomValue: Math.random()
      },
      polygonInfo
    ),
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_polygon_click", eventInfo);
  });
}

/**
* Returns bounds of edited rectangle back to shiny
*
*/
function rectangle_edited(map_id, rectangleObject) {

  //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }

  rectangleObject.addListener('bounds_changed', function () {
    var eventInfo = {
      id: rectangleObject.id,
      newBounds: rectangleObject.getBounds()
    },
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_rectangle_edit", eventInfo);
  });
}

/**
* Returns bounds of edited circle back to shiny
*
*/
function circle_edited(map_id, circleObject) {

  //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }
  circleObject.addListener('radius_changed', function () {
    var eventInfo = {
      id: circleObject.id,
      newCenter: circleObject.getCenter(),
      newRadius: circleObject.getRadius()
    },
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_circle_edit", eventInfo);
  });
}

function circle_dragged(map_id, circleObject) {

  //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }
  circleObject.addListener('center_changed', function () {
    var eventInfo = {
      id: circleObject.id,
      newCenter: circleObject.getCenter(),
      newRadius: circleObject.getRadius()
    },
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_circle_drag", eventInfo);
  });
}

function polyline_dragged(map_id, polylineObject) {

  //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }

  var path = polylineObject.getPath(),
    i = 0;

  path.addListener('set_at', function () {
    var polylinePath = google.maps.geometry.encoding.encodePath(polylineObject.getPath()),
      eventInfo = {
        id: polylineObject.id,
        path: polylinePath
    },
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_polyline_drag", eventInfo);
  });

}

function polyline_edited(map_id, polylineObject) {
  //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }

  var path = polylineObject.getPath(),
    i = 0;

  path.addListener('insert_at', function () {
    var polylinePath = google.maps.geometry.encoding.encodePath(polylineObject.getPath()),
    eventInfo = {
      id: polylineObject.id,
      path: polylinePath
    },
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_polyline_edit", eventInfo);
  });

  path.addListener('remove_at', function () {
    var polylinePath = google.maps.geometry.encoding.encodePath(polylineObject.getPath()),
      eventInfo = {
        id: polylineObject.id,
        path: polylinePath
      },
    event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_polyline_edit", eventInfo);
  });
}

function polygon_dragged(map_id, polygonObject) {

  //'use strict';
  if (!HTMLWidgets.shinyMode) {
    return;
  }
  var paths = polygonObject.getPaths(),
    i = 0;

  for (i = 0; i < paths.getLength(); i++) {
    paths.getAt(i).addListener('set_at', function() {

    var polygonOuterPath = google.maps.geometry.encoding.encodePath(polygonObject.getPath()),
      polygonAllPaths = [],
      paths = polygonObject.getPaths();

      for(i = 0; i < paths.getLength(); i++){
        polygonAllPaths.push(google.maps.geometry.encoding.encodePath(paths.getAt(i)));
      }

      var eventInfo = {
        id: polygonObject.id,
        outerPath: polygonOuterPath,
        allPaths: polygonAllPaths
      },
      event_return_type = window.googleway.params[1].event_return_type;
      eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
      Shiny.onInputChange(map_id + "_polygon_drag", eventInfo);
    });
  }
}
function polygon_edited(map_id, polygonObject) {

    //'use strict';

    if (!HTMLWidgets.shinyMode) {
        return;
    }
    var paths = polygonObject.getPaths(),
        i = 0;

    for (i = 0; i < paths.getLength(); i++) {

        paths.getAt(i).addListener('insert_at', function() {

            var polygonOuterPath = google.maps.geometry.encoding.encodePath(polygonObject.getPath()),
                polygonAllPaths = [],
                paths = polygonObject.getPaths();

            for(i = 0; i < paths.getLength(); i++){
                polygonAllPaths.push(google.maps.geometry.encoding.encodePath(paths.getAt(i)));
            }

            var eventInfo = {
                id: polygonObject.id,
                outerPath: polygonOuterPath,
                allPaths: polygonAllPaths
            },
                event_return_type = window.googleway.params[1].event_return_type;

            eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
            Shiny.onInputChange(map_id + "_polygon_edit", eventInfo);
        });


        paths.getAt(i).addListener('remove_at', function() {

            var polygonOuterPath = google.maps.geometry.encoding.encodePath(polygonObject.getPath()),
                polygonAllPaths = [],
                paths = polygonObject.getPaths();

            for(i = 0; i < paths.getLength(); i++){
                polygonAllPaths.push(google.maps.geometry.encoding.encodePath(paths.getAt(i)));
            }

            var eventInfo = {
                id: polygonObject.id,
                outerPath: polygonOuterPath,
                allPaths: polygonAllPaths
            },
                event_return_type = window.googleway.params[1].event_return_type;

            eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
            Shiny.onInputChange(map_id + "_polygon_edit", eventInfo);
        });
    }
}

/*
* Removes vertices from polylines
*
*/
function remove_vertex(vertex, polyObject) {

    //'use strict';

    var path = polyObject.getPath();
    path.removeAt(vertex);
}


function add_mouseOver(map_id, mapObject, infoWindow, objectAttribute, attributeValue, layer_id, layerType) {

    //'use strict';

    // notes
    // - mouseOver and mosueOverGroup need to have the same listener.
    // - the group takes precedence.
    mapObject.set(objectAttribute, attributeValue);

    // this infoWindow object is created so the 'mouseout' function doeesn't 'close'
    // the info window that's generated by clicking on the map.
    var infoWindow = new google.maps.InfoWindow();

    google.maps.event.addListener(mapObject, 'mouseover', function (event) {

        if (mapObject.get("mouseOverGroup") !== undefined) {
            // polygons can be made up of many shapes
            // so we need to iterate each one with the same id

            // markers only have opacity
            if (layerType === 'googleMarkers') {

                for (i = 0; i < window[map_id + layerType + layer_id].length; i++) {
                    if(window[map_id + layerType + layer_id][i].mouseOverGroup == this.mouseOverGroup){
                        window[map_id + layerType + layer_id][i].setOptions({Opacity: 1});
                    } else {
                        window[map_id + layerType + layer_id][i].setOptions({Opacity: 0.01});
                    }
                }

            // polylines only have strokeOpacity
            }else if (layerType === 'googlePolyline') {

                for (i = 0; i < window[map_id + layerType + layer_id].length; i++) {
                    if(window[map_id + layerType + layer_id][i].mouseOverGroup == this.mouseOverGroup){
                        window[map_id + layerType + layer_id][i].setOptions({strokeOpacity: 1});
                    } else {
                        window[map_id + layerType + layer_id][i].setOptions({strokeOpacity: 0.01});
                    }
                }
            } else {

                // other shapes have fillOpacity
                for (i = 0; i < window[map_id + layerType + layer_id].length; i++) {
                    if(window[map_id + layerType + layer_id][i].mouseOverGroup == this.mouseOverGroup){
                        window[map_id + layerType + layer_id][i].setOptions({fillOpacity: 1});
                    } else {
                        window[map_id + layerType + layer_id][i].setOptions({fillOpacity: 0.01});
                    }
                }
            }

        //}else{
          // mouseOverGroup is undefined...
          /**
          if(layerType === 'googleMarkers'){
            this.setOptions({Opacity: 1})
          }else if(layerType === 'googlePolyline'){
            this.setOptions({strokeOpacity: 1})
          }else{
            this.setOptions({fillOpacity: 1});
          }
          **/

          // infoWindow if 'mouseOver' is also specified
            if (mapObject.get("mouseOver") !== undefined) {

                mapObject.setOptions({"_mouse_over": mapObject.get(objectAttribute)});

                infoWindow.setContent(mapObject.get(objectAttribute).toString());

                infoWindow.setPosition(event.latLng);
                infoWindow.open(window[map_id + 'map']);
            }

        } else {

          // if the mouse_over is specified without the group, we need an info window
            if (mapObject.get("mouseOver") !== undefined) {

                mapObject.setOptions({"_mouse_over": mapObject.get(objectAttribute)});
                infoWindow.setContent(mapObject.get(objectAttribute).toString());


                if (layerType === 'googleMarkers') {
                    // markers need the info window to display at the top of the marker
                    // not where the event took place
                    this.infowindow = infoWindow;
                    this.infowindow.open(window[map_id + 'map'], this);
                } else {
                    infoWindow.setPosition(event.latLng);
                    infoWindow.open(window[map_id + 'map']);
                }

            }
        }

        //google.maps.event.addListenerOnce(window[map_id + 'map'], 'mousemove', function(event){
        //    infoWoindow.close();
        //})

    });

    google.maps.event.addListener(mapObject, 'mouseout', function(event) {

        if(mapObject.get("mouseOverGroup") !== undefined){
        // reset highlights

            if (layerType === 'googleMarkers') {

                for (i = 0; i < window[map_id + layerType + layer_id].length; i++) {
                    window[map_id + layerType + layer_id][i].setOptions({Opacity: window[map_id + layerType + layer_id][i].get('OpacityHolder')});
                }
            } else if (layerType === 'googlePolyline') {
                for (i = 0; i < window[map_id + layerType + layer_id].length; i++) {
                    window[map_id + layerType + layer_id][i].setOptions({strokeOpacity: window[map_id + layerType + layer_id][i].get('strokeOpacityHolder')});
                }
            } else {
                for (i = 0; i < window[map_id + layerType + layer_id].length; i++) {
                    window[map_id + layerType + layer_id][i].setOptions({fillOpacity: window[map_id + layerType + layer_id][i].get('fillOpacityHolder')});
                }
            }

        } else {

            if (layerType === 'googleMarkers') {
                this.setOptions({Opacity: mapObject.get('OpacityHolder')});
            } else if (layerType === 'googlePolyline'){
                this.setOptions({strokeOpacity: mapObject.get('strokeOpacityHolder')});
            } else {
                this.setOptions({fillOpacity: mapObject.get('fillOpacityHolder')});
            }

        }
        infoWindow.close();
    });
}




/**
 * Adds infowindow to the specified map object
 *
 * @param map_id
 * @param mapObject
 *          the object the info window is being attached to
 * @param objectAttribute
 *          string attribute name
 * @param attributeValue
 *          the value of the attribute
 */
function add_infoWindow(map_id, mapObject, infoWindow, objectAttribute, attributeValue) {

    //'use strict';

    mapObject.set(objectAttribute, attributeValue);

    if (mapObject.chart_type === undefined) {

      google.maps.event.addListener(mapObject, 'click', function(event){

          // the listener is being bound to the mapObject. So, when the infowindow
          // contents are updated, the 'click' listener will need to see the new   information
          // ref: http://stackoverflow.com/a/13504662/5977215
          mapObject.setOptions({"info_window": mapObject.get(objectAttribute)});

          infoWindow.setContent(mapObject.get(objectAttribute));
          infoWindow.setPosition(event.latLng);
          infoWindow.open(window[map_id + 'map']);
        });

    } else {

        mapObject.setOptions({"info_window": attributeValue});

        google.maps.event.addListener(mapObject, 'click', function(event) {

          var c = chartObject(this);
          infoWindow.setContent(c);
          infoWindow.setPosition(event.latLng);
          infoWindow.open(window[map_id + 'map']);
        });
    }
}
