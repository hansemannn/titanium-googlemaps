/**
 * Ti.GoogleMaps
 * Copyright (c) 2009-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import <GoogleMaps/GoogleMaps.h>

@interface TiGooglemapsCameraUpdateProxy : TiProxy {
    GMSCameraUpdate *cameraUpdate;
}

- (GMSCameraUpdate *)cameraUpdate;

/**
 * Zooms into the map.
 *
 *  @since 2.7.0
 */
- (void)zoomIn:(id)unused;

/**
 * Tooms out from the map.
 *
 *  @since 2.7.0
 */
- (void)zoomOut:(id)unused;

/**
 * Zoom by a given value-level and/or point.
 *
 *  @param args The zoom-level and/or point.
 *  @since 2.7.0
 */
- (void)zoom:(id)args;

/**
 * Sets the current target location and/or zoom-level.
 *
 *  @param args The target location and/or zoom-level.
 *  @since 2.7.0
 */
- (void)setTarget:(id)args;

/**
 * Sets the current camera.
 *
 *  @param args The camera options.
 *  @since 2.7.0
 */
- (void)setCamera:(id)args;

/**
 * Changes the camera to fit the specified bounds.
 *
 *  @param args The bounds.
 *  @since 2.7.0
 */
- (void)fitBounds:(id)args;

/**
 * Scroll by the specified point.
 *
 *  @param args The point.
 *  @since 2.7.0
 */
- (void)scrollBy:(id)args;

@end
