/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsPolylineProxy.h"

@implementation TiGooglemapsPolylineProxy

@synthesize polyline = _polyline;

-(GMSPolyline*)polyline
{
    if (_polyline == nil) {
        _polyline = [[GMSPolyline alloc] init];
        _polyline.tappable = YES;
    }
    
    return _polyline;
}

-(void)setPoints:(id)points
{
    ENSURE_UI_THREAD(setPoints, points);
    ENSURE_TYPE_OR_NIL(points, NSArray);
    
    [self replaceValue:points forKey:@"points" notification:NO];
    
    GMSMutablePath *path = [GMSMutablePath path];
    
    if (points != nil) {
        if ([points count] < 2) {
            NSLog(@"[WARN] Ti.GoogleMaps: You need to specify at least 2 points to create a polygon.");
            return;
        }
        
        for(id point in points) {
            if ([point isKindOfClass:[NSDictionary class]]) {
                CLLocationDegrees latitude = [TiUtils doubleValue:[point valueForKey:@"latitude"]];
                CLLocationDegrees longitude = [TiUtils doubleValue:[point valueForKey:@"longitude"]];
                
                [path addLatitude:latitude longitude:longitude];
            } else if ([point isKindOfClass:[NSArray class]]) {
                CLLocationDegrees latitude = [TiUtils doubleValue:[point objectAtIndex:0]];
                CLLocationDegrees longitude = [TiUtils doubleValue:[point objectAtIndex:1]];
                
                [path addLatitude:latitude longitude:longitude];
            }
        }
    }
    
    [[self polyline] setPath:path];
}

-(void)setTappable:(id)value
{
    ENSURE_UI_THREAD(setTappable, value);
    ENSURE_TYPE(value, NSNumber);
    
    [self replaceValue:value forKey:@"tappable" notification:NO];
    
    [[self polyline] setTappable:[TiUtils boolValue:value]];
}

-(void)setStrokeColor:(id)value
{
    ENSURE_UI_THREAD(setStrokeColor, value);
    
    [self replaceValue:value forKey:@"strokeColor" notification:NO];
    
    [[self polyline] setStrokeColor:[[TiUtils colorValue:value] _color]];
}

-(void)setStrokeWidth:(id)value
{
    ENSURE_UI_THREAD(setStrokeWidth, value);
    
    [self replaceValue:value forKey:@"strokeWidth" notification:NO];
    
    [[self polyline] setStrokeWidth:[TiUtils floatValue:value def:1]];
}

-(void)setGeodesic:(id)value
{
    ENSURE_UI_THREAD(setGeodesic, value);
    
    [self replaceValue:value forKey:@"setGeodesic" notification:NO];
    
    [[self polyline] setGeodesic:[TiUtils boolValue:value def:NO]];
}

@end
