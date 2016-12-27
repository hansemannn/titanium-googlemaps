/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import "GMUMarkerClustering.h"

@interface POIItem : NSObject<GMUClusterItem>

@property(nonatomic, readonly) CLLocationCoordinate2D position;
@property(nonatomic, readonly) NSString *name;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position name:(NSString *)name;

@end

@interface TiGooglemapsClusterItemProxy : TiProxy {
    POIItem *clusterItem;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andPosition:(CLLocationCoordinate2D)position title:(NSString *)title;
- (POIItem *)clusterItem;

@end
