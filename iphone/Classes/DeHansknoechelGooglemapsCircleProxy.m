/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "DeHansknoechelGooglemapsCircleProxy.h"

@implementation DeHansknoechelGooglemapsCircleProxy

-(GMSCircle*)circle
{
    if (circle == nil) {
        circle = [GMSCircle circleWithPosition:[self positionFromPoint:[self valueForKey:@"center"]]
                                         radius:[TiUtils doubleValue:[self valueForKey:@"radius"]]];
    
        circle.fillColor = [[TiUtils colorValue:[self valueForKey:@"fillColor"]] _color];
        circle.strokeColor = [[TiUtils colorValue:[self valueForKey:@"strokeColor"]] _color];
        circle.strokeWidth = [TiUtils floatValue:[self valueForKey:@"strokeWidth"] def:1];
    }
    
    return circle;
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
