
/**
 * Add Drawing
 *
 * Adds drawing controls to the map
 **/
function add_drawing(map_id){

  var drawingManager = new google.maps.drawing.DrawingManager({
    drawingMode: google.maps.drawing.OverlayType.MARKER,
    drawingControl: true,
    drawingControlOptions: {
      position: google.maps.ControlPosition.TOP_CENTER,
      drawingModes: ['marker', 'circle', 'polygon', 'polyline', 'rectangle']
    }
  });

  window[map_id + 'googleDrawingManager'] = drawingManager;
  drawingManager.setMap(window[map_id + 'map']);

  var drawingInfo;

  circle_complete(map_id, drawingManager, drawingInfo);
  rectangle_complete(map_id, drawingManager, drawingInfo);
  polyline_complete(map_id, drawingManager, drawingInfo);
  polygon_complete(map_id, drawingManager, drawingInfo);
}


function circle_complete(map_id, drawingManager, drawingInfo){

  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(drawingManager, 'circlecomplete', function(circle) {

    var eventInfo = $.extend(
      {
        center: circle.getCenter(),
        radius: circle.getRadius(),
        bounds: circle.getBounds(),
        randomValue: Math.random()
      },
      drawingInfo
    );
  Shiny.onInputChange(map_id + "_circlecomplete", eventInfo);
  });
}


function rectangle_complete(map_id, drawingManager, drawingInfo){

  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(drawingManager, 'rectanglecomplete', function(rectangle) {

    var eventInfo = $.extend(
      {
        bounds: rectangle.getBounds(),
        randomValue: Math.random()
      },
      drawingInfo
    );
  Shiny.onInputChange(map_id + "_rectanglecomplete", eventInfo);
  });
}


function polyline_complete(map_id, drawingManager, drawingInfo){

  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(drawingManager, 'polylinecomplete', function(polyline) {

    var eventInfo = $.extend(
      {
        path: polyline.getPath(),
        randomValue: Math.random()
      },
      drawingInfo
    );
  Shiny.onInputChange(map_id + "_polylinecomplete", eventInfo);
  });
}


function polygon_complete(map_id, drawingManager, drawingInfo){

  if(!HTMLWidgets.shinyMode) return;

  google.maps.event.addListener(drawingManager, 'polygoncomplete', function(polygon) {

    var eventInfo = $.extend(
      {
        path: polygon.getPath(),
        paths: polygon.getPaths(),
        randomValue: Math.random()
      },
      drawingInfo
    );
  Shiny.onInputChange(map_id + "_polygoncomplete", eventInfo);
  });
}


//function marker_click(map_id, markerObject, marker_id, markerInfo){
//  if(!HTMLWidgets.shinyMode) return;
//
//  google.maps.event.addListener(markerObject, 'click', function(event){
//
//    var eventInfo = $.extend(
//      {
//        id: marker_id,
//        lat: event.latLng.lat().toFixed(4),
//        lon: event.latLng.lng().toFixed(4),
//        randomValue: Math.random()
//      },
//      markerInfo
//    );
//
//    Shiny.onInputChange(map_id + "_marker_click", eventInfo);
//  });
//}


function clear_drawing(map_id){
  // TODO:
  // clear all drawn objects
  window[map_id + 'googleDrawingManager'].setMap(null);
}
