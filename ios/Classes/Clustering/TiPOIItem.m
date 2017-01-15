/**
 * Ti.GoogleMaps
 * Copyright (c) 2009-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPOIItem.h"

@implementation TiPOIItem

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position name:(NSString *)name userData:(NSDictionary *)userData
{
    if (self = [super init]) {
        _position = position;
        _name = [name copy];
        _userData = [userData retain];
    }
    return self;
}

@end
