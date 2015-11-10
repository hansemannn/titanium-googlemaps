/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "DeHansknoechelGooglemapsMapView.h"
#import "DeHansknoechelGooglemapsMarkerProxy.h"
#import "DeHansknoechelGooglemapsMapViewProxy.h"

@implementation DeHansknoechelGooglemapsMapView

@synthesize mapView = _mapView;

-(GMSMapView*)mapView
{
    if (_mapView == nil) {
        
        // TODO: Own proxy maps.createCamera({latitude:longitude:zoom})
        // GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
        
        _mapView = [GMSMapView mapWithFrame:self.bounds camera:nil];
        _mapView.delegate = self;
        _mapView.myLocationEnabled = [TiUtils boolValue:[self.proxy valueForKey:@"myLocationEnabled"] def:YES];
        _mapView.userInteractionEnabled = [TiUtils boolValue:[self.proxy valueForKey:@"userInteractionEnabled"] def:YES];
        _mapView.autoresizingMask = UIViewAutoresizingNone;
        
        [self addSubview:_mapView];
    }
    
    return _mapView;
}

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    [TiUtils setView:_mapView positionRect:bounds];
    [super frameSizeChanged:frame bounds:bounds];
}

#pragma mark Public API's

-(void)setMyLocationEnabled_:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [_mapView setMyLocationEnabled:[TiUtils boolValue:value]];
}

-(NSNumber*)myLocationEnabled
{
    return NUMBOOL([[self mapView] isMyLocationEnabled]);
}

-(void)setMapType_:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[self mapView] setMapType:[TiUtils intValue:value def:kGMSTypeNormal]];
}

-(NSNumber*)mapType
{
    return NUMINT([_mapView mapType]);
}


#pragma mark Delegates

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if ([[self proxy] _hasListeners:@"willmove"]) {
        [[self proxy] fireEvent:@"willmove" withObject:@{@"gesture" : NUMBOOL(gesture)}];
    }
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    if ([[self proxy] _hasListeners:@"camerachange"]) {
        [[self proxy] fireEvent:@"camerachange" withObject:[self dictionaryFromCameraPosition:position]];
    }
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    if ([[self proxy] _hasListeners:@"idle"]) {
        [[self proxy] fireEvent:@"idle" withObject:[self dictionaryFromCameraPosition:position]];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if ([[self proxy] _hasListeners:@"click"]) {
        [[self proxy] fireEvent:@"click" withObject:[self dictionaryFromCoordinate:coordinate]];
    }
}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if ([[self proxy] _hasListeners:@"longpress"]) {
        [[self proxy] fireEvent:@"longpress" withObject:[self dictionaryFromCoordinate:coordinate]];
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"markerclick"]) {
        NSDictionary *event = @{
            @"marker" : [self markerProxyFromMarker:marker]
        };
        [[self proxy] fireEvent:@"markerclick" withObject:event];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"markerinfoclick"]) {
        NSDictionary *event = @{
            @"marker" : [self markerProxyFromMarker:marker]
        };
        [[self proxy] fireEvent:@"markerinfoclick" withObject:event];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay
{
   
    if ([overlay isKindOfClass:[GMSPolygon class]]) {
        
    } else if([overlay isKindOfClass:[GMSPolyline class]]) {
        
    } else if([overlay isKindOfClass:[GMSCircle class]]) {
        
    }
    /*
    if ([[self proxy] _hasListeners:@"overlayclick"]) {
        NSDictionary *event = @{
            @"overlay" : [self dictionaryFromOverlay:overlay]
        };
        [[self proxy] fireEvent:@"overlayclick" withObject:event];
    }*/
}

- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"dragstart"]) {
        NSDictionary *event = @{
            @"marker" : [self markerProxyFromMarker:marker]
        };
        [[self proxy] fireEvent:@"dragstart" withObject:event];
    }
}

- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"dragend"]) {
        NSDictionary *event = @{
            @"marker" : [self markerProxyFromMarker:marker]
        };
        [[self proxy] fireEvent:@"dragend" withObject:event];
    }
}

- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"dragmove"]) {
        NSDictionary *event = @{
            @"marker" : [self markerProxyFromMarker:marker]
        };
        [[self proxy] fireEvent:@"dragmove" withObject:event];
    }
}

- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView
{
    if ([[self proxy] _hasListeners:@"locationclick"]) {
        DeHansknoechelGooglemapsMapViewProxy *mapViewProxy = [[DeHansknoechelGooglemapsMapViewProxy alloc] init];
        [mapViewProxy setMapView:mapView];

        NSDictionary *event = @{
            @"mapView" : mapViewProxy
        };
        [[self proxy] fireEvent:@"locationclick" withObject:event];
    }
}

#pragma mark Helper

-(NSDictionary*)dictionaryFromCameraPosition:(GMSCameraPosition*)position
{
    if (position == nil) {
        return @{};
    }
    
    return @{
       @"latitude" : NUMDOUBLE(position.target.latitude),
       @"longitude" : NUMDOUBLE(position.target.longitude),
       @"zoom" : NUMFLOAT(position.zoom),
       @"viewingAngle" : NUMDOUBLE(position.viewingAngle),
       @"bearing" : NUMDOUBLE([position bearing])
    };
}

-(NSDictionary*)dictionaryFromCoordinate:(CLLocationCoordinate2D)coordinate
{
    return @{
        @"latitude": NUMDOUBLE(coordinate.latitude),
        @"longitude": NUMDOUBLE(coordinate.longitude)
    };
}

-(NSDictionary*)dictionaryFromOverlay:(GMSOverlay*)overlay
{
    if (overlay == nil) {
        return @{};
    }
    
    DeHansknoechelGooglemapsMapViewProxy *mapViewProxy = [[DeHansknoechelGooglemapsMapViewProxy alloc] init];
    [mapViewProxy setMapView:[overlay map]];
    
    return @{
        @"title" : overlay.title,
        @"mapView" : mapViewProxy,
        @"tappable": NUMBOOL(overlay.tappable),
        @"zIndex": NUMINT(overlay.zIndex)
    };
}

-(DeHansknoechelGooglemapsMarkerProxy*)markerProxyFromMarker:(GMSMarker*)marker
{
    if (marker == nil) {
        return nil;
    }
    
    DeHansknoechelGooglemapsMarkerProxy* markerProxy = [[DeHansknoechelGooglemapsMarkerProxy alloc] init];
    [markerProxy setMarker:marker];
    
    return markerProxy;
}

@end
