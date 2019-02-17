/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "GMUMarkerClustering.h"
#import "TiPOIItem.h"
#import "TiProxy.h"

@interface TiGooglemapsClusterItemProxy : TiProxy {
  TiPOIItem *clusterItem;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andPosition:(CLLocationCoordinate2D)position title:(NSString *)title subtitle:(NSString *)subtitle icon:(id)icon userData:(NSDictionary *)userData;

- (TiPOIItem *)clusterItem;

@end
