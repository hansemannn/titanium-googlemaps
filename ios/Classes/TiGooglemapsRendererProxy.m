/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsRendererProxy.h"
#import "TiGooglemapsView.h"
#import "TiGooglemapsViewProxy.h"

@implementation TiGooglemapsRendererProxy

- (GMUGeometryRenderer *)renderer
{
  if (_renderer == nil) {
    id mapView = [self valueForKey:@"mapView"];
    id file = [self valueForKey:@"file"];

    ENSURE_TYPE(mapView, TiGooglemapsViewProxy);
    ENSURE_TYPE(file, NSString);

    NSURL *url = [TiUtils toURL:file proxy:self];

    if (url == nil) {
      [self throwException:@"Invalid file provided" subreason:@"The file provided could not be found." location:CODELOCATION];
      return;
    }

    GMUKMLParser *parser = [[GMUKMLParser alloc] initWithURL:url];
    [parser parse];

    _renderer = [[GMUGeometryRenderer alloc] initWithMap:[(TiGooglemapsView *)[(TiGooglemapsViewProxy *)mapView view] mapView]
                                              geometries:[parser placemarks]
                                                  styles:[parser styles]];
  }

  return _renderer;
}

- (void)render:(id)unused
{
  [[self renderer] render];
}

- (void)clear:(id)unused
{
  [[self renderer] clear];
}

@end
