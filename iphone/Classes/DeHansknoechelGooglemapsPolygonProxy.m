/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "DeHansknoechelGooglemapsPolygonProxy.h"

@implementation DeHansknoechelGooglemapsPolygonProxy

-(GMSPolygon*)polygon
{
    if (polygon == nil) {
        _path = [GMSMutablePath path];
        polygon = [GMSPolygon polygonWithPath:_path];
    
        id points = [self valueForKey:@"points"];
        
        ENSURE_TYPE_OR_NIL(points, NSArray);
        
        if (points != nil) {
            if ([points count] < 2) {
                NSLog(@"[WARN] GoogleMaps: You need to specify at least 2 points to create a polygon");
                return polygon;
            }
            
            for(id point in points) {
                
                if ([point isKindOfClass:[NSDictionary class]]) {
                    CLLocationDegrees latitude = [TiUtils doubleValue:[point valueForKey:@"latitude"]];
                    CLLocationDegrees longitude = [TiUtils doubleValue:[point valueForKey:@"longitude"]];
                    
                    [self.path addLatitude:latitude longitude:longitude];
                } else if ([point isKindOfClass:[NSArray class]]) {
                    CLLocationDegrees latitude = [TiUtils doubleValue:[point objectAtIndex:0]];
                    CLLocationDegrees longitude = [TiUtils doubleValue:[point objectAtIndex:1]];
                    
                    [self.path addLatitude:latitude longitude:longitude];
                }            
            }
        }
        
        polygon.path = self.path;
        polygon.fillColor = [[TiUtils colorValue:[self valueForKey:@"fillColor"]] _color];
        polygon.strokeColor = [[TiUtils colorValue:[self valueForKey:@"strokeColor"]] _color];
        polygon.strokeWidth = [TiUtils floatValue:[self valueForKey:@"strokeWidth"] def:1];
        polygon.geodesic = [TiUtils boolValue:[self valueForKey:@"geodesic"] def:NO];

    }
    
    return polygon;
}

@end
