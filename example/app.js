var win = Ti.UI.createWindow();
var maps = require("de.hansknoechel.googlemaps");
maps.setAPIKey("AIzaSyC8XCAFXe_oGrkM0o7God1YNeMApwLFQ3c");

/*
 *  MapView
 */
var mapView = maps.createMapView();
mapView.setMapType(maps.MAP_TYPE_TERRAIN);

/*
 *  Marker
 */
var marker = maps.createMarker({
	latitude : -32.9689,
	longitude : 151.7721,
	title : "Newcastle",
	snippet : "Australia"
});

mapView.addMarker(marker);
// mapView.addMarkers([marker]);
// mapView.removeMarker(marker);

/*
 *  Overlays - Polyline
 */
var polyline = maps.createPolyline({
	points : [{ // Can handle both object and array
		latitude : -37.81319,
		longitude : 144.96298
	}, [-31.95285, 115.85734]],
	strokeWidth : 3,
	strokeColor : "#f00"
});

mapView.addPolyline(polyline);
// mapView.removePolyline(polyline);

/*
 *  Overlays - Polygon
 */
var polygon = maps.createPolygon({
	points : [{ // Can handle both object and array
		latitude : -37.81819,
		longitude : 144.96798
	},
	[-32.95785, 115.86234],
	[-33.91785, 115.82234]],
	strokeWidth : 3,
	fillColor : "yellow",
	strokeColor : "green"
});

mapView.addPolygon(polygon);
// mapView.removePolygon(polygon);

/*
 *  Overlays - Circle
 */
var circle = maps.createCircle({
	center : [-32.9689, 151.7721], // Can handle both object and array
	radius : 500 * 1000, // 500km
	// fillColor: "blue",
	strokeWidth : 3,
	strokeColor : "orange"
});

mapView.addCircle(circle);
// mapView.removeCircle(circle);

win.add(mapView);
win.open();
