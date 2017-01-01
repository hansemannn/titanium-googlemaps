/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsClusterItemProxy.h"

@implementation TiGooglemapsClusterItemProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context andPosition:(CLLocationCoordinate2D)position title:(NSString *)title userData:(NSDictionary *)userData
{
    if (self = [super _initWithPageContext:context]) {
        clusterItem = [[TiPOIItem alloc] initWithPosition:position name:title userData:userData];
    }
    
    return self;
}

- (TiPOIItem *)clusterItem
{
    return clusterItem;
}

@end
