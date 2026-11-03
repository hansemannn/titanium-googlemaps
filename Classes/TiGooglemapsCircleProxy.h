/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import "TiUtils.h"
#import <GoogleMaps/GoogleMaps.h>

@interface TiGooglemapsCircleProxy : TiProxy

@property (nonatomic, retain) GMSCircle *circle;

// Set when the circle was added to a map before it had a valid center; it is attached once one is set.
@property (nonatomic, weak) GMSMapView *pendingMapView;

@end
