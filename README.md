# Native GoogleMaps iOS SDK in Appcelerator Titanium 

[![Build Status](https://travis-ci.org/hansemannn/titanium-google-maps.svg?branch=master)](https://travis-ci.org/hansemannn/titanium-google-maps)  [![License](http://hans-knoechel.de/shields/shield-license.svg?v=2)](./LICENSE)  [![Contact](http://hans-knoechel.de/shields/shield-twitter.svg?v=2)](http://twitter.com/hansemannnn)

<img width="1094" src="https://abload.de/img/687474703a2f2f61626c6ymjhw.jpg">

## Summary

Ti.GoogleMaps is an open-source project to support the Google Maps iOS-SDK in Appcelerator's Titanium Mobile. The module currently supports the following API's:

- [x] Map View
- [x] Annotations
- [x] Tile overlay
- [x] Polygon overlay
- [x] Polyline overlay
- [x] Circle overlay
- [x] Autocompletion dialog
- [x] Place Picker dialog
- [x] Clustering
- [x] Directions
- [x] Heatmap Layers
- [x] All delegates (exposed as events)

## Requirements

  - Appcelerator Titanium 6.3.0 or later

## Download, Setup and Build

### Download

  * [Stable release](https://github.com/hansemannn/titanium-googlemaps/releases)
  * [![gitTio](http://hans-knoechel.de/shields/shield-gittio.svg)](http://gitt.io/component/ti.googlemaps)

### Setup

#### Add to your Project

Unpack the module and place it inside the `modules/iphone/` folder of your project.
Edit the modules section of your `tiapp.xml` file to include this module:
```xml
<modules>
    <module platform="iphone">ti.googlemaps</module>
</modules>
```

#### Initialize with your API Key

Initialize the module by setting the Google Maps API key you can get from [here](https://developers.google.com/maps/signup).
```js
var maps = require('ti.googlemaps');
maps.setAPIKey('<YOUR_GOOGLE_MAPS_API_KEY>');
```

#### Use 100 % Cross-Platform with Android

If you want to use this moduel as a replacement for Ti.Map  on iOS, here is how you can have 100 % parity:
1. Create a file called `maps.js` in `app/lib/` (Alloy) or `Resources/` (Classic) with the following content
```js
if (Ti.Platform.osname === 'iphone' || Ti.Platform.osname === 'ipad') {
  module.exports = TiMap = require('ti.googlemaps');
} else {
  module.exports = TiMap = require('ti.map');
}
```
2. In your controllers, import / require the maps instance like before:
```
// ES6+ (recommended)
import TiMap from 'maps'

// ES5
var TiMap = require('maps');
```
3. (optional) You can even use it in Alloy:
```xml
<View module="maps" method="createView" id="mapView" />
```

That's it!

### Build

If you want to build the module from the source, you need to check some things beforehand:
- Set the `TITANIUM_SDK_VERSION` inside the `ios/titanium.xcconfig` file to the Ti.SDK version you want to build with.
- Build the project with `appc run -p ios --build-only`
- Check the [releases tab](https://github.com/hansemannn/titanium-googlemaps/releases) for stable pre-packaged versions of the module

## Features

### Map View

A map view creates the view on which annotations and overlays can be added to. You can see all possible events in the demo app. 
In addition, you can specify one of the following constants to the `mapType` property:
 - `MAP_TYPE_NORMAL`
 - `MAP_TYPE_HYBRID`
 - `MAP_TYPE_SATELLITE`
 - `MAP_TYPE_TERRAIN`
 - `MAP_TYPE_NONE`

```js
var mapView = maps.createView({
    mapType: maps.MAP_TYPE_TERRAIN,
    indoorEnabled: true, // shows indoor capabilities (see "Indoor Navigation" section) 
    indoorPicker: true, // shows the vertical floor level (see "Indoor Navigation" section)
    compassButton: true, // shows the compass (top/right) when bearing is non-zero
    myLocationEnabled: true, // default: false
    myLocationButton: true, // shows the default My location button
    region: { // Camera center of the map
        latitude: 37.368122,
        longitude: -121.913653,
        zoom: 10, // EITHER: Zoom in points
        latitudeDelta: 0.1, longitudeDelta: 0.1, // OR: LAT/LONG-delta
        bearing: 45, // orientation measured in degrees clockwise from north
        viewingAngle: 30 // measured in degrees
    }
});
```

#### Safe Area / iPhone X

The GoogleMaps SDK supports configuring the map-view for the iPhone X. Use the `paddingAdjustmentBehavior` to get
or set the padding-adjustment-behavior and use one of the following constants:
```
/** 1. Always include the safe area insets in the padding. */
PADDING_ADJUSTMENT_BEHAVIOR_ALWAYS

/**
* 2. When the padding value is smaller than the safe area inset for a particular edge, use the safe
* area value for layout, else use padding.
*/
PADDING_ADJUSTMENT_BEHAVIOR_AUTOMATIC

/**
* 3. Never include the safe area insets in the padding. This was the behavior prior to version 2.5.
*/
PADDING_ADJUSTMENT_BEHAVIOR_NEVER
```

#### Map Events

The module supports all native delegates - exposed as events. These are:

- [x] click - Can be an annotation, overlay or info-window. Use `clicksource` to determine.
- [x] mapclick
- [x] locationclick
- [x] longclick
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

#### Map Controls

```js
mapView.indoorEnabled = false;
mapView.indoorPicker = true;
mapView.compassButton = true;
mapView.myLocationEnabled = false;
mapView.myLocationButton = false;
mapView.trafficEnabled = true; // default is false
```

#### Enable / Disable Gestures

```js
mapView.scrollGesture = true;
mapView.zoomGestures = false;
mapView.tiltGestures = true;
mapView.rotateGestures = false;
mapView.allowScrollGesturesDuringRotateOrZoom = false;
```

#### Map Padding

> Note: The `mapInsets` property is deprecated since Ti.GoogleMaps 4.0.0 in favor this property to achieve better
parity with Ti.Map and will be removed in future versions of the module.

```js
mapView.padding = { bottom:200 };
```

#### Map Style

```js
// Either a JSON-string
mapView.mapStyle = 'JSON_STYLE_GOES_HERE';

// Or a JSON-file
mapView.mapStyle = 'mapStyle.json'
```
See [this link](https://developers.google.com/maps/documentation/ios-sdk/hiding-features) for more infos on map styling.

#### Map Location

```
map.location = {
  latitude: 37.368122,
  longitude: -121.913653,
  latitudeDelta: 0.2,
  longitudeDelta: 0.2,
  animate: true
}
```

#### Animations

##### Animate to a location

```js
mapView.animateToLocation({
    latitude: 36.368122,
    longitude: -120.913653
});
```

##### Animate to a zoom level:

```js
mapView.animateToZoom(5);
```

##### Animate to a bearing:

```js
mapView.animateToBearing(45);
```

##### Animate to a viewing angle:

```js
mapView.animateToViewingAngle(30);
```

### Camera Update

You can perform camera updates to your map view instance by creating an instance of the `CameraUpdate` API:
```js
var maps = require('ti.googlemaps');
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

After creating the camera update, you can use it in one of the following methods:
**moveCamera**
```js
mapView.moveCamera(cameraUpdate);
```
**animateWithCameraUpdate**
```js
mapView.animateWithCameraUpdate(cameraUpdate);
```

### Annotations

An annotation represents a location specified by at least a `title` and a `subtitle` property. 
It can be added to a map view:

```js
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
    zIndex: 1,
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

You can get a list of all currently added annotations by using `mapView.annotations`;

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
```js
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
```js
mapView.addAnnotations([anno1,anno2,anno3]);
mapView.removeAnnotation(anno4);
```

Remove Annotations by passing an array of Annotations:
```js
mapView.removeAnnotations([anno1,anno2,anno3]);
```
Remove all annotations (one shot):
```js
mapView.removeAllAnnotations();
```

You can select and deselect annotations, as well as receive the currently selected annotation:
```js
mapView.selectAnnotation(anno1); // Select
mapView.deselectAnnotation(); // Deselect
var selectedAnnotation = mapView.getSelectedAnnotation(); // Selected annotation, null if no annotation is selected
```

### Heatmap Layer
Use heatmaps-layers in your map-views by providing weighted data and designated gradient-colors.

```js
// Import data
var stations = JSON.parse(Ti.Filesystem.getFile('police_stations.json').read());
var data = [];

// Map data to an an array of latitude/longitude/intensity objects
for (var i = 0; i < stations.length; i++) {
  var station = stations[i];

  data.push({
    latitude: station.lat,
    longitude: station.lng,
    intensity: 1.0
  });
}

// Create a new heatmap-layer
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

// Add the layer to your map-view
mapView.addHeatmapLayer(heatmap);
```

### Autocomplete Dialog

A autocomplete dialog can be opened modally to search for places in realtime. A number of events
helps to work with partial results and final selections. 

The whole dialog can be styled (like in the following example) and the default native theming is light.

```js
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

#### Autocomplete Events

- [x] success
- [x] error
- [x] cancel

### Place Picker Dialog

A place picker provides an interface that displays a map to pick places from.

Set the `config` property with viewport-bounds to specify a configuration

```js
var dialog = GoogleMaps.createPlacePickerDialog({
    config: {
        northEast: {
            latitude: 0.0,
            longitude: 0.0
        },
        southWest: {
            latitude: 0.0,
            longitude: 0.0
        }
    }
});

// You need a Google Maps API key from the Google Developer Console
// This is not the same one like your Google Places API key
dialog.configure('<YOUR_GOOGLE_MAPS_API_KEY>');

dialog.open();
```

#### Place Picker Events

- [x] success
- [x] error
- [x] cancel

### Overlays

Overlays can be added to the map view just like annotations. The module supports the methods `addPolygon`, `addPolyline` and `addCircle` to add overlays and `removePolygon`, `removePolyline` and `removeCircle` to remove them.

#### Polyline

A polyline is a shape defined by its `points` property. It needs at least 2 points to draw a line.

```js
var polyline = maps.createPolyline({
    points : [{ // Can handle both object and array
        latitude : -37.81319,
        longitude : 144.96298
    }, [-31.95285, 115.85734]],
    strokeWidth : 3, // Default: 1
    strokeColor : '#f00'  // Default: Black (#000000),
    title: 'My Polyline',
    zIndex: 10
});
mapView.addPolyline(polyline);
```

You can get a list of all currently added polylines by using `mapView.polylines`;

#### Polygon

A polygon is a shape defined by its `points` property. It behaves similiar to a polyline, but is meant to close its area automatically and also supports the `fillColor` property.

```js
var polygon = maps.createPolygon({
    points : [{ // Can handle both object and array
        latitude : -37.81819,
        longitude : 144.96798
    }, [-31.95285, 115.85734]],
    strokeWidth : 3,
    fillColor : 'yellow', // Default: Blue (#0000ff)
    strokeColor : 'green',
    title: 'My Polygon',
    holes: [[{
        latitude: -32.95785,
        longitude: 115.86234
    }, [-32.95785, 115.86234]]]
    zIndex: 10
});
mapView.addPolygon(polygon);
```

You can get a list of all currently added polygons by using `mapView.polygons`;

#### Circle

A circle is a shape defined by the `center` property to specify its location as well as the `radius` in meters.

```js
var circle = maps.createCircle({
    center : [-32.9689, 151.7721], // Can handle object or array
    radius : 500 * 1000, // 500 km, Default: 0
    fillColor: 'blue', // Default: transparent
    strokeWidth : 3,
    strokeColor : 'orange'
    title: 'My Circle',
    zIndex: 10
});
mapView.addCircle(circle);
```

You can get a list of all currently added circles by using `mapView.circles`;

### Clustering

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

To remove cluster-items or clear the whole cluster, use the following methods:
```js
// Remove a single cluster-item
mapView.removeClusterItem(clisterItem);

// Clear the whole cluster
mapView.clearClusterItems();
```

Use the `clusterclick` and `clusteritemclick` events on your map view instance
to receive infos about your current cluster or cluster item.

### Tile Layers

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

### Renderer

Using Ti.GoogleMaps 3.8.0 and later, you are able to render '.geojson' and '.kml' files inside your map
by using the `Renderer` API. In can be instantiated by using the following constructor:
```js
var renderer = map.createRenderer({
    file: 'example.geojson'
    mapView: mapView
});
```
There are two methods `render` and `clear` available:
```js
// Renders the geometries
renderer.render();

// Removes the geometries
renderer.clear();
```

### Reverse Geocoder
Use the reverse geocoder to search a location based on a `latitude` and `longitude`:
```js
maps.reverseGeocoder(36.368122, -120.913653, function(e) {
    alert('Address found!');

    Ti.API.info(e.places);
});
```

### Indoor Navigation

There are a number of special API's to deal with indoor-navigtion in GoogleMaps. Inside a `View` instance,
you can enabled indoor-navigation by setting `indoorEnabled` to `true`. To show the the vertical floor levels
in your map-instance, set `indoorPicker` to `true`. 

To receive the indoor-display, use the `indoorDisplay` getter,
which has the following events to be notified when the indoor-navigation changes:

- [x] `didChangeActiveBuilding` (Raised when the activeBuilding has changed)
  - `defaultLevelIndex` (Array of GMSIndoorLevel describing the levels which make up the building)
  - `isUnderground` (Index in the levels array of the default level)
  - `levels` (If `true`, the building is entirely underground and supports being hidden)

- [x] `didChangeActiveLevel` (Raised when the activeLevel has changed)
  - `name` (Localized display name for the level, e.g. "Ground floor")
  - `shortName` (Localized short display name for the level, e.g. "1")

In addition to the above events, you can also communicate with the indoor-display by receiving the `activeBuilding`
and `activeLevel` properties. Finally, when receiving the floor-level inside the `level` property of the
`didChangeActiveBuilding` event, you can set the `activeLevel` property as well, to change the currently active
floor-level. 

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

## Example
For a full example, check the demos in `example/app.js` and `example/clustering.js`.

## Author
Hans Knöchel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))

## License
Apache 2.0

## Contributing
Code contributions are greatly appreciated, please submit a new [Pull-Request](https://github.com/hansemannn/titanium-google-maps/pull/new/master)!
