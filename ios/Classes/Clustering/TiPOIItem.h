/**
 * Ti.GoogleMaps
 * Copyright (c) 2009-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import "GMUMarkerClustering.h"

@interface TiPOIItem : NSObject<GMUClusterItem>

@property(nonatomic, readonly) CLLocationCoordinate2D position;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSDictionary *userData;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position name:(NSString *)name userData:(NSDictionary *)userData;

@end

