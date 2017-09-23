var maps = require('ti.googlemaps');
maps.setAPIKey('<YOUR_GOOGLE_MAPS_API_KEY>');

var win = Ti.UI.createWindow({
    title: 'Ti.GoogleMaps',
    includeOpaqueBars: true,
    extendEdges: [Ti.UI.EXTEND_EDGE_ALL]
});

var stations = JSON.parse(Ti.Filesystem.getFile('police_stations.json').read());
var data = [];

for (var i = 0; i < stations.length; i++) {
  var station = stations[i];

  data.push({
    latitude: station.lat,
    longitude: station.lng,
    intensity: 1.0
  });
}

var location = {
    latitude: -37.813628,
    longitude: 144.963058
};

var nav = Ti.UI.iOS.createNavigationWindow({
    window: win
});

var mapView = maps.createView({
    region: {
        latitude: location.latitude,
        longitude: location.longitude,
        zoom: 10
    }
});

var heatmap = maps.createHeatmapLayer({
  weightedData: data,
  radius: 80,
  opacity: 0.8,
  gradient: {
    colors: ['green', 'red'],
    startPoints: [0.2, 1.0],
    colorMapSize: 256
  }
});

mapView.addHeatmapLayer(heatmap);

win.add(mapView);
nav.open();
