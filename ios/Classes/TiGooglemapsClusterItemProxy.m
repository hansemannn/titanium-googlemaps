/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsClusterItemProxy.h"

@implementation POIItem

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position name:(NSString *)name {
    if (self = [super init]) {
        _position = position;
        _name = [name copy];
    }
    return self;
}

@end

@implementation TiGooglemapsClusterItemProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context andPosition:(CLLocationCoordinate2D)position title:(NSString *)title
{
    if (self = [super _initWithPageContext:context]) {
        clusterItem = [[POIItem alloc] initWithPosition:position name:title];
    }
    
    return self;
}

- (POIItem *)clusterItem
{
    return clusterItem;
}

@end
