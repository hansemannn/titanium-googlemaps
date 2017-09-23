/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsHeatmapLayerProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsHeatmapLayerProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context
{
  if (self = [super _initWithPageContext:context]) {
    _layer = [[GMUHeatmapTileLayer alloc] init];
  }

  return self;
}

- (GMUHeatmapTileLayer *)heatmapLayer
{
  return _layer;
}

- (void)setGradient:(NSDictionary *)gradient
{
  NSArray<UIColor *> *colors = [(NSArray *)[gradient objectForKey:@"colors"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
    return [[TiUtils colorValue:object] color];
  }]];

  GMUGradient *nativeGradient = [[GMUGradient alloc] initWithColors:colors
                                                        startPoints:[gradient objectForKey:@"startPoints"]
                                                       colorMapSize:[TiUtils intValue:@"colorMapSize" properties:gradient def:256]];

  [_layer setGradient:nativeGradient];
}

- (void)setRadius:(NSNumber *)radius
{
  [_layer setRadius:[TiUtils intValue:radius]];
}

- (void)setOpacity:(NSNumber *)opacity
{
  [_layer setOpacity:[TiUtils floatValue:opacity]];
}

- (void)setWeightedData:(NSArray *)weightedData
{
  NSArray<GMUWeightedLatLng *> *result = [weightedData filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([TiUtils doubleValue:@"latitude" properties:object], [TiUtils doubleValue:@"longitude" properties:object]);
    return [[GMUWeightedLatLng alloc] initWithCoordinate:coordinate intensity:[TiUtils floatValue:@"intensity" properties:object]];
  }]];

  [_layer setWeightedData:result];
}

@end
