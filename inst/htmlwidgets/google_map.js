HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        // TODO: code to render the widget, e.g.
        //el.innerText = x.message;

        function initMap() {
          var mapDiv = document.getElementById('map');
          var map = new google.maps.Map(mapDiv, {
              center: {lat: 44.540, lng: -78.546},
              zoom: 8
          });
        }

      },

      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }

    };
  }
});
