/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import "GMUMarkerClustering.h"
#import "TiPOIItem.h"

@interface TiGooglemapsClusterItemProxy : TiProxy {
    TiPOIItem *clusterItem;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andPosition:(CLLocationCoordinate2D)position title:(NSString *)title;
- (TiPOIItem *)clusterItem;

@end
