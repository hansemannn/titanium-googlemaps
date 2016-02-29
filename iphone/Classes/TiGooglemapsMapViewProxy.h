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
}

/**
 *  Adds a marker.
 *
 *  @param args The marker.
 *  @since 1.0.0
 */
-(void)addMarker:(id)args;

/**
 *  Adds multiple markers.
 *
 *  @param args The array of markers.
 *  @since 1.0.0
 */
-(void)addMarkers:(id)args;

/**
 *  Removes a marker.
 *
 *  @param args The marker proxy.
 *  @since 1.0.0
 */
-(void)removeMarker:(id)args;

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
-(id)selectedMarker:(id)unused;

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
