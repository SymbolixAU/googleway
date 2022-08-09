
// TODO:
// - accept URL for MWS
// - change the 'Map' button / add a 'new button'
function add_image_map_type(map_id) {

  const imageMapType = new google.maps.ImageMapType({
    getTileUrl: function (coord, zoom) {

     var url = 'https://base.maps.vic.gov.au/wmts/CARTO_WM_256/EPSG:3857:256/' + zoom + '/' + coord.x + '/' + coord.y +'.png'
            return(url);
    },
    tileSize: new google.maps.Size(256, 256),
    maxZoom: 20,
    minZoom: 6,
    name: "Vicmap"
  });

  window[map_id + 'map'].setOptions({
    mapTypeControlOptions: { mapTypeIds: ["image","satellite"]}
  });

  window[map_id + 'map'].mapTypes.set("image", imageMapType);
  window[map_id + 'map'].setMapTypeId("image");

}
