/**
 * Add markers
 *
 * adds markers to a google map object
 *
 * @param map_id
 *          the map object to which the markers will be added
 * @param data_markers
 *          JSON array of marker data
 * @param cluster
 *          logical, indicating if the markers should cluster when zoomed out
 * @param layer_id
 *          the layer identifier
 */
function add_markers(map_id, data_markers, cluster, cluster_options, update_map_view, layer_id, use_polyline, interval, focus, close_info_window) {

    if (focus === true) {
        clear_bounds(map_id);
    }

    createWindowObject(map_id, 'googleMarkers', layer_id);

    promise_to_add_markers(map_id, data_markers, update_map_view, layer_id, use_polyline, interval).then(function(i) {

        if (cluster === true) {

            // need a delay after a setTimeout inside a promise chain
            // https://stackoverflow.com/q/39538473/5977215
            return delay(interval * i).then(function(){
                return cluster_markers(map_id, layer_id, cluster_options );
            });
        }
    });

    if (close_info_window) {
      var i, iwindow;
      google.maps.event.addListener(googlewayMap, 'click', function (event) {
        for (i = 0; i < window[map_id + 'googleMarkers' + layer_id].length; i++) {
          iwindow = window[map_id + 'googleMarkers' + layer_id][i];
          if (iwindow.infowindow !== undefined) {
            iwindow.infowindow.close();
          }
        }
      });
    }

}

function promise_to_add_markers(map_id, data_markers, update_map_view, layer_id, use_polyline, interval) {

    return new Promise(function(resolve, reject) {
        var i,
            infoWindow = new google.maps.InfoWindow();

        for (i = 0; i < Object.keys(data_markers).length; i++) {
            set_markers(map_id, infoWindow, data_markers[i], update_map_view, layer_id, use_polyline, i * interval);
        }

        if(i == Object.keys(data_markers).length) {
            resolve(i);
        }

    });
}


function cluster_markers(map_id, layer_id, cluster_options) {

  const minPoints = cluster_options.minimumClusterSize || 2.0;
  const minZoom = cluster_options.minZoom || 0;
  const maxZoom = cluster_options.maxZoom || 16;
  const radius = cluster_options.radius || 40;
  const extent = cluster_options.extent || 512;
  const nodeSize = cluster_options.nodeSize || 64;

  var markers = window[ map_id + 'googleMarkers' + layer_id ];

  const markerCluster = new markerClusterer.MarkerClusterer({
    markers: markers,
    map: googlewayMap,
    algorithm: new markerClusterer.SuperClusterAlgorithm({
      minPoints, minZoom, maxZoom, radius, extent, nodeSize
    })
  });
  window[ map_id + 'googleMarkerClusterer' + layer_id ] = markerCluster;
}

function set_markers(map_id, infoWindow, aMarker, update_map_view, layer_id, use_polyline, timeout) {

    window.setTimeout(function () {

        var j, lon, lat, path, latlon;

        if (use_polyline) {

            for (j = 0; j < aMarker.polyline.length; j++) {

                path = google.maps.geometry.encoding.decodePath(aMarker.polyline[j]);
                latlon = new google.maps.LatLng(path[0].lat(), path[0].lng());

                set_each_marker(latlon, aMarker, infoWindow, update_map_view, map_id, layer_id);

                if (update_map_view === true) {
                    window[map_id + 'mapBounds'].extend(latlon);
                    googlewayMap.fitBounds(window[map_id + 'mapBounds']);
                }
            }
        } else {
            latlon = new google.maps.LatLng(aMarker.lat, aMarker.lng);

            set_each_marker(latlon, aMarker, infoWindow, update_map_view, map_id, layer_id);

            if (update_map_view === true) {
                window[map_id + 'mapBounds'].extend(latlon);
                googlewayMap.fitBounds(window[map_id + 'mapBounds']);
            }
        }
    }, timeout);
}

function draw_chart(marker) {

    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Topping');
    data.addColumn('number', 'Slices');
    data.addRows([
        ['Mushrooms', 3],
        ['Onions', 1],
        ['Olives', 1],
        ['Zucchini', 1],
        ['Pepperoni', 2]
    ]);

    // Set chart options
    var options = {'title':'Pizza sold @ '+
                           marker.getPosition().toString(),
                   'width':400,
                   'height':150};

    var node        = document.createElement('div'),
        infoWindow  = new google.maps.InfoWindow(),
        chart       = new google.visualization.PieChart(node);

        chart.draw(data, options);
        infoWindow.setContent(node);
        infoWindow.open(marker.getMap(),marker);

}

function set_each_marker(latlon, aMarker, infoWindow, update_map_view, map_id, layer_id) {

    var content, markerInfo;

    if( aMarker.url !== undefined ) {
      content = document.createElement("img");
      content.src = aMarker.url;

    } else {
      content = new google.maps.marker.PinElement({
        background: aMarker.colour,
        borderColor: aMarker.border_colour,
        glyphColor: aMarker.glyph_colour,
        glyph: aMarker.label,
        scale: aMarker.scale
      });


    }

    const marker = new google.maps.marker.AdvancedMarkerElement({
        map: googlewayMap,
        id: aMarker.id,
        position: latlon,
        gmpDraggable: aMarker.draggable,
        title: aMarker.title,
        content: content.element,
        //mouseOverGroup: aMarker.mouse_over_group,
        //chart_type: aMarker.chart_type,
        //chart_data: aMarker.chart_data,
        //chart_options: aMarker.chart_options
    });

    content.setAttribute("mouseOverGroup", aMarker.mouse_over_group);
    content.setAttribute("background", aMarker.colour);
    content.setAttribute("mapId", map_id);
    content.setAttribute("layerId", layer_id);

    console.log(content.getAttribute("mouseOverGroup"));

    marker.addListener("click", () => {}); // setting listener ensures mouseOver works

    if (aMarker.info_window) {

        marker.infowindow = new google.maps.InfoWindow({
            content: aMarker.info_window
        });

        //google.maps.event.addListener(marker, 'click', function () {
            //this.infowindow.open(googlewayMap, this);
        //    draw_chart(this);
        //});

        // info window can either be a value, formatted HTML, or a chart.
        //console.log(marker);

      if (aMarker.chart_type === undefined) {

        google.maps.event.addListener(marker, 'click', function() {
          this.infowindow.open(googlewayMap, this);
        });

      } else {

        google.maps.event.addListener(marker, 'click', function() {
          var c = chartObject(this);
          this.infowindow.setContent(c);
          this.infowindow.open(googlewayMap, this);
        });
      }


    // the listener is being bound to the mapObject. So, when the infowindow
    // contents are updated, the 'click' listener will need to see the new information
    // ref: http://stackoverflow.com/a/13504662/5977215

    }


    if( aMarker.mouse_over_group ) {

      // TODO: - 'highlight' markers in teh same gorup by setting all the other marker's opacity to
      // 0.1, and all the groups' to 1.0


        marker.content.addEventListener('mouseenter', highlight_marker_groups, false);

          /*
        marker.content.addEventListener('mouseenter', function() {

            console.log(content);

            content.background = "blue";
            marker.content = content.element;

            console.log(content);


          const markers = window[map_id + "googleMarkers" + layer_id];
          //const markers = [...document.querySelectorAll('gmp-advanced-marker')];
          const group = marker.getAttribute("mouseOverGroup");

          for (i = 0; i < markers.length; i++) {
            const thisMarker = markers[i];
            const content = thisMarker.content;

            //console.log(thisMarker.content);
            const thisGroup = thisMarker.getAttribute("mouseOverGroup");
              if(thisGroup == group){
                //console.log("highlight");
                //thisMarker.content.background = "#FF0000"

                thisMarker.pinElement = new google.maps.marker.PinElement({
                  background: "#00FF00"
                })
              } else {
                //console.log("don't highlight");
                //thisMarker.content.background = "#FFFFFF"
              }
          }

        });
          */

    } else if (aMarker.mouse_over) {
        //add_mouseOver(map_id, marker, infoWindow, '_mouse_over', aMarker.mouse_over, layer_id, 'googleMarkers');

        var infoWindow = new google.maps.InfoWindow();

        marker.content.addEventListener('mouseenter', function() {
          infoWindow.setContent(aMarker.mouse_over.toString());
          marker.infowindow = infoWindow;
          marker.infowindow.open(googlewayMap, marker);
        });

        marker.content.addEventListener('mouseleave', function() {
          infoWindow.close();
        });
    }

    markerInfo = {
        layerId : layer_id
    };

    marker_click(map_id, marker, marker.id, markerInfo);
    marker_dragged(map_id, marker, marker.id, markerInfo);
    window[map_id + 'googleMarkers' + layer_id].push(marker);

    //marker.setMap(googlewayMap);
}


function highlight_marker_groups() {

    // `this` is the marker.content on which the listener was assigned
    console.log(this);
    const group = this.getAttribute("mouseOverGroup");
    const map_id = this.getAttribute("mapId");
    const layer_id = this.getAttribute("layerId");

    console.log(group);

    const markers = window[map_id + "googleMarkers" + layer_id];
    console.log(markers);


    for (i = 0; i < markers.length; i++) {
      const thisMarker = markers[i];
      console.log(thisMarker);


      if(thisMarker.mouseOverGroup == group){
        console.log("highlight this one");
          //window[map_id + layerType + layer_id][i].setOptions({Opacity: 1});
      } else {
        console.log("don't highlight this one");
          //window[map_id + layerType + layer_id][i].setOptions({Opacity: 0.01});
      }

    }

}


/**
 * Clear markers
 *
 * clears markes from a google map object
 *
 * @param map_id
 *          the map to clear
 * @param layer_id
 *          the layer to clear
 */
function clear_markers(map_id, layer_id) {
    // the markers know which map they're on
    // http://stackoverflow.com/questions/7961522/removing-a-marker-in-google-maps-api-v3
    clear_object(map_id, 'googleMarkers', layer_id);

    if (window[map_id + 'googleMarkerClusterer' + layer_id]) {
        window[map_id + 'googleMarkerClusterer' + layer_id].clearMarkers();
        window[map_id + 'googleMarkerClusterer' + layer_id] = null;
    }
}


