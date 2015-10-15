/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "DeHansknoechelGooglemapsMapViewProxy.h"
#import "DeHansknoechelGooglemapsMarkerProxy.h"
#import "TiUtils.h"

@implementation DeHansknoechelGooglemapsMapViewProxy

-(DeHansknoechelGooglemapsMapView*)mapView
{
    return (DeHansknoechelGooglemapsMapView*)[self view];
}

-(void)addMarker:(id)args
{
    DeHansknoechelGooglemapsMarkerProxy *marker = [args objectAtIndex:0];
    
    ENSURE_TYPE(marker, DeHansknoechelGooglemapsMarkerProxy);
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[marker marker] setMap:[[self mapView] mapView]];
}

-(void)removeMarker:(id)args
{
    DeHansknoechelGooglemapsMarkerProxy *marker = [args objectAtIndex:0];
    
    ENSURE_TYPE(marker, DeHansknoechelGooglemapsMarkerProxy);
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[marker marker] setMap:nil];
}

@end
