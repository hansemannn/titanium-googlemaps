/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsMarkerProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsMarkerProxy

@synthesize marker = _marker;

-(GMSMarker*)marker
{
    if (_marker == nil) {
        _marker = [[GMSMarker alloc] init];
        
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
    [super dealloc];
}

#pragma mark Public API's

-(void)setTitle:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setTitle:[TiUtils stringValue:value]];
    [self replaceValue:value forKey:@"title" notification:NO];
}

-(void)setSnippet:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setSnippet:[TiUtils stringValue:value]];
    [self replaceValue:value forKey:@"snippet" notification:NO];
}

-(void)setInfoWindowAnchor:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE([args valueForKey:@"x"], NSNumber);
    ENSURE_TYPE([args valueForKey:@"y"], NSNumber);
    
    float x = [TiUtils floatValue:[args valueForKey:@"x"]];
    float y = [TiUtils floatValue:[args valueForKey:@"y"]];
    
    [[self marker] setInfoWindowAnchor:CGPointMake(x, y)];
    [self replaceValue:args forKey:@"infoWindowAnchor" notification:NO];
}

-(void)setIcon:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    NSLog(@"[WARN] Ti.GoogleMaps: The 'icon' property is deprecated in 2.1.0. Use 'image' or 'pinColor' instead.");
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
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setTappable:[TiUtils boolValue:value def:YES]];
    [self replaceValue:value forKey:@"tappable" notification:NO];
}

-(void)setFlat:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setFlat:[TiUtils boolValue:value def:NO]];
    [self replaceValue:value forKey:@"flat" notification:NO];
}

-(void)setDraggable:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setDraggable:[TiUtils boolValue:value def:NO]];
    [self replaceValue:value forKey:@"draggable" notification:NO];
}

-(void)setUserData:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setUserData:value];
    [self replaceValue:value forKey:@"userData" notification:NO];
}

@end
