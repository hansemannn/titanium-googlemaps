var maps = require('ti.googlemaps');
maps.setAPIKey('<YOUR_GOOGLE_MAPS_API_KEY>');

var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});

var btn = Ti.UI.createButton({
    title: 'Get directions!'
});

btn.addEventListener('click', function() {
    maps.getDirections({
        origin: 'Mountain View, CA',
        destination: 'San Francisco, CA',
        success: function(e) {
            Ti.API.info(e.routes);
        },
        error: function(e) {
            Ti.API.error('Error: ' + e.error);
        },
        // Optional
        waypoints: ['Cupertino, CA', 'via:Sunnyvale, CA'],
    });
});

win.add(btn);
win.open();
