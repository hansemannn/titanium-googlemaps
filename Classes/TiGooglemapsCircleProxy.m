/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsCircleProxy.h"

@implementation TiGooglemapsCircleProxy

- (GMSCircle *)circle
{
  if (_circle == nil) {
    _circle = [GMSCircle new];
    _circle.tappable = YES;
  }

  return _circle;
}

#pragma mark Public APIs

- (void)setCenter:(id)args
{
  ENSURE_UI_THREAD(setCenter, args);

  if (![args isKindOfClass:[NSArray class]] && ![args isKindOfClass:[NSDictionary class]]) {
    NSLog(@"[WARN] Ti.GoogleMaps: You need to specify the center either using an array or object.");
    return;
  }

  CLLocationCoordinate2D position = [self positionFromPoint:args];

  // Maps SDK 9.4 and 11.2 crash in -[GMSCircle setMap:] for an invalid center.
  // A common cause is passing [latitude, longitude] instead of [longitude, latitude].
  if (!CLLocationCoordinate2DIsValid(position)) {
    NSLog(@"[ERROR] Ti.GoogleMaps: Invalid circle center. Use { latitude, longitude } or a [longitude, latitude] array.");
    return;
  }

  [self replaceValue:args forKey:@"center" notification:NO];
  [[self circle] setPosition:position];

  GMSMapView *pendingMapView = [self pendingMapView];
  if (pendingMapView != nil && [[self circle] map] == nil) {
    [[self circle] setMap:pendingMapView];
  }
  [self setPendingMapView:nil];
}

- (void)setRadius:(id)value
{
  ENSURE_UI_THREAD(setRadius, value);
  ENSURE_TYPE(value, NSNumber);

  [[self circle] setRadius:[TiUtils doubleValue:value]];
  [self replaceValue:value forKey:@"radius" notification:NO];
}

- (void)setTappable:(id)value
{
  ENSURE_UI_THREAD(setTappable, value);
  ENSURE_TYPE(value, NSNumber);

  [[self circle] setTappable:[TiUtils boolValue:value]];
  [self replaceValue:value forKey:@"tappable" notification:NO];
}

- (void)setFillColor:(id)value
{
  ENSURE_UI_THREAD(setFillColor, value);

  [[self circle] setFillColor:[[TiUtils colorValue:value] _color]];
  [self replaceValue:value forKey:@"fillColor" notification:NO];
}

- (void)setStrokeColor:(id)value
{
  ENSURE_UI_THREAD(setStrokeColor, value);

  [[self circle] setStrokeColor:[[TiUtils colorValue:value] _color]];
  [self replaceValue:value forKey:@"strokeColor" notification:NO];
}

- (void)setStrokeWidth:(id)value
{
  ENSURE_UI_THREAD(setStrokeWidth, value);

  [[self circle] setStrokeWidth:[TiUtils floatValue:value def:1]];
  [self replaceValue:value forKey:@"strokeWidth" notification:NO];
}

- (void)setTitle:(id)value
{
  ENSURE_UI_THREAD(setTitle, value);
  ENSURE_TYPE(value, NSString);

  [[self circle] setTitle:[TiUtils stringValue:value]];
  [self replaceValue:value forKey:@"title" notification:NO];
}

- (void)setZIndex:(id)value
{
  ENSURE_UI_THREAD(setZIndex, value);
  ENSURE_TYPE(value, NSNumber);
  
  [[self circle] setZIndex:[TiUtils intValue:value]];
  [self replaceValue:value forKey:@"zIndex" notification:NO];
}

- (void)setUserData:(id)value
{
  ENSURE_UI_THREAD(setUserData, value);
  ENSURE_TYPE(value, NSDictionary);
  
  [[self circle] setUserData:value];
  [self replaceValue:value forKey:@"userData" notification:NO];
}

#pragma mark Utilities

static BOOL TiGooglemapsIsCoordinateValue(id value)
{
  return [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]];
}

// Returns kCLLocationCoordinate2DInvalid when a coordinate is missing (a short array or a
// missing key), so callers reject it instead of crashing or placing the circle at 0,0.
- (CLLocationCoordinate2D)positionFromPoint:(id)point
{
  if ([point isKindOfClass:[NSDictionary class]]) {
    id latitude = [point valueForKey:@"latitude"];
    id longitude = [point valueForKey:@"longitude"];

    if (!TiGooglemapsIsCoordinateValue(latitude) || !TiGooglemapsIsCoordinateValue(longitude)) {
      return kCLLocationCoordinate2DInvalid;
    }

    return CLLocationCoordinate2DMake([TiUtils doubleValue:latitude], [TiUtils doubleValue:longitude]);
  } else if ([point isKindOfClass:[NSArray class]]) {
    if ([point count] < 2 || !TiGooglemapsIsCoordinateValue(point[0]) || !TiGooglemapsIsCoordinateValue(point[1])) {
      return kCLLocationCoordinate2DInvalid;
    }

    return CLLocationCoordinate2DMake([TiUtils doubleValue:point[1]], [TiUtils doubleValue:point[0]]);
  }

  return kCLLocationCoordinate2DInvalid;
}

@end
