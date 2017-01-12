/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-Present by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsMarkerProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsMarkerProxy

@synthesize marker = _marker;

#define DEPRECATED(from, to, in) \
NSLog(@"[WARN] Ti.GoogleMaps: %@ is deprecated since %@ in favor of %@", from, in, to);\

-(GMSMarker*)marker
{
    if (_marker == nil) {
        DEPRECATED(@"Marker", @"Annotation", @"2.2.0");
        
        _marker = [GMSMarker new];

        [_marker setPosition:CLLocationCoordinate2DMake([TiUtils doubleValue:[self valueForKey:@"latitude"]],[TiUtils doubleValue:[self valueForKey:@"longitude"]])];
    }
    
    return _marker;
}

-(void)setMarker:(GMSMarker*)marker
{
    if (_marker) {
        RELEASE_TO_NIL(_marker);
    }
    
    _marker = marker;
    [self marker];
}

-(void)dealloc
{
    RELEASE_TO_NIL(_marker);
    [super dealloc];
}

#pragma mark Public API's

-(void)setTitle:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSString);

    [[self marker] setTitle:[TiUtils stringValue:value]];
    [self replaceValue:value forKey:@"title" notification:NO];
}

-(void)setSnippet:(id)value
{
    DEPRECATED(@"Annotation.snippet", @"Annotation.subtitle", @"2.2.0");
    [self setSubtitle:value];
}

-(void)setSubtitle:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSString);
    
    [[self marker] setSnippet:[TiUtils stringValue:value]];
    [self replaceValue:value forKey:@"subtitle" notification:NO];
}

-(void)setInfoWindowAnchor:(id)args
{
    DEPRECATED(@"Annotation.infoWindowAnchor", @"Annotation.centerOffset", @"2.2.0");
    [self setCenterOffset:args];
}

-(void)setCenterOffset:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[self marker] setInfoWindowAnchor:[TiUtils pointValue:args]];
    [self replaceValue:args forKey:@"centerOffset" notification:NO];
}

-(void)setGroundOffset:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[self marker] setGroundAnchor:[TiUtils pointValue:args]];
    [self replaceValue:args forKey:@"groundOffset" notification:NO];
}

-(void)setIcon:(id)value
{
    DEPRECATED(@"Annotation.icon", @"Annotation.image", @"2.1.0");
    [self setImage:value];
}

-(void)setImage:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setIcon:[TiUtils image:value proxy:self]];
    [self replaceValue:value forKey:@"image" notification:NO];
}

-(void)setPinColor:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setIcon:[GMSMarker markerImageWithColor:[[TiUtils colorValue:value] _color]]];
    [self replaceValue:value forKey:@"pinColor" notification:NO];
}

-(void)setTappable:(id)value
{
    DEPRECATED(@"Annotation.tappable", @"Annotation.touchEnabled", @"2.2.0");
    [self setTappable:value];
}

-(void)setTouchEnabled:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);

    [[self marker] setTappable:[TiUtils boolValue:value def:YES]];
    [self replaceValue:value forKey:@"touchEnabled" notification:NO];
}

-(void)setFlat:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);

    [[self marker] setFlat:[TiUtils boolValue:value def:NO]];
    [self replaceValue:value forKey:@"flat" notification:NO];
}

-(void)setDraggable:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);

    [[self marker] setDraggable:[TiUtils boolValue:value def:NO]];
    [self replaceValue:value forKey:@"draggable" notification:NO];
}

-(void)setOpacity:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[self marker] setOpacity:[TiUtils floatValue:value def:1]];
    [self replaceValue:value forKey:@"opacity" notification:NO];
}

-(void)setAnimationStyle:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[self marker] setAppearAnimation:[TiUtils intValue:value def:kGMSMarkerAnimationNone]];
    [self replaceValue:value forKey:@"animationStyle" notification:NO];
}

-(void)setUserData:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    
    [[self marker] setUserData:value];
    [self replaceValue:value forKey:@"userData" notification:NO];
}

@end
