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

- (GMUHeatmapTileLayer *)heatmapLayer;

@end
