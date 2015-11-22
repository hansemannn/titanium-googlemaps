/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsMapViewProxy.h"
#import "TiGooglemapsMarkerProxy.h"
#import "TiGooglemapsPolylineProxy.h"
#import "TiGooglemapsPolygonProxy.h"
#import "TiGooglemapsCircleProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsMapViewProxy

-(TiGooglemapsMapView*)mapView
{
    return (TiGooglemapsMapView*)[self view];
}

-(void)setMapView:(GMSMapView*)_mapView
{
    [self setMapView:_mapView];
}

#pragma mark Public API's

-(void)addMarker:(id)args
{
    TiGooglemapsMarkerProxy *marker = [args objectAtIndex:0];
    
    ENSURE_TYPE(marker, TiGooglemapsMarkerProxy);
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[marker marker] setMap:[[self mapView] mapView]];
}

-(void)addMarkers:(id)args
{
    id markers = [args objectAtIndex:0];
 
    ENSURE_TYPE(markers, NSArray);
    ENSURE_UI_THREAD_1_ARG(args);
    
    for(TiGooglemapsMarkerProxy *marker in markers) {
        [[marker marker] setMap:[[self mapView] mapView]];
    }
}

-(void)removeMarker:(id)args
{
    TiGooglemapsMarkerProxy *marker = [args objectAtIndex:0];
    
    ENSURE_TYPE(marker, TiGooglemapsMarkerProxy);
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[marker marker] setMap:nil];
}

-(void)addPolyline:(id)args
{
    id polyline = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polyline, TiGooglemapsPolylineProxy);
    
    [[polyline polyline] setMap:[[self mapView] mapView]];
}

-(void)removePolyline:(id)args
{
    id polyline = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polyline, TiGooglemapsPolylineProxy);
    
    [[polyline polyline] setMap:nil];
}

-(void)addPolygon:(id)args
{
    id polygon = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polygon, TiGooglemapsPolygonProxy);
    
    [[polygon polygon] setMap:[[self mapView] mapView]];
}

-(void)removePolygon:(id)args
{
    id polygon = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polygon, TiGooglemapsPolygonProxy);
    
    [[polygon polygon] setMap:nil];
}

-(void)addCircle:(id)args
{
    id circle = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(circle, TiGooglemapsCircleProxy);
    
    [[circle circle] setMap:[[self mapView] mapView]];
}

-(void)removeCircle:(id)args
{
    id circle = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(circle, TiGooglemapsCircleProxy);
    
    [[circle circle] setMap:nil];
}

@end
