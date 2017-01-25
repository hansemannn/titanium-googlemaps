/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import "GMUMarkerClustering.h"

@interface TiPOIItem : NSObject<GMUClusterItem>

@property(nonatomic, readonly) CLLocationCoordinate2D position;
@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSString *subtitle;
@property(nonatomic, readonly) UIImage *icon;
@property(nonatomic, readonly) NSDictionary *userData;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position andTitle:(NSString *)title subtitle:(NSString *)subtitle icon:(UIImage *)icon userData:(NSDictionary *)userData;

@end

