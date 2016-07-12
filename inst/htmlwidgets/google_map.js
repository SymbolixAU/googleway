HTMLWidgets.widget({

  name: 'google_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        // TODO: code to render the widget, e.g.
        //el.innerText = x.message;

        // mutate the DOM to include the <script> google api call </script>
        var map_el = document.getElementById("map_script");
        map_el.content = x.key;
        //document.getElementById("map_script").innerHTML = x.key;
        //el.innerHTML = x.key;


      },

      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }

    };
  }
});
