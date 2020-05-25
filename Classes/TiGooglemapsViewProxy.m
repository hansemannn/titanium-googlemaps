/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsViewProxy.h"
#import "TiGooglemapsCameraUpdateProxy.h"
#import "TiGooglemapsClusterItemProxy.h"
#import "TiGooglemapsHeatmapLayerProxy.h"
#import "TiGooglemapsIndoorDisplayProxy.h"
#import "TiGooglemapsTileProxy.h"
#import "TiGooglemapsView.h"
#import "TiUtils.h"
#import "math.h"

#import "GMUMarkerClustering.h"

const CGFloat LN2 = 0.6931471805599453;

@implementation TiGooglemapsViewProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context
{
  if (self = [super _initWithPageContext:context]) {
    q = dispatch_queue_create("ti.googlemaps-annotation-queue", DISPATCH_QUEUE_CONCURRENT);
  }

  return self;
}

- (TiGooglemapsView *)mapView
{
  return (TiGooglemapsView *)[self view];
}

- (NSMutableArray<TiGooglemapsAnnotationProxy *> *)markers
{
  if (markers == nil) {
    markers = [[NSMutableArray alloc] initWithArray:@[]];
  }

  return markers;
}

- (NSMutableArray *)overlays
{
  if (overlays == nil) {
    overlays = [[NSMutableArray alloc] initWithArray:@[]];
  }

  return overlays;
}

#pragma mark Public API's

- (void)setMyLocationButton:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[[self mapView] mapView] settings] setMyLocationButton:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"myLocationButton" notification:NO];
}

- (void)setCompassButton:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[[self mapView] mapView] settings] setCompassButton:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"compassButton" notification:NO];
}

- (void)setIndoorPicker:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[[self mapView] mapView] settings] setIndoorPicker:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"indoorPicker" notification:NO];
}

- (void)setIndoorEnabled:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[self mapView] mapView] setIndoorEnabled:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"indoorEnabled" notification:NO];
}

- (void)setScrollGestures:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[[self mapView] mapView] settings] setScrollGestures:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"scrollGestures" notification:NO];
}

- (void)setZoomGestures:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[[self mapView] mapView] settings] setZoomGestures:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"zoomGestures" notification:NO];
}

- (void)setTiltGestures:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[[self mapView] mapView] settings] setTiltGestures:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"tiltGestures" notification:NO];
}

- (void)setRotateGestures:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[[self mapView] mapView] settings] setRotateGestures:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"rotateGestures" notification:NO];
}

- (void)setConsumesGesturesInView:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[[self mapView] mapView] settings] setConsumesGesturesInView:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"consumesGesturesInView" notification:NO];
}

- (void)setAllowScrollGesturesDuringRotateOrZoom:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[[self mapView] mapView] settings] setAllowScrollGesturesDuringRotateOrZoom:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"allowScrollGesturesDuringRotateOrZoom" notification:NO];
}

- (void)setMyLocationEnabled:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[self mapView] mapView] setMyLocationEnabled:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"myLocationEnabled" notification:NO];
}

- (void)setMapType:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[self mapView] mapView] setMapType:[TiUtils intValue:value def:kGMSTypeNormal]];
  [self replaceValue:value forKey:@"mapType" notification:NO];
}

- (void)setTrafficEnabled:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[[self mapView] mapView] setTrafficEnabled:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"trafficEnabled" notification:NO];
}

- (void)setMapInsets:(id)args
{
  TI_GMS_DEPRECATED(@"View.mapInsets", @"View.padding", @"3.14.0");
  [self setPadding:args];
  [self replaceValue:args forKey:@"mapInsets" notification:NO];
}

- (void)setPadding:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);
  ENSURE_TYPE(args, NSDictionary);

  UIEdgeInsets mapInsets = [TiUtils contentInsets:args];

  [[[self mapView] mapView] setPadding:mapInsets];
  [self replaceValue:args forKey:@"padding" notification:NO];
}

- (void)setRegion:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);
  ENSURE_TYPE(args, NSDictionary);

  double latitude = [TiUtils floatValue:[args valueForKey:@"latitude"]];
  double longitude = [TiUtils floatValue:[args valueForKey:@"longitude"] ];
  double longitudeDelta = [TiUtils floatValue:[args valueForKey:@"longitudeDelta"] def:-1];
  CGFloat zoom = [TiUtils floatValue:[args valueForKey:@"zoom"] def:1];
  CGFloat bearing = [TiUtils floatValue:[args valueForKey:@"bearing"] def:0];
  CGFloat viewingAngle = [TiUtils floatValue:[args valueForKey:@"viewingAngle"] def:0];

  // Generate zoom based on longitude delta
  if ([args valueForKey:@"zoom"] == nil && longitudeDelta != -1) {
    zoom = round(log(360 / longitudeDelta) / LN2);
  } else if ([args valueForKey:@"zoom"] != nil && longitudeDelta != -1) {
    DebugLog(@"[WARN] Found both `zoomLevel` and `longitudeDelta` properties. Please use either of one. Using `zoom` for backwards compatibility …");
  }

  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                          longitude:longitude
                                                               zoom:zoom
                                                            bearing:bearing
                                                       viewingAngle:viewingAngle];

  [[[self mapView] mapView] setCamera:camera];
  [self replaceValue:args forKey:@"region" notification:NO];
}

- (void)setLocation:(id)args
{
  double latitude = [TiUtils floatValue:[args valueForKey:@"latitude"]];
  double longitude = [TiUtils floatValue:[args valueForKey:@"longitude"] ];
  double longitudeDelta = [TiUtils floatValue:[args valueForKey:@"longitudeDelta"] def:-1];
  double zoom = [TiUtils floatValue:[args valueForKey:@"zoom"] def:-1];
  BOOL animate = [TiUtils boolValue:[args valueForKey:@"animate"] def:YES];

  GMSCameraUpdate *update = nil;
  
  if (longitudeDelta != -1) {
    update = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(latitude, longitude)
                          zoom:round(log(360 / longitudeDelta) / LN2)];
  } else if (zoom != -1) {
    update = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(latitude, longitude)
                                   zoom:zoom];
  } else {
    update = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(latitude, longitude)];
  }

  if (animate) {
    [[[self mapView] mapView] animateWithCameraUpdate:update];
  } else {
    [[[self mapView] mapView] moveCamera:update];
  }
}

- (void)setPaddingAdjustmentBehavior:(id)paddingAdjustmentBehavior
{
  ENSURE_UI_THREAD(setPaddingAdjustmentBehavior, paddingAdjustmentBehavior);
  ENSURE_TYPE(paddingAdjustmentBehavior, NSNumber);
  
  [[[self mapView] mapView] setPaddingAdjustmentBehavior:[TiUtils intValue:paddingAdjustmentBehavior]];
}

- (void)paddingAdjustmentBehavior
{
  return @([[[self mapView] mapView] paddingAdjustmentBehavior]);
}

- (void)setMapStyle:(id)value
{
  ENSURE_UI_THREAD(setMapStyle, value);

  if (value == nil) {
    [[[self mapView] mapView] setMapStyle:nil];
  } else if ([value isKindOfClass:[NSString class]]) {
    NSError *error = nil;

    // Pretty simple check to distinguish between a JSON-file and JSON-content. Improve if desired 😙
    if ([[value pathExtension] isEqualToString:@"json"]) {
      [[[self mapView] mapView] setMapStyle:[GMSMapStyle styleWithContentsOfFileURL:[TiUtils toURL:value proxy:self]
                                                                              error:&error]];
    } else {
      [[[self mapView] mapView] setMapStyle:[GMSMapStyle styleWithJSONString:[TiUtils stringValue:value]
                                                                       error:&error]];
    }

    if (error != nil) {
      NSLog(@"[ERROR] Ti.GoogleMaps: Could not apply map style: %@", [error localizedDescription]);
    }
  } else {
    NSLog(@"[ERROR] Invalid map-style provided. Use either a a raw JSON string or a path to your JSON file instead!");
  }
}

- (void)moveCamera:(id)value
{
  ENSURE_UI_THREAD(moveCamera, value);
  ENSURE_SINGLE_ARG(value, TiGooglemapsCameraUpdateProxy);

  [[[self mapView] mapView] moveCamera:[(TiGooglemapsCameraUpdateProxy *)value cameraUpdate]];
}

- (void)animateWithCameraUpdate:(id)value
{
  ENSURE_UI_THREAD(animateWithCameraUpdate, value);
  ENSURE_SINGLE_ARG(value, TiGooglemapsCameraUpdateProxy);

  [[[self mapView] mapView] animateWithCameraUpdate:[(TiGooglemapsCameraUpdateProxy *)value cameraUpdate]];
}

- (void)cluster:(id)unused
{
  ENSURE_UI_THREAD(cluster, unused);

  [[[self mapView] clusterManager] cluster];
}

- (void)addClusterItem:(id)args
{
  ENSURE_SINGLE_ARG(args, TiGooglemapsClusterItemProxy);
  ENSURE_UI_THREAD(addClusterItem, args);

  [[[self mapView] clusterManager] addItem:[(TiGooglemapsClusterItemProxy *)args clusterItem]];
}

- (void)addClusterItems:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);
  ENSURE_UI_THREAD(addClusterItems, args);

  NSMutableArray *items = [NSMutableArray array];

    for (NSUInteger i = 0; i < [args count]; i++) {
      TiGooglemapsClusterItemProxy *clusterItem = [args objectAtIndex:i];
      ENSURE_TYPE(clusterItem, TiGooglemapsClusterItemProxy);

      [items addObject:[(TiGooglemapsClusterItemProxy *)clusterItem clusterItem]];
    }
    [[[self mapView] clusterManager] addItems:items];
}

- (void)setClusterItems:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);

  [[[self mapView] clusterManager] clearItems];

  dispatch_async(dispatch_get_main_queue(), ^{
    [[[self mapView] clusterManager] clearItems];
    [self addClusterItems:args];
  });
}

- (void)removeClusterItem:(id)args
{
  ENSURE_SINGLE_ARG(args, TiGooglemapsClusterItemProxy);

  dispatch_async(dispatch_get_main_queue(), ^{
    [[[self mapView] clusterManager] removeItem:[(TiGooglemapsClusterItemProxy *)args clusterItem]];
  });
}

- (void)clearClusterItems:(id)unused
{
  [[[self mapView] clusterManager] clearItems];
}

- (void)addAnnotation:(id)args
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

- (void)addAnnotations:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);

  for (NSUInteger i = 0; i < [args count]; i++) {
    [self addAnnotation:@[ [args objectAtIndex:i] ]];
  }
}

- (void)removeAnnotation:(id)args
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

- (void)removeAnnotations:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);

  for (NSUInteger i = 0; i < [args count]; i++) {
    [self removeAnnotation:@[ [args objectAtIndex:i] ]];
  }
}

- (void)removeAllAnnotations:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);

  dispatch_barrier_async(q, ^{
    [[self markers] removeAllObjects];

    dispatch_async(dispatch_get_main_queue(), ^{
      [[[self mapView] mapView] clear];
    });
  });
}

- (void)setAnnotations:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);

  dispatch_barrier_async(q, ^{
    for (NSUInteger i = 0; i < [[self markers] count]; i++) {
      [self removeAnnotation:@[ [[self markers] objectAtIndex:i] ]];
    }
  });

  [self addAnnotations:args];
}

- (void)addPolyline:(id)args
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

- (void)removeAllPolylines:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);
  
  dispatch_barrier_async(q, ^{
    [[self overlays] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([obj isKindOfClass:[TiGooglemapsPolylineProxy class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [[(TiGooglemapsPolylineProxy *)obj polyline] setMap:nil];
        });
        [[self overlays] removeObject:obj];
      }
    }];
  });
}

- (void)removePolyline:(id)args
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

- (void)addPolygon:(id)args
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

- (void)removeAllPolygons:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);
  
  dispatch_barrier_async(q, ^{
    [[self overlays] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([obj isKindOfClass:[TiGooglemapsPolygonProxy class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [[(TiGooglemapsPolygonProxy *)obj polygon] setMap:nil];
        });
        [[self overlays] removeObject:obj];
      }
    }];
  });
}

- (void)removePolygon:(id)args
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

- (void)addCircle:(id)args
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

- (void)removeAllCircles:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);
  
  dispatch_barrier_async(q, ^{
    [[self overlays] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([obj isKindOfClass:[TiGooglemapsCircleProxy class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [[(TiGooglemapsCircleProxy *)obj circle] setMap:nil];
        });
        [[self overlays] removeObject:obj];
      }
    }];
  });
}

- (void)removeCircle:(id)args
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

- (void)addTile:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);

  id tileProxy = [args objectAtIndex:0];
  ENSURE_TYPE(tileProxy, TiGooglemapsTileProxy);

  [[tileProxy tile] setMap:[[self mapView] mapView]];
}

- (void)removeTile:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);

  id tileProxy = [args objectAtIndex:0];
  ENSURE_TYPE(tileProxy, TiGooglemapsTileProxy);

  [[tileProxy tile] setMap:nil];
}

- (void)addHeatmapLayer:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);

  id heatmapLayerProxy = [args objectAtIndex:0];
  ENSURE_TYPE(heatmapLayerProxy, TiGooglemapsHeatmapLayerProxy);

  [[heatmapLayerProxy heatmapLayer] setMap:[[self mapView] mapView]];
}

- (void)removeHeatmapLayer:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);

  id heatmapLayerProxy = [args objectAtIndex:0];
  ENSURE_TYPE(heatmapLayerProxy, TiGooglemapsHeatmapLayerProxy);

  [[heatmapLayerProxy heatmapLayer] setMap:nil];
}

- (TiGooglemapsAnnotationProxy *)selectedAnnotation:(id)unused
{
  ENSURE_UI_THREAD(selectedAnnotation, unused);
  GMSMarker *selectedMarker = [[[self mapView] mapView] selectedMarker];

  if (selectedMarker == nil) {
    return nil;
  }

  for (NSUInteger i = 0; i < [[self markers] count]; i++) {
    TiGooglemapsAnnotationProxy *annotation = [[self markers] objectAtIndex:i];
    if ([annotation marker] == [[[self mapView] mapView] selectedMarker]) {
      return annotation;
    }
  }
  return nil;
}

- (void)selectAnnotation:(id)value
{
  ENSURE_UI_THREAD(selectAnnotation, value);
  id annotationProxy = [value objectAtIndex:0];
  ENSURE_TYPE(annotationProxy, TiGooglemapsAnnotationProxy);

  [[[self mapView] mapView] setSelectedMarker:[annotationProxy marker]];
}

- (void)deselectAnnotation:(id)unused
{
  ENSURE_UI_THREAD(deselectAnnotation, unused);
  [[[self mapView] mapView] setSelectedMarker:nil];
}

- (void)animateToLocation:(id)args
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

- (void)animateToZoom:(id)value
{
  ENSURE_UI_THREAD(animateToZoom, value);
  ENSURE_ARG_COUNT(value, 1);
  ENSURE_TYPE([value objectAtIndex:0], NSNumber);

  [[[self mapView] mapView] animateToZoom:[TiUtils floatValue:[value objectAtIndex:0]]];
}

- (void)animateToBearing:(id)value
{
  ENSURE_UI_THREAD(animateToBearing, value);
  ENSURE_ARG_COUNT(value, 1);
  ENSURE_TYPE([value objectAtIndex:0], NSNumber);

  [[[self mapView] mapView] animateToBearing:[TiUtils doubleValue:[value objectAtIndex:0]]];
}

- (void)animateToViewingAngle:(id)value
{
  ENSURE_UI_THREAD(animateToViewingAngle, value);
  ENSURE_ARG_COUNT(value, 1);
  ENSURE_TYPE([value objectAtIndex:0], NSNumber);

  [[[self mapView] mapView] animateToViewingAngle:[TiUtils doubleValue:[value objectAtIndex:0]]];
}

- (id)indoorDisplay
{
  __block TiGooglemapsIndoorDisplayProxy *indoorProxy = nil;

  TiThreadPerformOnMainThread(^{
    indoorProxy = [[TiGooglemapsIndoorDisplayProxy alloc] _initWithPageContext:[self pageContext] andIndoorDisplay:[[[self mapView] mapView] indoorDisplay]];
  },
      YES);

  return indoorProxy;
}

- (NSNumber *)containsCoordinate:(id)annotation
{
  ENSURE_SINGLE_ARG(annotation, NSDictionary);
  
  CLLocationDegrees latitude = [TiUtils doubleValue:annotation[@"latitude"]];
  CLLocationDegrees longitude = [TiUtils doubleValue:annotation[@"longitude"]];

  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
  
  if (![self mapView].mapView) {
    return @(NO);
  }
  
  GMSVisibleRegion region = [self mapView].mapView.projection.visibleRegion;
  GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithRegion:region];
  
  return @([bounds containsCoordinate:coordinate]);
}

- (void)showAnnotations:(id)args
{
  ENSURE_UI_THREAD(showAnnotations, args);
  
  NSMutableArray *markersToUse = [NSMutableArray array];
  CGFloat padding = 40;
  NSArray *annotations = [(NSArray *)args objectAtIndex:0];
  BOOL animated = NO;
  
  if ([args count] > 1) {
    ENSURE_TYPE(args[1], NSNumber);
    padding = [TiUtils floatValue:args[1]];
  }

  if ([args count] > 2) {
    ENSURE_TYPE(args[2], NSNumber);
    animated = [TiUtils boolValue:args[2]];
  }

  if (args != nil && [(NSArray *)annotations count] > 0) {
    [annotations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      [markersToUse addObject:[(TiGooglemapsAnnotationProxy *)obj marker]];
    }];
  } else {
    markersToUse = [[self markers] mutableCopy];
  }

  GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];

  for (GMSMarker *marker in markersToUse) {
    bounds = [bounds includingCoordinate:marker.position];
  }

  GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:padding];
  
  if (animated) {
    [self.mapView.mapView animateWithCameraUpdate:update];
  } else {
    [self.mapView.mapView moveCamera:update];
  }
}

- (NSArray<TiGooglemapsAnnotationProxy *> *)annotations
{
  return markers;
}

- (NSArray<TiGooglemapsPolylineProxy *> *)polylines
{
  NSMutableArray<TiGooglemapsPolylineProxy *> *polylines = [NSMutableArray array];
  
  [overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj isKindOfClass:TiGooglemapsPolylineProxy.class]) {
      [polylines addObject:obj];
    }
  }];
  
  return polylines;
}

- (NSArray<TiGooglemapsPolygonProxy *> *)polygons
{
  NSMutableArray<TiGooglemapsPolygonProxy *> *polygons = [NSMutableArray array];
  
  [overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj isKindOfClass:TiGooglemapsPolygonProxy.class]) {
      [polygons addObject:obj];
    }
  }];
  
  return polygons;
}

- (NSArray<TiGooglemapsCircleProxy *> *)circles
{
  NSMutableArray<TiGooglemapsCircleProxy *> *circles = [NSMutableArray array];
  
  [overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj isKindOfClass:TiGooglemapsCircleProxy.class]) {
      [circles addObject:obj];
    }
  }];
  
  return circles;
}

- (NSNumber *)zoom
{
  return @([[self mapView] mapView].camera.zoom);
}

- (void)setClusterConfiguration:(NSDictionary<NSString *,id> *)clusterConfiguration
{
  NSArray<NSNumber *> *ranges = clusterConfiguration[@"ranges"];
  NSArray<NSString *> *rangeBackgrounds = clusterConfiguration[@"rangeBackgrounds"];
  NSUInteger minimumClusterSize = [TiUtils intValue:clusterConfiguration[@"minimumClusterSize"] def:4];
  NSUInteger maximumClusterZoom = [TiUtils intValue:clusterConfiguration[@"maximumClusterZoom"] def:20];
  double animationDuration = [TiUtils doubleValue:clusterConfiguration[@"animationDuration"] def:0.5];

  [self mapView].clusterRenderer.minimumClusterSize = minimumClusterSize;
  [self mapView].clusterRenderer.maximumClusterZoom = maximumClusterZoom;
  [self mapView].clusterRenderer.animationDuration = animationDuration;
  
  // Set the proxy values to the old keys for background compatibility
  [self replaceValue:ranges forKey:@"clusterRanges" notification:NO];
  [self replaceValue:rangeBackgrounds forKey:@"clusterBackgrounds" notification:NO];
}

@end
