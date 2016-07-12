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
        //document.getElementById("map").innerHTML = x.key;
        //el.innerHTML = x.key;
/*
        var script =  document.createElement('script');
        script.type = 'text/javascript';

        script.appendChild(document.createTextNode(x.key));

        document.getElementByID("map").appendChild(script);
      var script = document.createElement('script');
      script.type = 'text/javascript';
      script.src = x.key;
      document.getElementsByTagName('head')[0].appendChild(script);
      */

/*    // working script inside a function loadScript()
      // see google_map.html document
      var script = document.createElement('script');
          script.type = 'text/javascript';
          script.src = 'https://maps.googleapis.com/maps/api/js?' +
              'key=' + x.key +'&callback=initMap';
          document.body.appendChild(script);
*/
//      el.innerHTML = "<script>" + x.key + "</script>";
        el.innerHTML = "<div id='map'></div><script>" + "var GOOGLE_MAP_KEY = " + x.key + "; function loadScript() { var script = document.createElement('script');script.type = 'text/javascript'; script.src = 'https://maps.googleapis.com/maps/api/js?' + 'key=' + GOOGLE_MAP_KEY +'&callback=initMap'; document.body.appendChild(script); } window.onload = loadScript;" + "</script>"
      },

      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }

    };
  }
});
