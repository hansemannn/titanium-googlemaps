/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "DeHansknoechelGooglemapsCircleProxy.h"

@implementation DeHansknoechelGooglemapsCircleProxy

@synthesize circle = _circle, path = _path;

-(GMSCircle*)circle
{
    if (_circle == nil) {
        _circle = [GMSCircle circleWithPosition:[self positionFromPoint:[self valueForKey:@"center"]]
                                         radius:[TiUtils doubleValue:[self valueForKey:@"radius"]]];
    
        _circle.fillColor = [[TiUtils colorValue:[self valueForKey:@"fillColor"]] _color];
        _circle.strokeColor = [[TiUtils colorValue:[self valueForKey:@"strokeColor"]] _color];
        _circle.strokeWidth = [TiUtils floatValue:[self valueForKey:@"strokeWidth"] def:1];
    }
    
    return _circle;
}

-(CLLocationCoordinate2D)positionFromPoint:(id)point
{
    if ([point isKindOfClass:[NSDictionary class]]) {
        CLLocationDegrees latitude = [TiUtils doubleValue:[point valueForKey:@"latitude"]];
        CLLocationDegrees longitude = [TiUtils doubleValue:[point valueForKey:@"longitude"]];

        return CLLocationCoordinate2DMake(latitude, longitude);
    } else if ([point isKindOfClass:[NSArray class]]) {
        CLLocationDegrees latitude = [TiUtils doubleValue:[point objectAtIndex:0]];
        CLLocationDegrees longitude = [TiUtils doubleValue:[point objectAtIndex:1]];
        
        return CLLocationCoordinate2DMake(latitude, longitude);
    }
}

@end
