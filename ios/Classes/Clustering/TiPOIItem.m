/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPOIItem.h"

@implementation TiPOIItem

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position andTitle:(NSString *)title subtitle:(NSString *)subtitle icon:(UIImage *)icon userData:(NSDictionary *)userData;
{
    if (self = [super init]) {
        _position = position;
        _title = title;
        _subtitle = subtitle;
        _icon = icon;
        _userData = userData;
    }
    return self;
}

@end
