/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "GMUHeatmapTileLayer.h"
#import "TiProxy.h"

@interface TiGooglemapsHeatmapLayerProxy : TiProxy {
  GMUHeatmapTileLayer *_layer;
}

/**
 *  Returns the heatmap-layer.
 *
 *  @since 3.10.0
 */
- (GMUHeatmapTileLayer *)heatmapLayer;

/**
 *  Sets a gradient based on a dictionary of keys and values.
 *
 *  @param args The gradient dictionary.
 *  @since 3.10.0
 */
- (void)setGradient:(NSDictionary *)gradient;

/**
 *  Sets the radius of the heatmap-layer.
 *
 *  @param radius The heatmap-layer radius.
 *  @since 3.10.0
 */
- (void)setRadius:(NSNumber *)radius;

/**
 *  Sets the opacity of the heatmap-layer.
 *
 *  @param radius The heatmap-layer opacity.
 *  @since 3.10.0
 */
- (void)setOpacity:(NSNumber *)opacity;

/**
 *  Sets the weighted data of the heatmap.
 *
 *  @param args An array of the weighted heatmap data.
 *  @since 3.10.0
 */
- (void)setWeightedData:(NSArray *)weightedData;

@end
