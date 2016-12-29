
var maps = require("ti.googlemaps");

/**
 *  SET YOUR API-KEY BEFORE USING THIS MODULE
 */
maps.setAPIKey("<YOUR_GOOGLE_MAPS_API_KEY>");

var win = Ti.UI.createWindow({
    title: "Ti.GoogleMaps",
    includeOpaqueBars: true,
    extendEdges: [Ti.UI.EXTEND_EDGE_ALL]
});

var nav = Ti.UI.iOS.createNavigationWindow({
    window: win
});

/*
 *  Test data
 */
var location = {
    latitude: 37.368122,
    longitude: -121.913653
};

/*
 *  MapView
 */
var mapView = maps.createView({
    region: {
        latitude: location.latitude,
        longitude: location.longitude
    }
});

var extent = 1;
var count = 10000;
var items = [];

for (var i = 0; i < count; ++i) {
    var clusterItem = maps.createClusterItem({
        latitude: getRandomInRange(37,38, 4),
        longitude: getRandomInRange(-120,-122, 4),
        title: 'Annotation ' + i 
    });
    
    items.push(clusterItem);
}

mapView.addClusterItems(items);
mapView.cluster();

win.add(mapView);
nav.open();

function getRandomInRange(from, to, fixed) {
    return (Math.random() * (to - from) + from).toFixed(fixed) * 1;
}
