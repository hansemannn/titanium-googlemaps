/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsPolylineProxy.h"
#import "TiGooglemapsConstants.h"

@implementation TiGooglemapsPolylineProxy

- (GMSPolyline*)polyline
{
    if (_polyline == nil) {
        _polyline = [GMSPolyline new];
        _polyline.tappable = YES;
    }

    if (dashLength == nil) {
        dashLength = @50;
    }

    if (gapLength == nil) {
        gapLength = @25;
    }

    return _polyline;
}

- (void)setPoints:(id)points
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

    if (patternType > 0) {
        UIColor  *color;
        
        color = [TiUtils colorValue:[self valueForKey:@"strokeColor"]].color;

        if (patternType == TiGooglemapsPolylinePatternDotted) {
            dashLength = [NSNumber numberWithFloat:[TiUtils floatValue:[self valueForKey:@"strokeWidth"] def:1]];
            gapLength = [NSNumber numberWithFloat:[TiUtils floatValue:[self valueForKey:@"strokeWidth"] def:1]];
        }
        
        NSArray *lengths = @[dashLength, gapLength];

        styles = @[[GMSStrokeStyle solidColor:color], [GMSStrokeStyle solidColor:[UIColor clearColor]]];

        [[self polyline] setSpans:GMSStyleSpans([self polyline].path, styles, lengths, kGMSLengthRhumb)];
    }
}

- (void)updatePattern:(float)scale
{
    NSNumber* scaledDashLength = [NSNumber numberWithFloat:dashLength.floatValue*scale];
    NSNumber* scaledGapLength = [NSNumber numberWithFloat:gapLength.floatValue*scale];
    
    NSArray* lengths = @[scaledDashLength, scaledGapLength];
    
    [[self polyline] setSpans:GMSStyleSpans([self polyline].path, styles, lengths, kGMSLengthRhumb)];
}

- (void)setPattern:(id)descriptor
{
    ENSURE_UI_THREAD(setPattern, descriptor);

    if ([descriptor isKindOfClass:[NSNumber class]]) {
        patternType = [TiUtils intValue:descriptor];
    } else {
        id givenType = [descriptor valueForKey:@"type"];
        id givenDashLength = [descriptor valueForKey:@"dashLength"];
        id givenGapLength = [descriptor valueForKey:@"gapLength"];

        if (givenType == nil) {
            NSLog(@"[WARN] Ti.GoogleMaps: You need to specify the 'type' for the pattern property.");
        }
        else {
            patternType = [TiUtils intValue:givenType];
        }

        if (givenDashLength)
            dashLength = [NSNumber numberWithInt:[TiUtils intValue:givenDashLength]];

        if (givenGapLength)
            gapLength = [NSNumber numberWithInt:[TiUtils intValue:givenGapLength]];
    }

    if ([self polyline].path != nil) {
        UIColor  *color;
        
        color = [TiUtils colorValue:[self valueForKey:@"strokeColor"]].color;
        
        if (patternType == TiGooglemapsPolylinePatternDotted) {
            dashLength = [NSNumber numberWithFloat:[TiUtils floatValue:[self valueForKey:@"strokeWidth"] def:1]];
            gapLength = [NSNumber numberWithFloat:[TiUtils floatValue:[self valueForKey:@"strokeWidth"] def:1]];
        }
        
        NSArray *lengths = @[dashLength, gapLength];
        
        styles = @[[GMSStrokeStyle solidColor:color], [GMSStrokeStyle solidColor:[UIColor clearColor]]];
        
        [[self polyline] setSpans:GMSStyleSpans([self polyline].path, styles, lengths, kGMSLengthRhumb)];
    }

    [self replaceValue:descriptor forKey:@"pattern" notification:NO];
}

- (void)setTappable:(id)value
{
    ENSURE_UI_THREAD(setTappable, value);
    ENSURE_TYPE(value, NSNumber);

    [[self polyline] setTappable:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"tappable" notification:NO];
}

- (void)setStrokeColor:(id)value
{
    ENSURE_UI_THREAD(setStrokeColor, value);

    [[self polyline] setStrokeColor:[[TiUtils colorValue:value] _color]];
    [self replaceValue:value forKey:@"strokeColor" notification:NO];
}

- (void)setStrokeWidth:(id)value
{
    ENSURE_UI_THREAD(setStrokeWidth, value);

    [[self polyline] setStrokeWidth:[TiUtils floatValue:value def:1]];
    [self replaceValue:value forKey:@"strokeWidth" notification:NO];
}

- (void)setGeodesic:(id)value
{
    ENSURE_UI_THREAD(setGeodesic, value);

    [[self polyline] setGeodesic:[TiUtils boolValue:value def:NO]];
    [self replaceValue:value forKey:@"setGeodesic" notification:NO];
}

@end
