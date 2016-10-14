/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-Present by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TiUtils.h"

@interface TiGooglemapsPolygonProxy : TiProxy

@property(nonatomic,retain) GMSPolygon *polygon;

@end
