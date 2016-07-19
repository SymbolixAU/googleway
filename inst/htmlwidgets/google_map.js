HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        setTimeout(function() {
          var mapDiv = document.getElementById(el.id);
            mapDiv.className = "googlemap";
            var map = new google.maps.Map(mapDiv, {
              center: {lat: x.lat, lng: x.lon},
              zoom: x.zoom
            });

        }, 1000);




        /*
        window.addEventListener('load',function(){
        if(document.getElementById(el.id)){
          google.load("maps", "3",{
            callback:function(){
               new google.maps.Map(document.getElementById(el.id), {
                  center: new google.maps.LatLng(-37,144),
                  zoom: 3
                });
            }
          });
        }
      },false);
      */


      //window.onload = initMap(x.lat, x.lon, x.zoom);

      },
      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }

    };
  }
});


//TODO: try standard HTML code with separate JS functions
