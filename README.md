# GoogleMaps iOS SDK in Appcelerator Titanium
[![Build Status](https://travis-ci.org/hansemannn/titanium-google-maps.svg?branch=master)](https://travis-ci.org/hansemannn/titanium-google-maps)  [![License](http://hans-knoechel.de/shields/shield-license.svg?v=2)](./LICENSE)  [![Contact](http://hans-knoechel.de/shields/shield-twitter.svg?v=2)](http://twitter.com/hansemannnn)

<img width="1094" src="http://abload.de/img/showcase3vron.png">

 Summary
---------------
Ti.GoogleMaps is an open-source project to support the Google Maps iOS-SDK in Appcelerator's Titanium Mobile. The module currently supports the following API's:
- [x] Map View
- [x] Annotations
- [x] Tile overlay
- [x] Polygon overlay
- [x] Polyline overlay
- [x] Circle overlay
- [x] Autocompletion dialog
- [x] Clustering
- [x] Directions
- [x] All delegates (exposed as events)

Requirements
---------------
  - Titanium Mobile SDK 5.2.2.GA or later
  - iOS 7.1 or later
  - Xcode 6.4 or later

Download + Setup
---------------

### Download
  * [Stable release](https://github.com/hansemannn/Ti.GoogleMaps/releases)
  * [![gitTio](http://hans-knoechel.de/shields/shield-gittio.svg)](http://gitt.io/component/ti.googlemaps)

### Setup
Unpack the module and place it inside the `modules/iphone/` folder of your project.
Edit the modules section of your `tiapp.xml` file to include this module:
```xml
<modules>
    <module platform="iphone">ti.googlemaps</module>
</modules>
```

Initialize the module by setting the Google Maps API key you can get from [here](https://developers.google.com/maps/signup).
```javascript
var maps = require('ti.googlemaps');
maps.setAPIKey('<YOUR_GOOGLE_MAPS_API_KEY>');
```

### Build
If you want to build the module from the source, you need to check some things beforehand:
- Set the `TITANIUM_SDK_VERSION` inside the `ios/titanium.xcconfig` file to the Ti.SDK version you want to build with.
- Ensure you **build** with SDK 6.0.3 or later. Those versions will include [this PR](https://github.com/appcelerator/titanium_mobile/pull/8861) to automatically set the `TI_MODULE_VERSION` when building. If you are building with SDK < 6.0.3, specify the `TI_MODULE_VERSION` manually in the `module.xcconfig`.   
- Build the project with `appc run -p ios --build-only`
- Check the [releases tab](https://github.com/hansemannn/ti.googlemaps/releases) for stable pre-packaged versions of the module

Features
--------------------------------
#### Map View
A map view creates the view on which annotations and overlays can be added to. You can see all possible events in the demo app.
In addition, you can specify one of the following constants to the `mapType` property:
 - `MAP_TYPE_NORMAL`
 - `MAP_TYPE_HYBRID`
 - `MAP_TYPE_SATELLITE`
 - `MAP_TYPE_TERRAIN`
 - `MAP_TYPE_NONE`

```javascript
var mapView = maps.createView({
    mapType: maps.MAP_TYPE_TERRAIN,
    indoorEnabled: true, // shows indoor polygons of mapped indoor venues
    indoorPicker: true, // shows the vertical floor level
    compassButton: true, // shows the compass (top/right) when bearing is non-zero
    myLocationEnabled: true, // default: false
    myLocationButton: true, // shows the default My location button
    region: { // Camera center of the map
        latitude: 37.368122,
        longitude: -121.913653,
        zoom: 10, // Zoom in points
        bearing: 45, // orientation measured in degrees clockwise from north
        viewingAngle: 30 // measured in degrees
    }
});
```

Map Events:
The module supports all native delegates - exposed as events. These are:

- [x] click (map, pin, infoWindow, overlay)
- [x] locationclick
- [x] longpress
- [x] regionchanged
- [x] regionwillchange
- [x] idle
- [x] dragstart
- [x] dragmove
- [x] dragend
- [x] complete

> Note: For annotations, the latitude, longitude and userData is returned, not the whole annotation proxy to keep the
> performance at it's best. If you want to identify an annotation, either use the generated UUID string in the `userData`
> or set an own key in the `userData` property of your annotation.

Map Controls:
```javascript
mapView.indoorEnabled = false;
mapView.indoorPicker = true;
mapView.compassButton = true;
mapView.myLocationEnabled = false;
mapView.myLocationButton = false;
mapView.trafficEnabled = true; // default is false
```

Enable/Disable Gestures:
```javascript
mapView.scrollGesture = true;
mapView.zoomGestures = false;
mapView.tiltGestures = true;
mapView.rotateGestures = false;
mapView.allowScrollGesturesDuringRotateOrZoom = false;
```

Map Insets:
```javascript
mapView.mapInsets = { bottom:200 };
```

Map Style:
```javascript
mapView.mapStyle = 'JSON_STYLE_GOES_HERE';
```
See [this link](https://developers.google.com/maps/documentation/ios-sdk/hiding-features) for more infos on map styling.

Animate to a location:
```javascript
mapView.animateToLocation({
    latitude: 36.368122,
    longitude: -120.913653
});
```

Animate to a zoom level:
```javascript
mapView.animateToZoom(5);
```

Animate to a bearing:
```javascript
mapView.animateToBearing(45);
```

Animate to a viewing angle:
```javascript
mapView.animateToViewingAngle(30);
```

#### Camera Update
You can perform camera updates to your map view instance by creating an instance of the `CameraUpdate` API:
```js
var cameraUpdate = maps.createCameraUpdate();
```
Before you can use the camera update, you must specify one of this actions:
- [x] **zoomIn**
```js
cameraUpdate.zoomIn();
```
- [x] **zoomOut**
```js
cameraUpdate.zoomOut();
```
- [x] **zoom**
```js
// The second parameter is optional
cameraUpdate.zoom(4, {
    x: 100,
    y: 100
});
```
- [x] **setTarget**
```js
cameraUpdate.setTarget({
    latitude: 10.0,
    longitude: 10.0,
    zoom: 4 // optional
});
```
- [x] **setCamera**
```js
cameraUpdate.setTarget({
    latitude: 10.0,
    longitude: 10.0,
    zoom: 4,
    bearing: 1,
    viewingAngle: 45
});
```
- [x] **fitBounds**
```js
cameraUpdate.fitBounds({
    // IMPORTANT: Use either `padding` or `insets`, not both together
    padding: 20,
    insets: {top: 10, left: 10, bottom: 10, right: 10},
    bounds: {
        coordinate1: {
            latitude: 10.0,
            longitude: 10.0
        },
        coordinate2: {
            latitude: 12.0,
            longitude: 12.0
        }
    }
});`
```
- [x] **scrollBy**
```js
cameraUpdate.scrollBy({
    x: 100,
    y: 100
});
```
-
After creating the camera update, you can use it in one of the following methods:
**moveCamera**
```js
mapView.moveCamera(cameraUpdate);
```
**animateWithCameraUpdate**
```js
mapView.animateWithCameraUpdate(cameraUpdate);
```

#### Annotations
An annotation represents a location specified by at least a `title` and a `subtitle` property.
It can be added to a map view:

```javascript
var annotation = maps.createAnnotation({
    latitude : 37.368122,
    longitude : -121.913653,
    title : 'Appcelerator, Inc',
    subtitle : '1732 N. 1st Street, San Jose',
    pinColor: 'green',
    image: 'pin.png',
    touchEnabled: true, // Default: true
    draggable: true, // Default: false
    flat: true, // Default: false
    opacity: 1,
    animationStyle: maps.APPEAR_ANIMATION_POP, // One of 'APPEAR_ANIMATION_NONE' (default) and 'APPEAR_ANIMATION_POP'
    rotation: 30, // measured in degrees clockwise from the default position
    centerOffset: {
        x: 0.5,
        y: 0
    },
    groundOffset: {
        x: 0.5,
        y: 0
    },
    userData: {
        id: 123,
        custom_key: 'custom_value'
    }
});
mapView.addAnnotation(annotation);
```

You can set an info window of the annotation. Note that you have to specify a width / height for subviews,
otherwise the SDK will not set a proper frame for the subview:
```js
var view = Ti.UI.createView({
    backgroundColor: "red",
    width: 200,
    height: 30
});

var label = Ti.UI.createLabel({
    text: key,
    width: 200,
    height: 30,
    color: '#fff',
    textAlign: 'center'
});

view.add(label);

var annotation = maps.createAnnotation({
    latitude: 37.4748624,
    longitude: -122.1490817
    infoWindow: view
});
```

You can update the location of an Annotation by using:
```javascript
annotation.updateLocation({
    // Required
    latitude: 36.368122,
    longitude: -125.913653,

    // Optional
    animated: true,
    duration: 1000 // in MS, default: 2000
    opacity: 0.5,
    rotation: 30 // in degrees, clockwise from the default position
});
```

Since Ti.GoogleMaps 3.5.0, you can also set a custom view. Please note that you need to specify a valid size (width/height)
for each view-child of this properly, otherwise the view will not be visible. Example:
```js
var maps = require("ti.googlemaps");
maps.setAPIKey('<api-key>');
var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});

var mapView = maps.createView({
    region: { // Camera center of the map
        latitude: 37.368122,
        longitude: -121.913653
    }
});

var label = Ti.UI.createLabel({
    text: 'Ti',
    width: Ti.UI.FILL, height: Ti.UI.FILL
});

var view = Ti.UI.createView({
    backgroundColor: 'red',
    width: 30, height: 30
});

view.add(label);

var annotation = maps.createAnnotation({
    latitude: 37.368122,
    longitude: -121.913653,
    title: 'Appcelerator, Inc',
    customView: view
});

mapView.addAnnotation(annotation);

win.add(mapView);
win.open();
```

You also can add multiple annotations as well as remove annotations again:
```javascript
mapView.addAnnotations([anno1,anno2,anno3]);
mapView.removeAnnotation(anno4);
```

Remove Annotations by passing an array of Annotations:
```javascript
mapView.removeAnnotations([anno1,anno2,anno3]);
```
Remove all annotations (one shot):
```javascript
mapView.removeAllAnnotations();
```

You can select and deselect annotations, as well as receive the currently selected annotation:
```javascript
mapView.selectAnnotation(anno1); // Select
mapView.deselectAnnotation(); // Deselect
var selectedAnnotation = mapView.getSelectedAnnotation(); // Selected annotation, null if no annotation is selected
```

#### Autocomplete Dialog
A autocomplete dialog can be opened modally to search for places in realtime. A number of events
helps to work with partial results and final selections.

The whole dialog can be styled (like in the following example) and the default native theming is light.

```javascript
var dialog = GoogleMaps.createAutocompleteDialog({
    tableCellBackgroundColor: '#333',
    tableCellSeparatorColor: '#444',
    primaryTextColor: '#fff',
    primaryTextHighlightColor: 'blue',
    tintColor: 'blue'
});

// You need a Google Places API key from the Google Developer Console
// This is not the same one like your Google Maps API key
dialog.configure('<YOUR_GOOGLE_PLACES_API_KEY>');

dialog.open();
```

##### Autocomplete Events
- [x] success
- [x] error
- [x] cancel

#### Overlays
Overlays can be added to the map view just like annotations. The module supports the methods `addPolygon`, `addPolyline` and `addCircle` to add overlays and `removePolygon`, `removePolyline` and `removeCircle` to remove them.

##### Polyline
A polyline is a shape defined by its `points` property. It needs at least 2 points to draw a line. You can optionally define a dashed or dotted polyline stroke.

```javascript
var polyline = maps.createPolyline({
    points : [{ // Can handle both object and array
        latitude : -37.81319,
        longitude : 144.96298
    }, [-31.95285, 115.85734]],
    strokeWidth : 3, // Default: 1
    strokeColor : '#f00',  // Default: Black (#000000)
    pattern: {
	type: Map.POLYLINE_PATTERN_DASHED, // or Map.POLYLINE_PATTERN_DOTTED
	dashLength: 15,
	gapLength: 10
    }
});
mapView.addPolyline(polyline);
```
When `pattern.type` property is set to `Map.POLYLINE_PATTERN_DOTTED`, `dashLenght` and `gapLength` are ignored and the property `strokeWidth` will be used to determine the dot sizes.

##### Polygon
A polygon is a shape defined by its `points` property. It behaves similiar to a polyline, but is meant to close its area automatically and also supports the `fillColor` property.

```javascript
var polygon = maps.createPolygon({
    points : [{ // Can handle both object and array
        latitude : -37.81819,
        longitude : 144.96798
    },
    [-32.95785, 115.86234],
    [-33.91785, 115.82234]],
    strokeWidth : 3,
    fillColor : 'yellow', // Default: Blue (#0000ff)
    strokeColor : 'green'
});
mapView.addPolygon(polygon);
```

##### Circle
A circle is a shape defined by the `center` property to specify its location as well as the `radius` in meters.

```javascript
var circle = maps.createCircle({
    center : [-32.9689, 151.7721], // Can handle object or array
    radius : 500 * 1000, // 500 km, Default: 0
    fillColor: 'blue', // Default: transparent
    strokeWidth : 3,
    strokeColor : 'orange'
});
mapView.addCircle(circle);
```

#### Clustering
You can cluster multiple items by using the Clustering API.

First, create a few cluster items using the `ClusterItem`:
```js
var items = [];

var clusterItem = maps.createClusterItem({
    // Required
    latitude: 37.368122,
    longitude: -121.913653,

    // Optional - for now only this three properties available
    title: 'My Annotation',
    subtitle: 'Hello World!',
    icon: 'marker.png' // either a String, Ti.Blob or Ti.File
});

// Create some more items here ...

items.push(clusterItem);
```
Then add the cluster items to a map:
```js
mapView.addClusterItems(items);
```
Finally, call `cluster()` to generate a new cluster:
```js
mapView.cluster();
```
You are all set! Optionally, you can also set your own cluster ranges and define custom
images for each cluster range in your `mapView` instance:
```js
var mapView = maps.createView({
    clusterRanges: [10, 50, 100, 200, 500],
    clusterBackgrounds: [
        'buckets/m1.png',
        'buckets/m2.png',
        'buckets/m3.png',
        'buckets/m4.png',
        'buckets/m5.png'
    ],
    region: {
        latitude: 37.368122,
        longitude: -121.913653,
    }
});
```

Use the `clusterclick` and `clusteritemclick` events on your map view instance
to receive infos about your current cluster or cluster item.


#### Tile Layers

You can create URL-based tile layers that use the x / y / z (zoom level) pattern to determine the location pattern:
```js
var tile = maps.createTile({
    // Required
	// z is for zoom level
    url: "http://c.tile.openstreetmap.org/{z}/{x}/{y}.png",

    // Optional
    userAgent: "Titanium rocks!",
    zIndex: 100,
    size: 200,
    opacity: 1,
    fadeIn: true
});

// Clear previous tile cache from this URL
tile.clearTileCache();

// Add tile
mapView.addTile(tile);

// Remove tile
mapView.removeTile(tile);
```
You can also request a tile image for a specified x/y/zoom position:
```js
var tile = maps.createTile({
    url: "http://c.tile.openstreetmap.org/{z}/{x}/{y}.png",
});

tile.addEventListener('receivetile', function(e) {
    Ti.API.info('Received new tile at ' + e.tile.x + 'x' + e.tile.y);
    Ti.API.info(e);

    // Add tile image to a view or process it somewhere else
    // win.add(Ti.UI.createImageView({image: e.tile.image}));
});

tile.requestTile({
    x: 200,
    y: 200,
    zoom: 3
});
```

For more information on Tile Layers: https://developers.google.com/maps/documentation/ios-sdk/tiles

In future releases you will also be able to specify local images, but that is not scheduled so far.

### Reverse Geocoder
Use the reverse geocoder to search a location based on a `latitude` and `longitude`:
```js
maps.reverseGeocoder(36.368122, -120.913653, function(e) {
    alert('Address found!');

    Ti.API.info(e.places);
});
```

### Directions
Use the Directions API to calculate advanced directions:
```js
maps.getDirections({
    origin: 'Mountain View, CA',
    destination: 'San Francisco, CA',
    success: function(e) {
        Ti.API.info(e.routes);
    },
    error: function(e) {
        Ti.API.error('Error: ' + e.error);
    },
    waypoints: ['Cupertino, CA', 'via:Sunnyvale, CA'] // Optional
});
```
The polyline points will be received encoded:
```js
"polyline": {
    "points": "a}dcF~nchVPLXLHQhAsCDKzAyDPe@fAqC`@aAh@sARc@pCoHJUj@yAj@{AL]`@cAd@iAbAiCnC_HjAsCvAqDL_@l@mB`@sA^kAJ[h@aBPi@DSJWDMHSFS@GXaABIBI\\eAHW?ATy@HSPo@"
}
```
To decode the polyline points, use the `maps.decodePolylinePoints(points)` utility method or [this utility](https://github.com/mapbox/polyline).

Note that this is not officially supported in the Google Maps iOS SDK. It has been exposed
by using the REST-API in combination with the `NSURLSession` API and the provided API key.

### Google License Info
Google requires you to link the Open Source license somewhere in your app.
Use the following API to receive the Google Maps license:

```js
var license = maps.getOpenSourceLicenseInfo()
```

Example
---------------
For a full example, check the demos in `example/app.js` and `example/clustering.js`.

Author
---------------
Hans Knoechel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))

License
---------------
Apache 2.0

Contributing
---------------
Code contributions are greatly appreciated, please submit a new [pull request](https://github.com/hansemannn/ti.googlemaps/pull/new/master)!
