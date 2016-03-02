/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsMapView.h"
#import "TiGooglemapsMarkerProxy.h"
#import "TiGooglemapsMapViewProxy.h"
#import "TiGooglemapsCircleProxy.h"
#import "TiGooglemapsPolygonProxy.h"
#import "TiGooglemapsPolylineProxy.h"

@implementation TiGooglemapsMapView

@synthesize mapView = _mapView;

-(GMSMapView*)mapView
{
    if (_mapView == nil) {
        
        _mapView = [GMSMapView mapWithFrame:self.bounds camera:nil];
        _mapView.delegate = self;
        _mapView.myLocationEnabled = [TiUtils boolValue:[self.proxy valueForKey:@"myLocationEnabled"] def:YES];
        _mapView.userInteractionEnabled = [TiUtils boolValue:[self.proxy valueForKey:@"userInteractionEnabled"] def:YES];
        _mapView.autoresizingMask = UIViewAutoresizingNone;
        
        [self addSubview:_mapView];
    }
    
    return _mapView;
}

-(TiGooglemapsMapViewProxy*)mapViewProxy
{
    return (TiGooglemapsMapViewProxy*)[self proxy];
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
    [[self proxy] replaceValue:value forKey:@"myLocationEnabled" notification:NO];
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
    [[self proxy] replaceValue:value forKey:@"mapType" notification:NO];
}

-(NSNumber*)mapType
{
    return NUMINT([_mapView mapType]);
}

-(void)setCamera_:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(args, NSDictionary);
    
    id latitude = [args valueForKey:@"latitude"];
    id longitude = [args valueForKey:@"longitude"];
    id zoom = [args valueForKey:@"zoom"];
    
    ENSURE_TYPE(latitude, NSNumber);
    ENSURE_TYPE(longitude, NSNumber)
    ENSURE_TYPE_OR_NIL(zoom, NSNumber);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[TiUtils doubleValue:latitude]
                                                            longitude:[TiUtils doubleValue:longitude]
                                                                 zoom:[TiUtils floatValue:zoom def:1]];
    [[self mapView] setCamera:camera];
    
    [[self proxy] replaceValue:args forKey:@"camera" notification:NO];
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
    if ([[self proxy] _hasListeners:@"overlayclick"]) {
        [[self proxy] fireEvent:@"overlayclick" withObject:[self dictionaryFromOverlay:overlay]];
    }
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
        NSDictionary *event = @{
            @"mapView" : [self proxy]
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
    ENSURE_UI_THREAD(dictionaryFromOverlay, overlay);
    
    NSString *type = nil;
    
    // Todo: Create constants
    if([overlay isKindOfClass:[GMSPolygon class]]) {
        type = @"polygon";
    } else if([overlay isKindOfClass:[GMSPolyline class]]) {
        type = @"polyline";
    } else if([overlay isKindOfClass:[GMSCircle class]]) {
        type = @"circle";
    }
    
    return @{
        @"overlayType" : type,
        @"overlay" : [self overlayProxyFromOverlay:overlay withType:type]
    };
}

-(TiGooglemapsMarkerProxy*)markerProxyFromMarker:(GMSMarker*)marker
{
    for (TiGooglemapsMarkerProxy* markerProxy in [[self mapViewProxy] markers]) {
        if ([markerProxy marker] == marker) {
            return markerProxy;
        }
    }
    
    return [NSNull null];
}

-(TiProxy*)overlayProxyFromOverlay:(GMSOverlay*)overlay withType:(NSString*)type
{
    for (TiProxy* overlayProxy in [[self mapViewProxy] overlays]) {
        
        // Check for polygons
        if ([overlay isKindOfClass:[GMSPolygon class]] && [overlayProxy isKindOfClass:[TiGooglemapsPolygonProxy class]]) {
            if ([(TiGooglemapsPolygonProxy*)overlayProxy polygon] == overlay) {
                return (TiGooglemapsPolygonProxy*)overlayProxy;
            }
        
        // Check for polylines
        } else if ([overlay isKindOfClass:[GMSPolyline class]] && [overlayProxy isKindOfClass:[TiGooglemapsPolylineProxy class]]) {
            if ([(TiGooglemapsPolylineProxy*)overlayProxy polyline] == overlay) {
                return (TiGooglemapsPolylineProxy*)overlayProxy;
            }
        
        // Check for circles
        } else if ([overlay isKindOfClass:[GMSCircle class]] && [overlayProxy isKindOfClass:[TiGooglemapsCircleProxy class]]) {
            if ([(TiGooglemapsCircleProxy*)overlayProxy circle] == overlay) {
                return (TiGooglemapsCircleProxy*)overlayProxy;
            }
        }
    }

    return [NSNull null];
}

@end
