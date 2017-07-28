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
        latitude: 37.368122,
        longitude: -121.913653
    }
});

var tile = maps.createTile({
    url: 'http://c.tile.openstreetmap.org/{z}/{x}/{y}.png'
});

var btn1 = Ti.UI.createButton({
    title: 'Add Tile!',
    top: 40,
    left: 30
});

var btn2 = Ti.UI.createButton({
    title: 'Remove Tile!',
    top: 40,
    right: 30
});

btn1.addEventListener('click', function() {
    mapView.addTile(tile);
});

btn2.addEventListener('click', function() {
    mapView.removeTile(tile);
});

win.add(mapView);
win.add(btn1);
win.add(btn2);
win.open();
