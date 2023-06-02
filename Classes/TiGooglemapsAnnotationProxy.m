/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsAnnotationProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsAnnotationProxy

@synthesize marker = _marker;

- (id)_initWithPageContext:(id<TiEvaluator>)context andMarker:(GMSMarker *)marker
{
  if (self = [super _initWithPageContext:context]) {
    // Assign native instance
    _marker = marker;

    // Map a few common properties over.
    // TODO: We could have an automatic mapping for this
    [self replaceValue:@(_marker.position.latitude) forKey:@"latitude" notification:NO];
    [self replaceValue:@(_marker.position.longitude) forKey:@"longitude" notification:NO];
    [self replaceValue:_marker.title forKey:@"title" notification:NO];
    [self replaceValue:_marker.snippet forKey:@"subtitle" notification:NO];

    _marker.userData = @{ @"uuid" : [[NSUUID UUID] UUIDString] };
  }
  
  return self;
}

- (GMSMarker *)marker
{
  if (!_marker) {
    _marker = [[GMSMarker alloc] init];

    CLLocationDegrees latitude = [TiUtils doubleValue:[self valueForKey:@"latitude"]];
    CLLocationDegrees longitude = [TiUtils doubleValue:[self valueForKey:@"longitude"]];

    _marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    _marker.userData = @{ @"uuid" : [[NSUUID UUID] UUIDString] };
  }

  return _marker;
}

- (NSArray *)keySequence
{
  return @[ @"latitude", @"longitude" ];
}

#pragma mark Public API's

- (TiViewProxy *)infoWindow
{
  return [self valueForUndefinedKey:@"infoWindow"];
}

- (void)setInfoWindow:(id)value
{
  [self replaceValue:value forKey:@"infoWindow" notification:NO];
}

- (void)setLatitude:(id)value
{
  ENSURE_TYPE(value, NSNumber);
  [self replaceValue:value forKey:@"latitude" notification:NO];
}

- (void)setLongitude:(id)value
{
  ENSURE_TYPE(value, NSNumber);
  [self replaceValue:value forKey:@"longitude" notification:NO];
}

- (void)setTitle:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSString);

  [[self marker] setTitle:[TiUtils stringValue:value]];
  [self replaceValue:value forKey:@"title" notification:NO];
}

- (void)setSubtitle:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSString);

  [[self marker] setSnippet:[TiUtils stringValue:value]];
  [self replaceValue:value forKey:@"subtitle" notification:NO];
}

- (void)setZIndex:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[self marker] setZIndex:[TiUtils intValue:value]];
  [self replaceValue:value forKey:@"zIndex" notification:NO];
}

- (void)setCenterOffset:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);

  [[self marker] setInfoWindowAnchor:[TiUtils pointValue:args]];
  [self replaceValue:args forKey:@"centerOffset" notification:NO];
}

- (void)setGroundOffset:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);

  [[self marker] setGroundAnchor:[TiUtils pointValue:args]];
  [self replaceValue:args forKey:@"groundOffset" notification:NO];
}

- (void)setImage:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  [[self marker] setIcon:[TiUtils image:value proxy:self]];
  [self replaceValue:value forKey:@"image" notification:NO];
}

- (void)setCustomIcon:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSDictionary);

  UIColor *textColor = [TiUtils colorValue:value[@"textColor"]].color;
  UIColor *tintColor = [TiUtils colorValue:value[@"tintColor"]].color;
  NSString *title = [TiUtils stringValue:value[@"title"]];
  UIImage *image = [TiUtils image:value[@"image"] proxy:self];
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
  if (tintColor != nil) {
    imageView.tintColor = tintColor;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  }
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.width)];
  [titleLabel setFont:[TiUtils fontValue:value[@"font"]].font];
  [titleLabel setText:title];
  [titleLabel setTextAlignment:NSTextAlignmentCenter];
  [titleLabel setTextColor:textColor];
  
  UIView *container = [[UIView alloc] initWithFrame:imageView.bounds];
  [container addSubview:imageView];
  [container addSubview:titleLabel];

  [[self marker] setIconView:container];
  [self replaceValue:value forKey:@"customIcon" notification:NO];
}

- (void)setPinColor:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  [[self marker] setIcon:[GMSMarker markerImageWithColor:[[TiUtils colorValue:value] _color]]];
  [self replaceValue:value forKey:@"pinColor" notification:NO];
}

- (void)setTouchEnabled:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[self marker] setTappable:[TiUtils boolValue:value def:YES]];
  [self replaceValue:value forKey:@"touchEnabled" notification:NO];
}

- (void)setFlat:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[self marker] setFlat:[TiUtils boolValue:value def:NO]];
  [self replaceValue:value forKey:@"flat" notification:NO];
}

- (void)setDraggable:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[self marker] setDraggable:[TiUtils boolValue:value def:NO]];
  [self replaceValue:value forKey:@"draggable" notification:NO];
}

- (void)setOpacity:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[self marker] setOpacity:[TiUtils floatValue:value def:1]];
  [self replaceValue:value forKey:@"opacity" notification:NO];
}

- (void)setAnimationStyle:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  ENSURE_TYPE(value, NSNumber);

  [[self marker] setAppearAnimation:[TiUtils intValue:value def:kGMSMarkerAnimationNone]];
  [self replaceValue:value forKey:@"animationStyle" notification:NO];
}

- (void)setRotation:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  [[self marker] setRotation:[TiUtils doubleValue:value def:0]];
}

- (void)setUserData:(id)value
{
  ENSURE_UI_THREAD_1_ARG(value);
  NSMutableDictionary *result = value;

  // Hook in internal uuid
  if ([[self marker] userData] != value) {
    [result setObject:[[[self marker] userData] valueForKey:@"uuid"] forKey:@"uuid"];
  }

  [[self marker] setUserData:result];
  [self replaceValue:result forKey:@"userData" notification:NO];
}

- (void)updateLocation:(id)args
{
  ENSURE_UI_THREAD(updateLocation, args);
  ENSURE_SINGLE_ARG(args, NSDictionary);

  id latitude = [args valueForKey:@"latitude"];
  id longitude = [args valueForKey:@"longitude"];
  id animated = [args valueForKey:@"animated"];
  id duration = [args valueForKey:@"duration"];
  id rotation = [args valueForKey:@"rotation"];
  id opacity = [args valueForKey:@"opacity"];

  ENSURE_TYPE(latitude, NSNumber);
  ENSURE_TYPE(longitude, NSNumber);
  ENSURE_TYPE_OR_NIL(animated, NSNumber);
  ENSURE_TYPE_OR_NIL(duration, NSNumber);
  ENSURE_TYPE_OR_NIL(rotation, NSNumber);
  ENSURE_TYPE_OR_NIL(opacity, NSNumber);

  typedef void (^UpdateLocationHandler)();

  UpdateLocationHandler locationHandler = ^void() {
    // Update coordinates
    if (latitude != nil && longitude != nil) {
      [[self marker] setPosition:CLLocationCoordinate2DMake([TiUtils doubleValue:latitude], [TiUtils doubleValue:longitude])];

      [self replaceValue:latitude forKey:@"latitude" notification:NO];
      [self replaceValue:longitude forKey:@"longitude" notification:NO];
    }

    // Update rotation
    if (rotation != nil) {
      [[self marker] setRotation:[TiUtils doubleValue:rotation def:0]];
      [self replaceValue:rotation forKey:@"rotation" notification:NO];
    }

    // Update opacity
    if (opacity != nil) {
      [[self marker] setOpacity:[TiUtils floatValue:opacity def:1]];
      [self replaceValue:opacity forKey:@"opacity" notification:NO];
    }
  };

  if ([TiUtils boolValue:animated def:NO]) {
    [CATransaction begin];
    [CATransaction setAnimationDuration:[TiUtils floatValue:duration def:2000] / 1000];

    locationHandler();

    [CATransaction commit];
  } else {
    locationHandler();
  }
}

- (void)setCustomView:(id)value
{
  ENSURE_UI_THREAD(setCustomView, value);

  id current = [self valueForUndefinedKey:@"customView"];
  [self replaceValue:value forKey:@"customView" notification:NO];

  if (value == [NSNull null] || value == nil) {
    [[self marker] setIconView:nil];
  } else if ([current isEqual:value] == NO) {
    [self forgetProxy:current];
    [self rememberProxy:value];

    [[self marker] setIconView:[(TiViewProxy *)value view]];
  }
}

@end
