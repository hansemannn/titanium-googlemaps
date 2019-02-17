/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

/**
 * The enumerations used to define overlays.
 *
 * @since 1.0.0
 */
typedef NS_ENUM(NSUInteger, TiGooglemapsOverlayType) {

  /**
     * Unknown overlay type.
     */
  TiGooglemapsOverlayTypeUnknown = 0,

  /**
     * Polygon overlay type.
     */
  TiGooglemapsOverlayTypePolygon,

  /**
     * Polyline overlay type.
     */
  TiGooglemapsOverlayTypePolyline,

  /**
     * Circle overlay type.
     */
  TiGooglemapsOverlayTypeCircle
};
