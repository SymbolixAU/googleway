
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
    },
    markerOptions: {icon: 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png'},
    circleOptions: {
      fillColor: '#ffff00',
      fillOpacity: 1,
      strokeWeight: 5,
      clickable: false,
      editable: true,
      zIndex: 1
    }
  });

  window[map_id + 'googleDrawingManager'] = drawingManager;
  drawingManager.setMap(window[map_id + 'map']);


//  google.maps.event.addListener(drawingManager, 'circlecomplete', function(circle){
//    var radius = circle.getRadius();
//    console.log(radius);
//  });

google.maps.event.addListener(drawingManager, 'overlaycomplete', function(event) {
  if (event.type == 'circle') {
    var radius = event.overlay.getRadius();
    console.log(radius);
    console.log(event);
  }
});

}

function clear_drawing(map_id){
  // TODO:
  // clear all drawn objects
  window[map_id + 'googleDrawingManager'].setMap(null);
}
