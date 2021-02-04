
/**
 * Add Drawing
 *
 * Adds drawing controls to the map
 **/
function add_drawing (map_id, drawing_modes, marker, circle, rectangle, polyline, polygon, delete_on_change) {

    window[map_id + 'googleDrawingOverlays'] = [];

    //createWindowObject(map_id, 'googleDrawingOverlays', layer_id);

    var drawingInfo,
        drawingManager = new google.maps.drawing.DrawingManager({

            //drawingMode: google.maps.drawing.OverlayType.MARKER,
            //drawingControl: true,

            drawingControlOptions: {
                position: google.maps.ControlPosition.TOP_RIGHT,
                drawingModes: drawing_modes
            },

            markerOptions: {
                icon: marker[0].icon
            },

            circleOptions: {
                fillColor: circle[0].fill_colour,
                fillOpacity: circle[0].fill_opacity,
                strokeWeight: circle[0].stroke_weigth,
                clickable: false,
                editable: true,
                zIndex: circle[0].z_index
            },

            polylineOptions: {
                geodesic: polyline[0].geodesic,
                strokeColor: polyline[0].stroke_colour,
                strokeWeight: polyline[0].stroke_weight,
                strokeOpacity: polyline[0].stroke_opacity,
                zIndex: polyline[0].z_index
            },

            polygonOptions: {
                strokeColor: polygon[0].stroke_colour,
                strokeWeight: polygon[0].stroke_weight,
                strokeOpacity: polygon[0].stroke_opacity,
                fillColor: polygon[0].fill_colour,
                fillOpacity: polygon[0].fill_opacity,
                zIndex: polygon[0].z_index
            },

            rectangleOptions: {
                strokeColor: rectangle[0].stroke_colour,
                strokeWeight: rectangle[0].stroke_weight,
                strokeOpacity: rectangle[0].stroke_opacity,
                fillColor: rectangle[0].fill_colour,
                fillOpacity: rectangle[0].fill_opacity,
                zIndex: rectangle[0].z_index
            }
        });

    window[map_id + 'googleDrawingManager'] = drawingManager;
    drawingManager.setMap(window[map_id + 'map']);

    marker_complete(map_id, drawingManager, drawingInfo);
    circle_complete(map_id, drawingManager, drawingInfo);
    rectangle_complete(map_id, drawingManager, drawingInfo);
    polyline_complete(map_id, drawingManager, drawingInfo);
    polygon_complete(map_id, drawingManager, drawingInfo);

   if(delete_on_change){
        google.maps.event.addListener(drawingManager, "drawingmode_changed", function(){
            clear_drawing(map_id);
        });
   }
}

/**
 * Clear Drawing
 *
 * Clears all the drawn elements from the map
 **/
function clear_drawing (map_id) {

    for (var i = 0; i < window[map_id + 'googleDrawingOverlays'].length; i++) {
        window[map_id + 'googleDrawingOverlays'][i].setMap(null);
    }
    window[map_id + 'googleDrawingOverlays'] = [];
}

function marker_complete (map_id, drawingManager, drawingInfo) {

    if(!HTMLWidgets.shinyMode) return;

    google.maps.event.addListener(drawingManager, 'markercomplete', function(marker) {
        window[map_id + 'googleDrawingOverlays'].push(marker);

        var eventInfo = $.extend(
            {
//        var eventInfo = {
                place: marker.getPlace(),
                position: marker.getPosition(),
                shape: marker.getShape(),
                title: marker.getTitle(),
                randomValue: Math.random()
            },
            drawingInfo
        );

        var event_return_type = window.googleway.params[1].event_return_type;
        eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
        Shiny.onInputChange(map_id + "_markercomplete", eventInfo);
    });
}


function circle_complete (map_id, drawingManager, drawingInfo) {

    if(!HTMLWidgets.shinyMode) return;

    google.maps.event.addListener(drawingManager, 'circlecomplete', function(circle) {

    var newShape = circle;
    google.maps.event.addListener(newShape, 'click', function(){
        //console.log('click');
    });

    window[map_id + 'googleDrawingOverlays'].push(circle);

    var eventInfo = $.extend(
        {
            center: circle.getCenter(),
            radius: circle.getRadius(),
            bounds: circle.getBounds(),
            randomValue: Math.random()
        },
        drawingInfo
    );
    var event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_circlecomplete", eventInfo);
    });
}


function rectangle_complete(map_id, drawingManager, drawingInfo){

  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(drawingManager, 'rectanglecomplete', function(rectangle) {
    window[map_id + 'googleDrawingOverlays'].push(rectangle);

    var eventInfo = $.extend(
      {
        bounds: rectangle.getBounds(),
        randomValue: Math.random()
      },
      drawingInfo
    );
    var event_return_type = window.googleway.params[1].event_return_type;
    eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
    Shiny.onInputChange(map_id + "_rectanglecomplete", eventInfo);
  });
}


function polyline_complete(map_id, drawingManager, drawingInfo){

  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(drawingManager, 'polylinecomplete', function(polyline) {
    window[map_id + 'googleDrawingOverlays'].push(polyline);

    var eventInfo = $.extend(
      {
        path: polyline.getPath(),
        encodedPath: google.maps.geometry.encoding.encodePath(polyline.getPath()),
        randomValue: Math.random()
      },
      drawingInfo
    );
          var event_return_type = window.googleway.params[1].event_return_type;
      eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
  Shiny.onInputChange(map_id + "_polylinecomplete", eventInfo);
  });
}


function polygon_complete(map_id, drawingManager, drawingInfo){

  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(drawingManager, 'polygoncomplete', function(polygon) {
    window[map_id + 'googleDrawingOverlays'].push(polygon);

    var eventInfo = $.extend(
      {
        path: polygon.getPath(),
        encodedPath: google.maps.geometry.encoding.encodePath(polygon.getPath()),
        randomValue: Math.random()
      },
      drawingInfo
    );
          var event_return_type = window.googleway.params[1].event_return_type;
      eventInfo = event_return_type === "list" ? eventInfo : JSON.stringify(eventInfo);
  Shiny.onInputChange(map_id + "_polygoncomplete", eventInfo);
  });
}

/**
 * Remove drawing
 *
 * Removes the drawing controls from the map
 **/
function remove_drawing(map_id){
    window[map_id + 'googleDrawingManager'].setMap(null);
}
