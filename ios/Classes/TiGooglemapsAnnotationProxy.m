/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsAnnotationProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsAnnotationProxy

@synthesize marker = _marker;

-(GMSMarker*)marker
{
    if (_marker == nil) {
        _marker = [GMSMarker new];
        
        [_marker setPosition:CLLocationCoordinate2DMake([TiUtils doubleValue:[self valueForKey:@"latitude"]],[TiUtils doubleValue:[self valueForKey:@"longitude"]])];
        [_marker setUserData:@{@"uuid": [[NSUUID UUID] UUIDString]}];
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
    RELEASE_TO_NIL(_marker)
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

-(void)setSubtitle:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSString);
    
    [[self marker] setSnippet:[TiUtils stringValue:value]];
    [self replaceValue:value forKey:@"subtitle" notification:NO];
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

-(void)setRotation:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setRotation:[TiUtils doubleValue:value def:0]];
}

-(void)setUserData:(id)value
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

-(void)updateLocation:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(args, NSDictionary);
    
    id latitude = [args valueForKey:@"latitude"];
    id longitude = [args valueForKey:@"longitude"];
    
    [[self marker] setPosition:CLLocationCoordinate2DMake([TiUtils doubleValue:latitude],[TiUtils doubleValue:longitude])];
    [self replaceValue:args forKey:@"updateLocation" notification:NO];
}

@end
