/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import "TiUtils.h"
#import <GoogleMaps/GoogleMaps.h>

@interface TiGooglemapsPolylineProxy : TiProxy

@property (nonatomic, retain) GMSPolyline *polyline;

@end
