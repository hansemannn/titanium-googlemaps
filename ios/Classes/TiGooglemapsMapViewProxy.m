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

#define DEPRECATED(from, to, in) \
NSLog(@"[WARN] Ti.GoogleMaps: %@ is deprecated since %@ in favor of %@", from, to, in);\

-(void)dealloc
{
    RELEASE_TO_NIL(mapView);
    RELEASE_TO_NIL(markers);
    RELEASE_TO_NIL(overlays);
    
    [super dealloc];
}

-(TiGooglemapsMapView*)mapView
{
    return (TiGooglemapsMapView*)[self view];
}

-(NSMutableArray*)markers
{
    if (markers == nil) {
        markers = [[NSMutableArray alloc] initWithArray:@[]];
    }
    
    return markers;
}

-(NSMutableArray*)overlays
{
    if (overlays == nil) {
        overlays = [[NSMutableArray alloc] initWithArray:@[]];
    }
    
    return overlays;
}

#pragma mark Public API's

-(void)addAnnotation:(id)args
{
    id markerProxy = [args objectAtIndex:0];
    
    ENSURE_TYPE(markerProxy, TiGooglemapsMarkerProxy);
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[markerProxy marker] setMap:[[self mapView] mapView]];
    [[self markers] addObject:markerProxy];
}

-(void)addAnnotations:(id)args
{
    id markerProxies = [args objectAtIndex:0];
    
    ENSURE_TYPE(markerProxies, NSArray);
    ENSURE_UI_THREAD_1_ARG(args);
    
    for(TiGooglemapsMarkerProxy *markerProxy in markerProxies) {
        [[markerProxy marker] setMap:[[self mapView] mapView]];
        [[self markers] addObject:markerProxy];
    }
}

-(void)removeAnnotation:(id)args
{
    id markerProxy = [args objectAtIndex:0];
    
    ENSURE_TYPE(markerProxy, TiGooglemapsMarkerProxy);
    ENSURE_UI_THREAD_1_ARG(args);
    
    [[markerProxy marker] setMap:nil];
    [[self markers] removeObject:markerProxy];
}

-(void)setAnnotations:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    for(TiGooglemapsMarkerProxy *markerProxy in [self markers]) {
        [[markerProxy marker] setMap:nil];
        [[self markers] removeObject:markerProxy];
    }
    
    [self addAnnotations:args];
}

-(void)addMarker:(id)args
{
    DEPRECATED(@"addMarker", @"addAnnotation", "2.2.0");
    [self addAnnotation:args];
}

-(void)addMarkers:(id)args
{
    DEPRECATED(@"addMarkers", @"addAnnotations", "2.2.0");
    [self addAnnotations:args];
}

-(void)removeMarker:(id)args
{
    DEPRECATED(@"removeMarker", @"removeAnnotation", "2.2.0");
    [self removeAnnotation:args];
}

-(void)addPolyline:(id)args
{
    id polylineProxy = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polylineProxy, TiGooglemapsPolylineProxy);
    
    [[polylineProxy polyline] setMap:[[self mapView] mapView]];
    [[self overlays] addObject:polylineProxy];
}

-(void)removePolyline:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id polylineProxy = [args objectAtIndex:0];
    ENSURE_TYPE(polylineProxy, TiGooglemapsPolylineProxy);
    
    [[polylineProxy polyline] setMap:nil];
    [[self overlays] removeObject:polylineProxy];
}

-(void)addPolygon:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id polygonProxy = [args objectAtIndex:0];
    ENSURE_TYPE(polygonProxy, TiGooglemapsPolygonProxy);
    
    [[polygonProxy polygon] setMap:[[self mapView] mapView]];
    [[self overlays] addObject:polygonProxy];
}

-(void)removePolygon:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id polygonProxy = [args objectAtIndex:0];
    ENSURE_TYPE(polygonProxy, TiGooglemapsPolygonProxy);
    
    [[polygonProxy polygon] setMap:nil];
    [[self overlays] removeObject:polygonProxy];
}

-(void)addCircle:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id circleProxy = [args objectAtIndex:0];
    ENSURE_TYPE(circleProxy, TiGooglemapsCircleProxy);
    
    [[circleProxy circle] setMap:[[self mapView] mapView]];
    [[self overlays] addObject:circleProxy];
}

-(void)removeCircle:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id circleProxy = [args objectAtIndex:0];
    ENSURE_TYPE(circleProxy, TiGooglemapsCircleProxy);
    
    [[circleProxy circle] setMap:nil];
    [[self overlays] removeObject:circleProxy];
}

-(id)getSelectedMarker:(id)unused
{
    DEPRECATED(@"getSelectedMarker()", @"getSelectedAnnotation()", @"2.2.0");
    [self getSelectedAnnotation:unused];
}

-(id)getSelectedAnnotation:(id)unused
{
    ENSURE_UI_THREAD(getSelectedAnnotation, unused);
    GMSMarker *selectedMarker = [[[self mapView] mapView] selectedMarker];
    
    if (selectedMarker == nil) {
        return [NSNull null];
    }
    
    for (TiGooglemapsMarkerProxy *marker in [self markers]) {
        if ([marker marker] == [[[self mapView] mapView] selectedMarker]) {
            return marker;
        }
    }
    return [NSNull null];
}

-(void)selectMarker:(id)value
{
    DEPRECATED(@"selectMarker()", @"selectAnnotation()", @"2.2.0");
    [self selectAnnotation:value];
}

-(void)selectAnnotation:(id)value
{
    ENSURE_UI_THREAD(selectAnnotation, value);
    id markerProxy = [value objectAtIndex:0];
    ENSURE_TYPE(markerProxy, TiGooglemapsMarkerProxy);
    
    [[[self mapView] mapView] setSelectedMarker:[markerProxy marker]];
}

-(void)deselectMarker:(id)unused
{
    DEPRECATED(@"deselectMarker()", @"deselectAnnotation()", @"2.2.0");
    [self deselectAnnotation:unused];
}

-(void)deselectAnnotation:(id)unused
{
    ENSURE_UI_THREAD(deselectAnnotation, unused);
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
