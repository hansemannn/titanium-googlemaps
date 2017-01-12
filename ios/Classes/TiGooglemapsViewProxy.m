/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-Present by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsView.h"
#import "TiGooglemapsViewProxy.h"
#import "TiGooglemapsPolylineProxy.h"
#import "TiGooglemapsPolygonProxy.h"
#import "TiGooglemapsCircleProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsViewProxy

#define DEPRECATED(from, to, in) \
NSLog(@"[WARN] Ti.GoogleMaps: %@ is deprecated since %@ in favor of %@", from, to, in);\

-(id)_initWithPageContext:(id<TiEvaluator>)context
{
    q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    return [super _initWithPageContext:context];
}

-(void)dealloc
{
    RELEASE_TO_NIL(mapView);
    RELEASE_TO_NIL(markers);
    RELEASE_TO_NIL(overlays);
    
    dispatch_release(q);
    
    [super dealloc];
}

-(TiGooglemapsView*)mapView
{
    return (TiGooglemapsView*)[self view];
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

-(void)setMarkers:(NSMutableArray*)_markers
{
    [markers removeAllObjects];
    RELEASE_TO_NIL(markers);
    markers = [[_markers mutableCopy] retain];
}

#pragma mark Public API's

-(void)setUserInteractionEnabled:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] setUserInteractionEnabled:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"userInteractionEnabled" notification:NO];
}

-(void)setMyLocationButton:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setMyLocationButton:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"myLocationButton" notification:NO];
}

-(void)setCompassButton:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setCompassButton:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"compassButton" notification:NO];
}

-(void)setIndoorPicker:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setIndoorPicker:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"indoorPicker" notification:NO];
}

-(void)setIndoorEnabled:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] setIndoorEnabled:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"indoorEnabled" notification:NO];
}

-(void)setScrollGestures:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setScrollGestures:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"scrollGestures" notification:NO];
}

-(void)setZoomGestures:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setZoomGestures:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"zoomGestures" notification:NO];
}

-(void)setTiltGestures:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setTiltGestures:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"tiltGestures" notification:NO];
}

-(void)setRotateGestures:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setRotateGestures:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"rotateGestures" notification:NO];
}

-(void)setConsumesGesturesInView:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setConsumesGesturesInView:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"consumesGesturesInView" notification:NO];
}

-(void)setAllowScrollGesturesDuringRotateOrZoom:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setAllowScrollGesturesDuringRotateOrZoom:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"allowScrollGesturesDuringRotateOrZoom" notification:NO];
}

-(void)setMyLocationEnabled:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] setMyLocationEnabled:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"myLocationEnabled" notification:NO];
}

-(void)setMapType:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] setMapType:[TiUtils intValue:value def:kGMSTypeNormal]];
    [self replaceValue:value forKey:@"mapType" notification:NO];
}

-(void)setTrafficEnabled:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] setTrafficEnabled:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"trafficEnabled" notification:NO];
}

-(void)setMapInsets:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(args, NSDictionary);
    
    UIEdgeInsets mapInsets = [TiUtils contentInsets:args];
    
    [[[self mapView] mapView] setPadding:mapInsets];
    [self replaceValue:args forKey:@"mapInsets" notification:NO];
}

-(void)setCamera:(id)args
{
    DEPRECATED(@"MapView.camera", @"View.region", @"2.2.0");
    [self setRegion:args];
}

-(void)setRegion:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(args, NSDictionary);
    
    id latitude = [args valueForKey:@"latitude"];
    id longitude = [args valueForKey:@"longitude"];
    id zoom = [args valueForKey:@"zoom"];
    id bearing = [args valueForKey:@"bearing"];
    id viewingAngle = [args valueForKey:@"viewingAngle"];
    
    ENSURE_TYPE(latitude, NSNumber);
    ENSURE_TYPE(longitude, NSNumber)
    ENSURE_TYPE_OR_NIL(zoom, NSNumber);
    ENSURE_TYPE_OR_NIL(bearing, NSNumber);
    ENSURE_TYPE_OR_NIL(viewingAngle, NSNumber);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[TiUtils doubleValue:latitude]
                                                            longitude:[TiUtils doubleValue:longitude]
                                                                 zoom:[TiUtils floatValue:zoom def:1]
                                                              bearing:[TiUtils floatValue:bearing def:0]
                                                         viewingAngle:[TiUtils floatValue:viewingAngle def:0]];
    
    [[[self mapView] mapView] setCamera:camera];
    [self replaceValue:args forKey:@"region" notification:NO];
}

-(void)setMapStyle:(id)value
{
    ENSURE_UI_THREAD(setMapStyle, value);
        
    if (value == nil) {
        [[[self mapView] mapView] setMapStyle:nil];
    } else {
        NSError *error = nil;
        [[[self mapView] mapView] setMapStyle:[GMSMapStyle styleWithJSONString:[TiUtils stringValue:value] error:&error]];
        
        if (error) {
            NSLog(@"[ERROR] Ti.GoogleMaps: Could not apply map style: %@", [error localizedDescription]);
        }
        
        RELEASE_TO_NIL(error);
    }
}

-(void)addAnnotation:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, TiGooglemapsAnnotationProxy);

    TiGooglemapsAnnotationProxy *annotationProxy = args;
    
    dispatch_barrier_async(q, ^{
        [[self markers] addObject:annotationProxy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[annotationProxy marker] setMap:[[self mapView] mapView]];
        });
    });
}

-(void)addAnnotations:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSArray);
    
    for(TiGooglemapsAnnotationProxy *annotationProxy in args) {
        [self addAnnotation:@[annotationProxy]];
    }
}

-(void)removeAnnotation:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, TiGooglemapsAnnotationProxy);
    
    TiGooglemapsAnnotationProxy *annotationProxy = args;
    
    dispatch_barrier_async(q, ^{
        [[self markers] removeObject:annotationProxy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[annotationProxy marker] setMap:nil];
        });
    });
}

-(void)removeAnnotations:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSArray);

    for(TiGooglemapsAnnotationProxy *annotationProxy in args) {
        [self removeAnnotation:@[annotationProxy]];
    }
}

-(void)removeAllAnnotations:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    
    dispatch_barrier_async(q, ^{
        [[self markers] removeAllObjects];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[self mapView] mapView] clear];
        });
    });
}

-(void)setAnnotations:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    dispatch_barrier_async(q, ^{
        for(TiGooglemapsAnnotationProxy *annotationProxy in [self markers]) {
            [self removeAnnotation:@[annotationProxy]];
        }
    });
    
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
    
    dispatch_barrier_async(q, ^{
        [[self overlays] addObject:polylineProxy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[polylineProxy polyline] setMap:[[self mapView] mapView]];
        });
    });
}

-(void)removePolyline:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id polylineProxy = [args objectAtIndex:0];
    ENSURE_TYPE(polylineProxy, TiGooglemapsPolylineProxy);
    
    dispatch_barrier_async(q, ^{
        [[self overlays] removeObject:polylineProxy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[polylineProxy polyline] setMap:nil];
        });
    });
}

-(void)addPolygon:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id polygonProxy = [args objectAtIndex:0];
    ENSURE_TYPE(polygonProxy, TiGooglemapsPolygonProxy);
    
    dispatch_barrier_async(q, ^{
        [[self overlays] addObject:polygonProxy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[polygonProxy polygon] setMap:[[self mapView] mapView]];
        });
    });
}

-(void)removePolygon:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id polygonProxy = [args objectAtIndex:0];
    ENSURE_TYPE(polygonProxy, TiGooglemapsPolygonProxy);
    
    dispatch_barrier_async(q, ^{
        [[self overlays] removeObject:polygonProxy];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[polygonProxy polygon] setMap:nil];
        });
    });
}

-(void)addCircle:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id circleProxy = [args objectAtIndex:0];
    ENSURE_TYPE(circleProxy, TiGooglemapsCircleProxy);
    
    dispatch_barrier_async(q, ^{
        [[self overlays] addObject:circleProxy];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[circleProxy circle] setMap:[[self mapView] mapView]];
        });
    });
}

-(void)removeCircle:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id circleProxy = [args objectAtIndex:0];
    ENSURE_TYPE(circleProxy, TiGooglemapsCircleProxy);
    
    dispatch_barrier_async(q, ^{
        [[self overlays] removeObject:circleProxy];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[circleProxy circle] setMap:nil];
        });
    });
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
    
    for (TiGooglemapsAnnotationProxy *annotation in [self markers]) {
        if ([annotation marker] == [[[self mapView] mapView] selectedMarker]) {
            return annotation;
        }
    }
    return [NSNull null];
}

-(void)selectMarker:(id)value
{
    DEPRECATED(@"MapView.selectMarker()", @"View.selectAnnotation()", @"2.2.0");
    [self selectAnnotation:value];
}

-(void)selectAnnotation:(id)value
{
    ENSURE_UI_THREAD(selectAnnotation, value);
    id annotationProxy = [value objectAtIndex:0];
    ENSURE_TYPE(annotationProxy, TiGooglemapsAnnotationProxy);
    
    [[[self mapView] mapView] setSelectedMarker:[annotationProxy marker]];
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
    ENSURE_ARG_COUNT(value, 1);
    ENSURE_TYPE([value objectAtIndex:0], NSNumber);
    
    [[[self mapView] mapView] animateToZoom:[TiUtils floatValue:[value objectAtIndex:0]]];
}

-(void)animateToBearing:(id)value
{
    ENSURE_UI_THREAD(animateToBearing, value);
    ENSURE_ARG_COUNT(value, 1);
    ENSURE_TYPE([value objectAtIndex:0], NSNumber);
    
    [[[self mapView] mapView] animateToBearing:[TiUtils doubleValue:[value objectAtIndex:0]]];
}

-(void)animateToViewingAngle:(id)value
{
    ENSURE_UI_THREAD(animateToViewingAngle, value);
    ENSURE_ARG_COUNT(value, 1);
    ENSURE_TYPE([value objectAtIndex:0], NSNumber);
    
    [[[self mapView] mapView] animateToViewingAngle:[TiUtils doubleValue:[value objectAtIndex:0]]];
}

@end
