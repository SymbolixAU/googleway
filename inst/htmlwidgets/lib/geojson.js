function add_geojson(map_id, geojson, geojson_source, style, style_type, update_map_view){

  if(geojson_source == "local"){
    window[map_id + 'map'].data.addGeoJson(geojson);
  }else if(geojson_source == "url"){
    console.log("url goejson");
    window[map_id + 'map'].data.loadGeoJson(geojson);
  }

  if(style_type == "individual"){
    // a function that computes the style for each feature
    window[map_id + 'map'].data.setStyle(function(feature){

      return({
        // all
        clickable: feature.getProperty(style.clickable),
        visible: feature.getProperty(style.visible),
        zIndex: feature.getProperty(style.zIndex),
        // point
        cursor: feature.getProperty(style.cursor),
        icon: feature.getProperty(style.icon),
        shape: feature.getProperty(style.shape),
        title: feature.getProperty(style.title),
        // lines
        strokeColor: feature.getProperty(style.strokeColor),
        strokeOpacity: feature.getProperty(style.strokeOpacity),
        strokeWeight: feature.getProperty(style.strokeWeight),
        // polygons
        fillColor: feature.getProperty(style.fillColor),
        fillOpacity: feature.getProperty(style.fillOpacity)
      })
    })

  }else if(style_type == "all"){
    //style each feature wtih the same styleOptions:

    window[map_id + 'map'].data.setStyle({

        clickable: style.clickable,
        visible: style.visible,
        zIndex: style.zIndex,
        // point
        cursor: style.cursor,
        icon: style.icon,
        shape: style.shape,
        title: style.title,
        // lines
        strokeColor: style.strokeColor,
        strokeOpacity: style.strokeOpacity,
        strokeWeight: style.strokeWeight,
        // polygons
        fillColor: style.fillColor,
        fillOpacity: style.fillOpacity

    })
  }


  if(update_map_view === true){
    // TODO: update bounds
  }
}
