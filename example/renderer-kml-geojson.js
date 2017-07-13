var maps = require('ti.googlemaps');

/**
 *  SET YOUR API-KEY BEFORE USING THIS MODULE
 */
maps.setAPIKey('<YOUR_GOOGLE_MAPS_API_KEY>');

var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});

var mapView = maps.createView({
    region: {
        latitude: -122.7258301,
        longitude: 38.7791672
    }
});

var btn = Ti.UI.createButton({
    title: 'Render from File!',
    top: 40
});

btn.addEventListener('click', function() {
    /**
     * Pass either a '.geojson' or '.kml' file
     **/
    mapView.renderFromFile('renderer/GeoJSON_Sample.geojson');
});

win.add(mapView);
win.add(btn);
win.open();
