/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "DeHansknoechelGooglemapsPolylineProxy.h"

@implementation DeHansknoechelGooglemapsPolylineProxy

-(GMSPolyline*)polyline
{
    if (polyline == nil) {
        _path = [GMSMutablePath path];
        polyline = [GMSPolyline polylineWithPath:_path];
    
        id points = [self valueForKey:@"points"];
        
        ENSURE_TYPE_OR_NIL(points, NSArray);
        
        if (points != nil) {
            if ([points count] < 2) {
                NSLog(@"[WARN] GoogleMaps: You need to specify at least 2 points to create a polyline");
                return polyline;
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
        
        polyline.path = self.path;
        polyline.strokeColor = [[TiUtils colorValue:[self valueForKey:@"strokeColor"]] _color];
        polyline.strokeWidth = [TiUtils floatValue:[self valueForKey:@"strokeWidth"] def:1];
        polyline.geodesic = [TiUtils boolValue:[self valueForKey:@"geodesic"] def:NO];
    }
    
    return polyline;
}

@end
