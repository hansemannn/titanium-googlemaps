/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsMapViewProxy.h"
#import "TiGooglemapsPolylineProxy.h"
#import "TiGooglemapsPolygonProxy.h"
#import "TiGooglemapsCircleProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsMapViewProxy

-(void)dealloc
{
    RELEASE_TO_NIL(mapView);
    RELEASE_TO_NIL(markers);
    
    [super dealloc];
}

-(TiGooglemapsMapView*)mapView
{
    return (TiGooglemapsMapView*)[self view];
}

-(NSMutableArray*)markers
{
    if (markers == nil) {
        markers = [NSMutableArray array];
    }
}

#pragma mark Public API's

-(void)addMarker:(id)args
{
    id markerProxy = [args objectAtIndex:0];
    
    ENSURE_TYPE(markerProxy, TiGooglemapsMarkerProxy);
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[markerProxy marker] setMap:[[self mapView] mapView]];
    [markers addObject:markerProxy];
}

-(void)addMarkers:(id)args
{
    id markerProxies = [args objectAtIndex:0];
 
    ENSURE_TYPE(markerProxies, NSArray);
    ENSURE_UI_THREAD_1_ARG(args);
    
    for(TiGooglemapsMarkerProxy *markerProxy in markerProxies) {
        [[markerProxy marker] setMap:[[self mapView] mapView]];
        [markers addObject:markerProxy];
    }
}

-(void)removeMarker:(id)args
{
    id markerProxy = [args objectAtIndex:0];
    
    ENSURE_TYPE(markerProxy, TiGooglemapsMarkerProxy);
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[markerProxy marker] setMap:nil];
    [markers removeObject:markerProxy];
}

-(void)addPolyline:(id)args
{
    id polylineProxy = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polylineProxy, TiGooglemapsPolylineProxy);
    
    [[polylineProxy polyline] setMap:[[self mapView] mapView]];
}

-(void)removePolyline:(id)args
{
    id polylineProxy = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polylineProxy, TiGooglemapsPolylineProxy);
    
    [[polylineProxy polyline] setMap:nil];
}

-(void)addPolygon:(id)args
{
    id polygonProxy = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polygonProxy, TiGooglemapsPolygonProxy);
    
    [[polygonProxy polygon] setMap:[[self mapView] mapView]];
}

-(void)removePolygon:(id)args
{
    id polygonProxy = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polygonProxy, TiGooglemapsPolygonProxy);
    
    [[polygonProxy polygon] setMap:nil];
}

-(void)addCircle:(id)args
{
    id circleProxy = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(circleProxy, TiGooglemapsCircleProxy);
    
    [[circleProxy circle] setMap:[[self mapView] mapView]];
}

-(void)removeCircle:(id)args
{
    id circleProxy = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(circleProxy, TiGooglemapsCircleProxy);
    
    [[circleProxy circle] setMap:nil];
}

-(id)getSelectedMarker:(id)unused
{
    ENSURE_UI_THREAD(selectedMarker, unused);
    GMSMarker *selectedMarker = [[[self mapView] mapView] selectedMarker];
    
    if (selectedMarker == nil) {
        return [NSNull null];
    }
    
    for (TiGooglemapsMarkerProxy *marker in markers) {
        if ([marker marker] == [[[self mapView] mapView] selectedMarker]) {
            return marker;
        }
    }
    return [NSNull null];
}

-(void)selectMarker:(id)args
{
    ENSURE_UI_THREAD(selectMarker, args);
    id markerProxy = [args objectAtIndex:0];
    ENSURE_TYPE(markerProxy, TiGooglemapsMarkerProxy);
    
    [[[self mapView] mapView] setSelectedMarker:[markerProxy marker]];
}

-(void)deselectMarker:(id)unused
{
    ENSURE_UI_THREAD(selectMarker, unused);
    
    [[[self mapView] mapView] setSelectedMarker:nil];
}

-(void)animateToLocation:(id)args
{
    ENSURE_UI_THREAD(animateToLocation, args);
    ENSURE_TYPE(args, NSArray);
    
    id params = [args objectAtIndex:0];
    
    id latitude = [params valueForKey:@"latitude"];
    id longitude = [params valueForKey:@"longitude"];
    
    if (!CLLocationCoordinate2DIsValid(CLLocationCoordinate2DMake([TiUtils doubleValue:latitude], [TiUtils doubleValue:longitude]))) {
        NSLog(@"[ERROR] Ti.GoogleMaps: Invalid location provided. Please check your latitude and longitude.");
        return;
    }
    
    [[[self mapView] mapView] animateToLocation:CLLocationCoordinate2DMake([TiUtils doubleValue:latitude], [TiUtils doubleValue:longitude])];
}

-(void)animateToZoom:(id)value
{
    ENSURE_UI_THREAD(animateToZoom, value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] animateToZoom:[TiUtils floatValue:value]];
}

-(void)animateToBearing:(id)value
{
    ENSURE_UI_THREAD(animateToBearing, value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] animateToBearing:[TiUtils doubleValue:value]];
}

-(void)animateToViewingAngle:(id)value
{
    ENSURE_UI_THREAD(animateToViewingAngle, value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] animateToViewingAngle:[TiUtils doubleValue:value]];
}

@end
