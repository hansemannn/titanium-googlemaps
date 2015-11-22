/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsCircleProxy.h"

@implementation TiGooglemapsCircleProxy

@synthesize circle = _circle;

-(GMSCircle*)circle
{
    if (_circle == nil) {
        _circle = [[GMSCircle alloc] init];
        _circle.tappable = YES;
    }
    
    return _circle;
}

#pragma mark Public APIs

-(void)setCenter:(id)args
{
    ENSURE_UI_THREAD(setCenter, args);
    [self replaceValue:args forKey:@"center" notification:NO];
    
    if(![args isKindOfClass:[NSArray class]] && ![args isKindOfClass:[NSDictionary class]]) {
        NSLog(@"[WARN] Ti.GoogleMaps: You need to specify the center either using an array or object.");
        return;
    }
    
    [[self circle] setPosition:[self positionFromPoint:args]];
}

-(void)setRadius:(id)value
{
    ENSURE_UI_THREAD(setRadius, value);
    ENSURE_TYPE(value, NSNumber);
    
    [self replaceValue:value forKey:@"radius" notification:NO];
    [[self circle] setRadius:[TiUtils doubleValue:value]];
}

-(void)setTappable:(id)value
{
    ENSURE_UI_THREAD(setTappable, value);
    ENSURE_TYPE(value, NSNumber);
    
    [self replaceValue:value forKey:@"tappable" notification:NO];
    
    [[self circle] setTappable:[TiUtils boolValue:value]];
}

-(void)setFillColor:(id)value
{
    ENSURE_UI_THREAD(setFillColor, value);
    
    [self replaceValue:value forKey:@"fillColor" notification:NO];
    
    [[self circle] setFillColor:[[TiUtils colorValue:value] _color]];
}

-(void)setStrokeColor:(id)value
{
    ENSURE_UI_THREAD(setStrokeColor, value);
    
    [self replaceValue:value forKey:@"strokeColor" notification:NO];
    
    [[self circle] setStrokeColor:[[TiUtils colorValue:value] _color]];
}

-(void)setStrokeWidth:(id)value
{
    ENSURE_UI_THREAD(setStrokeWidth, value);
    
    [self replaceValue:value forKey:@"strokeWidth" notification:NO];
    
    [[self circle] setStrokeWidth:[TiUtils floatValue:value def:1]];
}

#pragma mark Utilities

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
