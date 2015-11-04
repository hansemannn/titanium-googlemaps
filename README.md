# Ti.GoogleMaps

 Summary
---------------
Ti.GoogleMaps is an open-source project to support the Google Maps SDK for iOS on Appcelerator's Titanium Mobile. The module currently supports the following API's:
  - Map View
  - Marker
  - Polygon overlay
  - Polyline overlay
  - Circle overlay

Requirements
---------------
  - Titanium Mobile SDK 5.0.2.GA or later
  - iOS 7.1 or later
  - Xcode 6.4 or later

Download + Setup
---------------

### Download
  * [Stable release](https://github.com/hansemannn/Ti.GoogleMaps/releases)
  * Install from gitTio    [![gitTio](http://gitt.io/badge.png)](http://gitt.io/component/de.hansknoechel.googlemaps)
  
### Setup
Unpack the module and place it inside the ``/modules/iphone`` folder of your project.
Edit the modules section of your ``tiapp.xml`` file to include this module:
```xml
<modules>
    <module platform="iphone">de.hansknoechel.googlemaps</module>
</modules>
```
Initialize the module by setting the Google Maps API key you can get from [here](https://developers.google.com/maps/signup).
```javascriipt
var maps = require("de.hansknoechel.googlemaps");
maps.setAPIKey("<YOUR_API_KEY>");
```

Features
--------------------------------
#### Map View
A map view creates the view on which marker and overlays can be added to. You can specify one of the following constants to the ``mapType`` property:
 - ``MAP_TYPE_NORMAL``
 - ``MAP_TYPE_HYBRID``
 - ``MAP_TYPE_SATELLITE``
 - ``MAP_TYPE_TERRAIN``
 - ``MAP_TYPE_NONE``
```javascript
var mapView = maps.createMapView({
  mapType: maps.MAP_TYPE_TERRAIN
});
```

#### Marker
A marker represents a location specified by at least a ``title`` and a ``snippet`` property. It can be added to a map view:

```javascript
var marker = maps.createMarker({
	latitude : 37.368122,
	longitude : -121.913653,
	title : "Appcelerator, Inc",
	snippet : "1732 N. 1st Street, San Jose",
	icon: "pin.png", // Default: null
	tappable: true, // Default: true
	draggable: true, // Default: false
	flat: true, // Default: false
	userData: { // Default: null
	    id: 123,
	    custom_key: "custom_value"
	}
});
mapView.addMarker(marker);
```

You also can add multiple markers as well as remove markers again:
```javascript
mapView.addMarkers([marker1,marker2,marker3]);
mapView.removeMarker(marker4);
```

#### Overlays
Overlays can be added to the map view just like markers. The module supports the methods ``addPolygon``, ``addPolyline`` and ``addCircle`` to add overlays and ``removePolygon``, ``removePolyline`` and ``removeCircle`` to remove them.

##### Polyline
A polyline is a shape defined by its ``points`` property. It needs at least 2 points to draw a line.

```javascript
var polyline = maps.createPolyline({
	points : [{ // Can handle both object and array
		latitude : -37.81319,
		longitude : 144.96298
	}, [-31.95285, 115.85734]],
	strokeWidth : 3, // Default: 1
	strokeColor : "#f00"  // Default: Black (#000000)
});
mapView.addPolyline(polyline);
```

##### Polygon
A polygon is a shape defined by its ``points`` property. It behaves similiar to a polyline, but is meant to close its area automatically and also supports the ``fillColor`` property.

```javascript
var polygon = maps.createPolygon({
	points : [{ // Can handle both object and array
		latitude : -37.81819,
		longitude : 144.96798
	},
	[-32.95785, 115.86234],
	[-33.91785, 115.82234]],
	strokeWidth : 3,
	fillColor : "yellow", // Default: Blue (#0000ff)
	strokeColor : "green"
});
mapView.addPolygon(polygon);
```

#### Circle
A circle is a shape defined by the ``center`` property to specify its location as well as the ``radius`` in meters.

```javascript
var circle = maps.createCircle({
	center : [-32.9689, 151.7721], // Can handle object or array
	radius : 500 * 1000, // 500km, Default: 0
	fillColor: "blue", // Default: transparent
	strokeWidth : 3,
	strokeColor : "orange"
});
mapView.addCircle(circle);
````

For a full example, check the demo in ```example/app.js```.

Author
---------------
Hans Knoechel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))

License
---------------
MIT

Contributing
---------------
Code contributions are greatly appriciated, please submit a pull request!



