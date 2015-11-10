/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "DeHansknoechelGooglemapsPolygonProxy.h"

@implementation DeHansknoechelGooglemapsPolygonProxy

@synthesize polygon = _polygon, path = _path;

-(GMSPolygon*)polygon
{
    if (_polygon == nil) {
        [self setPath:[GMSMutablePath path]];
        [self setPolygon:[GMSPolygon polygonWithPath:_path]];
    
        id points = [self valueForKey:@"points"];
        
        ENSURE_TYPE_OR_NIL(points, NSArray);
        
        if (points != nil) {
            if ([points count] < 2) {
                NSLog(@"[WARN] GoogleMaps: You need to specify at least 2 points to create a polygon");
                return _polygon;
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
        
        _polygon.path = self.path;
        _polygon.fillColor = [[TiUtils colorValue:[self valueForKey:@"fillColor"]] _color];
        _polygon.strokeColor = [[TiUtils colorValue:[self valueForKey:@"strokeColor"]] _color];
        _polygon.strokeWidth = [TiUtils floatValue:[self valueForKey:@"strokeWidth"] def:1];
        _polygon.geodesic = [TiUtils boolValue:[self valueForKey:@"geodesic"] def:NO];

    }
    
    return _polygon;
}

@end
