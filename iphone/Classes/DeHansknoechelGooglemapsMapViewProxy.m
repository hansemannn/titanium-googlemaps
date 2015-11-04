/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "DeHansknoechelGooglemapsMapViewProxy.h"
#import "DeHansknoechelGooglemapsMarkerProxy.h"
#import "DeHansknoechelGooglemapsPolylineProxy.h"
#import "DeHansknoechelGooglemapsPolygonProxy.h"
#import "DeHansknoechelGooglemapsCircleProxy.h"
#import "TiUtils.h"

@implementation DeHansknoechelGooglemapsMapViewProxy

-(DeHansknoechelGooglemapsMapView*)mapView
{
    return (DeHansknoechelGooglemapsMapView*)[self view];
}

-(void)setMapView:(GMSMapView*)_mapView
{
    [self setMapView:_mapView];
}

#pragma mark Public API's

-(void)addMarker:(id)args
{
    DeHansknoechelGooglemapsMarkerProxy *marker = [args objectAtIndex:0];
    
    ENSURE_TYPE(marker, DeHansknoechelGooglemapsMarkerProxy);
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[marker marker] setMap:[[self mapView] mapView]];
}

-(void)addMarkers:(id)args
{
    id markers = [args objectAtIndex:0];
 
    ENSURE_TYPE(markers, NSArray);
    ENSURE_UI_THREAD_1_ARG(args);
    
    for(DeHansknoechelGooglemapsMarkerProxy *marker in markers) {
        [[marker marker] setMap:[[self mapView] mapView]];
    }
}

-(void)removeMarker:(id)args
{
    DeHansknoechelGooglemapsMarkerProxy *marker = [args objectAtIndex:0];
    
    ENSURE_TYPE(marker, DeHansknoechelGooglemapsMarkerProxy);
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[marker marker] setMap:nil];
}

-(void)addPolyline:(id)args
{
    id polyline = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polyline, DeHansknoechelGooglemapsPolylineProxy);
    
    [[polyline polyline] setMap:[[self mapView] mapView]];
}

-(void)removePolyline:(id)args
{
    id polyline = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polyline, DeHansknoechelGooglemapsPolylineProxy);
    
    [[polyline polyline] setMap:nil];
}

-(void)addPolygon:(id)args
{
    id polygon = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polygon, DeHansknoechelGooglemapsPolygonProxy);
    
    [[polygon polygon] setMap:[[self mapView] mapView]];
}

-(void)removePolygon:(id)args
{
    id polygon = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polygon, DeHansknoechelGooglemapsPolygonProxy);
    
    [[polygon polygon] setMap:nil];
}

-(void)addCircle:(id)args
{
    id circle = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(circle, DeHansknoechelGooglemapsCircleProxy);
    
    [[circle circle] setMap:[[self mapView] mapView]];
}

-(void)removeCircle:(id)args
{
    id circle = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(circle, DeHansknoechelGooglemapsCircleProxy);
    
    [[circle circle] setMap:nil];
}

@end
