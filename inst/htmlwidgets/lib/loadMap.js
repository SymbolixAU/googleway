function loadScript(GOOGLE_MAP_KEY) {
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'https://maps.googleapis.com/maps/api/js?' +
    'key=' + GOOGLE_MAP_KEY + '&callback=initMap';
    document.body.appendChild(script);
}
