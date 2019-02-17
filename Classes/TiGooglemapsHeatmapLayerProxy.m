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
  NSArray *proxyColors = (NSArray *)[gradient objectForKey:@"colors"];
  NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[proxyColors count]];

  for (id color in proxyColors) {
    [colors addObject:[[TiUtils colorValue:color] color]];
  }

  GMUGradient *nativeGradient = [[GMUGradient alloc] initWithColors:@[ UIColor.greenColor, UIColor.redColor ]
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
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:weightedData.count];

  for (NSDictionary *data in weightedData) {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([TiUtils doubleValue:@"latitude" properties:data], [TiUtils doubleValue:@"longitude" properties:data]);

    [result addObject:[[GMUWeightedLatLng alloc] initWithCoordinate:coordinate intensity:[TiUtils floatValue:@"intensity" properties:data]]];
  }

  [_layer setWeightedData:result];
}

@end
