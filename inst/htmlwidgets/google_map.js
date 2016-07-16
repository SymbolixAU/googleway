HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

      //el.innerHTML = "<script>initMap();</script>"
      //el.innerHTML = "<div id='map'></div><script>initMap();</script>"

      //<script>window.onload = loadScript('" + x.key + "');</script>"
      },
      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }

    };
  }
});


//TODO: try standard HTML code with separate JS functions
