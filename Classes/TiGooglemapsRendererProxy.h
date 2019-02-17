/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"

#import "GMUGeometryRenderer.h"
#import "GMUKMLParser.h"

@interface TiGooglemapsRendererProxy : TiProxy {
  GMUGeometryRenderer *_renderer;
}

/**
 *  Renders the geometries onto the Google Map.
 *
 *  @param unused An unused proxy-parameter.
 *  @since 3.8.0
 */
- (void)render:(id)unused;

/**
 *  Removes the rendered geometries from the Google Map. Markup that was not added
 *  by the renderer is preserved.
 *
 *  @param unused An unused proxy-parameter.
 *  @since 3.8.0
 */
- (void)clear:(id)unused;

@end
