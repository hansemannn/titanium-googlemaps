var win = Ti.UI.createWindow();
var maps = require("de.hansknoechel.googlemaps");
maps.setAPIKey("<YOUR_API_KEY>");

/*
 *  MapView
 */
var mapView = maps.createMapView();
mapView.setMapType(maps.MAP_TYPE_TERRAIN);

/*
 * Events
 */

function handleClickEvent(e) {
	Ti.API.warn("\"click\" event fired!");
	Ti.API.warn(e);
}

function handleLongpressEvent(e) {
	Ti.API.warn("\"longpress\" event fired!");
	Ti.API.warn(e);
}

function handlerMarkerClickEvent(e) {
	Ti.API.warn("\"markerclick\" event fired!");
	Ti.API.warn(e);
}

function handleWillMoveEvent(e) {
	Ti.API.warn("\"willmove\" event fired!");
	Ti.API.warn(e);
}

function handleCameraChangeEvent(e) {
	Ti.API.warn("\"camerachange\" event fired!");
	Ti.API.warn(e);
}

function handleIdleEvent(e) {
	Ti.API.warn("\"idle\" event fired!");
	Ti.API.warn(e);
}

function handleMarkerInfoClickEvent(e) {
	Ti.API.warn("\"markerinfoclick\" event fired!");
	Ti.API.warn(e);
}

function handleOverlayClickEvent(e) {
	Ti.API.warn("\"overlayclick\" event fired!");
	Ti.API.warn(e);
}

function handleDragStartEvent(e) {
	Ti.API.warn("\"dragstart\" event fired!");
	Ti.API.warn(e);
}

function handleDragMoveEvent(e) {
	Ti.API.warn("\"dragmove\" event fired!");
	Ti.API.warn(e);
}

function handleDragEndEvent(e) {
	Ti.API.warn("\"dragend\" event fired!");
	Ti.API.warn(e);
}

function handleLocationClickEvent(e) {
	Ti.API.warn("\"locationclick\" event fired!");
	Ti.API.warn(e);
}

mapView.addEventListener("click", handleClickEvent);
mapView.addEventListener("longpress", handleLongpressEvent);
mapView.addEventListener("markerclick", handlerMarkerClickEvent);
mapView.addEventListener("willmove", handleWillMoveEvent);
mapView.addEventListener("camerachange", handleCameraChangeEvent);
mapView.addEventListener("idle", handleIdleEvent);
mapView.addEventListener("markerinfoclick", handleMarkerInfoClickEvent);
mapView.addEventListener("overlayclick", handleOverlayClickEvent);
mapView.addEventListener("dragstart", handleDragStartEvent);
mapView.addEventListener("dragmove", handleDragMoveEvent);
mapView.addEventListener("dragend", handleDragEndEvent);
mapView.addEventListener("locationclick", handleLocationClickEvent);

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
