/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsAnnotationProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsAnnotationProxy

@synthesize marker = _marker;

- (GMSMarker *)marker
{
    if (!_marker) {
        _marker = [[GMSMarker alloc] init];
        
        CLLocationDegrees latitude = [TiUtils doubleValue:[self valueForKey:@"latitude"]];
        CLLocationDegrees longitude = [TiUtils doubleValue:[self valueForKey:@"longitude"]];
        
        [_marker setPosition:CLLocationCoordinate2DMake(latitude,longitude)];
        [_marker setUserData:@{@"uuid": [[NSUUID UUID] UUIDString]}];
    }
    
    return _marker;
}

- (NSArray *)keySequence
{
    return @[@"latitude", @"longitude"];
}

#pragma mark Public API's

- (TiViewProxy *)infoWindow
{
    return [self valueForUndefinedKey:@"infoWindow"];
}

- (void)setInfoWindow:(id)value
{
    [self replaceValue:value forKey:@"infoWindow" notification:NO];
}

- (void)setLatitude:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    [self replaceValue:value forKey:@"latitude" notification:NO];
}

- (void)setLongitude:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    [self replaceValue:value forKey:@"longitude" notification:NO];
}

- (void)setTitle:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSString);
    
    [[self marker] setTitle:[TiUtils stringValue:value]];
    [self replaceValue:value forKey:@"title" notification:NO];
}

- (void)setSubtitle:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSString);
    
    [[self marker] setSnippet:[TiUtils stringValue:value]];
    [self replaceValue:value forKey:@"subtitle" notification:NO];
}

- (void)setCenterOffset:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[self marker] setInfoWindowAnchor:[TiUtils pointValue:args]];
    [self replaceValue:args forKey:@"centerOffset" notification:NO];
}

- (void)setGroundOffset:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[self marker] setGroundAnchor:[TiUtils pointValue:args]];
    [self replaceValue:args forKey:@"groundOffset" notification:NO];
}

- (void)setImage:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setIcon:[TiUtils image:value proxy:self]];
    [self replaceValue:value forKey:@"image" notification:NO];
}

- (void)setPinColor:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setIcon:[GMSMarker markerImageWithColor:[[TiUtils colorValue:value] _color]]];
    [self replaceValue:value forKey:@"pinColor" notification:NO];
}

- (void)setTouchEnabled:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[self marker] setTappable:[TiUtils boolValue:value def:YES]];
    [self replaceValue:value forKey:@"touchEnabled" notification:NO];
}

- (void)setFlat:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[self marker] setFlat:[TiUtils boolValue:value def:NO]];
    [self replaceValue:value forKey:@"flat" notification:NO];
}

- (void)setDraggable:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[self marker] setDraggable:[TiUtils boolValue:value def:NO]];
    [self replaceValue:value forKey:@"draggable" notification:NO];
}

- (void)setOpacity:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[self marker] setOpacity:[TiUtils floatValue:value def:1]];
    [self replaceValue:value forKey:@"opacity" notification:NO];
}

- (void)setAnimationStyle:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[self marker] setAppearAnimation:[TiUtils intValue:value def:kGMSMarkerAnimationNone]];
    [self replaceValue:value forKey:@"animationStyle" notification:NO];
}

- (void)setRotation:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setRotation:[TiUtils doubleValue:value def:0]];
}

- (void)setUserData:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    NSMutableDictionary *result = value;
    
    // Hook in internal uuid
    if ([[self marker] userData] != value) {
        [result setObject:[[[self marker] userData] valueForKey:@"uuid"] forKey:@"uuid"];
    }
    
    [[self marker] setUserData:result];
    [self replaceValue:result forKey:@"userData" notification:NO];
}

- (void)updateLocation:(id)args
{
    ENSURE_UI_THREAD(updateLocation, args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    id latitude = [args valueForKey:@"latitude"];
    id longitude = [args valueForKey:@"longitude"];
    id animated = [args valueForKey:@"animated"];
    id duration = [args valueForKey:@"duration"];
    id rotation = [args valueForKey:@"rotation"];
    id opacity = [args valueForKey:@"opacity"];
    
    if ([TiUtils boolValue:animated def:NO]) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:[TiUtils floatValue:duration def:2000] / 1000];
        
        // Update coordinates
        if (latitude != nil && longitude != nil) {
            [[self marker] setPosition:CLLocationCoordinate2DMake([TiUtils doubleValue:latitude],[TiUtils doubleValue:longitude])];
        }
        
        // Update rotation
        if (rotation != nil) {
            [[self marker] setRotation:[TiUtils doubleValue:rotation def:0]];
        }
        
        // Update opacity
        if (opacity != nil) {
            [[self marker] setOpacity:[TiUtils floatValue:opacity def:1]];
        }
        
        [CATransaction commit];
    } else {
        [[self marker] setPosition:CLLocationCoordinate2DMake([TiUtils doubleValue:latitude],[TiUtils doubleValue:longitude])];
    }
    
    [self replaceValue:latitude forKey:@"latitude" notification:NO];
    [self replaceValue:longitude forKey:@"longitude" notification:NO];
}

- (void)setCustomView:(id)value
{
    ENSURE_UI_THREAD(setCustomView, value);
    
    id current = [self valueForUndefinedKey:@"customView"];
    [self replaceValue:value forKey:@"customView" notification:NO];
    
    if (value == [NSNull null] || value == nil) {
        [[self marker] setIconView:nil];
    } else if ([current isEqual:value] == NO) {
        [self forgetProxy:current];
        [self rememberProxy:value];
        
        [[self marker] setIconView:[(TiViewProxy *)value view]];
    }
}

@end
