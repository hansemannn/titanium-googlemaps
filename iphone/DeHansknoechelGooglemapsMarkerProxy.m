/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "DeHansknoechelGooglemapsMarkerProxy.h"
#import "TiUtils.h"

@implementation DeHansknoechelGooglemapsMarkerProxy

-(GMSMarker*)marker
{
    if (marker == nil) {
        marker = [[GMSMarker alloc] init];
        
        [marker setPosition:CLLocationCoordinate2DMake([TiUtils doubleValue:[self valueForKey:@"latitude"]],[TiUtils doubleValue:[self valueForKey:@"longitude"]])];
    }
    
    return marker;
}

-(void)setMarker:(GMSMarker*)_marker
{
    self.marker = _marker;
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
}

-(NSString*)title
{
    return [[self marker] title];
}

-(void)setSnippet:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setSnippet:[TiUtils stringValue:value]];
}

-(NSString*)snippet
{
    return [[self marker] snippet];
}

-(void)setIcon:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setIcon:[TiUtils image:value proxy:self]];
}

-(TiBlob*)icon
{
    return [[TiBlob alloc] initWithImage:[[self marker] icon]];
}

-(void)setTappable:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setTappable:[TiUtils boolValue:value def:YES]];
}

-(NSNumber*)tappable
{
    return NUMBOOL([[self marker] isTappable]);
}

-(void)setFlat:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setFlat:[TiUtils boolValue:value def:NO]];
}

-(NSNumber*)flat
{
    return NUMBOOL([[self marker] isFlat]);
}

-(void)setDraggable:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setDraggable:[TiUtils boolValue:value def:YES]];
}

-(NSNumber*)draggable
{
    return NUMBOOL([[self marker] isDraggable]);
}

-(void)setUserData:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setUserData:value];
}

-(id)userData
{
    return [[self marker] userData];
}

@end
