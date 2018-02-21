# GoogleMaps iOS SDK in Appcelerator Titanium 
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
- [x] Clustering
- [x] Heatmap Layers
- [x] All delegates (exposed as events)

## Requirements
  - Titanium Mobile SDK 5.2.2.GA or later
  - iOS 7.1 or later
  - Xcode 6.4 or later

## Download, Setup and Build

### Download
  * [Stable release](https://github.com/hansemannn/titanium-googlemaps/releases)
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
```js
var maps = require('ti.googlemaps');
maps.setAPIKey('<YOUR_GOOGLE_MAPS_API_KEY>');
```

### Build
If you want to build the module from the source, you need to check some things beforehand:
- Set the `TITANIUM_SDK_VERSION` inside the `ios/titanium.xcconfig` file to the Ti.SDK version you want to build with.
- Ensure you **build** with SDK 6.0.3 or later. Those versions will include [this PR](https://github.com/appcelerator/titanium_mobile/pull/8861) to automatically set the `TI_MODULE_VERSION` when building. If you are building with SDK < 6.0.3, specify the `TI_MODULE_VERSION` manually in the `module.xcconfig`.   
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
        zoom: 10, // Zoom in points
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

- [x] click (map, pin, infoWindow, overlay)
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

#### Map Insets
```js
mapView.mapInsets = { bottom:200 };
```

#### Map Style
```js
// Either a JSON-string
mapView.mapStyle = 'JSON_STYLE_GOES_HERE';

// Or a JSON-file
mapView.mapStyle = 'mapStyle.json'
```
See [this link](https://developers.google.com/maps/documentation/ios-sdk/hiding-features) for more infos on map styling.

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

You can set an info window of the annotation. Note that you have to specify a width / height for subviews,
otherwise the SDK will not set a proper frame for the subview:
```js
var view = Ti.UI.createView({
    backgroundColor: "red",
    width: 200,
    height: 30
});
