/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsView.h"
#import "TiGooglemapsViewProxy.h"
#import "TiGooglemapsAnnotationProxy.h"
#import "TiGooglemapsCircleProxy.h"
#import "TiGooglemapsPolygonProxy.h"
#import "TiGooglemapsPolylineProxy.h"
#import "TiGooglemapsConstants.h"

@implementation TiGooglemapsView

@synthesize mapView = _mapView;

#define DEPRECATED(from, to, in) \
NSLog(@"[WARN] Ti.GoogleMaps: %@ is deprecated since %@ in favor of %@", from, to, in);\

-(GMSMapView*)mapView
{
    if (_mapView == nil) {

        _mapView = [[GMSMapView alloc] initWithFrame:[self bounds]];
        [_mapView setDelegate:self];
        [_mapView setMyLocationEnabled:[TiUtils boolValue:[self.proxy valueForKey:@"myLocationEnabled"] def:YES]];
        [_mapView setUserInteractionEnabled:[TiUtils boolValue:[self.proxy valueForKey:@"userInteractionEnabled"] def:YES]];
        [_mapView setAutoresizingMask:UIViewAutoresizingNone];

        [self addSubview:_mapView];
    }

    return _mapView;
}

-(TiGooglemapsViewProxy*)mapViewProxy
{
    return (TiGooglemapsViewProxy*)[self proxy];
}

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    [TiUtils setView:_mapView positionRect:bounds];
    [super frameSizeChanged:frame bounds:bounds];
}

#pragma mark Delegates

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if ([[self proxy] _hasListeners:@"willmove"]) {
        DEPRECATED(@"Event.willmove", @"Event.regionwillchange", @"2.2.0");
        [[self proxy] fireEvent:@"willmove" withObject:@{@"gesture" : NUMBOOL(gesture)}];
    }
    if ([[self proxy] _hasListeners:@"regionwillchange"]) {
        [[self proxy] fireEvent:@"regionwillchange" withObject:@{
            @"map" : [self proxy],
            @"latitude" : NUMDOUBLE(mapView.camera.target.latitude),
            @"longitude" : NUMDOUBLE(mapView.camera.target.longitude),
            @"gesture" : NUMBOOL(gesture)
        }];
    }
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    if ([[self proxy] _hasListeners:@"camerachange"]) {
        DEPRECATED(@"Event.camerachange", @"Event.regionchanged", @"2.2.0");
        [[self proxy] fireEvent:@"camerachange" withObject:[self dictionaryFromCameraPosition:position]];
    }
    if ([[self proxy] _hasListeners:@"regionchanged"]) {
        [[self proxy] fireEvent:@"regionchanged" withObject:@{
            @"map" : [self proxy],
            @"latitude" : NUMDOUBLE(position.target.latitude),
            @"longitude" : NUMDOUBLE(position.target.longitude),
        }];
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
        [[self proxy] fireEvent:@"click" withObject:@{
            @"clicksource": @"map",
            @"map": [self proxy],
            @"latitude": NUMDOUBLE(coordinate.latitude),
            @"longitude": NUMDOUBLE(coordinate.longitude)
        }];
    }
}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if ([[self proxy] _hasListeners:@"longpress"]) {
        DEPRECATED(@"Event.longpress", @"Event.longclick", @"2.2.0");
        [[self proxy] fireEvent:@"longpress" withObject:[self dictionaryFromCoordinate:coordinate]];
    }
    if ([[self proxy] _hasListeners:@"longclick"]) {
        [[self proxy] fireEvent:@"longclick" withObject:@{
            @"map": [self proxy],
            @"latitude": NUMDOUBLE(coordinate.latitude),
            @"longitude": NUMDOUBLE(coordinate.longitude)
        }];
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"markerclick"]) {
        DEPRECATED(@"Event.markerclick", @"Event.click", @"2.2.0");
        NSDictionary *event = @{
            @"marker" : [self annotationProxyFromMarker:marker]
        };
        [[self proxy] fireEvent:@"markerclick" withObject:event];
    }
    if ([[self proxy] _hasListeners:@"click"]) {
        [[self proxy] fireEvent:@"click" withObject:@{
            @"clicksource": @"pin",
            @"annotation": [self annotationProxyFromMarker:marker],
            @"map": [self proxy],
            @"latitude": NUMDOUBLE(marker.position.latitude),
            @"longitude": NUMDOUBLE(marker.position.longitude)
        }];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"markerinfoclick"]) {
        DEPRECATED(@"Event.markerinfoclick", @"Event.click", @"2.2.0");
        NSDictionary *event = @{
            @"marker" : [self annotationProxyFromMarker:marker]
        };
        [[self proxy] fireEvent:@"markerinfoclick" withObject:event];
    }
    if ([[self proxy] _hasListeners:@"click"]) {
        [[self proxy] fireEvent:@"click" withObject:@{
            @"clicksource": @"infoWindow",
            @"annotation": [self annotationProxyFromMarker:marker],
            @"map": [self proxy],
            @"latitude": NUMDOUBLE(marker.position.latitude),
            @"longitude": NUMDOUBLE(marker.position.longitude)
        }];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay
{
    if ([[self proxy] _hasListeners:@"overlayclick"]) {
        [[self proxy] fireEvent:@"overlayclick" withObject:@{
            @"overlay": [self overlayProxyFromOverlay:overlay]
        }];
    }
    if ([[self proxy] _hasListeners:@"click"]) {
        [[self proxy] fireEvent:@"click" withObject:@{
            @"clicksource": NUMINT([self overlayTypeFromOverlay:overlay]),
            @"map": [self proxy],
            @"overlay": [self overlayProxyFromOverlay:overlay]
        }];
    }
}

- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"dragstart"]) {
        NSDictionary *event = @{
            @"marker" : [self annotationProxyFromMarker:marker], // Deprecated
            @"annotation" : [self annotationProxyFromMarker:marker]
        };
        [[self proxy] fireEvent:@"dragstart" withObject:event];
    }
}

- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"dragend"]) {
        NSDictionary *event = @{
            @"marker" : [self annotationProxyFromMarker:marker], // Deprecated
            @"annotation" : [self annotationProxyFromMarker:marker]
        };
        [[self proxy] fireEvent:@"dragend" withObject:event];
    }
}

- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"dragmove"]) {
        NSDictionary *event = @{
            @"marker" : [self annotationProxyFromMarker:marker], // Deprecated
            @"annotation" : [self annotationProxyFromMarker:marker]
        };
        [[self proxy] fireEvent:@"dragmove" withObject:event];
    }
}

- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView
{
    if ([[self proxy] _hasListeners:@"locationclick"]) {
        NSDictionary *event = @{
            @"map" : [self proxy]
        };
        [[self proxy] fireEvent:@"locationclick" withObject:event];
    }
}

- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView
{
    if ([[self proxy] _hasListeners:@"complete"]) {
        [[self proxy] fireEvent:@"complete"];
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

-(TiGooglemapsOverlayType)overlayTypeFromOverlay:(GMSOverlay*)overlay
{
    ENSURE_UI_THREAD(overlayTypeFromOverlay, overlay);

    if([overlay isKindOfClass:[GMSPolygon class]]) {
        return TiGooglemapsOverlayTypePolygon;
    } else if([overlay isKindOfClass:[GMSPolyline class]]) {
        return TiGooglemapsOverlayTypePolyline;
    } else if([overlay isKindOfClass:[GMSCircle class]]) {
        return TiGooglemapsOverlayTypeCircle;
    }
    
    NSLog(@"[WARN] Unknown overlay provided: %@", [overlay class])
    return [NSNull null];
}

-(id)annotationProxyFromMarker:(GMSMarker*)marker
{
    for (TiGooglemapsAnnotationProxy* annotationProxy in [[self mapViewProxy] markers]) {
        if ([annotationProxy marker] == marker) {
            // Replace the location attributes in the array of annotation-proxies
            NSLock* arrayLock = [NSLock new];
            [arrayLock lock];
            TiGooglemapsAnnotationProxy *newAnnotation = [annotationProxy mutableCopy];
            [newAnnotation updateLocation:@{
                @"latitude": NUMDOUBLE([marker position].latitude),
                @"longitude": NUMDOUBLE([marker position].longitude)
            }];
            NSMutableArray *newMarkers = [NSMutableArray arrayWithArray:[[self mapViewProxy] markers]];
            [newMarkers replaceObjectAtIndex:[newMarkers indexOfObject:annotationProxy] withObject:newAnnotation];
            [[self mapViewProxy] setMarkers:newMarkers];
            [arrayLock unlock];
            RELEASE_TO_NIL(newAnnotation);
            RELEASE_TO_NIL(arrayLock);
            
            return newAnnotation;
        }
    }

    return [NSNull null];
}

-(id)overlayProxyFromOverlay:(GMSOverlay*)overlay
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

MAKE_SYSTEM_PROP(OVERLAY_TYPE_POLYGON, TiGooglemapsOverlayTypePolygon);
MAKE_SYSTEM_PROP(OVERLAY_TYPE_POLYLINE, TiGooglemapsOverlayTypePolyline);
MAKE_SYSTEM_PROP(OVERLAY_TYPE_CIRCLE, TiGooglemapsOverlayTypeCircle);

@end
