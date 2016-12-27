/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-Present by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsPolygonProxy.h"

@implementation TiGooglemapsPolygonProxy

-(GMSPolygon*)polygon
{
    if (_polygon == nil) {
        _polygon = [GMSPolygon new];
        _polygon.tappable = YES;
    }
    
    return _polygon;
}

-(void)dealloc
{
    RELEASE_TO_NIL(_polygon);
    [super dealloc];
}

#pragma mark Public API's

-(void)setPoints:(id)points
{
    ENSURE_UI_THREAD(setPoints, points);
    ENSURE_TYPE_OR_NIL(points, NSArray);
    
    [self replaceValue:points forKey:@"points" notification:NO];

    GMSMutablePath *path = [GMSMutablePath path];

    if (points != nil) {
        if ([points count] < 2) {
            NSLog(@"[WARN] Ti.GoogleMaps: You need to specify at least 2 points to create a polygon.");
            return _polygon;
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
    
    [[self polygon] setPath:path];
}

-(void)setTappable:(id)value
{
    ENSURE_UI_THREAD(setTappable, value);
    ENSURE_TYPE(value, NSNumber);

    [[self polygon] setTappable:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"tappable" notification:NO];
}

-(void)setFillColor:(id)value
{
    ENSURE_UI_THREAD(setFillColor, value);
    
    [[self polygon] setFillColor:[[TiUtils colorValue:value] _color]];
    [self replaceValue:value forKey:@"fillColor" notification:NO];
}

-(void)setStrokeColor:(id)value
{
    ENSURE_UI_THREAD(setStrokeColor, value);
    
    [[self polygon] setStrokeColor:[[TiUtils colorValue:value] _color]];
    [self replaceValue:value forKey:@"strokeColor" notification:NO];
}

-(void)setStrokeWidth:(id)value
{
    ENSURE_UI_THREAD(setStrokeWidth, value);
    
    [[self polygon] setStrokeWidth:[TiUtils floatValue:value def:1]];
    [self replaceValue:value forKey:@"strokeWidth" notification:NO];
}

-(void)setGeodesic:(id)value
{
    ENSURE_UI_THREAD(setGeodesic, value);
    
    [[self polygon] setGeodesic:[TiUtils boolValue:value def:NO]];
    [self replaceValue:value forKey:@"setGeodesic" notification:NO];
}

@end
