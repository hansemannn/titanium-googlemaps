/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"
#import "TiGooglemapsMapView.h"
#import "TiGooglemapsMarkerProxy.h"

@interface TiGooglemapsMapViewProxy : TiViewProxy<GMSMapViewDelegate> {
    TiGooglemapsMapViewProxy* mapView;
    NSMutableArray *markers;
    NSMutableArray *overlays;
}


/**
 *  An array of marker proxies.
 *
 *  @return The proxies
 *  @since 2.1.0
 */
-(NSMutableArray*)markers;

/**
 *  An array of overlay proxies.
 *
 *  @return The proxies
 *  @since 2.1.0
 */
-(NSMutableArray*)overlays;

/**
 *  Adds an annotation.
 *
 *  @param args The annotation.
 *  @since 2.2.0
 */
-(void)addAnnotation:(id)args;

/**
 *  Adds multiple annotations.
 *
 *  @param args The annotations.
 *  @since 2.2.0
 */
-(void)addAnnotations:(id)args;

/**
 *  Set multiple annotations.
 *
 *  @param args The annotations.
 *  @since 2.2.0
 */
-(void)setAnnotations:(id)args;

/**
 *  Remove an annotation.
 *
 *  @param args The annotation.
 *  @since 2.2.0
 */
-(void)removeAnnotation:(id)args;

/**
 *  Adds a marker.
 *
 *  @param args The marker.
 *  @deprecated 2.2.0
 *  @since 1.0.0
 */
-(void)addMarker:(id)args __attribute((deprecated("Use addAnnotation instead.")));

/**
 *  Adds multiple markers.
 *
 *  @param args The array of markers.
 *  @deprecated 2.2.0
 *  @since 1.0.0
 */
-(void)addMarkers:(id)args __attribute((deprecated("Use addAnnotations instead.")));

/**
 *  Removes a marker.
 *
 *  @param args The marker proxy.
 *  @deprecated 2.2.0
 *  @since 1.0.0
 */
-(void)removeMarker:(id)args __attribute((deprecated("Use removeAnnotation instead.")));

/**
 *  Adds a polyline.
 *
 *  @param args The polyline proxy.
 *  @since 1.0.0
 */
-(void)addPolyline:(id)args;

/**
 *  Removes a polyline.
 *
 *  @param args The polyline proxy.
 *  @since 1.0.0
 */
-(void)removePolyline:(id)args;

/**
 *  Adds a polygon.
 *
 *  @param args The polygon proxy.
 *  @since 1.0.0
 */
-(void)addPolygon:(id)args;

/**
 *  Removes a polygon.
 *
 *  @param args The polygon proxy.
 *  @since 1.0.0
 */
-(void)removePolygon:(id)args;

/**
 *  Adds a circle.
 *
 *  @param args The circle proxy.
 *  @since 1.0.0
 */
-(void)addCircle:(id)args;

/**
 *  Removes a circle.
 *
 *  @param args The circle proxy.
 *  @since 1.0.0
 */
-(void)removeCircle:(id)args;

/**
 *  Animates to a location.
 *
 *  @param args The location to animate to.
 *  @since 2.1.0
 */
-(void)animateToLocation:(id)args;

/**
 *  Animates to a zoom level.
 *
 *  @param value The location to zoom to.
 *  @since 2.1.0
 */
-(void)animateToZoom:(id)value;

/**
 *  Animates to a bearing.
 *
 *  @param value The bearing value.
 *  @since 2.1.0
 */
-(void)animateToBearing:(id)value;

/**
 *  Animates to a viewing angle.
 *
 *  @param value The angle to animate to.
 *  @since 2.1.0
 */
-(void)animateToViewingAngle:(id)value;

/**
 *  Returns the currently selected marker.
 *
 *  @return The selected marker.
 *  @since 2.1.0
 */
-(id)getSelectedMarker:(id)unused;

/**
 *  Selects a marker.
 *
 *  @param args The marker proxy.
 *  @since 2.1.0
 */
-(void)selectMarker:(id)unused;

/**
 *  Deselects a marker.
 *
 *  @param args The marker proxy.
 *  @since 2.1.0
 */
-(void)deselectMarker:(id)args;

@end
